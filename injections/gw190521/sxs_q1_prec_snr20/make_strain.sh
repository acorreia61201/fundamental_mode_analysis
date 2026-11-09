#!/bin/bash

for i in H1 L1 V1; do
pycbc_condition_strain \
        --injection-file injection.hdf \
        --gps-start-time 1242441000 \
        --gps-end-time 1242444000 \
        --sample-rate 4096 \
        --fake-strain zeroNoise \
        --fake-strain-seed 44 \
        --low-frequency-cutoff 4 \
        --channel-name $i:STRAIN \
        --pad-data 8 \
        --output-strain-file $i-injection.gwf

done
