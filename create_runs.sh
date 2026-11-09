injs=(
	nrsur_q1_nonspin_snr20
	nrsur_q4_nonspin_snr20
	nrsur_q4_nonspin_snr30
	seobnr_q8_nonspin_snr20
	sxs_q1_prec_snr20
)

modes=(
	"220"
	"220_330"
	"220_210"
	"220_440"
	"220_221"
	"220_330_210"
	"220_210_320"
	"d220"
	"d220_330"
        "d220_210"
        "d220_440"
        "d220_221"
        "d220_330_210"
        "d220_210_320"
)

for i in "${injs[@]}"; do
	for j in "${modes[@]}"; do
		python make_runs.py --event gw190521 --injection $i --modes $j --nwavelets 1 2 3
	done
done

