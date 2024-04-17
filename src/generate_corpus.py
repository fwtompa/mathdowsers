"""
    The main file to generate the document corpus (html pages that are to be indexed by the search engine).
    Each html page is a question-answer pair with enriched details. See Andrew Kane, Yin Ki Ng, Frank Wm. Tompa:
        "Dowsing for Answers to Math Questions: Doing Better with Less." CLEF (Working Notes) 2022: 40-62.
        All formulas in each html page is converted to MathML (by default)

    Prerequisite:
        Original thread HTML files have been downloaded and then converted using src_2023/makefile.corpus.
        Template for HTML pages to be generated.
        Tsv-files of data (see nextQ, nextA, nextC, nextRm and nextF for descriptions)

    Example:
        Create pages for questions in QPosts.tsv:
            $ cat QPosts.tsv | python3 generate_corpus.py

        See all options:
            $ python3 generate_corpus.py -h
"""

import os
import gzip
import csv
import math
import argparse
import sys
import re
from llist import dllist

csv.field_size_limit(100000000)

MINIMAL_HTML = "template_minimal_v3.html"
INPUT_FORMAT = ".tsv.gz"
OUTPUT_FORMAT = ".xml.gz"
ENCODING = "utf-8"

# globals set or used in functions
formula=None; Fid=None; FTid=-1; visual=None; firstF = False
FormDict = {}; LFormDict = {}
Qid=0; latex_title=None; title=None; question=None; tags=None; Os = None; Ss = None; year = "0000"
ThreadId=-1; Aid=None; answer=None; firstA=None; Ayear = "0000"
Cid=None; Tid=-1; comment=None; firstC = False; Cyear = "0000"
Rid=-1; rel_type=None; Rtitle=None; firstR = False; Ryear = "0000"
SLT = {}; OPT = {} ; cache = {}; pq = dllist()
SLTcnt = 0; FDcnt = 0; ltxcnt = 0; nofcnt = 0; fcnt = 0


def generate_files(indir, aposts, comments, rels, outdir, l2pc, pmml, cmml, CY):
    # qposts come from stdin
    global SLT, OPT, cache, pq, SLTcnt, FDcnt, ltxcnt, nofcnt, fcnt, FormDict, LFormDict

    def nextF(pmml,cmml):
        # output tables: id post_id thread_id type comment_id visual_id formula year, sorted numerically by year, thread_id, post_id, id
        global formula, Fid, FTid, visual, firstF
        # print("nextF",file=sys.stderr)
        if FTid == math.inf:
            return
        if firstF:          # already read first record
            if FTid <= Qid:
                firstF = False
            if FTid >= Qid:
                return(True)
        else:
            if Qid < FTid:
                print("Impossible: Qid: " + str(Qid) + " < FTid: " + str(FTid),file=sys.stderr)
        if pmml:
            if Qid == FTid:
                try:
                    S = next(Ss)
                except:
                    FTid = math.inf
                    return(False)
                FTid = int(S["thread_id"])
            else:
                while Qid > FTid:
                    try:
                        S = next(Ss)
                    except:
                        FTid = math.inf
                        return(False)
                    FTid = int(S["thread_id"])
            Fid = S["id"]
            visual = S["visual_id"]
            Sform = S["formula"]
            if cmml:		# both SLT and OPT requested
                OFid = "0";
                while OFid != Fid:     # move up to the corresponding formula
                    try:
                        O = next(Os)
                    except:
                        FTid = math.inf
                        return(False)
                    OFid = O["id"]
                # SLT: <math alttext="0.999999999\dots=1" class="ltx_Math" display="block"
                #               xmlns="http://www.w3.org/1998/Math/MathML"><semantics>...</semantics></math>
                # OPT: <math encoding="MathML-Content" xmlns="http://www.w3.org/1998/Math/MathML">...</math>
                Cform = O["formula"]
                if Cform:
                    Cform = Cform[Cform.index(">")+1:-7]               
                    formula = Sform[0:-19] + '<annotation-xml encoding="MathML-Content">' + Cform + '</annotation-xml></semantics></math>'
                else:
                    formula = Sform
            else:		# only SLT requested
                formula = Sform
        else:
            if cmml:		# only OPT requested
                if Qid == FTid:
                    try:
                        O = next(Os)
                    except:
                        FTid = math.inf
                        return(False)
                    FTid = int(O["thread_id"])
                else:
                    while Qid > FTid:
                        try:
                            O = next(Os)
                        except:
                            FTid = math.inf
                            return(False)
                        FTid = int(O["thread_id"])
                Fid = O["id"]
                visual = O["visual_id"]
                formula = O["formula"]
            else:
                formula = None
        if FTid > Qid:
            firstF = True
        #if formula:
        #    print("nextF: " + str(FTid) + "/" + (Fid) + "/" + visual + " = " + formula, flush=True,file=sys.stderr)
        #else:
        #    print("no formulas",file=sys.stderr)
        #if not formula:
        #    print("formula is None: " + Fid + " in thread " + str(FTid),file=sys.stderr)
        return(True) 

    def getFormulas(pmml,cmml):
        global FormDict
        # create a dictionary of formulas
        #if Qid == 2682503:
        #    print("Get formulas for Qid " + str(Qid), flush=True,file=sys.stderr)
        if not pmml and not cmml:
            return
        FormDict.clear()
        nextF(pmml,cmml)        # find the first corresponding formulas
        #if Qid == 2682503:
        #    print("First formula id: " + Fid + " for thread: " + str(Qid),file=sys.stderr)
        while FTid == Qid:      # read all the corresponding formulas
            if formula:
                FormDict[Fid] = [visual,formula]
            nextF(pmml,cmml)
        #if Qid == 2682503:
        #    print("Not including formula id: " + Fid + " for Q " + str(Qid),file=sys.stderr)
        #    for k in FormDict.keys():
        #        print(k + " -> " + FormDict[k][1], flush=True,file=sys.stderr)
        return


    def unmathify(s):
        # <span class="math-container" id="1294">p(n \xi)</span> -> $p(n \xi)$
        span1 = s.find('<span class="math-container"')
        while span1 > 0:
            span2 = s.find('>',span1)
            s = (s[0:span1] + '$' + s[span2+1:])
            span1 = s.find('<span class="math-container"')
        return s.replace("</span>",'$')

    def mathify(s):
        global nofcnt, SLTcnt, FDcnt, fcnt
        def replace_latex(t):
            global ltxcnt
            # preconditions: t contains a $ and does not contain any recognized math expressions
            # postcondition: potential math expressions marked by <span .... </span>
            pieces = t.split("$")
            escaped = False
            if pieces[0] and pieces[0][-1] == "\\":
                if len(pieces[0]) > 1 and pieces[0][-2] != "\\" or len(pieces[0]) == 1:
                    # ignoring possibility of more escapes before that!
                    escaped == True
                    pieces[0] = pieces[0] + "$"     # so leave the $
            in_math = 0
            for i in range(1,len(pieces)):
                f = pieces[i]
                if not escaped and not in_math:
                    if i == len(pieces)-1:
                        pieces[i] = '$' + f
                    else:
                        pieces[i] = '<span class="math-container">' + f
                        in_math =  3 if not f else 1    # not f => $$ opening
                        ltxcnt = ltxcnt + 1
                        # print("replaced latex: " + f,file=sys.stderr)
                elif not escaped:
                    in_math = in_math - 1
                    if in_math == 0 or i == len(pieces)-1:   # reached end of latex or end of $
                        pieces[i] = "</span>" + f
                else:
                    escaped = False     # dealt with \$
                if f and f[-1] == "\\":
                    if len(f) > 1 and f[-2] != "\\" or len(f) == 1:
                        escaped = True
                        pieces[i] = f + "$"      # so leave the $
            return "".join(pieces)


        if len(FormDict) == 0 or not s: # no dictionary entries or no string, so leave formulas unchanged
            return(s)
        
        if s.find("$"):
            frags = s.split('<span class="math-container"')
            if frags[0].find("$") >= 0:    # deal with LaTeX if present
                frags[0] =  replace_latex(frags[0])
            for i in range(1,len(frags)):
                f = frags[i]
                if f.find("$") >= 0:
                    endspan = f.find("</span>") + 7
                    if endspan < 7:
                        frags[i] = replace_latex(f)
                    else:
                        frags[i] = f[0:endspan] + replace_latex(f[endspan:])
            s ='<span class="math-container"'.join(frags)

        # now try to insert <math...</math>
        frags = s.split('<span class="math-container"')
        #if len(frags) > 1:
        #    print("mathify " + str(len(frags)-1) + " formula(s): " + s, flush=True,file=sys.stderr)
        for i in range(1,len(frags)):
            f = frags[i]
            endtag = f.index(">")
            endspan = f.find("</span>")
            if endspan < 0:
                # print("NO MATCHING </span> IN " + f + " FOR " + s,file=sys.stderr)
                continue
            fcnt = fcnt + 1
            lx = f[endtag+1:endspan]   # latex expression
            alttext = '<math alttext="' + lx  + '"'
            hasid = f.find('id="')
            if hasid >= 0:
                id = f[hasid+4 : endtag-1]
                if id in FormDict:
                    rform = FormDict[id][1]
                    if cmml and not pmml:
                        rform = alttext + rform[5:] # insert LaTeX as alttext into <math header
                    frags[i] = '<span class="math-container"' + f[0:endtag]  + ' visual_id="' + FormDict[id][0] + '">' + rform + f[endspan:]
                    if not re.search(r"[a-zA-Z]",lx): # all corpus LaTeX expressions with alphabetics are in SLT
                       LFormDict[lx] = [rform,FormDict[id][0]]
                       if lx in cache:
                           pq.remove(cache[lx])  # move to end
                           # print("moving '" + lx + "' and LRU is " + cache[0] ,file=sys.stderr)
                       cache[lx] = pq.insert(lx)
                       if len(cache) > 10000: # keep the last k latex formulas in reverse LRU order
                           # print("delete '" + cache[0] + "'",file=sys.stderr)
                           lx = pq.popleft()
                           del LFormDict[lx]
                           del cache[lx]

                else: # id does not match any formula
                    #print("No matching formula: "+ str(Qid) + " " + str(Aid) +f,file=sys.stderr)
                    #raise("nomatch")

                    if lx in SLT:
                        rform = SLT[lx][0]
                        if cmml and not pmml:
                            rform = alttext + rform[5:] # insert LaTeX as alttext into <math header
                        frags[i] = '<span class="math-container"' + f[0:endtag]  + ' visual_id="' + SLT[lx][1] + '">' + rform + f[endspan:]
                        sltcnt = SLTcnt + 1
                        # print("has id but found in SLT: " + rform,file=sys.stderr)
                    elif lx in LFormDict:
                        rform = LFormDict[lx][0]
                        if cmml and not pmml:
                            rform = alttext + rform[5:] # insert LaTeX as alttext into <math header
                        frags[i] = '<span class="math-container"' + f[0:endtag]  + ' visual_id="' + LFormDict[lx][1] + '">' + rform + f[endspan:]
                        FDcnt = FDcnt + 1
                        # print("has id but found in LFormDict: " + rform,file=sys.stderr)
                    else:
                        frags[i] = '<span class="math-container"' + f
                        nofcnt = nofcnt + 1
                        # print("Formula " + id + " not found for Q " + str(Qid) + " when mathifying " + frags[i] + " in " + s,file=sys.stderr)
            else: # no id for the formula
                if lx in SLT:
                    rform = SLT[lx][0]
                    if cmml and not pmml:
                        rform = alttext + rform[5:] # insert LaTeX as alttext into <math header
                    frags[i] = '<span class="math-container"' + f[0:endtag]  + ' visual_id="' + SLT[lx][1] + '">' + rform + f[endspan:]
                    SLTcnt = SLTcnt + 1
                    # print("no id but found in SLT: " + rform,file=sys.stderr)
                elif lx in LFormDict:
                    rform = LFormDict[lx][0]
                    if cmml and not pmml:
                        rform = alttext + rform[5:] # insert LaTeX as alttext into <math header
                    frags[i] = '<span class="math-container"' + f[0:endtag]  + ' visual_id="' + LFormDict[lx][1] + '">' + rform + f[endspan:]
                    FDcnt = FDcnt + 1
                    # print("no id but found in LFormDict: " + rform,file=sys.stderr)
                else:
                    frags[i] = '<span class="math-container"' + f
                    nofcnt = nofcnt + 1
        return "".join(frags)

    def nextQ(pmml,cmml):
        # QPosts table: Qid Year Title Body Tags, sorted numerically by Year, Qid
        global Qid, latex_title, title, question, tags, Os, Ss, comment, answer, year, FTid
        if Qid == math.inf:
            return(False)
        try:
            Q = next(Qs) 
        except:
            Qid = math.inf
            return(False)
        # print("next Q =" + str(Q),file=sys.stderr)
        y = year
        Qid = int(Q["Qid"])
        year = Q["Year"]
        # print("Get new formulas",file=sys.stderr)
        getFormulas(pmml,cmml)               # read all formulas for the thread, since some are missing ids and some have spurious ids
        if firstA and ThreadId == Qid:
            answer = mathify(answer)    # apply formulas to read-ahead answer and comment
        if firstC and Tid == Qid:
            comment = mathify(comment)
        latex_title = unmathify(Q["Title"])
        title = mathify(Q["Title"])
        question = mathify(Q["Body"])
        tags = Q["Tags"]
        return(True)

    def nextA():
        # APosts table: Qid Year Aid Body, sorted numerically by Year, Qid, Aid
        global ThreadId, Aid, answer, firstA, Ayear
        # print("nextA",file=sys.stderr)
        if Aid == math.inf:
            return(False)
        if firstA:          # already read the first match
            if [Ayear,ThreadId] <= [year,Qid]:
                firstA = False
            if [Ayear,ThreadId] >= [year,Qid]:
                return(True)
        if (Qid == ThreadId):
            try:
                A = next(As)
            except:
                Aid = math.inf
                return(False)
            # print("nextA: " + str(A),file=sys.stderr)
            ThreadId = int(A["Qid"])
            Ayear = A["Year"]
        else:
            while [year,Qid] > [Ayear,ThreadId]:
                try:
                    A = next(As)
                except:
                    Aid = math.inf
                    return(False)
                # print("nextA: " + str(A),file=sys.stderr)
                ThreadId = int(A["Qid"])
                Ayear = A["Year"]
        Aid = int(A["Aid"])
        if ThreadId != Qid: # can't match formulas yet
            answer = A["Body"]
            firstA = True
        else:
            answer = mathify(A["Body"])
        return(True)

    def nextC(qa):  # qa = "q" for questions and "a" for answers
        # Comments table: PostId Qid Year CommentId Text, sorted numerically by Year, Qid, PostId, CommentId
        global Cid, Tid, comment, firstC, Cyear
        # print("nextC(" + qa + ")",file=sys.stderr)
        if Cid == math.inf:
            return(False)
        if firstC:          # already read the first match, if present
            # print("firstC",file=sys.stderr)
            if (qa == "q" and [Cyear,Tid] < [year,Qid] or 
                qa == "q" and [Cyear,Tid] == [year,Qid] and Cid == Tid or 
                qa == "a" and [Cyear,Tid,Cid] <= [year,Qid,Aid]):
                    firstC = False
            if (qa == "q" and [Cyear,Tid] > [year,Qid] or 
                qa == "q" and [Cyear,Tid] >= [year,Qid] and Cid == Tid or 
                qa == "a" and [Cyear,Tid,Cid] >= [year,Qid,Aid]):
                    return(True)
        if (Qid == Tid):
            try:
                C = next(Cs)
            except:
                Cid = math.inf
                return(False)
            # print("nextC: " + str(C),file=sys.stderr)
            Tid = int(C["Qid"])
            Cyear = C["Year"]
            Cid = int(C["PostId"])
            if qa == "a":
                while [year,Qid,Aid] > [Cyear,Tid,Cid]:
                    try:
                        C = next(Cs)
                    except:
                        Cid = math.inf
                        return(False)
                    # print("nextC: " + str(C),file=sys.stderr)
                    Tid = int(C["Qid"])
                    Cyear = C["Year"]
                    Cid = int(C["PostId"])
        else:
            while [year,Qid] > [Cyear,Tid]:
                try:
                    C = next(Cs)
                except:
                    Cid = math.inf
                    return(False)
                # print("nextC: " + str(C),file=sys.stderr)
                Tid = int(C["Qid"])
                Cyear = C["Year"]
            Cid = int(C["PostId"])
        # print("Tid: " + str(Tid) + " Qid: " + str(Qid),file=sys.stderr)
        if Tid == Qid:  # can't match formulas yet
            comment = '<div class="comment" id="{0}"> {1} </div>'.format(C["CommentId"],mathify(C["Text"]))
        else:
            comment = '<div class="comment" id="{0}"> {1} </div>'.format(C["CommentId"],C["Text"])
        if qa == "q" and Qid != Cid or qa == "a" and Aid != Cid:
            firstC = True
        return(True)

    def nextR():
        # Related table: Qid Year PostId LinkType Title, sorted numerically by Year, Qid, LinkType, 
        global Rid, rel_type, Rtitle, firstR, Ryear
        # print("nextR",file=sys.stderr)
        if Rid == math.inf:
            return(False)
        if firstR:          # already read the first match, if present
            if [Ryear,Rid] <= [year,Qid]:
                firstR = False
            if [Ryear,Rid] >= [year,Qid]:
                return(True)
        if (Qid == Rid):
            try:
                R = next(Rs)
            except:
                Rid = math.inf
                return(False)
            # print("nextR: " + str(R),file=sys.stderr)
            Rid = int(R["Qid"])
            Ryear = R["Year"]
        else:
            while [year,Qid] > [Ryear,Rid]:
                try:
                    R = next(Rs)
                except:
                    Rid = math.inf
                    return(False)
                # print("nextR: " + str(R),file=sys.stderr)
                Rid = int(R["Qid"])
                Ryear = R["Year"]
        rel_type = int(R["LinkType"])
        # <span class="math-container" id="229985"><math alttext="9!!!!!!!! !" class="ltx_Math" display="block" xmlns="http://www.w3.org/1998/Math/MathML">
        # <semantics><mrow>...</mrow><annotation-xml encoding="MathML-Content">...</annotation-xml></semantics></math></span>
        title = R["Title"]
        if pmml:
            if not cmml:
                frags = title.split("<annotation-xml ")
                for i in range(1,len(frags)):
                   f = frags[i]
                   frags[i] = f[f.index("</annotation-xml>")+17:]
                title = "".join(frags)
        else:
            if cmml:
                frags = title.split("<semantics>")
                for i in range(1,len(frags)):
                    f = frags[i]
                    start = f.index(">",f.index("<annotation-xml"))+1
                    end = f.index("</annotation-xml>")
                    frags[i] = "<semantics>" + f[start:end] + f[end+17:]
                for i in range(0,len(frags)-1):
                    f = frags[i]
                    mathstart = f.index("<math ") + 6
                    frags[i] = f[0:mathstart] + 'encoding="MathML-Content" ' + f[mathstart:]
            else:
                frags = title.split('<math alttext="')
                for i in range(1,len(frags)):
                    f = frags[i]
                    frags[i] = f[0:f.index('"')] + f[f.index("</math>")+7:]
            title = "".join(frags)
        Rtitle = '<div class="title" id="{0}"> {1} </div>'.format(R["PostId"],title) # formulas have already been substituted
        if Rid != Qid:       # read ahead
            firstR = True
        return(True)


    if not outdir:    # use stdout rather than creating compressed files
        outf = sys.stdout
    else:
        try:
            os.makedir(outdir)
        except:
            pass    # OK for directory to exist already


    with open(MINIMAL_HTML) as f:
        template = f.read().split('|')    # pieces of the template to surround Q-A-specific data
        # to insert [LaTeX title, Title, Qid, QBody, tags, QComments, Aid, Answer, AComments, Duplicate posts, Related posts]

    if l2pc:
        with gzip.open(indir + l2pc + INPUT_FORMAT, 'rt') as Lfile:
            Ls = csv.reader(Lfile, delimiter='\t', quotechar='\a')
            # "latex","slt","vid","opt"
            for row in Ls:
                if len(row[0]) < 50:
                   try:
                      SLT[row[0]] = [row[1],row[2]]
                      if row[3]:
                          OPT[row[0]] = [row[3],row[2]]
                   except:
                      continue
            print(str(len(SLT)) + " entries in LaTeX dictionary",file=sys.stderr)


    with gzip.open(indir + aposts   + INPUT_FORMAT, 'rt') as Afile, \
         gzip.open(indir + comments + INPUT_FORMAT, 'rt') as Cfile, \
         gzip.open(indir + rels     + INPUT_FORMAT, 'rt') as Rfile:

        Qs = csv.DictReader(sys.stdin, delimiter='\t', quotechar='\a')        # nothing ever quoted
        As = csv.DictReader(Afile, delimiter='\t', quotechar='\a')
        Cs = csv.DictReader(Cfile, delimiter='\t', quotechar='\a')
        Rs = csv.DictReader(Rfile, delimiter='\t', quotechar='\a')

        if cmml:
            Ofile = gzip.open(indir + cmml + INPUT_FORMAT, 'rt')
            Os = csv.DictReader(Ofile, delimiter='\t', quotechar='\a')
        else:
            Os = None
        if pmml:
            Sfile = gzip.open(indir + pmml + INPUT_FORMAT, 'rt')
            Ss = csv.DictReader(Sfile, delimiter='\t', quotechar='\a')
        else:
            Ss = None

        y = year
        while nextQ(pmml,cmml):
            if year !=  y:        # starting a new year
                print("Year: " +  year,file=sys.stderr)
                y = year
                if outdir:
                    outf = gzip.open(outdir + "task1_" + CY + "_corpus_" + year + OUTPUT_FORMAT, 'wt')  # output to one xml file per year

            nextA()
            if ThreadId > Qid:            # Answer is for a later question, so advance the question
                # print("No answers for question " + str(Qid),file=sys.stderr)
                continue

            nextC("q")                     # advance comments to the question post (if any)
            list = []
            while Cid == Qid:
                # print("Next comment for Tid: " + str(Tid) + " Qid: " + str(Qid),file=sys.stderr)
                list.append(comment)
                nextC("q")
            QComments = " ".join(list)

            nextR()                     # advance related posts to question post (if any)
            list = []
            while Rid == Qid and rel_type == 1:
                list.append(Rtitle)
                nextR()
            RelPosts = " ".join(list)
            list = []
            while Rid == Qid and rel_type == 3:
                list.append(Rtitle)
                nextR()
            DupPosts = " ".join(list)

            while ThreadId == Qid:        # Answer matches current question: create a page for the Q-A pair
                nextC("a")
                list = []
                while Cid == Aid:
                    # print("Next comment for Tid: " + str(Tid) + " Qid: " + str(Qid) + " Cid: " + str(Cid) + " Aid: " + str(Aid),file=sys.stderr)
                    list.append(comment)
                    nextC("a")
                AComments = " ".join(list)

                data = [latex_title, title, str(Qid), question, tags, QComments, str(Aid), answer, AComments, DupPosts, RelPosts, ""]
                list = []
                for items in zip(template, data):    # interleave template fragments with data
                    list.extend(items)
                newpage = "".join(list)

                outf.write("<DOC>\n<DOCNO>" + year + "_" + str(Qid) + "_" + str(Aid) + "</DOCNO>\n" + newpage + "\n</DOC>\n")
                outf.flush()
                if not nextA():
                        break
    #gzip.close(outf)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Generate HTMLs for indexing.")

    parser.add_argument(
        "-i", "--input_dir", default=".", dest="indir",
        help="Directory for reading inputs. Default = current directory."
    )

    parser.add_argument(
        "-A", "--answer_posts", default="APosts", dest="aposts",
        help="File name for answer posts (Qid Aid Body, sorted by Qid,Aid). Default = APosts."
    )

    parser.add_argument(
        "-C", "--comments", default="Comments", dest="comments",
        help="File name for comments (PostID QId CommentId Text, sorted by Qid,PostId). Default = Comments."
    )

    parser.add_argument(
        "-R", "--related", default="Related", dest="related",
        help="File name for related posts (Qid PostId LinkType Title, sorted by Qid,LinkType). Default = Related."
    )

    parser.add_argument(
        "-L", "--latex", default=None, dest="l2pc",
        help="File name for LaTeX to MathML mapping (latex slt [opt], sorted by latex). Default = None."
    )

    parser.add_argument(
        "-S", "--slts", default=None, dest="pmml",
        help="File name prefix for Presentation MathML (id post_id thread_id type comment_id visual_id formula year, sorted by id). Default = None."
    )

    parser.add_argument(
        "-O", "--opts", default=None, dest="cmml",
        help="File name prefix for Content MathML (id post_id thread_id type comment_id visual_id formula year, sorted by id). Default = None."
    )
    parser.add_argument(
        "-o", "--output_dir", default=None, dest="outdir",
        help="Directory for storing generated corpus by year. Default = stdout."
    )
    parser.add_argument(
        "-y", "--year", default="2024", dest="CY",
        help="Corpus year. Default = 2024."
    )

    args = parser.parse_args()

    if not args.indir:
       indir = "."
    else:
       if args.indir.endswith("/"):
          indir = args.indir
       else:
          indir = args.indir + "/"
    if args.outdir:
       if args.outdir.endswith("/"):
          outdir = args.indir
       else:
          outdir = args.indir + "/"
    else:
        outdir = None

    print("Using {0}{1}.tsv.gz (similarly, {2} and {3})".format(indir, args.aposts, args.comments, args.related),file=sys.stderr)
    print("to create corpus {0} Presentation and {1} Content MathML".format("with" if args.pmml else "without", "with" if args.cmml else "without"),file=sys.stderr)
    print("into {0}.\n<corpus>".format((outdir + "task1_" + args.CY + "_corpus_*" + OUTPUT_FORMAT) if outdir else "stdout"),file=sys.stderr)
    generate_files(indir, args.aposts, args.comments, args.related,
            outdir, args.l2pc, args.pmml, args.cmml, args.CY)
    print("</corpus> Loaded corpus into {0}.".format(outdir if outdir else "stdout"),file=sys.stderr)
    print(str(fcnt) + " math exprs in all: " + str(ltxcnt) + " found as LaTeX; " + str(SLTcnt) + " resolved in dict; " + str(FDcnt) + "resolved from cache; " + str(nofcnt) + " not resolved")
