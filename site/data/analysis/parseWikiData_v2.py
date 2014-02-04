import sys


# infile= sys.argv[1]


# infile = "samplefile"
# outfile = "sampleoutput.txt"

in_file = open("eng_cropped4", 'r')
# in_file = open("samplefile", 'r')


prefix = 'Z'

totalGood = 0
totalBad = 0
moreThan1 = 0
lessThan2 = 0

pagestotal = 10
count = 0
outfile = open('eng_cropped5','w')


# for lineItem in in_file.readlines():
# 	prefix = lineItem.split(' ')[0].strip()
# 	# print prefix
# 	if prefix != 'en.z' and prefix != 'en.y':
# 		print lineItem
# 		print count
		
# 	else:
# 		outfile.write(lineItem)


# 	count += 1 


for lineItem in in_file.readlines():
	title = lineItem.split(' ')[0].strip()
	# if title.startswith(('Upload.wikimedia','wikt:','wiktionary:','en.wiki','fa:','Category_talk','%22//','#','en:','fi:','az:','fr:','hu:','it:','pt:','de:','pl:','es:','wiki/','Wiki/','Wikipedia_talk:','Wikipedia_talk%3A','Help:','Help%3A','Portal:','Portal%3A','Talk:','Talk%3A','User:','User%3A','Wikipedia:','wikipedia:','Wikipedia%3A','User_talk:','User_talk%3A','Template_talk:','Template_talk%3A','Category:','Category%3A','category:','File:','File%3A','Template:','Template%3A','Special:','Special%3A','En:','SQ:','aa:','ab:','af:','ak:','am:','an:','ar:','as:','av:','ay:','az:','az:','az:','ba:','be:','bg:','bh:','bi:','bm:','bn:','bo:','br:','bs:','bs:','bs:','bs:','bs:','bs:','bs:','bs:','ca:','ca:','ca:','ca:','ca:','ca:','ca:','ca:','ce:','ce:','ce:','ce:','ch:','ch:','ch:','ch:','co:','co:','co:','co:','co:','co:','cr:','cr:','cr:','cr:','cs:','cs:','cs:','cs:','cs:','cs:','cs:','cs:','cs:','cu:','cu:','cu:','cu:','cv:','cv:','cv:','cy:','cy:','cy:','cy:','cy:','cy:','cz:','da:','da:','da:','da:','da:','da:','de:','de:','de:','de:','de:','de:','de:','de:','de:','dk:','dv:','dv:','dv:','dv:','dv:','dv:','dz:','dz:','dz:','ee:','ee:','ee:','el:','el:','el:','el:','el:','el:','el:','el:','en:','en:','en:','en:','en:','en:','en:','en:','en:','eo:','eo:','eo:','eo:','eo:','eo:','eo:','es:','es:','es:','es:','es:','es:','es:','es:','es:','et:','et:','et:','et:','et:','eu:','eu:','eu:','eu:','eu:','eu:','fa:','fa:','fa:','fa:','fa:','fa:','fa:','fa:','ff:','ff:','fi:','fi:','fi:','fi:','fi:','fi:','fi:','fi:','fj:','fj:','fj:','fo:','fo:','fo:','fr:','fr:','fr:','fr:','fr:','fr:','fr:','fr:','fr:','fy:','fy:','fy:','fy:','ga:','ga:','ga:','ga:','gd:','gd:','gd:','gl:','gl:','gl:','gl:','gl:','gl:','gl:','gn:','gn:','gn:','gn:','gu:','gu:','gu:','gu:','gu:','gu:','gu:','gv:','gv:','gv:','ha:','ha:','ha:','he:','he:','he:','he:','he:','he:','he:','he:','hi:','hi:','hi:','hi:','hi:','ho:','hr:','hr:','hr:','hr:','hr:','hr:','ht:','ht:','ht:','ht:','hu:','hu:','hu:','hu:','hu:','hu:','hu:','hy:','hy:','hy:','hy:','hy:','hy:','hz:','hz:','ia:','ia:','ia:','ia:','ia:','id:','id:','id:','id:','id:','id:','id:','id:','ie:','ie:','ie:','ie:','ie:','ig:','ig:','ig:','ig:','ig:','ig:','ii:','ii:','ik:','ik:','io:','io:','is:','is:','is:','is:','is:','is:','is:','is:','it:','it:','it:','it:','it:','it:','it:','it:','it:','iu:','iu:','iu:','ja:','ja:','ja:','ja:','ja:','ja:','ja:','ja:','ja:','jp:','jv:','jv:','jv:','jv:','ka:','ka:','ka:','ka:','ka:','ka:','kg:','ki:','ki:','kj:','kj:','kk:','kk:','kk:','kk:','kk:','kk:','kl:','kl:','kl:','kl:','km:','km:','km:','km:','kn:','kn:','kn:','kn:','kn:','kn:','ko:','ko:','ko:','ko:','ko:','ko:','ko:','ko:','ko:','kr:','kr:','kr:','ks:','ks:','ks:','ku:','ku:','ku:','ku:','ku:','ku:','kv:','kv:','kv:','kv:','kw:','kw:','kw:','kw:','ky:','ky:','ky:','ky:','ky:','ky:','la:','la:','la:','la:','la:','la:','lb:','lb:','lb:','lb:','lg:','lg:','li:','li:','li:','li:','li:','ln:','ln:','ln:','ln:','lo:','lo:','lo:','lo:','lo:','lo:','lt:','lt:','lt:','lt:','lt:','lt:','lt:','lv:','lv:','lv:','lv:','mg:','mg:','mg:','mg:','mg:','mh:','mh:','mi:','mi:','mi:','mi:','mk:','mk:','mk:','mk:','mk:','mk:','ml:','ml:','ml:','ml:','ml:','ml:','ml:','ml:','mn:','mn:','mn:','mn:','mn:','mo:','mo:','mo:','mo:','mr:','mr:','mr:','mr:','mr:','mr:','mr:','ms:','ms:','ms:','ms:','ms:','ms:','ms:','mt:','mt:','mt:','mt:','my:','my:','my:','na:','na:','na:','na:','nb:','nb:','ne:','ne:','ne:','ne:','ne:','ng:','nl:','nl:','nl:','nl:','nl:','nl:','nl:','nl:','nl:','nn:','nn:','nn:','nn:','no:','no:','no:','no:','no:','no:','no:','no:','no:','nv:','nv:','nv:','ny:','ny:','ny:','oc:','oc:','oc:','oc:','oc:','om:','om:','or:','or:','or:','or:','or:','or:','or:','os:','os:','os:','os:','os:','os:','pa:','pa:','pa:','pa:','pi:','pi:','pl:','pl:','pl:','pl:','pl:','pl:','pl:','pl:','ps:','ps:','ps:','ps:','ps:','pt:','pt:','pt:','pt:','pt:','pt:','pt:','pt:','pt:','qu:','qu:','qu:','qu:','rm:','rm:','rn:','rn:','ro:','ro:','ro:','ro:','ro:','ro:','ro:','ru:','ru:','ru:','ru:','ru:','ru:','ru:','ru:','ru:','rw:','rw:','rw:','sa:','sa:','sa:','sa:','sa:','sa:','sc:','sc:','sd:','sd:','sd:','sd:','se:','se:','se:','se:','sg:','sg:','sh:','sh:','sh:','sh:','sh:','sh:','si:','si:','si:','si:','sk:','sk:','sk:','sk:','sk:','sl:','sl:','sl:','sl:','sl:','sl:','sl:','sm:','sm:','sn:','sn:','so:','so:','sq:','sq:','sq:','sq:','sq:','sq:','sq:','sr:','sr:','sr:','sr:','sr:','sr:','sr:','sr:','ss:','ss:','ss:','ss:','st:','st:','st:','su:','su:','su:','su:','su:','sv:','sv:','sv:','sv:','sv:','sv:','sv:','sv:','sv:','sw:','sw:','sw:','sw:','sw:','sw:','ta:','ta:','ta:','ta:','ta:','ta:','ta:','te:','te:','te:','te:','te:','te:','tg:','tg:','tg:','tg:','tg:','tg:','th:','th:','th:','th:','th:','th:','th:','th:','ti:','ti:','tk:','tk:','tk:','tk:','tk:','tl:','tl:','tl:','tl:','tn:','tn:','tn:','tn:','tn:','to:','to:','tr:','tr:','tr:','tr:','tr:','tr:','ts:','ts:','ts:','tt:','tt:','tt:','tt:','tt:','tt:','tw:','tw:','ty:','ug:','ug:','ug:','ug:','uk:','ur:','ur:','ur:','ur:','ur:','ur:','ur:','uz:','uz:','uz:','uz:','uz:','uz:','ve:','ve:','vi:','vi:','vi:','vi:','vi:','vi:','vi:','vi:','vi:','vo:','vo:','vo:','vo:','vo:','wa:','wa:','wa:','wo:','wo:','wo:','xh:','xh:','xh:','xh:','yi:','yi:','yi:','yi:','yo:','yo:','yo:','yo:','yo:','za:','za:','za:','za:','zh:','zu:')):
	if title.startswith(('/Template_talk:','/Talk:','File_talk:','/','Image:')):
		totalBad += 1
	else:
		totalGood += 1
		outfile.write(lineItem.split(' ')[0].strip() + " " + lineItem.split(' ')[1].strip() +"\n")
	# prefix = lineItem.split(' ')[0].strip()
	# print prefix
	# if count > 15:
	# 	break
		
	# else:
	# 	outfile.write(lineItem)


	# count += 1 


	# while count < pagestotal:
	# 	prefix = lineItem.split(' ')[0].strip()

	# 	if prefix == 'en.z':
	# 		# print prefix
	# 		title = lineItem.split(' ')[1].strip()
	# 		print prefix
	# 		print title
	# 		print lineItem
	# 		count +=1

	# if prefix == 'en':
	# 	if title.startswith(('Help:','Portal:','Talk:','User:','Wikipedia:','User_talk:','Tamplate_talk:','Category:','File:','Template:','Special:')):
	# 		totalBad += 1

	# 	else:
	# 		numVis = int(lineItem.split(' ')[2].strip())
	# 		if numVis > 5:
	# 			moreThan1 += 1
	# 		else:
	# 			lessThan2 += 1
	# 		totalGood += 1

print "totalGood: " + str(totalGood)
print "totalBad:  " + str(totalBad)
# print "moreThan1: " + str(moreThan1)
# print "lessThan2: " + str(lessThan2)
    # if totalEN % 10000 == 0:
    		# print totalEN	

outfile.close()

# print totalEN


# # with open(infile) as inf, open(outfile,"w") as outf:
# with open(infile) as inf:
#     line_words = (line.split(' ') for line in inf)
#     print line_words
#     # outf.writelines(words[1].strip() + '\n' for words in line_words if len(words)>1)



# Loop through all, 
# each line, check to make sure, it isn't special or things like that
# Add name to list