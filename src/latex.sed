# remove latex delimiters
s/\$//g
# trim starting and ending blanks
s/  */ /g
s/ *	 */	/g
s/^ //
s/ $//
# no line can end with a tab (i.e., no latex)
/	$/d
# handle errors in capturing latex
s/\\>/\\:/g
/<span/d
/<math/d
/	%/d
/^[^\\]*\([a-zA-Z ]\)\{20\}/d
# no starting quote means already on one line
/	[^"	][^	]*$/s/$/\a/
# text within quote, so change line end to blank
/	"./s/$/ /
/^[^	]*[^"]$/s/$/ /
# remove starting quote
s/	"/	/
# ending quote signals need for line end
s/"$/\a/
# but double quote means a single quote instead
s/"\a$/""/
# but triple quote means quote before terminating quote
s/"""$/""\a/
# all other double quotes represent single quotes
s/""/"/g
