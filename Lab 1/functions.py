import numpy
import scipy

def kep2car(a,e,i,omega,OMEGA,theta,mu)

    p = a*(1 - norm(e)^2);

    # Dalla polare è noto R

    R = p/(1 + norm(e)*cos(theta));
    r_pf = [R*cos(theta);R*sin(theta);0];

    # Ricavo la velocità nel sistema di riferimento perifocale

    v_pf = [-sqrt(mu/p)*sin(theta); sqrt(mu/p)*(norm(e) + cos(theta)); 0];

    # Calcolo le singole matrici di rotazione

    OMEGA_ROT = [ cos(OMEGA),sin(OMEGA), 0; -sin(OMEGA), cos(OMEGA), 0; 0, 0, 1];
    i_ROT = [1, 0, 0; 0, cos(i), sin(i);  0, -sin(i), cos(i)];
    omega_ROT = [cos(omega), sin(omega), 0; -sin(omega), cos(omega), 0; 0, 0, 1];

    # Matrice di rotazione completa

    T = OMEGA_ROT*i_ROT*omega_ROT;

    # Calcolo i vettori posizione e velocità nel sistema di riferimento geocentrico equatoriale

    r = T'*r_pf;
    v = T'*v_pf;

    return r, v

def car2kep(r,v,mu)
    # Versori terna
    I = [1;0;0];
    J = [0;1;0];
    K = [0;0;1];

    #Passo 1
    R = norm(r);
    V = norm(v);

    # Passo 2

    a = 1/((2/R) - (V^2/mu));

    # Passo 3

    h = cross(r,v);
    H = norm(h);

    # Passo 4

    e = 1/mu*(cross(v,h)- mu * r./R);
    E = norm(e);

    # Passo 5

    i = acos(dot(h,K)./H);

    # Passo 6

    n = cross(K,h)./norm(cross(K,h));

    # Passo 7

    if dot(n,J) > 0
        OMEGA = acos(dot(I,n));
    else
        OMEGA = 2*pi-acos(dot(I,n));

    # Passo 8

    if dot(e,K) > 0
        omega = acos((dot(n,e))/E);
    else
        omega = 2*pi - acos((dot(n,e))/E);

    # Passo 9

    if dot(v,r) > 0
        fprintf('Maggiore')
        theta = acos((dot(r,e))/R*E);
    else
        fprintf('Minore')
        theta = 2*pi - acos((dot(r,e))/R*E);


