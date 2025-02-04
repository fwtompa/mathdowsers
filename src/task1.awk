#   Expects to read processed formulas (fid,latex,slt,opt) followed by topics
#
#   q_1     c       #(start)# #(v!c,!0)# #(v!c,!0,-)# #(end)#       #(start)# #(v!𝑐,!0)# #(v!𝑐,!0,-)# #(end)#

#   Command line arguments to process slts and/or opts
#   	trees=... (default = "")
#   	if trees[1] in [Ss], then SLTs
#   	if trees[-1] in [Oo] then OpTs

#   <Topic number="A.4">
#      <Title>How to compute this combinatoric sum?</Title>
#      <Question>&lt;p&gt;I have the sum&lt;/p&gt;  &lt;p&gt;&lt;span class=&quot;math-container&quot; id=&quot;q_22&quot;&gt;$$\sum_{k=0}^{n} \binom{n}{k} k$$&lt;/span&gt;&lt;/p&gt;  &lt;p&gt;I know the result is &lt;span class=&quot;math-container&quot; id=&quot;q_23&quot;&gt;$n 2^{n-1}$&lt;/span&gt; but I don't know how you get there. How does one even begin to simplify a sum like this that has binomial coefficients.&lt;/p&gt; </Question>
#      <Tags>combinatorics,number-theory,summation,proof-explanation</Tags>
#   </Topic>
#

function get_latex(s) {
	# remove $..$ or $$..$$
	gsub(/\$/,"",s)
	# remove trailing blanks
	sub(/ *$/,"",s)
	gsub(/&amp;/,"\\&",s)
	gsub(/&lt;/,"<",s)
	gsub(/&gt;/,">",s)
	gsub(/&quot;/,"\"",s)
	return(s)
}

function text(s,	 n, spanend, f, fid, endspan, frag, latex) {
	gsub(/&quot;/,"\"",s)
	gsub(/&lt;span [^&]*&gt;/,"<&>",s)	# span has attributes
	gsub(/&lt;a [^&]*&gt;/,"<&>",s)		# so does a
	gsub(/&lt;[^ &]*&gt;/,"<&>",s)		# all other tags
	gsub(/<&lt;/,"<",s)
	gsub(/&gt;>/,">",s)
	gsub(/&amp;amp;/,"\\&amp;",s)
	n = split(s,frag,"<span ")
	# <span class="math-container" id="q_22">
	s = frag[1]
	for(i=2;i<=n;i++) {
	    spanend = index(frag[i],">")
	    endspan = index(frag[i],"</span>")
	    if(endspan==0) {
		# spurious <span found
	        continue
		}
	    f = index(frag[i],"id=") + 4
	    fid = substr(frag[i],f,spanend-f-1)
	    if(f > 0 && fid in form) {
	        s = s "<span " substr(frag[i],1,spanend) form[fid] substr(frag[i],endspan)
		lastfid = fid
                }
	    else {
	        latex = get_latex(substr(frag[i],spanend+1,endspan-spanend-1))
	        if (latex in qid) {
		    s = s "<span " substr(frag[i],1,spanend) form[qid[latex]] substr(frag[i],endspan)
		    }
		else {
		    print "No match to latex:", "#" latex "#", "after matching", lastfid
	            }
	    }   
	}
	return(s)
}

BEGIN		{FS = "\t"
		 file = 0
		}

/<Topics>/	{FS = "[<>]"
		 file = 1}

file == 0	{#  map latex formulas to fid
		 if (length(trees) == 0) next
		 qid[$2] = $1
		 f = ""
		 if (tolower(substr(trees,1,1)) == "s") {f = $3}
		 if (tolower(substr(trees,length(trees),1)) == "o") {f = f " " $4}
		 form[$1] = f
		}

/<Topic number/	{split($2,fld,/"/)
		 Tid = fld[2]
		}
/<Title>/	{Title = text($3)}
/<Question>/	{Question = text($3)}
/<Tags>/	{Tags = $3
		 gsub(/,/,", ",Tags)
		}
/<\/Topic>/	{print Tid ";",Title,Question,Tags}
