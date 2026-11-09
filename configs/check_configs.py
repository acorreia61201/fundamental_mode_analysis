"""Checks that the config files given in each run's submit.sh combine to the
configuration that the run used.

pycbc_inference stores the (combined) configuration in its output file. For
every run directory under ../runs that has a submit.sh and an INFERENCE.hdf,
the config files listed after --config-files in submit.sh are loaded with
WorkflowConfigParser (which combines multiple files and does the ${...}
interpolation), and compared, section by section and option by option, with
the configuration stored in INFERENCE.hdf. The [environment] section that
WorkflowConfigParser adds is skipped. The options that are paths to files
(psd-file and injection-file) are compared by file name, since the runs may
have been done from another directory; the paths in the config files are
checked to exist.

This shows that the config files reproduce the runs, and so can be used for
new ones. (The variable_params may be listed in a different order, which only
changes the order of the sampler's dimensions; it is reported but is not a
difference.)

The gate file tied to the inverse PSD length (gate_fixed_edge_invpsd.ini) is
also checked: its edges should evaluate to trigger_time +/- (inverse PSD
length + 0.2 s).

Usage: python check_configs.py   (exits with status 1 if anything differs)
"""
import glob
import os
import re
import shlex
import sys

from pycbc.inference.io import loadfile
from pycbc.workflow import WorkflowConfigParser

HERE = os.path.dirname(os.path.abspath(__file__))
RUNS = os.path.join(HERE, '..', 'runs')
# options whose values are (detector:)paths to files
PATH_OPTIONS = ['psd-file', 'injection-file']


def as_dict(cp):
    """A config parser as a dict of section -> dict of option -> value,
    without the environment section."""
    return {sec: dict(cp.items(sec)) for sec in cp.sections()
            if sec != 'environment'}


def submit_config_files(submit):
    """The config files given after --config-files in a submit script."""
    text = open(submit).read().replace('\\\n', ' ')
    line = [l for l in text.splitlines() if '--config-files' in l]
    assert len(line) == 1, submit
    args = shlex.split(line[0])
    files = []
    for arg in args[args.index('--config-files') + 1:]:
        if arg.startswith('-'):
            break
        files.append(arg)
    return files


def paths(value):
    """The paths in a (detector:)path option."""
    return [v.split(':', 1)[-1] for v in value.split()]


def compare(stored, new, rundir):
    """Compares the stored config with the new one, printing any differences.
    Returns True if they are the same."""
    ok = True
    for sec in sorted(set(stored) | set(new)):
        if sec not in new:
            print(f'  section [{sec}] is missing from the config files')
            ok = False
            continue
        if sec not in stored:
            print(f'  section [{sec}] is not in the stored config')
            ok = False
            continue
        for opt in sorted(set(stored[sec]) | set(new[sec])):
            a, b = stored[sec].get(opt), new[sec].get(opt)
            if opt in PATH_OPTIONS and a is not None and b is not None:
                if [os.path.basename(p) for p in paths(a)] != \
                        [os.path.basename(p) for p in paths(b)]:
                    print(f'  [{sec}] {opt}: different files: {a!r} vs {b!r}')
                    ok = False
                for p in paths(b):
                    if not os.path.exists(os.path.join(rundir, p)):
                        print(f'  [{sec}] {opt}: {p} does not exist')
                        ok = False
            elif a != b:
                print(f'  [{sec}] {opt}: stored {a!r}, config files {b!r}')
                ok = False
    nopts = sum(len(opts) for opts in stored.values())
    print(f'  {"SAME" if ok else "DIFFERENT"}: {len(stored)} sections, '
          f'{nopts} options')
    if ok and list(stored.get('variable_params', {})) != \
            list(new.get('variable_params', {})):
        print('  (the variable_params are in a different order)')
    return ok


allok = True
submits = sorted(glob.glob(os.path.join(RUNS, '**', 'submit.sh'),
                           recursive=True))
nruns = 0
for submit in submits:
    rundir = os.path.dirname(submit)
    output = os.path.join(rundir, 'INFERENCE.hdf')
    if not os.path.exists(output):
        continue
    nruns += 1
    print(f'== {os.path.relpath(rundir, RUNS)}')
    files = submit_config_files(submit)
    print(f'   config files: {" ".join(os.path.basename(f) for f in files)}')
    with loadfile(output, 'r') as fp:
        stored = as_dict(fp.read_config_file())
    new = as_dict(WorkflowConfigParser([os.path.join(rundir, f)
                                        for f in files]))
    allok &= compare(stored, new, rundir)
if nruns == 0:
    print('no runs with an INFERENCE.hdf found')

# the gate tied to the inverse PSD length
print('== gate_fixed_edge_invpsd.ini')
cfg = as_dict(WorkflowConfigParser(
    [os.path.join(HERE, f) for f in ['data.ini', 'prior_common.ini',
                                     'gate_fixed_edge_invpsd.ini']]))
invlen = float(cfg['inspiral__data']['psd-inverse-length'])
trigger_time = float(cfg['static_params']['trigger_time'])
sec = [s for s in cfg
       if s.startswith('waveform_transforms-inspiral__t_gate_end_h1')]
assert len(sec) == 1, sec
ok = True
for opt, expr in cfg[sec[0]].items():
    if opt in ('name', 'inputs'):
        continue
    offset = eval(expr, {'trigger_time': trigger_time}) - trigger_time
    expected = (invlen + 0.2) * (1 if opt.startswith('inspiral') else -1)
    good = abs(offset - expected) < 1e-6
    ok &= good
    print(f'  {opt} = {expr}  ->  trigger_time {offset:+.4f} s '
          f'({"ok" if good else "WRONG"})')
allok &= ok

print('ALL SAME' if allok else 'SOME DIFFERENCES')
sys.exit(0 if allok else 1)
