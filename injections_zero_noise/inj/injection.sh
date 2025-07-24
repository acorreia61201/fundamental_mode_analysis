#!/usr/bin/env bash

pycbc_create_injections --verbose --config-files injection.ini --output-file injection.hdf --variable-params-section variable_params \
                        --static-params-section static_params --ninjections 1 --force

