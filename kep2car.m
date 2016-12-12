function [r,v]=kep2car(kep,mu)

%% Function that switch keplerian parameters into cartesian coordinates (alternative mthod without v)
%% We need to move from inertial frame --> perifocal frame

a = kep(1);
e = kep(2);
i = kep(3);
OMG = kep(4);
omg = kep(5);
theta = kep(6);

% 1) Semi latus rectus

p = a*(1 - norm(e)^2);

% 2) Compute R position of S/C

R = p/(1 + norm(e)*cos(theta));

% 3) Compute r perifocal

r_pf = [R*cos(theta);R*sin(theta);0];

% 4)Compute v perifocal

v_pf = [-sqrt(mu/p)*sin(theta); sqrt(mu/p)*(norm(e) + cos(theta)); 0];

% 5) Writing the rotational Matrix

RM_OMG = [ cos(OMG),sin(OMG), 0; -sin(OMG), cos(OMG), 0; 0, 0, 1];
RM_i = [1, 0, 0; 0, cos(i), sin(i);  0, -sin(i), cos(i)];
RM_omg = [cos(omg), sin(omg), 0; -sin(omg), cos(omg), 0; 0, 0, 1];

T = RM_OMG'*RM_i'*RM_omg';

% Compute v and r in geoceter equatorial system

r = T*r_pf;
v = T*v_pf;

end
