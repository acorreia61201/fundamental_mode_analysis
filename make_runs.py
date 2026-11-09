"""Creates run directories, with Slurm submit scripts, for runs that combine
the config files in configs/.

Each run is in its own directory,

    runs/{event}_injections/{injection}/qnm{modes}-{n}wavelet/

which gets a submit.sh that runs pycbc_inference (with MPI) on these config
files (see configs/README.md):

    configs/model.ini
    configs/sampler.ini
    configs/{data}                          the event's data (default data.ini)
    configs/data-{event}_{injection}.ini    the injection
    configs/{gate}.ini                      the gates (default
                                            gate_fixed_edge_1s)
    configs/prior_common.ini
    configs/prior_ringdown_{modes}.ini
    configs/prior_inspiral_{n}wavelet.ini

The paths in the config files are relative to the run directory, which is
four levels below this directory; submit.sh must be submitted from the run
directory (cd into it, then sbatch submit.sh). The results are written to
INFERENCE.hdf there.

Usage, e.g. for 1-, 2-, and 3-wavelet runs on the nrsur_q4_nonspin_snr20
injection:

    python make_runs.py --event gw190521 --injection nrsur_q4_nonspin_snr20 \\
        --modes 220_330 --nwavelets 1 2 3

Existing submit scripts are not overwritten, unless --force is given.
"""

import argparse
import os
import sys
import zlib

# the directory of this file (run_files)
HERE = os.path.dirname(os.path.abspath(__file__))
CONFIGS = os.path.join(HERE, 'configs')
BINDSCRIPT = os.path.join(HERE, 'bind_to_allocation.sh')


def layout(ntasks, partition, mem_per_cpu):
    """The Slurm options for the given number of tasks, spread over however
    many nodes Slurm finds room on."""
    return f'''\
# {ntasks} tasks, one per physical core, on whichever nodes have room (no fixed
# number of tasks per node, so that the job can start on the cores that are
# free), sharing the nodes with other jobs; bind_to_allocation.sh keeps each
# rank on its own allocated core. Each rank needs about 2 GB; each task is
# allocated both hardware threads of its core, so --mem-per-cpu={mem_per_cpu}
# gives each twice that.
#SBATCH --ntasks={ntasks}
#SBATCH --mem-per-cpu={mem_per_cpu}
#SBATCH --partition={partition}
'''


SUBMIT = '''#!/bin/bash -l

#SBATCH --job-name={name}
{layout}#SBATCH --cpus-per-task=1
#SBATCH --hint=nomultithread
#SBATCH --time=14-00:00:00
#SBATCH --output={name}-%j.out
#SBATCH --error={name}-%j.err

# Settings that depend on the installation; change these for your own:
# the conda installation, the environment with pycbc (installed from the
# speedup_margphasepol branch) and the wavelet_merger_model plugin, and a
# directory containing the NRSur7dq4 data file (NRSur7dq4.h5), which is needed
# to generate the injection.
CONDA_BASE=$HOME/miniforge3
CONDA_ENV=fundamental_fork
export LAL_DATA_PATH=/home/alcorrei/packages/surrogate

module purge

# Use SLURM's node-local tmp dir if available, fallback to /tmp
export TMPDIR="${{SLURM_TMPDIR:-/tmp}}/tmp_$SLURM_JOB_ID"
mkdir -p "$TMPDIR"

# Direct temporary and cache files to local space (avoid NFS issues)
export MPLCONFIGDIR="$TMPDIR/mpl"
export PYTHONPYCACHEPREFIX="$TMPDIR/pycache"
export NUMBA_CACHE_DIR="$TMPDIR/numba_cache"
export NUMBA_DISABLE_CACHE=1
export PYTHONDONTWRITEBYTECODE=1
export OMP_NUM_THREADS=1

eval "$($CONDA_BASE/bin/conda shell.bash hook)"
conda activate $CONDA_ENV

# the configs rely on pycbc fixes whose absence would be silently ignored:
# the injection taper, the ringdown t0, and the margphasepol polarization
# bounds; and on the speedups of the multimargphase model; stop if they are
# missing
python - <<'EOF' || exit 1
import inspect, sys
from pycbc.inject.inject import projector
from pycbc.waveform.ringdown import td_args
from pycbc.inference.models.gated_gaussian_noise import (
    GatedGaussianMultimodeMargPhase, GatedGaussianMultimodeMargPhasePol)
if 'inj.get(' in inspect.getsource(projector) or 't0' not in td_args or \\
        'polarization_bounds' not in inspect.signature(
            GatedGaussianMultimodeMargPhasePol).parameters or \\
        not hasattr(GatedGaussianMultimodeMargPhase, '_det_inner_products'):
    sys.exit('the installed pycbc does not have the injection taper, ringdown '
             't0, polarization bounds, or multimargphase speedups; reinstall '
             'it from the speedup_margphasepol branch')
EOF

# MPI over TCP on the cluster's network
export OMPI_MCA_pml=ob1
export OMPI_MCA_btl=self,tcp
export OMPI_MCA_btl_tcp_if_include=10.59.0.0/16

# the config files use paths relative to this directory
cd "$SLURM_SUBMIT_DIR"

# By default, mpirun binds ranks to cores starting from core 0 on every node,
# regardless of which CPUs Slurm allocated to the job (the allocation is not
# enforced by cgroups), so ranks of different jobs end up sharing cores.
# Instead, mpirun is run with --bind-to none, so each rank starts with the
# job's allocation on its node, and bind_to_allocation.sh binds each rank to
# its own core within it.
mpirun -np $SLURM_NTASKS --bind-to none -- \\
    {bindscript} \\
    "$CONDA_PREFIX/bin/pycbc_inference" \\
    --config-files \\
{configs}    --seed {seed} \\
    --output-file INFERENCE.hdf \\
    --use-mpi --verbose
'''


def run_dir(event, injection, modes, nwavelets):
    """The directory of a run, relative to this directory."""
    return os.path.join('runs', f'{event}_injections', injection,
                        f'qnm{modes}-{nwavelets}wavelet')


def config_files(event, injection, modes, nwavelets, data, gate):
    """The config files of a run, in the order they are given to
    pycbc_inference."""
    return ['model.ini', 'sampler.ini', data,
            f'data-{event}_{injection}.ini', f'{gate}.ini', 'prior_common.ini',
            f'prior_ringdown_{modes}.ini',
            f'prior_inspiral_{nwavelets}wavelet.ini']


def default_seed(rundir):
    """A seed that is fixed for a given run, and different for different
    runs."""
    return 100000 + zlib.crc32(rundir.encode()) % 900000


def make_submit(event, injection, modes, nwavelets, data='data.ini',
                gate='gate_fixed_edge_1s', ntasks=192,
                partition='compute_zone2', mem_per_cpu='1500M', seed=None):
    """Returns the run directory (relative to this directory) and the text of
    the submit script of a run."""
    rundir = run_dir(event, injection, modes, nwavelets)
    absdir = os.path.join(HERE, rundir)
    files = config_files(event, injection, modes, nwavelets, data, gate)
    missing = [f for f in files if not os.path.exists(os.path.join(CONFIGS, f))]
    if missing:
        raise ValueError(f'missing config files: {", ".join(missing)}')
    if seed is None:
        seed = default_seed(rundir)
    configs = ''.join(
        f'        {os.path.relpath(os.path.join(CONFIGS, f), absdir)} \\\n'
        for f in files)
    name = f'{event}-{injection}-qnm{modes}-{nwavelets}wavelet'
    text = SUBMIT.format(
        name=name, layout=layout(ntasks, partition, mem_per_cpu),
        bindscript=os.path.relpath(BINDSCRIPT, absdir), configs=configs,
        seed=seed)
    return rundir, text


def main():
    parser = argparse.ArgumentParser(
        description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument('--event', required=True,
                        help='e.g. gw190521')
    parser.add_argument('--injection', required=True,
                        help='e.g. nrsur_q4_nonspin_snr20; needs '
                             'configs/data-{event}_{injection}.ini')
    parser.add_argument('--modes', default='220_330',
                        help='the ringdown modes; needs '
                             'configs/prior_ringdown_{modes}.ini (default '
                             '220_330)')
    parser.add_argument('--nwavelets', type=int, nargs='+', required=True,
                        help='the numbers of wavelets (one run each); needs '
                             'configs/prior_inspiral_{n}wavelet.ini')
    parser.add_argument('--data', default='data.ini',
                        help="the event's data config file (default "
                             "data.ini)")
    parser.add_argument('--gate', default='gate_fixed_edge_1s',
                        help='the gate config file, without .ini (default '
                             'gate_fixed_edge_1s)')
    parser.add_argument('--ntasks', type=int, default=192,
                        help='the number of MPI tasks (default 192)')
    parser.add_argument('--partition', default='compute_zone2',
                        help='the Slurm partition (default compute_zone2)')
    parser.add_argument('--mem-per-cpu', default='1500M',
                        help='Slurm --mem-per-cpu (default 1500M)')
    parser.add_argument('--seed', type=int,
                        help='the seed (only with one --nwavelets); by '
                             'default, one is made from the run directory')
    parser.add_argument('--force', action='store_true',
                        help='overwrite existing submit scripts')
    opts = parser.parse_args()
    if opts.seed is not None and len(opts.nwavelets) > 1:
        parser.error('--seed can only be given with a single --nwavelets')
    for n in opts.nwavelets:
        rundir, text = make_submit(
            opts.event, opts.injection, opts.modes, n, data=opts.data,
            gate=opts.gate, ntasks=opts.ntasks, partition=opts.partition,
            mem_per_cpu=opts.mem_per_cpu, seed=opts.seed)
        submit = os.path.join(HERE, rundir, 'submit.sh')
        if os.path.exists(submit) and not opts.force:
            print(f'{rundir}/submit.sh exists; not overwriting it (use --force '
                  'to)', file=sys.stderr)
            continue
        os.makedirs(os.path.join(HERE, rundir), exist_ok=True)
        with open(submit, 'w') as fp:
            fp.write(text)
        print(f'wrote {rundir}/submit.sh')


if __name__ == '__main__':
    main()
