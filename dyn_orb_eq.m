function [Y] = dyn_orb_eq(t,X,mu)

%% This function give the orbit dynamics equation

%% Input: 
% t   - time vector
% X   - indipendet variable vector
% mu  - planetary constat

%% Output:
% Y   - dipendent variable vector

%% Definition of position and velocity component

rx = X(1);
ry = X(2);
rz = X(3);
%                        -------
vx = X(4);
vy = X(5);
vz = X(6);

%% Definition of position vector 

r = [rx, ry, rz];

%% Definition of the norm of position vector

rn = norm(r);

%% Preallocation of dipendent variable vector 

Y = [];

%% Computation of output of the function

Y(1) = vx;
Y(2) = vy;
Y(3) = vz;
Y(4) = -(mu/rn^3)*rx;
Y(5) = -(mu/rn^3)*ry;
Y(6) = -(mu/rn^3)*rz;

Y = Y';
end