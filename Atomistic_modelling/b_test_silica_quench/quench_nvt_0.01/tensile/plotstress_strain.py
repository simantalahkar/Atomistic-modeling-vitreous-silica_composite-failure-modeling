#Plots the stress strain graph from the data of tensile test result file

from bokeh.plotting import figure, output_file, show, save
from bokeh.layouts import gridplot
from bokeh.models import HoverTool, BoxSelectTool
import numpy as np
from numpy import polyfit


f1 = open("stress_strain_50.txt","r")
for _ in xrange(1):
        next(f1)
xstrain=[]
ystrain=[]
xstress=[]
ystress=[]
poissons=[]
youngs=[]
minus_ystrain=[]
j=0
for line in f1:
	c = line.split(" ")
	#print(c[1])
	
	xstrain.append(float(c[0]))
	ystrain.append(float(c[4]))
	minus_ystrain.append(-float(c[4]))
	xstress.append(float(c[1]))
	ystress.append(float(c[2]))
	if float(c[0])<0.13:
		poissons.append(-float(c[4])/float(c[0]))
		youngs.append(float(c[1])/float(c[0]))
		j=j+1
	else:
		break


y, V = np.polyfit(xstrain, xstress, 1, cov=True)
print "youngs modulus is: {} +/- {}".format(y[0], np.sqrt(V[0][0]))
print "intercept is: {} +/- {}".format(y[1], np.sqrt(V[1][1]))

nu, W = np.polyfit(xstrain, minus_ystrain, 1, cov=True)
print "poissonsratio is: {} +/- {}".format(nu[0], np.sqrt(W[0][0]))
print "intercept is: {} +/- {}".format(nu[1], np.sqrt(W[1][1]))


averagenu=nu[0]
nuerror=np.sqrt(W[0][0])
averagey=y[0]
yerror=np.sqrt(V[0][0])


output_file("mbks0.01-8bitmap_betacristobalite_fulltensile.html")
TOOLS = "pan,resize,save,wheel_zoom,box_zoom,reset"
#TOOLS=[HoverTool()]
p1 = figure(tools=TOOLS, title="stress vs strain in x", x_axis_label='applied strain(xdirection)', y_axis_label='observed stress(x direction), GPa',x_range=[0,0.5], y_range=(-1, 17))
p1.add_tools(HoverTool())
p1.circle(xstrain, xstress, legend=None, line_width=1, size=2)


p2 = figure(tools=TOOLS, title="y strain vs x strain", x_axis_label='applied strain(xdirection)', y_axis_label='observed strain(y direction)', x_range=p1.x_range, y_range=(-0.2, 0.2))
p2.add_tools(HoverTool())
p2.triangle(xstrain, ystrain, legend=None, line_width=1, size=2, color="olive", alpha=0.5)

g = gridplot([[p1, p2]])

save(g,'mbks0.01-8bitmap_betacristobalite_fulltensile.html')
show(g)



