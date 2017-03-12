fo = open("cris.txt", "r+")
fb = open("norm.txt","w")
i=0
for line in fo:
	array=line.split()
	i=i+1
		
	stri = array[0]+"\t"+ array[1] + "\t" +  str(float(array[2])/42.72)  +"\t" + str(float(array[3])/35.6) +"\t" + str(float(array[4])/35.6) + "\n" 
	print stri
	fb.write(stri)