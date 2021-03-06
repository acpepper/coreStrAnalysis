#!/bin/bash

RUN_DIR='/group/stewartgrp/acpepper/cthruns/HOTCI_tests/coreStr/'
CTH_BASE_NAME='coreStr_master'

cd ~/HOTCI_stuff/coreStrAnalysis/

for yieldVal in {10..100..10}
do  
    echo '=============================='
    echo 'Making dir '$RUN_DIR'M1.05_L2.7_yield'$yieldVal
    echo '=============================='
    
    # move the CTH input file into its own directory
    mkdir $RUN_DIR'M1.05_L2.7_yield'$yieldVal
    cp base_run/cth.slurm $RUN_DIR'M1.05_L2.7_yield'$yieldVal/
    cp base_run/clean.sh $RUN_DIR'M1.05_L2.7_yield'$yieldVal/
    cp ../HERCULES_v1.0/HOTCI/CTH_in/$CTH_BASE_NAME'.in' $RUN_DIR'M1.05_L2.7_yield'$yieldVal/'M1.05_L2.7_yield'$yieldVal'.in'
    
    # Set the core yield strength
    let yieldVal_scaled=$yieldVal*1000000000
    sed -i "s/yield=1e10/yield = "$yieldVal_scaled"/" $RUN_DIR'M1.05_L2.7_yield'$yieldVal/'M1.05_L2.7_yield'$yieldVal'.in'
    if [ $? -gt 0 ]
    then
	echo 'Error encountered using sed'
	exit 1
    fi
    	
    # Set the CTH file to the correct one in cth.slurm
    sed -i 's/i=default_name.in >/i=M1.05_L2.7_yield'$yieldVal'.in >/' $RUN_DIR'M1.05_L2.7_yield'$yieldVal/cth.slurm
    if [ $? -gt 0 ]
    then
	echo 'Error encountered using sed'
	exit 1
    fi

    # Set the identifier of the run
    sed -i 's/J\s\S*\s/J str'$yieldVal' /' $RUN_DIR'M1.05_L2.7_yield'$yieldVal/cth.slurm
    if [ $? -gt 0 ]
    then
	echo 'Error encountered using sed'
	exit 1
    fi

    # Start the run
    cd $RUN_DIR'M1.05_L2.7_yield'$yieldVal
    sbatch cth.slurm
    cd ~/HOTCI_stuff/coreStrAnalysis/    
done
