%% Mars Express Trajectory

clear
close all
clc

%% Time transformation from Gregorian calendar to modified 2000 Julian calendar 

starting_departure_time = [2003 4 1 12 0 0];
final_departure_time = [2003 8 1 12 0 0];
starting_arrival_time = [2003 9 1 12 0 0];
final_arrival_time = [2004 3 1 12 0 0];

date1_departure = date2mjd2000(starting_departure_time);
date2_departure = date2mjd2000(final_departure_time);
date1_arrival = date2mjd2000(starting_arrival_time);
date2_arrival = date2mjd2000(final_arrival_time);

% Definition of the time vectors of departures and arrivals
t_dep_vect = date1_departure : 1 : date2_departure ;
t_arr_vect = date1_arrival: 1 : date2_arrival ;


% Time of fligth computation 


[TOF] = tof_calculator (t_dep_vect,t_arr_vect);


%% Earth orbit computation from ephemerides 


ibodyE = 3;


[kep_earth,ksun] = uplanet(date1_departure, ibodyE);


a_e = kep_earth(1);
e_e = kep_earth(2);
i_e = kep_earth(3);
OMG_e = kep_earth(4);
omg_e = kep_earth(5);
theta_e = kep_earth(6);


%% Mars orbit computation from ephemerides 


ibodyM = 4;


[kep_mars,ksun] = uplanet(date1_arrival, ibodyM);


a_m = kep_mars(1);
e_m = kep_mars(2);
i_m = kep_mars(3);
OMG_m = kep_mars(4);
omg_m = kep_mars(5);
theta_m = kep_mars(6);


%% Sun Gravitational constant


mu = ksun;


%% Integration of orbit equations to find vectors that we need for LambertMR


[rx_E_vect, ry_E_vect, rz_E_vect, vx_E_vect, vy_E_vect, vz_E_vect] = int_orb_eq(a_e,e_e,i_e,OMG_e,omg_e,theta_e,mu);
[rx_M_vect, ry_M_vect, rz_M_vect, vx_M_vect, vy_M_vect, vz_M_vect] = int_orb_eq(a_m,e_m,i_m,OMG_m,omg_m,theta_m,mu);


% OK
% Chiedere ad aureliano o prof

[rxd_E_vect, ryd_E_vect, rzd_E_vect, vxd_E_vect, vyd_E_vect, vzd_E_vect] = int_orb_eq(a_e,e_e,i_e,OMG_e,omg_e,theta_e,mu,t_dep_vect);
[rxa_M_vect, rya_M_vect, rza_M_vect, vxa_M_vect, vya_M_vect, vza_M_vect] = int_orb_eq(a_m,e_m,i_m,OMG_m,omg_m,theta_m,mu,t_arr_vect);

r_vect = [];
v_vect = [];

for j=1:length(t_dep_vect)
    date_e = t_dep_vect(j);
    [kep_e,ksun] = uplanet(date_e, ibodyE);
    a_ee = kep_e(1);
    e_ee = kep_e(2);
    i_ee = kep_e(3);
    OMG_ee = kep_e(4);
    omg_ee = kep_e(5);
    theta_ee = kep_e(6);

    [r,v]=kep2car(a_ee,e_ee,i_ee,OMG_ee,omg_ee,theta_ee,mu);
    r_vect  = [r_vect, r];
    v_vect = [v_vect,v];
end
    
r_vect = r_vect';
v_vect = v_vect';

r_dep_vect = [rxd_E_vect ryd_E_vect rzd_E_vect];
r_arr_vect = [rxa_M_vect rya_M_vect rza_M_vect];
v_dep_vect = [vxd_E_vect, vyd_E_vect, vzd_E_vect];
v_arr_vect = [vxa_M_vect, vya_M_vect, vza_M_vect];




%%  Orbits Plotting


figure(1)
whitebg(figure(1), 'black')
hold on
grid on
title('Orbits rapresentation')
plot3(rx_E_vect, ry_E_vect, rz_E_vect,'c--');
plot3(rx_M_vect, ry_M_vect, rz_M_vect,'r--');
plot3(r_vect(1,:),r_vect(2,:),r_vect(3,:))

%plot3(rxd_E_vect, ryd_E_vect, rzd_E_vect)



%% SUN Plotting 
 
% SUN = imread('Sun.png','png');
% R_SUN = 695700;
% props.FaceColor='texture';
% props.EdgeColor='none';
% props.FaceLighting='phong';
% props.Cdata = SUN;
% Center = [0; 0; 0];
% [XX, YY, ZZ] = ellipsoid(Center(1),Center(2),Center(3),R_SUN,R_SUN,R_SUN,30);
% surface(-XX, -YY, -ZZ,props);
% 
% 
% legend('Earth Orbit','Mars Orbit','Sun');
% 
% plotorbit(a_e,e_e,i_e,OMG_e,omg_e,mu,5);
% plotorbit(a_m,e_m,i_m,OMG_m,omg_m,mu,4);
  
%% Lambert's problem computation for each value of departure and arrival


%[DV_vect, DV_min, DV_max, V_I, V_F] = pork_chop(r_dep_vect,r_arr_vect,v_dep_vect,v_arr_vect,t_dep_vect,t_arr_vect,mu); 

% Plotting

%figure(2)

%M_plot = repmat(t_dep_vect,22509,1);

%plot3(M_plot,TOF , DV_vect)
