%Plots the radial distribution data of model from the rdf file at any timestep
%The indices of A.data to be read, has to be given by the entry corresponding to the particular timestep
%based on the way rdf files are written by lammps script
%It is god to check the data in rdf file before plotting 


d = dir('rdf_Si_O.rdf');
lngth_d=length(d)
for i = 1:length(d)
   
    fname = d(i).name;
    A = importdata(fname,' ',4);
    number=A.data(1:9999,1);
    distance = A.data(1:9999,2);
    distribution = A.data(1:9999,3);

   
    plot(distance,distribution,'-');hold on
    
    exportfig(gcf,strrep(fname,'.def1.txt','.tif'),'Format','tiff',...
    'Color','rgb','Resolution',300)
    close(1)
    
end