#coder
fo = open("cris.txt", "r+")
fb = open("basis.txt","w")
i=0
for line in fo:
	array=line.split()
	i=i+1
	s = "af"
	if array[0]=="Si":
		s ="1"
	else:
		s="2"	
	stri = "basis"+"\t"+ str(i) + "\t" +  s  +"\t" + "&" + "\n" 
	print stri
	fb.write(stri)