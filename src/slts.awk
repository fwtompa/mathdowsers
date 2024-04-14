# input format: id post_id thread_id type comment_id old_visual_id visual_id issue formula, sorted numerically by id
#  where the formula encoding is: " <math alttext=""\pi"" class=""ltx_Math"" display=""block"" xmlns= ...
# desired formula format: <math alttext="\pi" class="ltx_Math" display="block" xmlns="http://www.w3.org/1998/Math/MathML"><sema....
BEGIN	{FS = "	"; OFS = "	"}
/\\par Formula/	{next}
/\\begin{equation/	{next}
/\\@@eqnarray/	{next}
	{
	gsub(/" *<math/,"<math",$9)
	gsub(/<\/math>.*/,"</math>",$9)
	gsub(/""/,"\"",$9)
	gsub(/&/,"\\&amp;",$9)
	gsub(/<<</,"\\&lt;\\&lt;<",$9)
	gsub(/<</,"\\&lt;<",$9)
	gsub(/>>>/,">\\&gt;\\&gt;",$9)
	gsub(/>>/,">\\&gt;",$9)
	gsub(/<=</,"\\&lt;=<",$9)
	gsub(/>"</,">\\&quot;<",$9)
	gsub(/>'</,">\\&apos;<",$9)
	n = index($9,"alttext=")
	if (n>0) {
		alttext = substr($9,n+8)
		delim = substr(alttext,1,1)
		end = index(substr(alttext,2),delim) + 1    # offset of delim offset at end of alttext
		alt = substr(alttext,2,end-2)               # text between delims
		gsub(/</,"\\&lt;",alt)
		gsub(/>/,"\\&gt;",alt)
		gsub(/'/,"\\&apos;",alt)
		$9 = substr($9,1,n+8) alt substr(alttext,end)
		}
	gsub("<mpadded[^>]*>","",$9) 		# LaTeXML does not produce </mpadded>
	print $1, $2, $3, $4, $5, $7, $9
	}	
