%% Mars Express Trajectory

clear
close all
clc

%% Time transformation from Gregorian calendar to MJD2000 

starting_departure_time = [2003 4 1 12 0 0];
final_departure_time = [2003 8 1 12 0 0];
starting_arrival_time = [2003 9 1 12 0 0];
final_arrival_time = [2004 3 1 12 0 0];

date1_departure = date2mjd2000(starting_departure_time);
date2_departure = date2mjd2000(final_departure_time);
date1_arrival = date2mjd2000(starting_arrival_time);
date2_arrival = date2mjd2000(final_arrival_time);

% Definition of the time vectors of departures and arrivals in DAYS

t_dep_vect = date1_departure : 1 : date2_departure ;
t_arr_vect = date1_arrival: 1 : date2_arrival ;


% Time of fligth computation in DAYS

[TOF] = tof_calculator (t_dep_vect,t_arr_vect);


%% Earth orbit and departure window 


% Earth orbit
ibodyE = 3;

[kep_earth,ksun] = uplanet(date1_departure, ibodyE);

a_e = kep_earth(1);
e_e = kep_earth(2);
i_e = kep_earth(3);
OMG_e = kep_earth(4);
omg_e = kep_earth(5);
theta_e = kep_earth(6);

% Departure window

% First day
[kep_earth_f,ksun] = uplanet(date1_departure, ibodyE);
a_ef = kep_earth_f(1);
e_ef = kep_earth_f(2);
i_ef = kep_earth_f(3);
OMG_ef = kep_earth_f(4);
omg_ef = kep_earth_f(5);
theta_ef = kep_earth_f(6);

% Last Day
[kep_earth_l,ksun] = uplanet(date2_departure, ibodyE);
a_el = kep_earth_l(1);
e_el = kep_earth_l(2);
i_el = kep_earth_l(3);
OMG_el = kep_earth_l(4);
omg_el = kep_earth_l(5);
theta_el = kep_earth_l(6);

%Conversion to position
[r_dep_ef,v_dep_ef]=kep2car(a_ef,e_ef,i_ef,OMG_ef,omg_ef,theta_ef,ksun);
[r_dep_el,v_dep_el]=kep2car(a_el,e_el,i_el,OMG_el,omg_el,theta_el,ksun);


%% Mars orbit and arrival window computation from ephemerides 


ibodyM = 4;

% Mars Orbit
[kep_mars,ksun] = uplanet(date1_arrival, ibodyM);
a_m = kep_mars(1);
e_m = kep_mars(2);
i_m = kep_mars(3);
OMG_m = kep_mars(4);
omg_m = kep_mars(5);
theta_m = kep_mars(6);

% Arrival window

% First day
[kep_mars_f,ksun] = uplanet(date1_arrival, ibodyM);
a_mf = kep_mars_f(1);
e_mf = kep_mars_f(2);
i_mf = kep_mars_f(3);
OMG_mf = kep_mars_f(4);
omg_mf = kep_mars_f(5);
theta_mf = kep_mars_f(6);

% Last day
[kep_mars_l,ksun] = uplanet(date2_arrival, ibodyM);
a_ml = kep_mars_l(1);
e_ml = kep_mars_l(2);
i_ml = kep_mars_l(3);
OMG_ml = kep_mars_l(4);
omg_ml = kep_mars_l(5);
theta_ml = kep_mars_l(6);

% Conversion to position
[r_arr_mf,v_arr_mf]=kep2car(a_mf,e_mf,i_mf,OMG_mf,omg_mf,theta_mf,ksun);
[rw_arr_ml,vw_arr_ml]=kep2car(a_ml,e_ml,i_ml,OMG_ml,omg_ml,theta_ml,ksun);


%% Sun Gravitational constant


mu = ksun;


%% Integration of orbit equations to find vectors that we need for LambertMR

% Da scalare in giorni

[rx_E_vect, ry_E_vect, rz_E_vect, vx_E_vect, vy_E_vect, vz_E_vect] = int_orb_eq(a_e,e_e,i_e,OMG_e,omg_e,theta_e,mu);
[rx_M_vect, ry_M_vect, rz_M_vect, vx_M_vect, vy_M_vect, vz_M_vect] = int_orb_eq(a_m,e_m,i_m,OMG_m,omg_m,theta_m,mu);

[rxd_E_vect, ryd_E_vect, rzd_E_vect, vxd_E_vect, vyd_E_vect, vzd_E_vect] = int_orb_eq(a_e,e_e,i_e,OMG_e,omg_e,theta_e,mu,t_dep_vect);
[rxa_M_vect, rya_M_vect, rza_M_vect, vxa_M_vect, vya_M_vect, vza_M_vect] = int_orb_eq(a_m,e_m,i_m,OMG_m,omg_m,theta_m,mu,t_arr_vect);


% ??? 

r_dep_vect = [rxd_E_vect ryd_E_vect rzd_E_vect];
r_arr_vect = [rxa_M_vect rya_M_vect rza_M_vect];
v_dep_vect = [vxd_E_vect, vyd_E_vect, vzd_E_vect];
v_arr_vect = [vxa_M_vect, vya_M_vect, vza_M_vect];




%%  Orbit Plotting


figure(1)
whitebg(figure(1), 'black')
hold on
grid on
title('Orbits rapresentation')

% Earth and Mars orbit
plot3(rx_E_vect, ry_E_vect, rz_E_vect,'c--');
plot3(rx_M_vect, ry_M_vect, rz_M_vect,'r--');
% Departure window
plot3(r_dep_ef(1),r_dep_ef(2),r_dep_ef(3),'*');
plot3(r_dep_el(1),r_dep_el(2),r_dep_el(3),'*');
% Arrival window
plot3(r_arr_mf(1),r_arr_mf(2),r_arr_mf(3),'*');
plot3(rw_arr_ml(1),rw_arr_ml(2),rw_arr_ml(3),'*');

axis('vis3d')

% % SUN Plotting 
% SUN = imread('Sun.png','png');
% R_SUN = 695700;
% props.FaceColor='texture';
% props.EdgeColor='none';
% props.FaceLighting='phong';
% props.Cdata = SUN;
% Center = [0; 0; 0];
% [XX, YY, ZZ] = ellipsoid(Center(1),Center(2),Center(3),R_SUN,R_SUN,R_SUN,30);
% sh = surface(-XX, -YY, -ZZ,props);


legend('Earth Orbit','Mars Orbit','First Day of Departure Window', 'Last Day of Departure Window', 'First Day of Arrival Window','Last Day of Arrival Window');

%% Lambert's problem computation for each value of departure and arrival


%[DV_vect, DV_min, DV_max, V_I, V_F] = pork_chop(r_dep_vect,r_arr_vect,v_dep_vect,v_arr_vect,t_dep_vect,t_arr_vect,mu); 

% Plotting

%figure(2)

%M_plot = repmat(t_dep_vect,22509,1);

%plot3(M_plot,TOF , DV_vect)
