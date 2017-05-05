%% ASSIGNMENT 2 - INTERPLANETARY FLYBY
%  Planetes : Mars, Saturn, Neptune
%  (C) Collogrosso Alfonso, Cuzzocrea Francescodario, Lui Benedetto - POLIMI SPACE AGENCY
%  WEB : https://github.com/fcuzzocrea/OrbitalMechanics2016

clear
close all
% clc

% File for saving datas
if exist(fullfile(cd, 'results_flyby.txt'), 'file') == 2
    delete(fullfile(cd, 'results_flyby.txt'))
end
filename = 'results_flyby.txt';
fileID = fopen(filename,'w+');
fprintf(fileID,'[ASSIGNMENT 2 : INTERPLANETARY FLYBY]\n');
fclose(fileID);

date =  [2016 1 1 12 0 0];
date = date2mjd2000(date);

%% TIMES MATRIX COMPUTATION

starting_departure_time = [2016 1 1 12 0 0];
final_departure_time = [2055 1 1 12 0 0];
fileID = fopen(filename,'a+');
fprintf(fileID,'[LOG] Mission Window : [%d %d %d %d %d %d] - [%d %d %d %d %d %d]\n',starting_departure_time,final_departure_time);
fclose(fileID);

% Conversion of departure dates from Gregorian calendar
% to modified Julian Day 2000.
date1_departure = date2mjd2000(starting_departure_time);
date2_departure = date2mjd2000(final_departure_time);

% Time of departure window vectors in days and seconds.
t_dep = date1_departure : 100 : date2_departure ;
t_dep_sec = t_dep*86400;


% First and last arrival dates.
starting_arrival_time = [2016 1 1 12 0 0];
final_arrival_time = [2055 1 1 12 0 0];

% Conversion of arrival dates from Gregorian calendar
% to modified Julian Day 2000
date1_arrival = date2mjd2000(starting_arrival_time);
date2_arrival = date2mjd2000(final_arrival_time);

% Time of arrival window vectors in days and seconds
% One arrival per month (needed by iterative routine and Pork Chop plots)
t_arr = date1_arrival: 100 : date2_arrival ;
t_arr_sec = t_arr*86400;

% Time of fligth matrix computation
TOF_matrix = tof_calculator (t_dep,t_arr);
for q = 1: numel(TOF_matrix)
    if TOF_matrix(q) <= 0
        TOF_matrix(q) = nan;
    end
end

%% ORBITS DEFINITION

% Needed for orbits plots
ibody_mars = 4;
[kep_mars,ksun] = uplanet(date, ibody_mars);
[rx_mars, ry_mars, rz_mars, vx_mars, vy_mars, vz_mars] = int_orb_eq(kep_mars,ksun);

ibody_saturn = 6;
[kep_saturn,ksun] = uplanet(date, ibody_saturn);
[rx_saturn, ry_saturn, rz_saturn, vx_saturn, vy_saturn, vz_saturn] = int_orb_eq(kep_saturn,ksun);

ibody_neptune = 8;
[kep_neptune,ksun] = uplanet(date, ibody_neptune);
[rx_neptune, ry_neptune, rz_neptune, vx_neptune, vy_neptune, vz_neptune] = int_orb_eq(kep_neptune,ksun);

%% DELTAV CALCULATION

% ITERATIVE ROUTINE
[DV_MIN_ir, DV_MAX, Dv_min_TOF_1_ir, Dv_matrix_1, Dv_matrix_2, Dv_min_TOF_2_ir, r1_arc_ir, r2_arc_ir, r3_arc_ir, v_saturn_ir, t_saturn_ir] = Dv_Tensor_Calculator (t_dep, ibody_mars, ibody_saturn, ibody_neptune, ksun, TOF_matrix);

% INTERIOR POINT ALGORITHM WITH FMINCON
[DV_MIN_fmc, Dv_min_TOF_1_fmc, Dv_min_TOF_2_fmc, r1_arc_fmc, r2_arc_fmc, r3_arc_fmc, v_saturn_fmc, t_saturn_fmc] = Fmincon_Flyby (t_dep);

% GENETIC ALGORITHM
[DV_MIN_ga, Dv_min_TOF_1_ga, Dv_min_TOF_2_ga, r1_arc_ga, r2_arc_ga, r3_arc_ga, v_saturn_ga, t_saturn_ga, dv_ga] = Flyby_GA(0);

%% OPTIMUM DELTAV SELECTOR

DV_OPT = [DV_MIN_ir, DV_MIN_fmc, DV_MIN_ga];
DV_MIN = min(DV_OPT);

if DV_MIN == DV_MIN_ir
    fileID = fopen(filename,'a+');
    fprintf(fileID,'[LOG] BEST FLYBY FOUND WITH ITERATIVE ROUTINE\n');
    fclose(fileID);
    r1_arc = r1_arc_ir;
    r2_arc = r2_arc_ir;
    r3_arc = r3_arc_ir;
    v_saturn = v_saturn_ir; 
    t_saturn = t_saturn_ir;
    Dv_min_TOF_1 = Dv_min_TOF_1_ir;
    Dv_min_TOF_2 = Dv_min_TOF_2_ir;
elseif DV_MIN == DV_MIN_fmc
    fileID = fopen(filename,'a+');
    fprintf(fileID,'[LOG] BEST FLYBY FOUND WITH FMINCON\n');
    fclose(fileID);
    r1_arc = r1_arc_fmc;
    r2_arc = r2_arc_fmc;
    r3_arc = r3_arc_fmc;
    v_saturn = v_saturn_fmc; 
    t_saturn = t_saturn_fmc;
    Dv_min_TOF_1 = Dv_min_TOF_1_fmc;
    Dv_min_TOF_2 = Dv_min_TOF_2_fmc;
elseif DV_MIN == DV_MIN_ga
    fileID = fopen(filename,'a+');
    fprintf(fileID,'[LOG] BEST FLYBY FOUND WITH GENETIC ALGORITHM\n');
    fclose(fileID);
    r1_arc = r1_arc_ga;
    r2_arc = r2_arc_ga;
    r3_arc = r3_arc_ga;
    v_saturn = v_saturn_ga; 
    t_saturn = t_saturn_ga;
    Dv_min_TOF_1 = Dv_min_TOF_1_ga;
    Dv_min_TOF_2 = Dv_min_TOF_2_ga;
end

fileID = fopen(filename,'a+');
fprintf(fileID,'[LOG] DELTAV MIN : %f \n',DV_MIN);
fclose(fileID);

% Compute bests transfer arcs
[~,~,~,~,VI_arc1,VF_arc1,~,~] = lambertMR(r1_arc,r2_arc,Dv_min_TOF_1,ksun);
[~,~,~,~,VI_arc2,VF_arc2,~,~] = lambertMR(r2_arc,r3_arc,Dv_min_TOF_2,ksun);

[rx_arc_1, ry_arc_1, rz_arc_1, vx_arc_1, vy_arc_1, vz_arc_1] = intARC_lamb(r1_arc,...
    VI_arc1,ksun,Dv_min_TOF_1,86400);

[rx_arc_2, ry_arc_2, rz_arc_2, vx_arc_2, vy_arc_2, vz_arc_2] = intARC_lamb(r2_arc,...
    VI_arc2,ksun,Dv_min_TOF_2,86400);

% V infinity
v_inf_min = (VF_arc1 - v_saturn');
v_inf_plus = (VI_arc2 - v_saturn');

%% FLYBY

% Radius of pericenter of the flyby hyperbola
delta = acos(dot(v_inf_min,v_inf_plus)/(norm(v_inf_min)*norm(v_inf_plus)));
ksaturn = astroConstants(16);
f = @(r_p) delta - asin(1/(1+(r_p*norm(v_inf_min)^2/ksaturn))) - asin(1/(1+(r_p*norm(v_inf_plus)^2/ksaturn)));
r_p = fzero(f,10000000);
fileID = fopen(filename,'a+');
fprintf(fileID,'[LOG] Pericenter Radius of Hyperbola : %f \n',r_p);
fclose(fileID);

% Entering hyperbola 
e_min = 1 + (r_p*norm(v_inf_min)^2)/ksaturn;
delta_min = 2*(1/e_min);
DELTA_min = r_p*sqrt(1 + 2*(ksaturn/(r_p*norm(v_inf_min)^2)));
theta_inf_min = acos(-1/e_min);
beta_min = acos(1/e_min);
a_min = DELTA_min /(e_min^2 -1);
b_min = a_min*(sqrt(e_min^2 -1));
h_min = sqrt(ksaturn*a_min*(e_min^2 -1));

% Exiting hyperbola
e_plus = 1 + (r_p*norm(v_inf_plus)^2)/ksaturn;
delta_plus = 2*(1/e_plus);
DELTA_plus = r_p*sqrt(1 + 2*(ksaturn/(r_p*norm(v_inf_plus)^2)));
theta_inf_plus = acos(-1/e_plus);
beta_plus = acos(1/e_plus);
a_plus = DELTA_plus /(e_plus^2 -1);
h_plus = sqrt(ksaturn*a_plus*(e_plus^2 -1));
b_plus = a_plus*(sqrt(e_plus^2 -1));

% Velocities at pericenter 
vp_min = (DELTA_min*norm(v_inf_min))/(r_p);
vp_plus = (DELTA_plus*norm(v_inf_plus))/(r_p);

% DeltaV flyby
toll = 2.5e-10;
DELTA_FLYBY = norm(v_inf_plus - v_inf_min);
DELTA_VP = abs(vp_plus - vp_min);
if DELTA_VP <= toll
    fileID = fopen(filename,'a+');
    fprintf(fileID,'[LOG] Powered gravity assist is not needed \n');
    fclose(fileID);
else
    fileID = fopen(filename,'a+');
    fprintf(fileID,'[LOG] DeltaV to give at pericenter%f : \n',DELTA_VP);
    fclose(fileID);
end

% Saturn SOI data
% Saturn Semimajor axis in AU from https://nssdc.gsfc.nasa.gov/planetary/factsheet/saturnfact.html
a_saturn = 9.53707032;
r_soi_saturn = astroConstants(2)*a_saturn*(astroConstants(16)/astroConstants(4))^(2/5);
fileID = fopen(filename,'a+');
fprintf(fileID,'[LOG] Saturn SOI radius : %f \n',r_soi_saturn);
fclose(fileID);

% Hyperbola parameters
theta_SOI_min = acos((h_min^2/(ksaturn*r_soi_saturn*e_min))-1/e_min);
theta_min = -theta_SOI_min:0.01:0;
theta_min = [theta_min 0];
x_hyp_min = -a_min*((e_min+cos(theta_min))./(1+e_min*cos(theta_min)))+a_min+r_p;
y_hyp_min = b_min*((sqrt(e_min)^2*sin(theta_min))./(1+e_min*cos(theta_min)));

theta_SOI_plus = acos((h_plus^2/(ksaturn*r_soi_saturn*e_plus))-1/e_plus);
theta_plus = 0:0.01:theta_SOI_plus;
theta_plus = [theta_plus theta_SOI_plus];
x_hyp_plus = -a_plus*((e_plus+cos(theta_plus))./(1+e_plus*cos(theta_plus)))+a_plus+r_p;
y_hyp_plus = b_plus*((sqrt(e_plus)^2*sin(theta_plus))./(1+e_plus*cos(theta_plus)));

% Flyby Time
F_min = acosh((cos(theta_SOI_min) + e_min)/(1 + e_min*cos(theta_SOI_min)));
dt_min = sqrt(a_min^3/ksaturn)*(e_min*sinh(F_min)-F_min);
F_plus = acosh((cos(theta_SOI_plus) + e_plus)/(1 + e_plus*cos(theta_SOI_plus)));
dt_plus = sqrt(a_plus^3/ksaturn)*(e_plus*sinh(F_plus)-F_plus);
dt_tot = dt_min+dt_plus;
dt_tot_days = dt_tot*1.1574e-5;
fileID = fopen(filename,'a+');
fprintf(fileID,'[LOG] Flyby time %f days\n',dt_tot_days);
fclose(fileID);

% FlyBy altitude from Saturn
altitude = r_p-astroConstants(26);

%% SATURNOCENTRIC FRAME PLOT

% Rotation matrix : heliocentric -> saturnocentric
[kep_saturn,ksun] = uplanet(t_saturn, ibody_saturn);
i_sat = kep_saturn(3);
OMG_sat = kep_saturn(4);
omg_sat = kep_saturn(5);
theta_sat = kep_saturn(6);
RM_theta = [cos(theta_sat), sin(theta_sat), 0; -sin(theta_sat), cos(theta_sat),0; 0,0,1];
RM_OMG = [ cos(OMG_sat),sin(OMG_sat), 0; -sin(OMG_sat), cos(OMG_sat), 0; 0, 0, 1];
RM_i = [1, 0, 0; 0, cos(i_sat), sin(i_sat);  0, -sin(i_sat), cos(i_sat)];
RM_omg = [cos(omg_sat), sin(omg_sat), 0; -sin(omg_sat), cos(omg_sat), 0; 0, 0, 1];
T = RM_theta*RM_omg*RM_i*RM_OMG;

% Fondamentalmente ho che il versore uscente dal piano e perpendicolare ad esso sara quello dato dal
% prodotto scalare di vinfmeno x vinfplus. L'orienzione : sara quella tale
% per cui le due vinf giacciono sullo stesso piano. Ok, dato questo come
% continuo per plottare l'iperbole ?
v_inf_min_saturn = T*v_inf_min';
v_inf_plus_saturn = T*v_inf_plus';
k_direction = cross(v_inf_min_saturn,v_inf_plus_saturn);
k_direction = k_direction/norm(k_direction); 

% Get Lambert arc in Saturnocentric frame
[A]=T*[rx_arc_1, ry_arc_1, rz_arc_1]';
rx_arc_1_saturn = A(1,:);
ry_arc_1_saturn = A(2,:);
rz_arc_1_saturn = A(3,:);

[B]=T*[rx_arc_2, ry_arc_2, rz_arc_2]';
rx_arc_2_saturn = B(1,:);
ry_arc_2_saturn = B(2,:);
rz_arc_2_saturn = B(3,:);

%% PLOTTING 

% Orbits in the heliocentric frame
figure(1)
grid on
hold on
whitebg(figure(1), 'black')
plot3(rx_mars,ry_mars,rz_mars);
plot3(rx_neptune,ry_neptune,rz_neptune);
plot3(rx_saturn,ry_saturn,rz_saturn);
axis equal
legend('Mars Orbit', 'Neptune Orbit', 'Saturn Orbit')
title('Orbits in Heliocentric Frame')

%  Pork chop plot DV,TOF for Mars -> Saturn transfer
figure(2)
hold on
grid on
title('Pork chop plot contour and TOF for Mars to Saturn')
xlabel('Time of arrival');
ylabel('Time of departure');
axis equal
contour(t_arr,t_dep,Dv_matrix_1,50);
contour(t_arr,t_dep,TOF_matrix,20,'r','ShowText','on');
caxis([DV_MIN DV_MAX]);
colormap jet
datetick('x','yy/mm/dd','keepticks','keeplimits')
datetick('y','yy/mm/dd','keepticks','keeplimits')
set(gca,'XTickLabelRotation',45)
set(gca,'YTickLabelRotation',45)

%  Pork chop plot DV,TOF for Saturn -> Neptune transfer
figure(3)
hold on
grid on
title('Pork chop plot contour and TOF for Saturn to Neptune')
xlabel('Time of arrival');
ylabel('Time of departure');
axis equal
contour(t_arr,t_dep,Dv_matrix_2,50);
contour(t_arr,t_dep,TOF_matrix,20,'r','ShowText','on');
caxis([DV_MIN DV_MAX]);
colormap jet
datetick('x','yy/mm/dd','keepticks','keeplimits')
datetick('y','yy/mm/dd','keepticks','keeplimits')
set(gca,'XTickLabelRotation',45)
set(gca,'YTickLabelRotation',45)

% Best flyby plot in heliocentric frame
figure(4)
grid on
hold on
whitebg(figure(4), 'black')
plot3(rx_mars,ry_mars,rz_mars);
plot3(rx_neptune,ry_neptune,rz_neptune);
plot3(rx_saturn,ry_saturn,rz_saturn);
plot3(rx_arc_1, ry_arc_1, rz_arc_1,'y')
plot3(rx_arc_2, ry_arc_2, rz_arc_2,'w')
axis equal
legend('Mars Orbit', 'Neptune Orbit', 'Saturn Orbit', 'First Transfer Arc','Second Transfer Arc')
title('Orbits and Lamberts Arc in Heliocentric Frame')

% Best flyby in saturnocentric frame
figure(5)
grid on 
hold on
title('Lambert Arcs in Planetocentric Frame')
plot3(rx_arc_1_saturn,ry_arc_1_saturn,rz_arc_1_saturn)
plot3(rx_arc_2_saturn,ry_arc_2_saturn,rz_arc_2_saturn)
xlabel('Km')
ylabel('Km')
legend('Before GA', 'After GA')
axis equal

% 2D Hyperbola
figure(6)
hold on
plot(x_hyp_min,y_hyp_min)
zoomPlot (6,'x',[-10000000 3000000],'y',[-5000000 5000000]);
plot(x_hyp_plus,y_hyp_plus)
zoomPlot (6,'x',[-10000000 3000000],'y',[-5000000 5000000]);
plot(0,0,'*')
grid on
axis equal
xlabel('Km')
ylabel('Km')
title('Flyby Hyperbola')
legend('Entering Hyperbola', 'Exiting Hyperbola')


