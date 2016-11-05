function [delta_v,theta_1,omega_2]=inclinationchange(a,e,i_1,OMEGA_1,i_2,OMEGA_2,omega_1,mu)
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
% Questa function implementa il cambio di piano, restituisce la variazione di i e OMEGA
%
% PARAMETRI DI USCITA :
% 
% delta_v                         Costo della manovra in termini di delta_v
% theta_1			  Anomalia vera all'inizio della manovra
% omega_2			  Anomalia di pericentro alla fine della manovra
%
% % Author : Francescodario Cuzzocrea
% emal : francescodario.cuzzocrea@mail.polimi.it
% (C) 2014

h = waitbar(0,'Please wait...');

if nargin == 7
    w = msgbox('Hai dimenticato mu, lo sto automaticamente settando a 398600');
    mu = 398600;
end

% Calcolo i delta_i e delta_OMEGA 

delta_i = i_2 - i_1;
delta_OMEGA = OMEGA_2 - OMEGA_1;
delta_check = delta_i*delta_OMEGA;

% Calcolo alpha sfruttando il teorma del coseno visto a lezione, ovvero
%
% 	 cos(alpha) = sin(beta)*sin(gamma)*cos(a) - cos(beta)*cos(gamma)
%
% Poi ricavo alpha come arco_coseno di cos(alpha)

cos_alpha = sin(i_1)*sin(i_2)*cos(delta_OMEGA) + cos(i_1)*cos(i_2);
alpha = acos(cos_alpha);

% A questo punto posso ricavare u_1 ed u_2 grazie al teorema del seno

if delta_check > 0
	    cos_u_1 = (cos(i_1)*cos(alpha) - cos(i_2)) / (sin(i_1)*sin(alpha));
	    cos_u_2 = (cos(i_1) - cos(i_2)*cos(alpha)) / (sin(i_2)*sin(alpha));	
else
	    cos_u_1 = (cos(i_2) - cos(alpha)*cos(i_1)) / (sin(alpha)*sin(i_1));
    	    cos_u_2 = (cos(alpha)*cos(i_2) - cos(i_1)) / (sin(alpha)*sin(i_2));
end

% Ricavo i seni di u1 ed u2, e tramite l'arcotangente risalgo ai valori di u1 ed u2

sin_u_1 = sin(i_2)*(sin(delta_OMEGA)/sin(alpha));
sin_u_2 = sin(i_1)*(sin(delta_OMEGA)/sin(alpha));
u_1 = atan2(sin_u_1,cos_u_1);
u_2 = atan2(sin_u_2,cos_u_2);

% Posso ricavare theta ed omega_2 dal sistema di equazioni visto a lezione

if delta_check >  0
	theta_1 = u_1 - omega_1;
	omega_2 = u_2 - theta_1;
else
	theta_1 = 2*pi - (omega_1 + u_1);
	omega_2 = 2*pi - (u_2 + theta_1);
end

% Calcolo il costo della manovra in termini di delta_v

p = a*(1 - e^2);
v_theta = sqrt(mu/p)*(1 + e*cos(theta_1));    
delta_v = 2*v_theta*sin(alpha/2);

close(h)

end

