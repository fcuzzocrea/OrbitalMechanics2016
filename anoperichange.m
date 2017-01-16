function [delta_V,theta_2,theta_3] = anoperichange(a,e,omega_1,omega_2,theta_0,mu_p)

%questa funzione calcola il cambio di anomalia di pericentro tra 2 orbite
%aventi stesso semiassethet maggiore a e stessa eccentricità e. I parametri in
%input sono: a,e,anomalia pericentro iniziale e finale, anomalia vera
%orbita iniziale
%
%La funzione fornisce in uscita il delta velocità necessario a compiere la
%manovra, l'anomalia vera sulla nuova orbita e il parametro gravitazionale
%di riferimento
%
%[delta_V,theta2] = cambio_anom_pericentro(a,e,omega1,omega2,theta1,mu)
%
%delta_V in KM/S e theta2 in radianti

delta_omega = abs(omega_2 - omega_1);

p = a*(1-e^2);
delta_V = abs(2*sqrt(mu_p/p)*e*sin(delta_omega/2));

theta_A = delta_omega/2;
theta_B = pi + delta_omega/2; 

if theta_0 > theta_B    
    theta_2 = theta_A;
    theta_3 = 2*pi - theta_A;
else
    theta_2 = theta_B;  
    theta_3 = pi - theta_A;
end

theta_3 = mod(theta_3,2*pi);

end