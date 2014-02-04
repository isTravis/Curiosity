import sys


# infile= sys.argv[1]


# infile = "samplefile"
# outfile = "sampleoutput.txt"

in_file = open("pagecounts-20140131-060000", 'r')
# in_file = open("samplefile", 'r')


prefix = 'Z'

totalGood = 0
totalBad = 0
moreThan1 = 0
lessThan2 = 0
for lineItem in in_file.readlines():
	prefix = lineItem.split(' ')[0].strip()
	# print prefix
	title = lineItem.split(' ')[1].strip()
	if prefix == 'en':
		if title.startswith(('Help:','Portal:','Talk:','User:','Wikipedia:','User_talk:','Tamplate_talk:','Category:','File:','Template:','Special:')):
			totalBad += 1

		else:
			numVis = int(lineItem.split(' ')[2].strip())
			if numVis > 5:
				moreThan1 += 1
			else:
				lessThan2 += 1
			totalGood += 1

print "totalGood: " + str(totalGood)
print "totalBad: " + str(totalBad)
print "moreThan1: " + str(moreThan1)
print "lessThan2: " + str(lessThan2)
    # if totalEN % 10000 == 0:
    		# print totalEN	


# print totalEN


# # with open(infile) as inf, open(outfile,"w") as outf:
# with open(infile) as inf:
#     line_words = (line.split(' ') for line in inf)
#     print line_words
#     # outf.writelines(words[1].strip() + '\n' for words in line_words if len(words)>1)



# Loop through all, 
# each line, check to make sure, it isn't special or things like that
# Add name to list