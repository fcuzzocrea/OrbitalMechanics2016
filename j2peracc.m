function [apJ2_vect] = j2peracc (r_vect,J2,R,mu)

r = norm(r_vect);

x = r_vect(1);
y = r_vect(1);
z = r_vect(1);

c = 3/2*(J2*mu*R^2)/r^4;

ap_x = c*(x/r*(5*((z^2)/(r^2))- 1));
ap_y = c*(y/r*(5*((z^2)/(r^2))- 1));
ap_z = c*(z/r*(5*((z^2)/(r^2))- 3));

apJ2_vect = [ap_x ap_y ap_z];

end