clear
close all
clc

%% Assignment 3

date = date2mjd2000([2017,5,23,17,35,10]);


%% Orbital Data

global mu_earth; mu_earth = astroConstants(13);
a = 3.7067e4;
e = 0.5682;
i = 49.587;
h_p = 9627.33;
earth_radius = 6378.14;

r_p =  earth_radius + h_p;

[r_sp,v_sp] = kep2car([a,e,i,0,0,0],mu_earth);
[r_Moon,v_Moon] = ephMoon(date);

%% Perturbation Data

J2 = 1.08e-3;

%% Given orbit



%% Groundtrack per 1 day

%% Assigned perturbation

apJ2_vect = j2peracc (r_sp,J2,earth_radius,mu_earth);    % J2 perturbed acceleration vector
apMG_vect = Moonper (r_Moon,r_sp); % Moon gravity perturbed acceleration vector

ap_car = apJ2_vect + apMG_vect;          % Total perturbed acceleration vector

t_vers = v_sp/norm(v_sp);
h_vers = cross(r_sp,v_sp)/norm(cross(r_sp,v_sp));
n_vers = cross(h_vers,t_vers);
A = [t_vers,n_vers,h_vers];
global ap_tnh; ap_tnh = A'*ap_car;


%% Applied Gauss Equations

[t_out,kep_out] = ode45(@GaussPert,linspace(0,10*86400,1e4),[a,e,i,1,0,0]);
% [a,e,i,OM,om,th] 

figure,plot(t_out,kep_out(:,1))
figure,plot(t_out,kep_out(:,2))
figure,plot(t_out,kep_out(:,3))
figure,plot(t_out,kep_out(:,4))
figure,plot(t_out,kep_out(:,5))
figure,plot(t_out,kep_out(:,6))

figure
plotorbit(a,e,i,1,0,mu_earth,1)
hold on

r_vect = zeros(size(kep_out,1),3);
for i = 1:size(kep_out,1)
    r_vect(i,:) = kep2car(kep_out(i,:),mu_earth);
end

plot3(r_vect(:,1),r_vect(:,2),r_vect(:,3),'r')

%% Compare the parametres
%% Plot the parametres



