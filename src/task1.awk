#   Expects to read formulas followed by topics
#
#   <Topic number="A.4">
#      <Title>How to compute this combinatoric sum?</Title>
#      <Question>&lt;p&gt;I have the sum&lt;/p&gt;  &lt;p&gt;&lt;span class=&quot;math-container&quot; id=&quot;q_22&quot;&gt;$$\sum_{k=0}^{n} \binom{n}{k} k$$&lt;/span&gt;&lt;/p&gt;  &lt;p&gt;I know the result is &lt;span class=&quot;math-container&quot; id=&quot;q_23&quot;&gt;$n 2^{n-1}$&lt;/span&gt; but I don't know how you get there. How does one even begin to simplify a sum like this that has binomial coefficients.&lt;/p&gt; </Question>
#      <Tags>combinatorics,number-theory,summation,proof-explanation</Tags>
#   </Topic>
#
#   Found the following encoding errors in formulas:
#
#   <mi mathvariant=""normal"">&amp;</mi><mi>l</mi><mi>t</mi><mo>;</mo>
#   <mo>⁢</mo><mi mathvariant=""normal"">&amp;</mi><mo>⁢</mo><mi>g</mi><mo>⁢</mo><mi>t</mi></mrow><mo>;</mo> 
#   <mrow><mi mathvariant=""normal"">&amp;</mi><mo>⁢</mo><mi>l</mi><mo>⁢</mo><mi>t</mi></mrow><mo>;</mo>
#   <mo>⁢</mo><mi mathvariant=""normal"">&amp;</mi><mo>⁢</mo><mi>l</mi><mo>⁢</mo><mi>t</mi></mrow></mrow><mo>;</mo>
#   <mo>⁢</mo><mi mathvariant=""normal"">&amp;</mi><mo>⁢</mo><mi>a</mi><mo>⁢</mo><mi>m</mi><mo>⁢</mo><mi>p</mi></mrow><mo>;</mo>
#   <mo>⁢</mo><mi mathvariant=""normal"">&amp;</mi><mo>⁢</mo><mi>a</mi><mo>⁢</mo><mi>m</mi><mo>⁢</mo><mi>p</mi></mrow></mrow><mo>;</mo>
#   <mo>⁢</mo><mi mathvariant=""normal"">&amp;</mi><mo>⁢</mo><mi>g</mi><mo>⁢</mo><mi>t</mi></mrow></mrow></mrow><mo>;</mo>

function formula(s)
{
	s = substr(s,index(s,"<math"),index(s,"</math>")-index(s,"<math")+7)
	gsub(/""/,"\"",s)
	gsub(/> *</,"><",s)
	gsub( /<mo>.<.mo><mi mathvariant="normal">&amp;<.mi><mo>.<.mo><mi>lt<.mi><.mrow><mo>;<.mo>/,
            "<mo>\\&lt;</mo></mrow>",
            s)
	gsub( /<mo>.<.mo><mi mathvariant="normal">&amp;<.mi><mo>.<.mo><mi>lt<.mi><.mrow><.mrow><mo>;<.mo>/,
            "<mo>\\&lt;</mo></mrow></mrow>",
            s)

	gsub( /<mi mathvariant="normal">&amp;<.mi><mi>g<.mi><mi>t<.mi><mo>;<.mo>/,
            "<mo>\\&gt;</mo>",
            s)  
	gsub( /<mi mathvariant="normal">&amp;<.mi><mi>l<.mi><mi>t<.mi><mo>;<.mo>/,
            "<mo>\\&lt;</mo>",
            s)
	gsub( /<mrow><mi mathvariant="normal">&amp;<.mi><mo>.<.mo><mi>g<.mi><mo>.<.mo><mi>t<.mi><.mrow><mo>;<.mo>/,
            "<mo>\\&gt;</mo>",
            s)
	gsub( /<mrow><mi mathvariant="normal">&amp;<.mi><mo>.<.mo><mi>l<.mi><mo>.<.mo><mi>t<.mi><.mrow><mo>;<.mo>/,
            "<mo>\\&lt;</mo>",
            s)
	gsub( /<mo>.<.mo><mi mathvariant="normal">&amp;<.mi><mo>.<.mo><mi>a<.mi><mo>.<.mo><mi>m<.mi><mo>.<.mo><mi>p<.mi><.mrow><mo>;<.mo>/,
            "<mi>\\&amp;</mi></mrow>",
            s)
	gsub( /<mo>.<.mo><mi mathvariant="normal">&amp;<.mi><mo>.<.mo><mi>g<.mi><mo>.<.mo><mi>t<.mi><.mrow><mo>;<.mo>/,
            "<mo>\\&gt;</mo></mrow>",
            s)
	gsub( /<mo>.<.mo><mi mathvariant="normal">&amp;<.mi><mo>.<.mo><mi>l<.mi><mo>.<.mo><mi>t<.mi><.mrow><mo>;<.mo>/,
            "<mo>\\&lt;</mo></mrow>",
            s)
	gsub( /<mo>.<.mo><mi mathvariant="normal">&amp;<.mi><mo>.<.mo><mi>a<.mi><mo>.<.mo><mi>m<.mi><mo>.<.mo><mi>p<.mi><.mrow><.mrow><mo>;<.mo>/,
            "<mi>\\&amp;</mi></mrow></mrow>",
            s)
	gsub( /<mo>.<.mo><mi mathvariant="normal">&amp;<.mi><mo>.<.mo><mi>g<.mi><mo>.<.mo><mi>t<.mi><.mrow><.mrow><mo>;<.mo>/,
            "<mo>\\&gt;</mo></mrow></mrow>",
            s)
	gsub( /<mo>.<.mo><mi mathvariant="normal">&amp;<.mi><mo>.<.mo><mi>l<.mi><mo>.<.mo><mi>t<.mi><.mrow><.mrow><mo>;<.mo>/,
            "<mo>\\&lt;</mo></mrow></mrow>",
            s)
	gsub( /<mo>.<.mo><mi mathvariant="normal">&amp;<.mi><mo>.<.mo><mi>g<.mi><mo>.<.mo><mi>t<.mi><.mrow><.mrow><.mrow><mo>;<.mo>/,
            "<mo>\\&gt;</mo></mrow></mrow></mrow>",
            s)
	gsub( /<mo>.<.mo><mi mathvariant="normal">&amp;<.mi><mo>.<.mo><mi>l<.mi><mo>.<.mo><mi>t<.mi><.mrow><.mrow><.mrow><mo>;<.mo>/,
            "<mo>\\&lt;</mo></mrow></mrow></mrow>",
            s)
	gsub(/\302\240/," ",s)
	gsub(/><</,">\\&lt;<",s)
	gsub(/>></,">\\&gt;<",s)
	gsub(/&#10;/,"",s)
	gsub(/&amp;amp;/,"\\&amp;",s)
	gsub(/&amp;lt;/,"\\&lt;",s)
	gsub(/&amp;gt;/,"\\&gt;",s)
	gsub(/&lt;/,"#lt;",s)
	gsub(/&gt;/,"#gt;",s)
	gsub(/&amp;/,"#amp;",s)
	gsub(/&quot;/,"#quot;",s)
	gsub(/&/,"\\&amp;",s)
	gsub(/</,"\\&lt;",s)
	gsub(/>/,"\\&gt;",s)
	sub(/^&lt;/,"<",s)
	sub(/&gt;$/,">",s)
	gsub(/&gt;[^ &|]*&lt;/,">&<",s)
	gsub(/>&gt;/,">",s)
	gsub(/&lt;</,"<",s)
	gsub(/<mtext&gt;/,"<mtext>",s)
	gsub(/&lt;\/mtext>/,"</mtext>",s)
	gsub(/&gt;lim sup&lt;/,">lim sup<",s)
	gsub(/<[^&#<]*&gt;/,"&>",s)
	gsub(/&lt;\/[a-z]*>/,"<&",s)
	gsub(/&gt;>/,">",s)
	gsub(/<&lt;/,"<",s)
	gsub(/#/,"\\&",s)
	return s
}

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

$1 == "id"	{file = file + 1}

file == 1	{#  map latex formulas to query numbers
		 sub(/ *$/,"",$5)
		 gsub(/\$/,"",$5)
		 qid[$5] = $1
		}

/<math/		{form[$1] = formula($5)
		}

/<Topics>/	{FS = "[<>]"}
/<Topic number/	{split($2,fld,/"/)
		 Tid = fld[2]
		}
/<Title>/	{Title = text($3)}
/<Question>/	{Question = text($3)}
/<Tags>/	{Tags = $3
		 gsub(/,/,", ",Tags)
		}
/<\/Topic>/	{print Tid ";",Title,Question,Tags}
END		{for (fid in form) {
		     print fid "\t"  form[fid] > "forms"
	             }
		}
