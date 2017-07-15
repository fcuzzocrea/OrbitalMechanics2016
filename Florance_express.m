%% ASSIGNMENT 1 - EXPRESS TRANSFER
%  Asteroid : Florance
%  (C) Collogrosso Alfonso, Cuzzocrea Francescodario, Lui Benedetto - POLIMI SPACE AGENCY
%  WEB : https://github.com/fcuzzocrea/OrbitalMechanics2016

clear
close all
clc

% File for saving results
if exist(fullfile(cd, 'results_florance.txt'), 'file') == 2
    delete(fullfile(cd, 'results_florance.txt'))
end
filename = 'results_florance.txt';
fileID = fopen(filename,'w+');
fprintf(fileID,'[ASSIGNMENT 1 : FLORANCE EXPRESS]\n');
fclose(fileID);

%% TIMES MATRIX COMPUTATION

% First and last departure dates.
starting_departure_time = [2024 3 1 12 0 0];
final_departure_time = [2027 1 1 12 0 0];
fileID = fopen(filename,'a+');
fprintf(fileID,'[LOG] Departure Window : [%d %d %d %d %d %d] - [%d %d %d %d %d %d]\n',starting_departure_time,final_departure_time);
fclose(fileID);

% Conversion of departure dates from Gregorian calendar
% to modified Julian Day 2000.
date1_departure = date2mjd2000(starting_departure_time);
date2_departure = date2mjd2000(final_departure_time);

% Time of departure window vectors in days and seconds.
t_dep = date1_departure : 7 : date2_departure ;
t_dep_sec = t_dep*86400;

% First and last arrival dates.
starting_arrival_time = [2024 11 1 12 0 0];
final_arrival_time = [2029 6 1 12 0 0];
fileID = fopen(filename,'a+');
fprintf(fileID,'[LOG] Arrival Window : [%d %d %d %d %d %d] - [%d %d %d %d %d %d]\n',starting_arrival_time,final_arrival_time);
fclose(fileID);

% Conversion of arrival dates from Gregorian calendar
% to modified Julian Day 2000.
date1_arrival = date2mjd2000(starting_arrival_time);
date2_arrival = date2mjd2000(final_arrival_time);

% Time of arrival window vectors in days and seconds.
t_arr = date1_arrival: 7 : date2_arrival ;
t_arr_sec = t_arr*86400;

% Time of fligth computation.
TOF_matrix = tof_calculator (t_dep,t_arr);

for q = 1: numel(TOF_matrix)
    if TOF_matrix(q) <= 0
        TOF_matrix(q) = nan;
    end
end

% Conversion of time of departure and arrival windows to Gregorian
% calendar dates (for plotting).
date_dep_window = zeros(length(t_dep),6);
date_arr_window = zeros(length(t_arr),6);

for k = 1 : length(t_dep)
    date_dep_window(k,:) = mjd20002date(t_dep(k));
end

for h = 1 : length(t_arr)
    date_arr_window(h,:) = mjd20002date(t_arr(h));
end

dep_window = datenum(date_dep_window);
arr_window = datenum(date_arr_window);


%% ORBITS COMPUTATION

% Departure orbit.
ibody_dep = 3;
[kep_dep,ksun] = uplanet(date1_departure, ibody_dep);
a_dep = kep_dep(1);
e_dep = kep_dep(2);
i_dep = kep_dep(3);
OMG_dep = kep_dep(4);
omg_dep = kep_dep(5);
theta_dep = kep_dep(6);

% Arrival orbit.
id_arr = 35;
[kep_arr, Mass_Florence, M_Florence] = ephNEO(date1_arrival,id_arr);
a_arr = kep_arr(1);
e_arr = kep_arr(2);
i_arr = kep_arr(3);
OMG_arr = kep_arr(4);
omg_arr = kep_arr(5);
theta_arr = kep_arr(6);

% Preallocation.
kep_dep_vect = zeros(length(t_dep),6);
kep_arr_vect = zeros(length(t_arr),6);
r_dep_vect = zeros(length(t_dep),3);
r_arr_vect = zeros(length(t_arr),3);
v_dep_vect = zeros(length(t_dep),3);
v_arr_vect = zeros(length(t_arr),3);

% Computation of position and velocity.
parfor i = 1 : length(t_dep)
    [kep_dep_vect(i,:),~] = uplanet(t_dep(i),ibody_dep);
    [r_dep_vect(i,:),v_dep_vect(i,:)] = kep2car(kep_dep_vect(i,:),ksun);
end

parfor i = 1 : length(t_arr)
    [kep_arr_vect(i,:),~,~] = ephNEO(t_arr(i),id_arr);
    [r_arr_vect(i,:),v_arr_vect(i,:)] = kep2car(kep_arr_vect(i,:),ksun);
end


%% MAIN ROUTINE

% Preallocation.
Dv_matrix = zeros(size(TOF_matrix));
v_inf_matrix = zeros(size(TOF_matrix));
error = zeros(size(TOF_matrix));

% Computation of the 2D-Tensor of deltav with two nested for cylcles
for i = 1 : length(t_dep)
    
    r_e = r_dep_vect(i,:);
    v_e = v_dep_vect(i,:);
    
    for j = 1 : length(t_arr)
        
        tof = TOF_matrix(i,j)*86400;
        
        if tof > 0
            r_f = r_arr_vect(j,:);
            v_f = v_arr_vect(j,:);
            [~,~,~,~,VI,VF,~,~] = lambertMR(r_e,r_f,tof,ksun);
            dv1 = norm(VI - v_e);
            dv2 = norm(v_f - VF);
            Dv_matrix(i,j) = abs(dv1) + abs(dv2);
            v_inf_matrix(i,j) = dv1;
        else
            Dv_matrix(i,j) = nan;
            v_inf_matrix(i,j) = nan;
        end
    end
end


for p = 1 : numel(Dv_matrix)
    if Dv_matrix(p) >= 100
        Dv_matrix(p) = nan;
    end
end

% Extraction of the minimum DV and the maximum DV.
Dv_min = min(min(Dv_matrix));
Dv_max = max(max(Dv_matrix));
fileID = fopen(filename,'a+');
fprintf(fileID,'[LOG] Mimimum DV found after optimization : %f\n',Dv_min);
fprintf(fileID,'[LOG] Maximum DV found after optimization : %f\n',Dv_max);
fclose(fileID);

% Maximum V infinity
v_inf_assigned = 5.8;
fileID = fopen(filename,'a+');
fprintf(fileID,'[LOG] Assigned C3 : %f\n',v_inf_assigned);
fclose(fileID);

if min(min(v_inf_matrix)) > v_inf_assigned
    warning ('The value of C3 Max is too small, automatically set C3 Max = C3 Max*2');
    v_inf_assigned = v_inf_assigned*2;
    fileID = fopen(filename,'a+');
    fprintf(fileID,'[LOG] The value of C3 Max is too small, automatically set C3 Max = C3 Max*2 = %f\n',v_inf_assigned);
    fclose(fileID);
end

for s = 1 : numel(v_inf_matrix)
    if v_inf_matrix(s) > v_inf_assigned
        v_inf_matrix(s) = nan;
    end
end


%% BEST TRANSFER ARC COMPUTATION

% Find minimum deltav position
[ROW,COLUMN] = find(Dv_matrix == Dv_min);
Dv_min_TOF = (TOF_matrix(ROW,COLUMN)*86400);

r1_arc = r_dep_vect(ROW,:);
r2_arc = r_arr_vect(COLUMN,:);
[~,~,~,~,v1_arc,v2_arc,~,~] = lambertMR(r1_arc,r2_arc,Dv_min_TOF,ksun);

[rx_arc, ry_arc, rz_arc, vx_arc, vy_arc, vz_arc] = intARC_lamb(r1_arc,...
    v1_arc,ksun,Dv_min_TOF,86400);


%%  SUB-OPTIMAL TRANSFER ARC COMPUTATION
%   for the nearest V infinity to V infinity assigned

v_inf_max = max(max(v_inf_matrix));
fileID = fopen(filename,'a+');
fprintf(fileID,'[LOG] Maximum V_infinity : %f\n',v_inf_max);
fclose(fileID);

[ROW_v_inf,COLUMN_v_inf] = find(v_inf_matrix == v_inf_max);
v_inf_TOF = (TOF_matrix(ROW_v_inf,COLUMN_v_inf)*86400);

r1_sub_arc = r_dep_vect(ROW_v_inf,:);
r2_sub_arc = r_arr_vect(COLUMN_v_inf,:);
[A,P,E,ERROR,v1_sub_arc,v2_sub_arc,TPAR,THETA] = lambertMR(r1_sub_arc,...
    r2_sub_arc,v_inf_TOF,ksun);

[rx_sub_arc, ry_sub_arc, rz_sub_arc, vx_sub_arc, vy_sub_arc, vz_sub_arc...
    ] = intARC_lamb(r1_sub_arc,v1_sub_arc,ksun,v_inf_TOF,86400);


%% HOHMANN TRANSFER FOR DELTAV COMPARISON

% Change of a and e whith an ohman transfer
[deltaV_a_t1,deltaV_a_t2,Tt_1,Tt_2,e_t1,e_t2,a_t1,a_t2]=homann(a_dep,e_dep,a_arr,e_arr,ksun);

% Change of inclination
[delta_v_inc,theta_1,omega_2]=inclinationchange(a_dep,e_dep,0.00001,OMG_dep,i_arr,OMG_arr,omg_dep,0,ksun);

% Change of w in order to adjust the shape of the orbit
[delta_v_w,theta_man,theta_after_man]= anoperichange(a_dep, e_dep, omega_2, omg_arr, theta_1, ksun);

% Total deltaV
delta_V_TOT = delta_v_inc + delta_v_w + deltaV_a_t1;

fileID = fopen(filename,'a+');
fprintf(fileID,'[LOG] Total DV required in the case of Hohmann transfer : %f\n',delta_V_TOT);
fclose(fileID);

%% PLOTTING
% Orbits
figure(1)
whitebg(figure(1), 'black')
hold on
grid on
axis equal
plotorbit(a_dep,e_dep,i_dep,OMG_dep,omg_dep,ksun,5);
plotorbit(a_arr,e_arr,i_arr,OMG_arr,omg_arr,ksun,4);
legend('Earth Orbit','Florence Orbit','Location', 'NorthWest')
title('Earth and Florence Orbits ')

% Optimal Arc
figure(2)
whitebg(figure(2), 'black')
hold on
grid on
axis equal
plotorbit(a_dep,e_dep,i_dep,OMG_dep,omg_dep,ksun,5);
plotorbit(a_arr,e_arr,i_arr,OMG_arr,omg_arr,ksun,4);
plot3(r1_arc(1),r1_arc(2),r1_arc(3),'b*')
plot3(r2_arc(1),r2_arc(2),r2_arc(3),'r*')
plot3(rx_arc, ry_arc, rz_arc,'y')
title('Best Transfer Arc')
legend('Earth Orbit','Florence Orbit','Earth Departure Position',...
    'Florence Arrival Position','Best Transfer Arc')

% Suboptimal Arc
figure(3)
whitebg(figure(3), 'black')
hold on
grid on
axis equal
plotorbit(a_dep,e_dep,i_dep,OMG_dep,omg_dep,ksun,5);
plotorbit(a_arr,e_arr,i_arr,OMG_arr,omg_arr,ksun,4);
plot3(r1_sub_arc(1),r1_sub_arc(2),r1_sub_arc(3),'w*')
plot3(r2_sub_arc(1),r2_sub_arc(2),r2_sub_arc(3),'m*')
plot3(rx_sub_arc, ry_sub_arc, rz_sub_arc,'g')
legend('Earth Orbit','Florence Orbit','Earth Departure Position',...
    'Florence Arrival Position','Suboptimal Transfer Arc')
title('Suboptimal Transfer Arc')

% Both of them
figure(4)
whitebg(figure(4), 'black')
hold on
grid on
axis equal
plotorbit(a_dep,e_dep,i_dep,OMG_dep,omg_dep,ksun,5);
plotorbit(a_arr,e_arr,i_arr,OMG_arr,omg_arr,ksun,4);

% Best transfer arc plot.
plot3(r1_arc(1),r1_arc(2),r1_arc(3),'b*')
plot3(r2_arc(1),r2_arc(2),r2_arc(3),'r*')
plot3(rx_arc, ry_arc, rz_arc,'y')

% V infinity nearest to assigned V infinity transfer arc plot
plot3(r1_sub_arc(1),r1_sub_arc(2),r1_sub_arc(3),'w*')
plot3(r2_sub_arc(1),r2_sub_arc(2),r2_sub_arc(3),'m*')
plot3(rx_sub_arc, ry_sub_arc, rz_sub_arc,'g')

legend('Earth Orbit','Florence Orbit','Earth Departure Position',...
    'Florence Arrival Position','Transfer arc',...
    'Earth sub-optimal departure','Florence sub-optimal arrival',...
    'Transfer arc for c3~c3_max', 'Location', 'NorthWest')

title('Best Transfer Arc against Suboptimal')

% Time of departure, Time of fligt, Delta v plot.
figure(5)
hold on
grid on
title('Pork chop plot');
xlabel('Time of departure');
ylabel('Time of Fligth');
zlabel('DeltaV')
plot3(t_dep_sec,TOF_matrix*86400,Dv_matrix);

% Pork chop plot contour.
figure(6)
hold on
grid on
title('Pork chop plot contour')
xlabel('Time of arrival');
ylabel('Time of departure');
axis equal
contour(t_arr,t_dep,Dv_matrix,50);
colormap jet
datetick('x','yy/mm/dd','keepticks','keeplimits')
datetick('y','yy/mm/dd','keepticks','keeplimits')
set(gca,'XTickLabelRotation',45)
set(gca,'YTickLabelRotation',45)

%  Pork chop plot DV,TOF.
figure(7)
hold on
grid on
title('Pork chop plot contour and TOF')
xlabel('Time of arrival');
ylabel('Time of departure');
axis equal
contour(t_arr,t_dep,Dv_matrix,50);
contour(t_arr,t_dep,TOF_matrix,20,'r','ShowText','on');
caxis([Dv_min Dv_max]);
colormap jet
datetick('x','yy/mm/dd','keepticks','keeplimits')
datetick('y','yy/mm/dd','keepticks','keeplimits')
set(gca,'XTickLabelRotation',45)
set(gca,'YTickLabelRotation',45)
clb = colorbar;
clb.Label.String = '\Delta V (km/s)';
clb.Label.FontSize = 11;

% Pork chop plot V infinity.
figure(8)
hold on
grid on
title('Pork chop plot V infinity')
xlabel('Time of arrivals');
ylabel('Time of departure');
axis equal
contour(t_arr,t_dep,Dv_matrix,50);
caxis([Dv_min Dv_max]);
colormap jet
contour(t_arr,t_dep,TOF_matrix,20,'r');
contour(t_arr,t_dep,v_inf_matrix,10,'ShowText','on')
datetick('x','yy/mm/dd','keepticks','keeplimits')
datetick('y','yy/mm/dd','keepticks','keeplimits')
set(gca,'XTickLabelRotation',45)
set(gca,'YTickLabelRotation',45)

% 3D Pork chop plot contour.
figure(9)
hold on
grid on
title('3D Pork chop plot')
xlabel('Time of arrivals');
ylabel('Time of departure');
zlabel('Delta V (km/s)')
%axis vis3d
% contour3(t_arr,t_dep,Dv_matrix,125);
caxis([Dv_min Dv_max]);
[X,Y]=meshgrid(t_arr(1:2:end),t_dep(1:2:end));
surface(X,Y,Dv_matrix(1:2:end,1:2:end));
datetick('x','yy/mm/dd','keepticks','keeplimits')
datetick('y','yy/mm/dd','keepticks','keeplimits')
% set(gca,'XTickLabelRotation',45)
% set(gca,'YTickLabelRotation',45)
