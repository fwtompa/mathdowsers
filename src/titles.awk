# SLT:
# 360	11	11	title	#(start)# ... #(end)#	2010
#
# OPT:
# 360	11	11	title	<math encoding="MathML-Content" xmlns="http://www.w3.org/1998/Math/MathML"><apply><eq></eq><apply><times></times><cn type="float">0.999999999</cn><ci>⋯</ci></apply><cn type="integer">1</cn></apply></math>	2010

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
	     slt[$3,$1] = pres[5] $5
	    }
	}

	{
	 n = split($5,frags,"<span ")
	 title = frags[1]
	 for (i=2;i<=n;i++) {
	     start = index(frags[i]," id=")+5
	     len = index(frags[i],">") - 1 - start
	     id = substr(frags[i],start,len)
	     title = title "<span " substr(frags[i],1,start+len) ">" slt[$3,id] frags[i]
	     }
	 print $1, $2, $3, $4, title
	}
	     
	     
