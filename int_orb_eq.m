function [rx_vect, ry_vect, rz_vect, vx_vect, vy_vect, vz_vect] = int_orb_eq(kep,mu,time)

% int_orb_eq.m
% 
% PROTOTYPE:
%   [rx_vect, ry_vect, rz_vect, vx_vect, vy_vect, vz_vect] = int_orb_eq(kep,mu,time)
%
% DESCRIPTION:
% 	 This function implements the integration of the dynamics orbit equations
%
% INPUT:
%   kep          vector composed by the following 6 elements
%   a[1]         Semimajor axis
%   e[1]         Eccentricity
%   i[1]         Inclination
%   OMG[1]       Right ascension 
%   omg[1]       Pericenter anomaly
%   theta[1]     True anomaly
%   mu 
% 
% OUTPUT:
%   rx_vect[3]   Vector of all x components of position vectors
%   ry_vect[3]   Vector of all y components of position vectors
%   rz_vect[3]   Vector of all z components of position vectors
%   vx_vect[3]   Vector of all x components of velocity vectors
%   vy_vect[3]   Vector of all y components of velocity vectors
%   vz_vect[3]   Vector of all z components of velocity vectors
%
%
% AUTHOR:
%   Alfonso Collogrosso
%  

% Using kep2car function to find position and velocity at initial condition
[r,v]=kep2car(kep,mu);

% Intitial position and velocity vector's components
rx0 = r(1);
ry0 = r(2);
rz0 = r(3);
vx0 = v(1);
vy0 = v(2);
vz0 = v(3);

% Initial condition vector
X0 =[rx0, ry0, rz0, vx0, vy0, vz0]; 

% Time Setting
if nargin <= 7
    Period = ((2*pi)/sqrt(mu))*kep(1)^(3/2);
    time = (0:86400:Period); 
end

% Ode setting
options = odeset('Reltol',1e-13,'AbsTol',1e-14);

% Integration with ode113 function
[T,X] = ode113(@(t,X) dyn_orb_eq(t,X,mu),time,X0,options);

% Definition of the Output after from integration values
rx_vect = X(:,1);
ry_vect = X(:,2);
rz_vect = X(:,3);
vx_vect = X(:,4);
vy_vect = X(:,5);
vz_vect = X(:,6);

end