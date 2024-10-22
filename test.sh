#!/usr/bin/bash

set -x

WD=$(pwd)

cp main PSII_data/wholePBS/main
cd PSII_data/wholePBS
LD_LIBRARY_PATH=$WD/hdf5/lib:$LD_LIBRARY_PATH ./main ./config_sum
