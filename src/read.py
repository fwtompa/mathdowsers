import argparse
import sys
import csv
import dbm

if __name__ == '__main__':
    s = dbm.open('../data/processed/NAN',flag='r')
    t = dbm.open('../data/processed/AN',flag='r')
    print(dbm.whichdb('../data/processed/NAN'))
    Ls = csv.reader(sys.stdin, delimiter='\t', quotechar='\a')
    i = 0
    for row in Ls:
        k = row[0].strip()
        if len(k) == 0:
                continue
        if k[0].isalnum():
            d = t
        else:
            d = s
        if k.encode() in d:
            print(k + " -> " +d[k.encode()].decode())
        else:
            print("Line " + str(i) + " not found: " + row[0])
        i = i + 1
    s.close()
    t.close()
