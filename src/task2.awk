#      <Topic number="B.201">
#       <Formula_Id>q_1</Formula_Id>
#       <Latex>n\times n</Latex>
#       <Title>Matrix over division ring having one sided inverse is invertible</Title>
#       <Question>&lt;p&gt;I want to ... </Question>
#       <Tags>abstract-algebra,matrices,ring-theory</Tags>
#    </Topic>

#
BEGIN		{FS = "\t"
		 while ((getline < "forms") > 0) { # one entry per line
		    form[$1] = $2
	    	    }
		 FS = "[<>]"
		}

/<Topic number/	{split($2,fld,/"/)
		 Tid = fld[2]
		}
/<Formula_Id>/	{print Tid "; " form[$3]}
