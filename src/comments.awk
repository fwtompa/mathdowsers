#   <row CreationDate="2017-04-16T08:22:26.993" Id="4598590" PostId="9" Score="2" Text="I assume with &quot;positive numbers&quot; you mean &quot;positive *integers*&quot;. Because, after all, &lt;span class=&quot;math-container&quot; id=&quot;1&quot;&gt;\pi&lt;/span&gt; is a positive number as well." UserId="34930"/>

# Comments are writtens as .tsv to stdout (but need to be sorted)

# must include fields.awk on command line

	{
	parse()
	print unquote(val["PostId"]), unquote(val["Id"]), decode(val["Text"]) | "sort -k 1,1"
	}
