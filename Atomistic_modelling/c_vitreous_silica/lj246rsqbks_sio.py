import math
fo = open("rsqextra.txt", "r+")
fb = open("rsq_sio_ljbks_0.01-10.txt","w")
eps = 0.0112245
sig = 1.31
#q1=2.4
#q2=-1.2
a=18003.7572
b=4.8732
c=133.5381

i=0
for line in fo:
	array=line.split()
	i=i+1
	r=float(array[1])
	phi = 4*eps*(((sig/(r))**24) - ((sig/(r))**6))  + (a*math.exp(-b*r)) - (c/(r)**6)
	force = 4*eps*( (24/(r))*((sig/(r))**24) - (6/(r))*((sig/(r))**6)) + (b*a*math.exp(-b*r)) - (6*c/(r)**7)

	#phi = str(phi)
	#force = str(force)
	# ind_phi = phi.find('e')
	# if(ind_phi!=-1):
	# 	if(phi[ind_phi+1]=='+'):
	# 		temp = phi.split('+')
	# 		phi = ''.join(temp)
	# 	elif(phi[ind_phi+1]=='-'):
	# 		temp = phi.split('e')
	# 		phi = temp[0]+'/1.0e'+temp[1][1:]

	# ind_force = force.find('e')
	# if(ind_force!=-1):
	# 	if(force[ind_force+1]=='+'):
	# 		temp = force.split('+')
	# 		force = ''.join(temp)
	# 	elif(force[ind_force+1]=='-'):
	# 		temp = force.split('e')
	# 		force = temp[0]+'/1.0e'+temp[1][1:]

	string = str(i) + '\t' + str(r) + '\t' + str(phi) + '\t' + str(force) + '\n'
	print(string)
	fb.write(string)
