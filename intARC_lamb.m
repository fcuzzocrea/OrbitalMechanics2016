function [rx_vect, ry_vect, rz_vect, vx_vect, vy_vect, vz_vect] = intARC_lamb(r_1,VI,mu,time,n)


% intARC_lamb.m
% 
% PROTOTYPE:
%   [rx_vect, ry_vect, rz_vect, vx_vect, vy_vect, vz_vect] = intARC_lamb(r_1,VI,mu,time,n)
%
% DESCRIPTION:
% 	This function implements the integration of the dynamics orbit equations
%
% INPUT:
%   r_1[3]         Initial position  
%   time[1]        Transfer time
%   VI[3]          Initial velocity
%   mu[1]          Planetary constant
%
% OUTPUT :
% 
%   rx_vect[]     Vector of all x components of position vectors
%   ry_vect[]     Vector of all y components of position vectors
%   rz_vect[]     Vector of all z components of position vectors
%   vx_vect[]     Vector of all x components of velocity vectors
%   vy_vect[]     Vector of all y components of velocity vectors
%   vz_vect[]     Vector of all z components of velocity vectors
%
% FUNCTIONS CALLED:
%   dyn_orb_eq.m
%
% AUTHOR:
%   Alfonso Collogrosso
%

% Intitial position and velocity vector's components
rx0 = r_1(1);
ry0 = r_1(2);
rz0 = r_1(3);
vx0 = VI(1);
vy0 = VI(2);
vz0 = VI(3);

% Initial condition vector
X0 =[rx0,ry0,rz0,vx0,vy0,vz0]; 

options = odeset('Reltol',1e-13,'AbsTol',1e-14);

if nargin <= 4
    n =1;
end

time = 0:n:time;

[~,X] = ode113(@ dyn_orb_eq,time,X0,options,mu);

% Definition of the Output after from integration values
rx_vect = X(:,1);
ry_vect = X(:,2);
rz_vect = X(:,3);
vx_vect = X(:,4);
vy_vect = X(:,5);
vz_vect = X(:,6);

end