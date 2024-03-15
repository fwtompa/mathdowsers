/<row/!d
s/ \([A-Z][^=]*="[^"]*"\)/	\1/g
s/^ *<row	//
s/\/>$//
s/\(&lt;span class=&quot;math-container&quot;&gt;\)\$\+/\1/g
s/\$\+\(&lt;\/span&gt;\)/\1/g
