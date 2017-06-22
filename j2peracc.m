function [apJ2_vect] = j2peracc (r_vect,J2,R,mu)

% j2peracc.m 
% 
% PROTOTYPE:
%   [apJ2_vect] = j2peracc (r_vect,J2,R,mu)
%
% DESCRIPTION:
% 	 This function give the perturbed acceleration due J2 perturbation
%    
% INPUT:
%   r_vec              Position vector
%   J2                 J2 parameter
%   R                  Planet radius
%   mu                 Planet gravitational constant
% 
% OUTPUT:
%   [apJ2_vect]        Perturbed acceleration due J2 
%
% AUTHOR:
%    Benedetto Lui
%    Alfonso Collogrosso
%    Francescodario Cuzzocrea
%

r = norm(r_vect);

x = r_vect(1);
y = r_vect(2);
z = r_vect(3);

c = 3/2*(J2*mu*R^2)/r^4;

ap_x = c*(x/r*(5*((z^2)/(r^2))- 1));
ap_y = c*(y/r*(5*((z^2)/(r^2))- 1));
ap_z = c*(z/r*(5*((z^2)/(r^2))- 3));

apJ2_vect = [ap_x ap_y ap_z];

end