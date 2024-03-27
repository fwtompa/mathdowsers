# id      post_id thread_id       type    comment_id      visual_id       formula
# 1       9       1       comment 4598590 1294    <math alttext="\pi" class="ltx_Math" display="block" xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mi>π</mi></semantics></math>
# 30      52      1       answer          87828   <math alttext="a_{1},a_{2},a_{3},..." class="ltx_Math" display="block" xmlns="http://www.w3.org/1998/Math/MathML"><semantics><mrow><msub><mi>a</mi><mn>1</mn></msub><mo>,</mo><msub><mi>a</mi><mn>2</mn></msub><mo>,</mo><msub><mi>a</mi><mn>3</mn></msub><mo>,</mo><mi mathvariant="normal">…</mi></mrow></semantics></math>
BEGIN	{FS = "\t"}
$1 != "id"	{
		 if(($4 == "question" || $4 == "answer") && !($6 in seen)) {
		    seen[$6]
		    print "<DOC>"
		    print "<DOCNO>" $1 "_" $2 "_" $6 "</DOCNO>"
		    print $7
		    print "</DOC>"
	    	    }
		}
