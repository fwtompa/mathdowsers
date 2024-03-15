# Id="3"  PostTypeId="1"  CreationDate="2010-07-20T19:12:14.353"  ViewCount="70334"       Score="120"     CommentCount="3"        OwnerUserId="29"        Title="List of interesting math podcasts?"     Body="&lt;p&gt;&lt;a href=&quot;http://mathfactor.uark.edu/&quot;&gt;mathfactor&lt;/a&gt; is one I listen to.  Does anyone else have a recommendation?&lt;/p&gt; "     AnswerCount="20"        Tags="&lt;soft-question&gt;&lt;big-list&gt;&lt;online-resources&gt;"
# Id="4"  PostTypeId="2"  CreationDate="2010-07-20T19:14:10.603"  Score="11"      CommentCount="1"        OwnerUserId="31"        Body="&lt;p&gt;&lt;a href=&quot;http://www.bbc.co.uk/podcasts/series/moreorless&quot; rel=&quot;noreferrer&quot;&gt;More or Less&lt;/a&gt; is a BBC Radio 4 programme about maths and statistics in the news, and there is a free podcast. It's presented by &lt;a href=&quot;http://timharford.com/&quot; rel=&quot;noreferrer&quot;&gt;Tim Harford&lt;/a&gt;, the Undercover Economist from the &lt;a href=&quot;http://www.ft.com/home/uk&quot; rel=&quot;noreferrer&quot;&gt;Financial Times&lt;/a&gt;.&lt;/p&gt; "      ParentId="3"

# Question posts are written as .tsv to stdout (and assumed to be in order)
# Answer posts are writtens as .tsv to Aposts (but need to be sorted)

# must include fields.awk on command line

BEGIN	{
	print "Qid","Year","Title","Body","Tags"
	} 

$2 ~ "1"	{	# Question Posts
	parse()
	id = unquote(val["Id"])
	title = decode(val["Title"])
	year = substr(val["CreationDate"],2,4)
	if(unquote(val["AnswerCount"])!="0") {
		print id, year, title, decode(val["Body"]),list(val["Tags"])
		print id,id | "sort -t '	' -k 2,2 >> PostsToThreads"
	}
	print id,year,title | "sort -t '	' >> PostsToTitles"
	}
$2 ~ "2"	{	# Answer Posts
	parse()
	qid = unquote(val["ParentId"])
	aid = unquote(val["Id"])
	print qid,aid,decode(val["Body"]) | "sort -t '	' -k 1,1 >> Aposts"
	print aid,qid | "sort -t '	' -k 2,2 >> PostsToThreads"
	}
