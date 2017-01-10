function [delta_v, teta_2] = perianomaly_change(a, e, omega_1, omega_2, theta_1, mu)
%

% This function implements the change of the pericenter anomaly between two 
% orbits that have the same semimajor axis and the same eccentricity
% 
% INPUT 
% 
% a                     semimajor axis
% e                     eccentricity
% omega 1               anomaly of the pericenter of orbit 1
% omega 2               anomaly of the pericenter of orbit 1
% theta 1               true anomaly of orbit 1 where we do the change of the pericenter anomaly
% 
% OUTPUT 
% 
% delta_v               delta_v 
% theta_2               true anomaly of the orbit 2

if nargin == 5
    w = msgbox('Hai dimenticato mu, lo sto automaticamente settando a 398600');
    mu = 398600;
end

p = a*(1-e^2);
delta_omega = omega_2 - omega_1;

% delta_V for the change of pericenter anomaly

delta_v = 2*sqrt(mu/p)*e*abs(sin(delta_omega/2));

% True anomaly

if theta_1 > pi + delta_omega/2
    theta_2 = 2*pi - delta_omega/2;
else
    theta_2 = pi - delta_omega/2;
end

theta_2 = mod(theta_2,2*pi);

end
 
