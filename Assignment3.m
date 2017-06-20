clear
close all
clc

%% Assignment 3

date = date2mjd2000([2017,5,23,17,35,10]);


%% Orbital Data

mu_earth = astroConstants(13);
a = 3.7067e4;
e = 0.5682;
i = 49.587/180*pi;
OM = pi/6;
om = pi/3;
h_p = 9627.33;
earth_radius = 6378.14;

r_p =  earth_radius + h_p;

kep_0 = [a,e,i,OM,om,0];
[r_sp,v_sp] = kep2car(kep_0,mu_earth);

%% Perturbation Data

J2 = 1.08e-3;


%% Groundtrack per 1 day

% Still to do


%% Application of Gauss Equations

odeopt = odeset('RelTol',1e-13,'AbsTol',1e-14');
[t_out,kep_out] = ode45(@(t,kep) GaussPert(t,kep,mu_earth, ...
    earth_radius,J2,date),linspace(0,28*12*86400,5e5),kep_0,odeopt);

r_vect = zeros(size(kep_out,1),3);
for j = 1:size(kep_out,1)
    r_vect(j,:) = kep2car(kep_out(j,:),mu_earth);
end


%% Direct dynamic integration

[t_out2,car_out] = ode45(@(t,car) pertdyn2bp(t,car,mu_earth, ...
    earth_radius,J2,date),linspace(0,10*86400,1e4),[r_sp',v_sp'],odeopt);

kep_vect = zeros(size(car_out,1),6);
for j = 1:size(car_out,1)
    [~,kep_vect(j,1),kep_vect(j,2),kep_vect(j,3), ...
        kep_vect(j,4),kep_vect(j,5),kep_vect(j,6)] = ...
        evalc('car2kep(car_out(j,1:3),car_out(j,4:6),mu_earth);');
end


%% Compare the parametres
%% Plot the parametres
% Da fare con subplot

figure,plot(t_out,kep_out(:,1))
figure,plot(t_out,kep_out(:,2))
figure,plot(t_out,kep_out(:,3))
figure,plot(t_out,kep_out(:,4))
figure,plot(t_out,kep_out(:,5))
figure,plot(t_out,kep_out(:,6))

figure
plotorbit(a,e,i,pi/6,pi/3,mu_earth,1)
hold on
plot3(r_vect(:,1),r_vect(:,2),r_vect(:,3),'r')

figure(1), hold on, plot(t_out2,kep_vect(:,1))
figure(2), hold on, plot(t_out2,kep_vect(:,2))
figure(3), hold on, plot(t_out2,kep_vect(:,3))
figure(4), hold on, plot(t_out2,kep_vect(:,4))
figure(5), hold on, plot(t_out2,kep_vect(:,5))
figure(6), hold on, plot(t_out2,kep_vect(:,6))

%% Lowpass Filter Design (parameters tbf)

L = 5e5;
Ts = t_out(2)-t_out(1);
Fs = 1/Ts;

NFFT = 2^nextpow2(L);
X_a = fft(detrend(kep_out(:,1)-a),NFFT)/L;
X_e = fft(detrend(kep_out(:,2)-e),NFFT)/L;
X_i = fft(detrend(kep_out(:,3)-i),NFFT)/L;
X_OM = fft(detrend(kep_out(:,4)-OM),NFFT)/L;
X_om = fft(detrend(kep_out(:,5)-om),NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);

figure
plot(f,abs(X_a(1:NFFT/2+1)),'.-')
figure
plot(f,abs(X_e(1:NFFT/2+1)),'.-')
figure
plot(f,abs(X_i(1:NFFT/2+1)),'.-')
figure
plot(f,abs(X_OM(1:NFFT/2+1)),'.-')
figure
plot(f,abs(X_om(1:NFFT/2+1)),'.-')

%% Filtering

f_c = 0.5*sqrt(mu_earth/a^3)/pi/2;
[b_f,a_f] = butter(2,f_c/(Fs/2));

e_filt = filtfilt(b_f,a_f,kep_out(:,2));
i_filt = filtfilt(b_f,a_f,kep_out(:,3));
OM_filt = filtfilt(b_f,a_f,kep_out(:,4));
om_filt = filtfilt(b_f,a_f,kep_out(:,5));

figure
plot(t_out,e_filt)
figure
plot(t_out,i_filt)
figure
plot(t_out,OM_filt)
figure
plot(t_out,om_filt)

%%

f_c = 1e-6;
[b_f,a_f] = butter(2,f_c/(Fs/2));

a_filt = filtfilt(b_f,a_f,kep_out(:,1)-a);

figure
plot(t_out,a_filt)