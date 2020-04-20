import os
import matplotlib as mpl
mpl.use('Agg')
import matplotlib.pyplot as plt
import sys
sys.path.append("/home/acpepper/HOTCI_stuff/")
import pyCTH.DataOutBinReader as dor
import pyCTH.HcthReader as hcr
import pyCTH.ImpactAnalysis as ima
import pyCTH.CoreStrAnalysis as csa



RUN_DIR = "/group/stewartgrp/acpepper/cthruns/HOTCI_tests/coreStr/"
if RUN_DIR[-1] != '/':
    RUN_DIR = RUN_DIR+'/'

PLOT_DIR = "../plots/"
if PLOT_DIR[-1] != '/':
    PLOT_DIR = PLOT_DIR+'/'

    

if __name__ == "__main__":
    fig, ax = plt.subplots()

    # visit each directory
    for dirName in os.listdir(RUN_DIR):
        print "now analyzing directory {}".format(dirName)

        # for each data dump, collect the core temperature
        coreTemp = []
        times = []
        # binary data analysis (binDat files)
        dobrDat = dor.DataOutBinReader()
        cycs, numCycs = dobrDat.getCycles("binDat", RUN_DIR+dirName)
        print "Number of cycles = {}".format(len(cycs))
        for i, cyc in enumerate(cycs[-3:]):
            dobrDat = dor.DataOutBinReader()
            dobrDat.readSev("binDat", cyc, RUN_DIR+dirName)

            print dobrDat.varNames
            print "Time of this dump: {} hr".format(dobrDat.times[0]/3600)

            times.append(dobrDat.times[0]/3600)
            coreTemp.append(1.1604e4
                            *csa.getCoreTemp(dobrDat, PLOT_DIR+dirName)[0])
            
        ax.plot(times, coreTemp, label=dirName)

    fig.legend()
    fig.savefig(PLOT_DIR+"coreStrAnalysis/coreTemp.png")
