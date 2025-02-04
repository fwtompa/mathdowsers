#   Expects to read formulas (SLT or OpT)
#
#   id      topic_id        thread_id       type    slt
#   q_1     A.1     3062860 title   "<?xml version=""1.0"" encoding=""UTF-8""?> <math xmlns=""http://www.w3.org/1998/Math/MathML"" alttext=""c"" display=""block"">   <mi>c</mi> </math> "
#
#   or
#
#   id      topic_id        thread_id       type    opt
#   q_1     A.1     3062860 title   "<?xml version=""1.0"" encoding=""UTF-8""?> <math xmlns=""http://www.w3.org/1998/Math/MathML"" alttext=""c"" display=""block"">   <ci>𝑐</ci> </math> "

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
	gsub(/<share[^>]*\/> */,"",s)
	return s
}

BEGIN		{FS = "\t"
		}

/<math/		{print $1 "\t" formula($5)
		}
