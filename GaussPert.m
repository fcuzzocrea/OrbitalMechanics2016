function [dkep] = GaussPert (time,kep,mu_earth,earth_radius,J2,date)

% GaussPert.m
% 
% PROTOTYPE:
%   [dkep] = GaussPert (time,kep,mu_earth,earth_radius,J2,date)
%
% DESCRIPTION:
% 	This function implements the Gauss equation for the computation of 
% 	perturbed orbital parameters 
%
% INPUT:
%	time               Time interval of integration
%   kep                Keplerian parameters vector
%	mu_earth           Earth gravitational constant
%   earth_radius       Earth radious
%   J2                 J2 parameters due Earth oblateness
%   date               Date of starting evaluation
%
% OUTPUT:
%   [dkep]             Perturbed keplerian parameters
%   
% AUTHOR:
%   Francescodario Cuzzocrea
%   Benedetto Lui
%   Collogrosso Alfonso

a = kep(1);
e = kep(2);
i = kep(3);
% OM = kep(4);
om = kep(5);
th = kep(6);

b = a*sqrt(1-e^2);
p = b^2/a;
n = sqrt(mu_earth/a^3);
h = n*a*b;
r = p/(1+e*cos(th));
v = sqrt((2*mu_earth)/r-mu_earth/a);
th_star = th+om;

[r_sp,v_sp] = kep2car(kep,mu_earth);
[r_Moon,~] = ephMoon(date+time/86400);

apJ2_vect = j2peracc (r_sp,J2,earth_radius,mu_earth);    % J2 perturbed acceleration vector
apMG_vect = Moonper (r_Moon,r_sp'); % Moon gravity perturbed acceleration vector

% "Cartesian" to TNH reference frame rotation matrix

t_vers = v_sp/norm(v_sp);
h_vers = cross(r_sp,v_sp)/norm(cross(r_sp,v_sp));
n_vers = cross(h_vers,t_vers);
A = [t_vers,n_vers,h_vers];

ap_car = apJ2_vect + apMG_vect;          % Total perturbed acceleration vector
ap_tnh = A'*ap_car';
% ap_tnh = [0 0 0]';

da = (2*a^2*v)/mu_earth*ap_tnh(1);
de = 1/v*(2*(e+cos(th))*ap_tnh(1)-r/a*sin(th)*ap_tnh(2));
di = r*cos(th_star)/h*ap_tnh(3);
dOM = r*sin(th_star)/(h*sin(i))*ap_tnh(3);
dom = 1/(e*v)*(2*sin(th)*ap_tnh(1)+(2*e+r/a*cos(th))*ap_tnh(2))- ...
    (r*sin(th_star)*cos(i))/(h*sin(i))*ap_tnh(3);
dth = h/r^2-1/(e*v)*(2*sin(th)*ap_tnh(1)+(2*e+r/a*cos(th))*ap_tnh(2));

dkep = [da,de,di,dOM,dom,dth]';