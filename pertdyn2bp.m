function [Xdot] = pertdyn2bp (t,X,mu_earth,earth_radius,J2,date)

Xdot = zeros(size(X));

r = sqrt(X(1)^2+X(2)^2+X(3)^2);

[r_Moon,~] = ephMoon(date+t/86400);

apJ2_vect = j2peracc (X(1:3),J2,earth_radius,mu_earth);    % J2 perturbed acceleration vector
apMG_vect = Moonper (r_Moon,X(1:3)'); % Moon gravity perturbed acceleration vector

ap_car = apJ2_vect + apMG_vect;          % Total perturbed acceleration vector

Xdot(1) = X(4);
Xdot(2) = X(5);
Xdot(3) = X(6);
Xdot(4) = -mu_earth/r^3*X(1)+ap_car(1);
Xdot(5) = -mu_earth/r^3*X(2)+ap_car(2);
Xdot(6) = -mu_earth/r^3*X(3)+ap_car(3);

end