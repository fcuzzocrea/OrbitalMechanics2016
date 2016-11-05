function [delta_v, teta_2] = perianomaly_change(a, e, omega_1, omega_2, theta_1, mu)
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% You should have received a copy of the GNU General Public License along
% with this program; if not, write to the Free Software Foundation, Inc.,
% 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
%
% Questa function implementa il cambio di anomalia del pericentro tra due
% orbite aventi lo stesso semiasse maggiore e la stessa eccentricità. 
% Fornire il parametro gravitazionale di riferimento
% 
% PARAMETRI DI INGRESSO 
% 
% a                     semiasse maggiore
% e                     eccentricità
% omega 1               anomalia di pericentro iniziale
% omega 2               anomalia di pericentro finale
% theta 1               anomalia vera orbita iniziale
% 
% PARAMETRI DI USCITA 
% 
% delta_v               delta_v da fornire
% theta_2               anomalia vera orbita finale, in radianti

h = waitbar(0,'Computating delta_v...');

if nargin == 5
    w = msgbox('Hai dimenticato mu, lo sto automaticamente settando a 398600');
    mu = 398600;
end

p = a*(1-e^2);
delta_omega = omega_2 - omega_1;

% Uso la formula spiegata a lezione da DiLizia per il calcolo di delta_v

delta_v = 2*sqrt(mu/p)*e*abs(sin(delta_omega/2));

% Calcolo l'anomalia vera dell'orbita, check sul segno di theta per capire
% se devo aggingere o meno 2*pi (cioè, in che punto mi trovo in cui sto
% facendo la manovra

if theta_1 > pi + delta_omega/2
    theta_2 = 2*pi - delta_omega/2;
else
    theta_2 = pi - delta_omega/2;
end

theta_2 = mod(theta_2,2*pi);

close(h)

end
 