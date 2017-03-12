#coder
fo = open("norm.txt", "r+")
fb = open("coordinates.txt","w")
i=0
for line in fo:
	array=line.split()
	i=i+1
		
	stri = "basis"+"\t"+ array[2] +"\t"+ array[3]+"\t"+ array[4] +"\t"+ "&"+ "\n" 
	print stri
	fb.write(stri)