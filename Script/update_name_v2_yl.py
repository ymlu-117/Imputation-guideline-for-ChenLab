import sys
import getopt
import pandas as pd

def take_input():
    argv = sys.argv[1:]
    opts, args = getopt.getopt(argv, "i:")
    for opt, arg in opts:
        if opt in ['-i']:
            bim_filename = arg
    return bim_filename

filename=take_input()

inputFileName = filename
outputFileName = inputFileName
headers = ['CHR', 'SNP', '0', 'BP', 'A1', 'A2']

chrDF = pd.read_csv(inputFileName, sep='\s+', names=headers)

chrDF.SNP = chrDF.CHR.astype(str) + ':' + chrDF.BP.astype(str)

chrDF.to_csv(outputFileName, sep='\t', index=False, header=False)


def take_input():
    argv = sys.argv[1:]
    opts, args = getopt.getopt(argv, "i:")
    for opt, arg in opts:
        if opt in ['-i']:
            filename = arg
    return filename