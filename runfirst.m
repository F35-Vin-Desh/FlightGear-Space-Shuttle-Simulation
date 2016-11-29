%runfirst
val = xlsread('outputs.xlsx');
TIME = val(:,1);
DR = val(:,2);
HEIGHT = val(:,3);
PITCH = val(:,4);
%roll back from 180 to 0 (pitch up in): 360s
