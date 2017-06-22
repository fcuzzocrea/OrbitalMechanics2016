function [Y] = dyn_2BP_pert(t,X,mu,ap_vect)

%% This function give the orbit dynamics equation perturbed

%% Input: 
% t       - time vector
% X       - indipendet variable vector
% mu      - planetary constat
% ap_vect - perturbed acceleration vector

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
Y(4) = -(mu/rn^3)*rx + ap_vect(1);
Y(5) = -(mu/rn^3)*ry + ap_vect(2);
Y(6) = -(mu/rn^3)*rz + ap_vect(3);

Y = Y';
end