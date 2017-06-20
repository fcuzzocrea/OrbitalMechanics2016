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
h_p = 9627.33;
earth_radius = 6378.14;

r_p =  earth_radius + h_p;

kep_0 = [a,e,i,pi/6,pi/3,0];
[r_sp,v_sp] = kep2car(kep_0,mu_earth);

%% Perturbation Data

J2 = 1.08e-3;


%% Groundtrack per 1 day

% Still to do


%% Application of Gauss Equations

odeopt = odeset('RelTol',1e-13,'AbsTol',1e-14');
[t_out,kep_out] = ode45(@(t,kep) GaussPert(t,kep,mu_earth, ...
    earth_radius,J2,date),[0,10*86400],kep_0,odeopt);

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
y0 = interp1(linspace(0,10*86400,1e4),t_out2,kep_vect(:,3)); 
% Sampling rate
% Lunghezza della finestra, la documentazione suggerisce :
NFFT = pow2(nextpow2(length(y0)));
% Faccio la fft
Y=fft(y0,NFFT);
% Prendo solo la lunghezza che mi interessa
Y=Y(1:length(kep_vect)); 

%Plot
fs = 0.0116;
dF = fs/length(kep_vect);
f = -fs/2:dF:fs/2-dF;
figure
plot(f,abs(Y)/length(kep_vect));
figure
semilogy(f,mag2db(abs(Y)/length(kep_vect)));
% Filter design
fc = 0.0002; % Frequenza di taglio,
fs = 0.0116; %Frequenza di campionamento come cazzo faccio a saperla se campiono con ode ??? 
[b,a] = butter(6,fc/(fs/2)); % Butterworth filter of order 6
output = filter(b,a,Y); % Will be the filtered signal
% Antitrasformo il segnale
iY = ifft(output);
% A me interessa solo l'ampiezza del segnale
fY = abs(iY);
% Prendi un numero di dati pari al numero di dati originale
fY=fY(1:length(t_out2));
% Correggi la max ampiezza dei dati
filteredsignal = fY*NFFT;
% Plotta
figure
plot(t_out2, filteredsignal);

