%space shuttle model
clc; close all; clear all;
y = xlsread('THRUST_MASS_FLOW.xlsx');
TIME = y(:,1); THR = y(:,2);
MASS = y(:,3); k = 0.2; %k = step size
MASS_FLOW = y(:,4);
%ours
t = 0:k:590;

%spline interpolate thrust
t_c = spline(TIME,THR,t); t_c(60/k:120/k) = 31559000; 
t_c(125/k:180/k) = 5486250;
%thrust_curve

%spline interpolate mass
m_c = spline(TIME,MASS,t); i = 90/k; o = 125/k;
while (90/k<=i)&&(i<=120/k)
    m_c(i+1) = m_c(i)-(abs((m_c(90/k)-m_c(120/k)))/(120-90))*k;
    i = i+1;
end
m_c(120/k:124/k) = 870000;
while (125/k<=o)&&(o<=210/k)
    m_c(o+1) = m_c(o)-(abs((m_c(125/k)-m_c(210/k)))/(210-125))*k;
    o = o+1;
end
t_c(510/k:length(t_c)) = 0; %empty thrust
m_c(514/k:length(m_c)) = 74200; %final mass

%spline interpolate mass flow
m_dot = spline(TIME,MASS_FLOW,t);
% plot(TIME,MASS_FLOW,'o',t,m_dot);

%% 
%Now thrust and mass are f(time);
t_c; m_c;
%earth r (in m)
Re = 6378000;
%i.c.
gam = pi/2 - 0.0001; v = 1; y = 50; D = 0; T = t_c(1); m = m_c(1); x = 0; y = 0;
%density, temperature, pressure at zero
rho = 1.225; Temp = 20; p = 101.29;
%area, drag coefficient, gravity
Aw = 1100; cd = 0.0610; gc = 9.81;
%time, exhaust velocity, spec. impulse
time = 0; c = 0; Isp = 0;
%

%solve
for l=1:length(t_c);
    
    %density
    if y<=11000
        Temp(l+1) = 15.04-0.00649*y(l);
        p(l+1) = 101.29*((Temp(l)+273.1)/288.08)^5.258;
    elseif 11000 < y <=25000
        Temp(l+1) = -56.46;
        p(l+1) = 22.65*exp(1.73-0.000157*y(l));
    else
        Temp(l+1) = -131.21 + 0.00299*y(l);
        p(l+1) = 2.488*((Temp(l)+273.1)/216.6)^-11.388;
    end
        
    rho(l+1) = p(l)/(0.2869*(Temp(l)+273.1));
        
    %drag force D
    D(l+1) = 0.5*rho(l)*v(l)^2*Aw*cd;
    
    %speed magnitude v
    v(l+1) = v(l) + (t_c(l)/m_c(l) - D(l)/m_c(l) - gc*sin(gam(l)))*k;
    
    %path angle gam (from 90 to 0 degrees)
    if l <= 15/k
        gam(l+1) = gam(l);
    elseif 15/k < l <= 17/k
        gam(l+1) = gam(l) - 0.0032*gam(l);
    else
        gam(l+1) = gam(l) - ((gc/v(l) - v(l)/(Re+y(l)))*cos(gam(l)))*k; 
    end   
    
    %x distance downrange
    x(l+1) = x(l) + (Re/(Re+y(l))*v(l)*cos(gam(l)))*k;
    
    %altitude y
    y(l+1) = y(l) + (v(l)*sin(gam(l)))*k;
    VG(l) = gc*sin(gam(l));
    
    %exhaust velocity
    c(l) = t_c(l)/m_dot(l);
    if c(l) > 10^6
        c(l) = 0;
    end
    Isp(l) = c(l)/gc;
    if Isp(l) > 50000
        Isp(l) = 0;
    end
    
    VD(l) = D(l)/m_c(l);
end

Ve = mean(c(1:510/k));

Imp = mean(Isp(1:510/k));
m_o = m_c(1);
m_f = m_c(length(m_c));

Vd = trapz(VD); Vg = trapz(VG); Vw = Imp*gc*log(m_c(1)/m_c(length(m_c)));
DELV = Vw-(Vg+Ve);

n = m_o/m_f;
hmax = (Ve/mean(m_dot(1:510/k)))*(1+log(n)-n)+0.5*(Ve^2/gc)*(log(n))^2;
W = transpose(m_c);
%y = height
xlswrite('outputs.xlsx',transpose(t),'A1:A2952');
xlswrite('outputs.xlsx',transpose(x),'B1:B2952');
xlswrite('outputs.xlsx',transpose(y),'C1:C2952');
xlswrite('outputs.xlsx',transpose(gam),'D1:D2952'); %pitch angle
%roll angle automated
    
    