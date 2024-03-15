# Id="13" CreationDate="2010-07-21T05:09:26.900"  PostId="113"    RelatedPostId="234"     LinkTypeId="1" />
# Id="55" CreationDate="2010-07-22T16:53:03.793"  PostId="477"    RelatedPostId="505"     LinkTypeId="1" />
# Id="121"        CreationDate="2010-07-25T09:58:14.870"  PostId="618"    RelatedPostId="614"     LinkTypeId="1" />
# sorted lexicographically by PostId, RelatedPostId, reverse LinkTypeId


# Comments are writtens as .tsv to stdout (but need to be sorted)

BEGIN	{
	qid = 0; postid = 0
	}

	{
	parse()
	oldqid = qid
	oldpid = postid
	qid = unquote(val["PostId"])
	postid = unquote(val["RelatedPostId"])
	if(qid!=oldqid || postid!=oldpid) {
		type = val["LinkTypeId"]
		type = substr(type,2,1)
		print qid, postid, type | "sort -k 2,2"
		print postid, qid, type | "sort -k 2,2"	 	# relatedness is symmetric
		}
	}
