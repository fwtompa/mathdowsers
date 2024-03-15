# <math alttext="\pi" class="ltx_Math" display="block" xmlns="http://www.w3.org/1998/Math/MathML"><sema....
/alttext=/	{
	n = split($0,frags,"alttext=")
	for(i=2;i<=n;i++) {
		delim = substr(frags[i],1,1)
		end = index(substr(frags[i],2),delim) + 1    # delim offset in frags[i]
		alt = substr(frags[i],2,end-2)               # between delims
		gsub(/&/,"\\&amp;",alt)
		gsub(/</,"\\&lt;",alt)
		gsub(/>/,"\\&gt;",alt)
		gsub(/'/,"\\&apos;",alt)
		frags[i] = "alttext=" delim alt substr(frags[i],end)
		}
	t = frags[1]
	for(i=2;i<=n;i++) {t = t frags[i]}
	n = split(t,frags,"<mpadded")
	for(i=2;i<=n;i++) {
		if(index(frags[i],"</mpadded>")>0) continue
		sub(">","></mpadded>",frags[i])
		}
	t = frags[1]
	for(i=2;i<=n;i++) {t = t "<mpadded" frags[i]}
	print t
	}
!/alttext=/	{
	n = split($0,frags,"<mpadded")
	for(i=2;i<=n;i++) {
		if(index(frags[i],"</mpadded>")>0) continue
		sub(">","></mpadded>",frags[i])
		}
	t = frags[1]
	for(i=2;i<=n;i++) {t = t "<mpadded" frags[i]}
	print t
	}
