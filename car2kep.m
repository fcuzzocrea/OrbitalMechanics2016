function [a,e,i,OMG,omg,theta]=car2kep(r,v,mu)

% car2kep.m
% 
% PROTOTYPE:
%   [a,e,i,OMG,omg,theta]=car2kep(r,v,mu)
%
% DESCRIPTION:
% 	This function switch cartesian coordinates to kepler parameters
%
% INPUT:
%	r[3]           Position vector
%   v[3]           Velocity vector
%   mu[1]          
%
% OUTPUT:
%	a[1]           Semimajoraxis 
%   e[1]           Eccentricity 
%   OMEGA[1]       Right Ascension 
%   omega[1]       Argument of pericenter
%   theta[1]     True anomaly
%
% AUTHOR:
%   Alfonso Collogrosso
%  

rn=norm(r);

vn=norm(v);

h=cross(r,v);

hn=norm(h);

hz=h(3);
i=acos(hz/hn);

if (0<i)&&(i<90)
    disp('Prograde Orbit')
elseif (90<i)&&(i<180)
    disp('Retrograde Orbit')
elseif i==0
    disp('Orbital plane = Equatorial Plane, the line of node coincide with the direction i* (i*,j,k)')
end

k=[0,0,1];

N=cross(k,h);

if N==0
    Nn=0;
    N_hat=[0 0 0];
else
    Nn=norm(N);
    N_hat=N/Nn;
end
 
Nx=N_hat(1);
Ny=N_hat(2);

if Ny>=0
    OMG=acos(Nx);
elseif Ny<0
    OMG=(2*pi)-acos(Nx);
end

ev= 1/mu.*(cross(v,h)-mu*(r/rn));

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

ek=ev(3);

if ek>=0
    omg=acos(dot(N_hat,ev)/e);
elseif ek<0
    omg=(2*pi)-acos(dot(N_hat,ev)/e);
end

vr=(dot(r,v))/rn;

if vr>=0
    theta=acos(dot(ev,r)/(rn*e));
elseif vr<0
    theta=(2*pi)-acos(dot(ev,r)/(rn*e));
end

a=1/(2/rn-vn^2/mu);
end




