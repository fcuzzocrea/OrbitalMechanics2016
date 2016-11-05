function [a,e,i,omega,OMEGA,theta] = pos2par(r,v,mu)
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
% Questa function implementa l'algoritmo necessario per ottenere i parametri orbitali a parteire dai vettori (colonna) 
% di velocità e posizione.
% 
% PARAMETRI DI INGRESSO 			
%
% r			Vettore Posizione
% v			Vettore Velocità
% mu			Parametro gravitazionale
%
% Author : Francescodario Cuzzocrea
% emal : francescodario.cuzzocrea@mail.polimi.it
% (C) 2014

h = waitbar(0,'Please wait...');

if nargin == 2
    w = msgbox('Hai dimenticato mu, lo sto automaticamente settando a 398600');
    mu = 398600;
end

% Versori terna
I = [1;0;0];
J = [0;1;0];
K = [0;0;1];

% Passo 1
R = norm(r);
V = norm(v);

% Passo 2

a = 1/((2/R) - (V^2/mu));

% Passo 3

h = cross(r,v);
H = norm(h);

% Passo 4

e = 1/mu*(cross(v,h)- mu * r./R);
E = norm(e);

% Passo 5

i = acos(dot(h,K)./H);

% Passo 6

n = cross(K,h)./norm(cross(K,h));

% Passo 7

if dot(n,J) > 0
	OMEGA = acos(dot(I,n));
else
	OMEGA = 2*pi-acos(dot(I,n));
end


% Passo 8

if dot(e,K) > 0
	omega = acos((dot(n,e))/E);
else
	omega = 2*pi - acos((dot(n,e))/E);
end


% Passo 9

if dot(v,r) > 0
    fprintf('Maggiore')
	theta = acos((dot(r,e))/R*E);
else
    fprintf('Minore')
	theta = 2*pi - acos((dot(r,e))/R*E);
end

close(h)

end


