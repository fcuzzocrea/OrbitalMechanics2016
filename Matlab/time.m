function [delta_t] = time(a,e,theta_1,theta_2,mu)
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
% Questa function serve a calcolare il tempo trascorso per spostarsi da un
% anomalia vera theta_1 ad un anomalia vera theta_2, dati semiasse maggiore
% ed eccentricità 

h = waitbar(0,'Computating times...');

if nargin == 4
    w = msgbox('Hai dimenticato mu, lo sto automaticamente settando a 398600');
    mu = 398600;
end

% Inserisco un check sull'eccentricità per vedere con che tipo di orbita ho
% a che fare, diversi casi disponibili. In ognuno dei casi calcolo
% l'appropriato parametro dell'orbita ed i 2 tempi  impiegati a percorrerla

if e > 0 || e < 1
    % Orbita ellittica
    E_1 = 2*atan(sqrt((1-e)/(1+e)))*tan(theta_1/2);
    E_2 = 2*atan(sqrt((1-e)/(1+e)))*tan(theta_2/2);
    t_1 = sqrt(a^3/mu)*(E_1 - e*sin(E_1));
    t_2 = sqrt(a^3/mu)*(E_2 - e*sin(E_2));
elseif e == 1
    % Orbita parabolica    
    D_1 = tan(theta_1/2);             
    D_2 = tan(theta_2/2);
    t_1 = 0.5*sqrt(p^3/mu)*(D_1+D_1^3/3);
    t_2 = 0.5*sqrt(p^3/mu)*(D_2+D_2^3/3);
elseif e > 1
    % orbita iperbolica    
     F_1 = 2*atanh((sqrt((e+1)/(e-1)))*tan(theta_1/2));              
     F_2 = 2*atanh((sqrt((e+1)/(e-1)))*tan(theta_2/2));
     t_1 = sqrt(-a/mu)*(e*sinh(F_1)-F_1);   
     t_2 = sqrt(-a/mu)*(e*sinh(F_2)-F_2);
end

% Posso quindi calcolarmi il periodo che mi servirà più avanti 

T =  2*pi/sqrt(mu) * a^(3/2);

% Risolvo la questione del tempo negativo aggiungendoci il periodo al tempo

if t_1 < 0
    t_1 = t_1 + T;
end

if t_2 < 0
    t_2 = t_2 + T;
end

% A questo punto posso finalmente calcolare i tempi di percorrenza

if theta_2 > theta_1
    delta_t = t_2 - t_1;
else
    delta_t = t_2 - t_1 + T;
end
close(h)
end


