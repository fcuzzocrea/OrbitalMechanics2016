%% ASSIGNMENT 3 - ORBITAL PERTURBATIONS
%  Perturbations : J2, Moon
%  (C) Collogrosso Alfonso, Cuzzocrea Francescodario, Lui Benedetto - POLIMI SPACE AGENCY
%  WEB : https://github.com/fcuzzocrea/OrbitalMechanics2016

clear
close all
%clc

% File for saving datas
if exist(fullfile(cd, 'results_perturbations.txt'), 'file') == 2
    delete(fullfile(cd, 'results_perturbations.txt'))
end
filename = 'results_perturbations.txt';
fileID = fopen(filename,'w+');
fprintf(fileID,'[ASSIGNMENT 3 - ORBITAL PERTURBATIONS]\n');
fclose(fileID);

% Starting time for simulation
date = date2mjd2000([2017,5,23,17,35,10]);
fileID = fopen(filename,'a+');
fprintf(fileID,'[LOG] Starting time for simulation : [%d %d %d %d %d %d]\n',date);
fclose(fileID);

% Orbit datas
mu_earth = astroConstants(13);
a = 3.7067e4;
e = 0.5682;
i = 49.587/180*pi;
OM = pi/6;
om = pi/3;
h_p = 9627.33;
earth_radius = 6378.14;
r_p =  earth_radius + h_p;

% Convert to keplerian parameters
kep_0 = [a,e,i,OM,om,0];
[r_0,v_0] = kep2car(kep_0,mu_earth);

% Assigned perturbations datas
J2 = 1.08e-3;

% ODE Options
odeopt = odeset('RelTol',1e-13,'AbsTol',1e-14');

%% GROUND TRACK

% Still to do


%% EVALUATION OF ORBITAL PERTURBATIONS BY GAUSS EQUATIONS

% Gauss Equations integration
propagation_time_gauss = linspace(0,28*12*86400,5e5);
% kep_out_gauss contain [a,e,i,OM,om,th]
[t_out_gauss,kep_out_gauss] = ode45(@(t,kep) GaussPert(t,kep,mu_earth,earth_radius,J2,date),propagation_time_gauss,kep_0,odeopt);

% Conversion to cartesian components
r_vect_gauss = zeros(size(kep_out_gauss,1),3);
for j = 1:size(kep_out_gauss,1)
    r_vect_gauss(j,:) = kep2car(kep_out_gauss(j,:),mu_earth);
end


%% DIRECT DYNAMIC INTEGRATION OF PERTURBED EQUATIONS

propagation_time_ddi = linspace(0,10*86400,1e4);
[t_out_ddi,car_out_ddi] = ode45(@(t,car) pertdyn2bp(t,car,mu_earth,earth_radius,J2,date),propagation_time_ddi,[r_0',v_0'],odeopt);

kep_vect_ddi = zeros(size(car_out_ddi,1),6);
for j = 1:size(car_out_ddi,1)
    [~,kep_vect_ddi(j,1),kep_vect_ddi(j,2),kep_vect_ddi(j,3), ...
        kep_vect_ddi(j,4),kep_vect_ddi(j,5),kep_vect_ddi(j,6)] = ...
        evalc('car2kep(car_out_ddi(j,1:3),car_out_ddi(j,4:6),mu_earth);');
end

%% LOWPASS FILTER DESIGN

% Frequency components of the orbital perturbations

% Number of samples (basically is the size of the kep_out vector)
L = 5e5;
% Sample time
Ts = t_out_gauss(2)-t_out_gauss(1);
% Sampling frequency
Fs = 1/Ts;
% According to MATLAB documentations this value should be selected like
% this to have a meaningful frequency representation of the input vector
NFFT = 2^nextpow2(L);
% Frequency components
X_a = fft(detrend(kep_out_gauss(:,1)-a),NFFT)/L;
X_e = fft(detrend(kep_out_gauss(:,2)-e),NFFT)/L;
X_i = fft(detrend(kep_out_gauss(:,3)-i),NFFT)/L;
X_OM = fft(detrend(kep_out_gauss(:,4)-OM),NFFT)/L;
X_om = fft(detrend(kep_out_gauss(:,5)-om),NFFT)/L;
% Frequency range (for the frequency plots)
f = Fs/2*linspace(0,1,NFFT/2+1);

% Filtering

% Cutoff frequency
f_c = 0.5*sqrt(mu_earth/a^3)/pi/2;
% Filter transfer function
[b_f,a_f] = butter(2,f_c/(Fs/2));

e_filt = filtfilt(b_f,a_f,kep_out_gauss(:,2));
i_filt = filtfilt(b_f,a_f,kep_out_gauss(:,3));
OM_filt = filtfilt(b_f,a_f,kep_out_gauss(:,4));
om_filt = filtfilt(b_f,a_f,kep_out_gauss(:,5));

% Semimajor axis is a 'special guy...'
f_c = 1e-6;
[b_f,a_f] = butter(2,f_c/(Fs/2));
a_filt = filtfilt(b_f,a_f,kep_out_gauss(:,1)-a);

%% PLOTTING

t_plot_gauss = t_out_gauss/86400 + date; 
t_plot_ddi = t_out_ddi/84600 + date;

figure(1)
plotorbit(a,e,i,pi/6,pi/3,mu_earth,1)
hold on
plot3(r_vect_gauss(:,1),r_vect_gauss(:,2),r_vect_gauss(:,3),'r')
title('Orbit evolution : 2 years simulation')
legend('Initial Orbit')

figure(2)
hold on
plot(t_plot_gauss(1:41667),kep_out_gauss(1:41667,1))
plot(t_plot_ddi,kep_vect_ddi(:,1))
title('Semimajor axis variation')
legend('Gauss Results','DDI Results')
xlabel('Days')
ylabel('Km')
figure(3)
hold on
plot(t_plot_gauss(1:41667),kep_out_gauss(1:41667,2))
plot(t_plot_ddi,kep_vect_ddi(:,2))
title('Eccentricity variation')
legend('Gauss Results','DDI Results')
xlabel('Days')
figure(4)
hold on
plot(t_plot_gauss(1:41667),kep_out_gauss(1:41667,3))
plot(t_plot_ddi,kep_vect_ddi(:,3))
title('Inclination variation')
legend('Gauss Results','DDI Results')
xlabel('Days')
figure(5)
hold on
plot(t_plot_gauss(1:41667),kep_out_gauss(1:41667,4))
plot(t_plot_ddi,kep_vect_ddi(:,4))
title('Right Ascension variation')
legend('Gauss Results','DDI Results')
xlabel('Days')
figure(6)
hold on
plot(t_plot_gauss(1:41667),kep_out_gauss(1:41667,5))
plot(t_plot_ddi,kep_vect_ddi(:,5))
title('Argument of perigee variation')
legend('Gauss Results','DDI Results')
xlabel('Days')
figure(7)
hold on
plot(t_plot_gauss(1:41667),kep_out_gauss(1:41667,6))
plot(t_plot_ddi,kep_vect_ddi(:,6))
title('True anomaly variation')
legend('Gauss Results','DDI Results')
xlabel('Days')

% FFT Plots
figure(8)
plot(f,abs(X_a(1:NFFT/2+1)),'.-')
title('Semimajor axis frequency content')
ylabel('Magnitude')
xlabel('Frequency')
figure(9)
plot(f,abs(X_e(1:NFFT/2+1)),'.-')
title('Eccentricity frequency content')
ylabel('Magnitude')
xlabel('Frequency')
figure(10)
plot(f,abs(X_i(1:NFFT/2+1)),'.-')
title('Inclination frequency content')
ylabel('Magnitude')
xlabel('Frequency')
figure(11)
plot(f,abs(X_OM(1:NFFT/2+1)),'.-')
title('Right ascension frequency content')
ylabel('Magnitude')
xlabel('Frequency')
figure(12)
plot(f,abs(X_om(1:NFFT/2+1)),'.-')
title('Argument of perigee frequency content')
ylabel('Magnitude')
xlabel('Frequency')

% Secular Components
figure(13)
plot(t_out_gauss,e_filt)
title('Eccentricity axis secular component')
xlabel('Months')
figure(14)
plot(t_out_gauss,i_filt)
title('Inclination secular component')
xlabel('Months')
figure(15)
plot(t_out_gauss,OM_filt)
title('Right ascension secular component')
xlabel('Months')
figure(16)
plot(t_out_gauss,om_filt)
title('Argument of perigee secular component')
xlabel('Months')
figure(17)
plot(t_out_gauss,a_filt)
title('Semimajor axis secular component')
xlabel('Months')
ylabel('Km')