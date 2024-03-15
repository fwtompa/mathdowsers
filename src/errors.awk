# SLT:
# 360	11	11	title		4799524	4799524		<math alttext="0.999999999\dots=1" class="ltx_Math" display="block" xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><mrow><mn>0.999999999</mn><mo>⁢</mo><mi mathvariant="normal">⋯</mi></mrow><mo>=</mo><mn>1</mn></mrow></semantics></math>
#
# errors:
# 987257
# 1383345
# 1001751

BEGIN   {
	 FS = "\t"
	 OFS = "\t"
	 while ((getline < "errors") > 0) # one entry per line
	    {
	       error[$1]
	    }
	}

!($1 in error)	{
	 print $0
	}
	     
	     
