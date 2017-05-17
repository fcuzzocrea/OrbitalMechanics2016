%% Assignment 3

%% Orbital Data

mu_earth = astroCostant(13);   
a = 3.7067e4;                  
e = 0.5682;
i = 49.587;                    
h_p = 9627.33;                 
earth_radius = 6378.14;        

r_p =  earth_radius + h_p;


%% Perturbation Data

J2 = 1.08e-3;

%% Given orbit

%% Groundtrack per 1 day

%% Assigned perturbation

apJ2_vect = j2peracc (r_vect,J2,R,mu);    % J2 perturbed acceleration vector
apMG_vect = Moonper (r_moon_vect,r_vect); % Moon gravity perturbed acceleration vector

ap_vect = apJ2_vect + apMG_vect;          % Total perturbed acceleration vector

%% Applied Gauss Equations
%% Compare the parametres
%% Plot the parametres



