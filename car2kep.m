function [a,e,i,OMG,omg,theta]=car2kep(r,v,mu)

%% This function switch cartesian coordinates to kepler parameters

%1) Compute norm of r
rn=norm(r);

%2) Compute norm of v
vn=norm(v);

%3) Compute the specific angular momentum
h=cross(r,v);

%4) Compute norm of h
hn=norm(h);

%5) Compute the inclination angle i
hz=h(3);
i=acos(hz/hn);

if (0<i)&&(i<90)
    disp('Prograde Orbit')
elseif (90<i)&&(i<180)
    disp('Retrograde Orbit')
elseif i==0
    disp('Orbital plane = Equatorial Plane, the line of node coincide with the direction i* (i*,j,k)')
end

%6) Identify the line of node
k=[0,0,1];

N=cross(k,h);

%7) Compute nodal Vector
if N==0
    Nn=0;
    N_hat=[0 0 0];
else
    Nn=norm(N);
    N_hat=N/Nn;
end

%8) Compute right ascension OMG 
Nx=N_hat(1);
Ny=N_hat(2);

if Ny>=0
    OMG=acos(Nx);
elseif Ny<0
    OMG=(2*pi)-acos(Nx);
end

%9) Compute the eccentricity vector ev
ev= 1/mu.*(cross(v,h)-mu*(r/rn));

%10) Compute norm of ev = eccentricity 
e=norm(ev);

if e==0
    disp('Circular Orbit')
elseif (0<e)&&(e<1)
    disp('Elliptical Orbit')
elseif e==1
    disp('Parabolic Orbit')
elseif e>1
    disp('Hyperbolic Orbit')
end

%11) Compute pericenter anomaly omg
ek=ev(3);

if ek>=0
    omg=acos(dot(N_hat,ev)/e);
elseif ek<0
    omg=(2*pi)-acos(dot(N_hat,ev)/e);
end

%12)Compute the true anomaly theta
vr=(dot(r,v))/rn;

if vr>=0
    theta=acos(dot(ev,r)/(rn*e));
elseif vr<0
    theta=(2*pi)-acos(dot(ev,r)/(rn*e));
end

%13) Compute the semi major axis a
a=1/(2/rn-vn^2/mu);
end




