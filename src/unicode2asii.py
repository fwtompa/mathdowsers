#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Date:       2024-03-18
Purpose:    convert UTF-8 to ASCII, but preserving XML tags and MathDowser's mathtuples
            remove all diacritics, convert all dashes to hyphens 
Depends on: unidecode
""" 

import argparse
import sys
import os
import re
from unidecode import unidecode

__author__ = 'FWTompa'

ENCODING = "utf-8"

def convert(docid="",KEEP="",START="",END="",ERRORS="",CONVERT=""):
    SPLITTER = re.compile(r"((?:" + START + r")|(?:" + END + r")|(?:" + KEEP + r"))")
    """
     SPLITTER.split("abc <xyz> def #(start)# #(v!x,n!2,n)# #(end)# ghi")
     -> ['abc ', '<xyz>', ' def ', '#(start)#', ' #(v!x,n!2,n)# ', '#(end)#', ' ghi']
     => [text (, delim, text)*] where text could be ''
    """
    KEEP = re.compile(KEEP)
    START = re.compile(START)
    END = re.compile(END)

    idRE = re.compile(r"\Z(.)") # an impossible pattern to match
    if docid != "":
        idRE = re.compile(docid + r"([^ <>]*)")
    docID = ""

    stems = {}
    lineNum = 0
    with sys.stdin as fin:
        with sys.stdout as fout:
            inKeep = False  # start outside text region to preserve
            for line in fin:  # process each line, one at a time
                lineNum += 1
                newID = idRE.search(line)
                if newID:
                    if inKeep:
                        print("On line " + str(lineNum) + ": unclosed end for preserved text in data file or query "
                              + docID + " matching " + keeptag + "from line "+ str(keepline), file=sys.stderr)
                        inKeep = False
                    docID = newID.group(1)
                    lineNum = 0

                content = []    # collect output
                frags = SPLITTER.split(line)     # split line into [text (, delim, text)*]
                for frag in frags:
                    if inKeep: 
                        if END.match(frag):
                            inKeep = False
                        elif KEEP.match(frag) or START.match(frag):
                            print("On line " + str(lineNum) + ": preserving "+ frag +" inside preserved text in data file or query "
                                  + docID +" matching " + keeptag + " from line "+ str(keepline), file=sys.stderr)
                        if CONVERT:
                            content.append(unidecode(frag,errors="preserve"))
                        else:
                            content.append(frag)
                    elif KEEP.match(frag):      # if matches both KEEP and START, preserves just one token as is
                        if CONVERT:
                            content.append(unidecode(frag,errors="preserve"))
                        else:
                            content.append(frag)
                    elif START.match(frag):
                        inKeep = True
                        keeptag = frag
                        keepline = lineNum
                        if CONVERT:
                            content.append(unidecode(frag,errors="preserve"))
                        else:
                            content.append(frag)
                    elif END.match(frag):
                        print("On line " + str(lineNum) + ": superfluous end signal "+ frag +" with no start for preserved text in data file or query "+ docID, file=sys.stderr)
                        try:
                            content.append(unidecode(frag,errors=ERRORS))
                        except Exception as err:
                            print("On line " + str(lineNum) + ": error in data file or query "+ docID, file=sys.stderr)
                            print(err, file=sys.stderr)
                            print("=> preserving: " + frag, file=sys.stderr)
                            content.append(frag)
                    else:
                        try:
                            content.append(unidecode(frag,errors=ERRORS))
                        except Exception as err:
                            print("Error in data file or query "+ docID +", line "+ str(lineNum), file=sys.stderr)
                            print(err, file=sys.stderr)
                            print("ignoring" + line, file=sys.stderr)
                line = "".join(content)
                print(line, file=fout, end="")
    if inKeep:
        print("At end of file: no end signal in data file or query "
                         + docID +" matching " + keeptag + " from line "+ str(keepline), file=sys.stderr)
 

if __name__ == "__main__":

    descp = "Convert UTF-8 to ASCII"
    epi = "where each regex must escape parentheses and must match strings that do not break across lines."
    parser = argparse.ArgumentParser(description=descp,epilog=epi,formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("-docid",'--docid',
                        dest="docid",
                        help="string preceding each document identifier; default => <DOCNO>",
                        default="<DOCNO>")
    parser.add_argument("-k",'--keep',
                        dest="KEEP",
                        help="regex for individual tokens to keep unchanged; default => XML tags",
                        default=r"<[^>]*>")
    parser.add_argument("-s",'--start',
                        dest="START",
                        help="regex for start of text to preserve unchanged; default => math tuple start",
                        default=r"#\(start\)#")
    parser.add_argument("-e",'--end',
                        dest="END",
                        help="regex for end of text to preserve unchanged; default => math tuple end",
                        default=r"#\(end\)#")
    parser.add_argument("-x",'--errors',
                        dest="ERRORS",
                        help="ignore, strict, replace, or preserve characters that cannot be translated; default => ignore",
                        default="ignore")
    parser.add_argument("-c",'--convert',
                        dest="CONVERT",
                        action="store_true",
                        help="convert kept text, but preserve characters that cannot be translated; default => do not convert kept text",
                        default=False)
    args = parser.parse_args()

    if args.ERRORS in {"ignore","strict","replace","preserve"}:
        ERRORS = args.ERRORS
    else:
        print("--errors must be one of ignore, strict, replace, or preserve, not " + arg.ERRORS + "; ignore assumed", file=sys.stderr)
        ERRORS = "ignore"

    convert(docid=args.docid,KEEP=args.KEEP,START=args.START,END=args.END,ERRORS=args.ERRORS,CONVERT=args.CONVERT)
