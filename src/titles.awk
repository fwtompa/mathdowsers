# SLT:
# 360	11	11	title		4799524	4799524		<math alttext="0.999999999\dots=1" class="ltx_Math" display="block" xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mrow><mn>0.999999999</mn><mo>⁢</mo><mi mathvariant="normal">⋯</mi></mrow><mo>=</mo><mn>1</mn></mrow></semantics></math>
#
# OPT:
# 360	11	11	title		4799524	4799524		<math encoding="MathML-Content" xmlns="http://www.w3.org/1998/Math/MathML"><apply><eq></eq><apply><times></times><cn type="float">0.999999999</cn><ci>⋯</ci></apply><cn type="integer">1</cn></apply></math>

# 987257  2010	1000024 1       proving that a function is uniformly continuous
# 1383345 2010	1000025 1       Show that <span class="math-container" id="9533887">\mathbb{Z}[\sqrt{223}]</span> has three ideal classes.
# 1001751 2010	1001834 1       Prove that <span class="math-container" id="9548873">m+\frac{4}{m^2}\geq3</span> for every <span class="math-container" id="9548874">m > 0</span>

BEGIN   {
	 FS = "\t"
	 OFS = "\t"
	 while ((getline < "pmml") > 0) # one entry per line
	    {
	     split($0,pres)
	     if ((getline <  "cmml") < 0) break
	     if ($1 != pres[1] || $3 != pres[3]) {
	         print "Mismatched MathML: " $0
	         break
	     }
	     start = index($9,">")+1
	     opt = substr($9,start,length($9)-start-6)
	     slt[$3,$1,"v"] = $7
	     slt[$3,$1,"f"] = substr(pres[9],1,length(pres[9])-19) "<annotation-xml encoding=\"MathML-Content\">" opt "</annotation-xml></semantics></math>"
	    }
	}

	{
	 n = split($5,frags,"<")
	 title = frags[1]
	 for (i=2;i<=n;i++) {
	     if (substr(frags[i],1,5) == "span ") {	
	         start = index(frags[i]," id=")+5
	         len = index(frags[i],">") - 1 - start
	         id = substr(frags[i],start,len)
	         title = title "<" substr(frags[i],1,start+len) " visual_id=\"" slt[$3,id,"v"] "\">" slt[$3,id,"f"]
	         }
	     else title = title "<" frags[i]
	     }
	 print $1, $2, $3, $4, title
	}
	     
	     
