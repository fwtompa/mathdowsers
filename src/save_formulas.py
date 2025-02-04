import argparse
import sys
import csv
import dbm

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Convert tsv file on stdin to mappings from LaTeX to (vid, SLT, OPT).")

    parser.add_argument(
        "-A", "--alpha", default="AN", dest="alpha",
        help="File for holding the mapping for formulas starting with alphanumerics. Default = AN."
    )
    parser.add_argument(
        "-N", "--non", default="NAN", dest="non",
        help="File for holding the mapping for formulas starting with non-alphabetics. Default = NAN."
    )
    args = parser.parse_args()

    AN = dbm.open(args.alpha,flag='csu')
    NAN = dbm.open(args.non,flag='csu')
    Ls = csv.reader(sys.stdin, delimiter='\t', quotechar='\a')
    csv.field_size_limit(sys.maxsize)
    # latex \t vid \t slt \t opt
    i = 0
    tab = '\t'.encode()
    try:
        for row in Ls:
            ltx = row[0].strip()
            if len(ltx) == 0:
                continue
            if ltx[0].isalnum():
                AN[ltx.encode()] = row[1].encode() + tab + row[2].encode() + tab + row[3].encode()
            else:
                NAN[ltx.encode()] = row[1].encode() + tab + row[2].encode() + tab + row[3].encode()
            i = i + 1
            if i % 10000 == 0:
                print(str(i) + "th entry: " + ltx,file=sys.stderr)
    except:
        print("Exception after " + str(i) + "th entry: ",file=sys.stderr)

    print(str(i) + " entries in LaTeX dictionary",file=sys.stderr)
    AN.close()
    NAN.close()
