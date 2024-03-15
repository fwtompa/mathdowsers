# Posts:
# Id="3"  PostTypeId="1"  CreationDate="2010-07-20T19:12:14.353"  ViewCount="70334"       Score="120"     CommentCount="3"        OwnerUserId="29"        Title="List of interesting math podcasts?"     Body="&lt;p&gt;&lt;a href=&quot;http://mathfactor.uark.edu/&quot;&gt;mathfactor&lt;/a&gt; is one I listen to.  Does anyone else have a recommendation?&lt;/p&gt; "     AnswerCount="20"        Tags="&lt;soft-question&gt;&lt;big-list&gt;&lt;online-resources&gt;"
# Comments:
#   <row CreationDate="2017-04-16T08:22:26.993" Id="4598590" PostId="9" Score="2" Text="I assume with &quot;positive numbers&quot; you mean &quot;positive *integers*&quot;. Because, after all, &lt;span class=&quot;math-container&quot; id=&quot;1&quot;&gt;\pi&lt;/span&gt; is a positive number as well." UserId="34930"/>

function field(s,	t)
{
	t = index(s,"=")
	val[substr(s,1,t-1)] = substr(s,t+1)
}
function parse()
{
	delete val
	for(i=1;i<=NF;i++) {field($i)}
}
function unquote(s)
{
	return(substr(s,2,length(s)-2))
}
function restore_punc(t,	v)
{
	for (v in entref) {gsub("&" v,entref[v],t)}
	gsub(/&amp;/,"\\&",t)
	gsub(/<math/,"\\&lt;math",t)		# but do not allow loose <math tags
	gsub(/<\/math>/,"\\&lt;/math\\&gt;",t)	# nor loose </math> tags
	return(t)
}
function encode_chardata(t,	v)
{
	# gsub(/&/,"\\&amp;",t) for (v in entref) {gsub("&amp;" v, "\\&" v, t)}	# &amp;lt; -> &lt; etc.
	gsub(/&amp;amp;/,"\\&amp;",t)
	for (v in entref) {gsub(entref[v],"\\&" v,t)} 	# < -> &lt; etc.
	return(t)
}
function decode(s,	t)
{
	# restore angle brackets for <span ... </span>
	gsub(/&quot;/,"\"",s)
	gsub(/&apos;/,"'",s)
	t = unquote(s)
	gsub(/&lt;span[^&]*&gt;/,"<@@@@@&@@@@@>",t)   # simulate gensub(...)
        gsub("<@@@@@&lt;","<",t)
        gsub("&gt;@@@@@>",">",t)
	gsub(/&lt;\/span&gt;/,"</span>",t)
	# ... <span class="math-container" id="323">0&amp;lt;\sqrt{D}-n&amp;lt;1.</span> ...

	if (t ~ /&#/) {	# make sure char refs have semicolon
		gsub(/&#[0-9]+/,"&@@@@@",t)
		gsub(/@@@@@;/,";",t)
		gsub(/@@@@@/,";",t)
		for (v in char) {gsub(v,char[v],t)}
		}

	gsub(/&nbsp;/," ",t) 	# remove &nbsp; everywhere
	# for (v in entref) {gsub("&amp;" v, "\\&" v, t)}	# &amp;lt; -> &lt; etc.
	# gsub(/&amp;amp;/,"\\&amp;",t)

	n = split(t,frags,"<span class=")
	frags[1] = restore_punc(frags[1])
	for(i=2;i<=n;i++) {
		f = frags[i]
		endtag = index(f,">")
		endspan = index(f,"</span>")
		# remove junk formulas (e.g.,  Wow, <span class="math-container" id="11192966">g</span>reat way to explain it.)
		#if (endspan==endtag+2) {  # removes ALL singleton formulas
		if (endspan==endtag+2 && (length(f) == endspan+7 || (substr(f,endspan+7,1) ~ /[a-zA-Z0-9]/) || (substr(frags[i-1],length(frags[i-1]),1) ~ /[a-zA-Z0-9]/))) {
			frags[i] = substr(f,endtag+1,1) restore_punc(substr(f,endspan+7))	# remove <span>
			seps[i-1] = ""
			endtag = 0
			endspan = 0
			}
		else {
			# latex formula must be character data only; all characters allowed outside span
			frags[i] = substr(f,1,endtag) encode_chardata(substr(f,endtag+1,endspan-endtag-1)) "</span>" restore_punc(substr(f,endspan+7))
			seps[i-1] = "<span class="
			}
		}
	t = frags[1]
        for (i=2;i<=n;i++) {t = t seps[i-1] frags[i]}
	return(t)
}
function list(s,	t)
{
	t = unquote(s)
	gsub(/&lt;/,"<span>",t)
	gsub(/&gt;/,"</span>, ",t)
	return(substr(t,1,length(t)-2))	# remove trailing comma and space
}

BEGIN	{
	FS = "	"
	OFS = "	"
	entref["lt;"] = "<"
	entref["gt;"] = ">"
	entref["quot;"] = "\""
	entref["apos;"] = "'"
	for (i=32;i<127;i++) {char["&#" i ";"] = sprintf("%c",i)}
	}
