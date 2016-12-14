%% Florance_express.

clear 
close all
clc


%% -------------------------- Time settings -----------------------------

% First and last departure dates.

starting_departure_time = [2024 3 1 12 0 0];
final_departure_time = [2027 1 1 12 0 0];

% Conversion departure Gregorian calendar dates to modify Julian dates 2000.

date1_departure = date2mjd2000(starting_departure_time);
date2_departure = date2mjd2000(final_departure_time);

% Time departures window vectors in days and seconds.

t_dep = date1_departure : 7 : date2_departure ;
t_dep_sec = t_dep*86400;



% First and last arrival dates.

starting_arrival_time = [2024 11 1 12 0 0];
final_arrival_time = [2029 6 1 12 0 0];

% Conversion arrival Gregorian calendar dates to modify Julian dates 2000.

date1_arrival = date2mjd2000(starting_arrival_time);
date2_arrival = date2mjd2000(final_arrival_time);

% Time arrivals window vectors in days and seconds.

t_arr = date1_arrival: 7 : date2_arrival ;
t_arr_sec = t_arr*86400;

% Time of fligth computation. 

[TOF] = tof_calculator (t_dep,t_arr);

for q = 1: length(TOF)
    if TOF(q) <= 0
        TOF(q) = nan;
    end
end

TOF_matrix = reshape(TOF,[length(t_arr),length(t_dep)]); 
TOF_matrix = TOF_matrix';

% Definition of time departures and arrivals and windows.

date_dep_window = [];
date_arr_window = [];

for k = 1 : length(t_dep)
    date_dep = mjd20002date(t_dep(k));
    date_dep_window = [date_dep_window; date_dep];
end

for h = 1 : length(t_arr)
    date_arr = mjd20002date(t_arr(h));
    date_arr_window = [date_arr_window; date_arr];
end

dep_window = datenum(date_dep_window(:,1),date_dep_window(:,2),date_dep_window(:,3));
arr_window = datenum(date_arr_window(:,1),date_arr_window(:,2),date_arr_window(:,3));


%% ---------- Orbit of departure computation from ephemerides ------------

% Departure orbit.

ibody_dep = 3;

[kep_dep,ksun] = uplanet(date1_departure, ibody_dep);

a_dep = kep_dep(1);
e_dep = kep_dep(2);
i_dep = kep_dep(3);
OMG_dep = kep_dep(4);
omg_dep = kep_dep(5);
theta_dep = kep_dep(6);
 
% Arrival orbit

id_arr = 35;
[kep_arr, Mass_Florence, M_Florence] = ephNEO(date1_arrival,id_arr);

a_arr = kep_arr(1);
e_arr = kep_arr(2);
i_arr = kep_arr(3);
OMG_arr = kep_arr(4);
omg_arr = kep_arr(5);
theta_arr = kep_arr(6);



%% -------- Computation of DV from Lambert for the pork chop plot --------

% Preallocation.

Dv_vect = [];
r1 = [];
r2 = [];
v_inf_vect =[];

% Computation of DV with two for cylcle.

for i = 1 : length(t_dep)
    date1 = t_dep(i);
    [kep_e,ksun] = uplanet(date1, 3);
    [r_e,v_e]=kep2car(kep_e,ksun);
    t1 = t_dep(i);
    
    parfor j = 1 : length(t_arr)
        date2 = t_arr(j);
        [kep_f, Mass_Florence, M_Florence] = ephNEO(date2,35);  
        [r_f,v_f]=kep2car(kep_f,ksun);
        tof = (t_arr(j) - t1)*86400;
        
        if tof > 0
            [A,P,E,ERROR,VI,VF,TPAR,THETA] = lambertMR(r_e,r_f,tof,ksun);
            dv1 = norm(VI' - v_e);
            dv2 = norm(v_f - VF');
            dv_tot = abs(dv1) + abs(dv2);
            v_inf = (norm(v_e - VI'));     
        else
            dv_tot = nan;
            v_inf = nan;
        end
        
        if i == length(t_dep)
            r2 = [r2 r_f];
        end
        
        Dv_vect = [Dv_vect dv_tot];
        v_inf_vect = [v_inf_vect v_inf];
    end
    r1 =[r1 r_e];
end

r1 = r1';
r2 = r2';



%% ----------------------- DV matrix definition -------------------------

for p = 1 : length(Dv_vect)
    if Dv_vect(p) >= 100;
        Dv_vect(p) = nan;
    end
end


Dv_matrix = reshape(Dv_vect,[length(t_arr),length(t_dep)]); 
Dv_matrix = Dv_matrix';

% Extraction of the minimum DV and the maximum DV.

Dv_min = min(min(Dv_matrix));
Dv_max = max(max(Dv_matrix));



%% -------------------------------- C3 -----------------------------------

v_inf_max = 5.8;

if min(v_inf_vect) > v_inf_max
    warning ('The value of C3 Max is too small, automatically set C3 Max = C3 Max*2');
    v_inf_max =v_inf_max*2;
end

for s = 1 : length(v_inf_vect)
    if v_inf_vect(s) > (v_inf_max)
       v_inf_vect(s) = nan;
    end
end

 
v_inf_matrix = reshape(v_inf_vect,[length(t_arr),length(t_dep)]); 
v_inf_matrix = v_inf_matrix';



%% ------------------- Best transfer arc computation ---------------------

[ROW,COLUMN] =find(Dv_matrix == Dv_min);
Dv_min_TOF = (TOF_matrix(ROW,COLUMN)*86400);

r1_arc = r1(ROW,:);
r2_arc = r2(COLUMN,:);
[A,P,E,ERROR,v1_arc,v2_arc,TPAR,THETA] = lambertMR(r1_arc,r2_arc,Dv_min_TOF,ksun);

[rx_arc, ry_arc, rz_arc, vx_arc, vy_arc, vz_arc] = intARC_lamb(r1_arc,v1_arc,ksun,Dv_min_TOF,86400);



%% ----- Computation of sub-optimal transfer arc for the minimun C3 ------

v_inf_min = min(min(v_inf_matrix));
[ROW_v_inf_min,COLUMN_v_inf_min] =find(v_inf_matrix == v_inf_min);
v_inf_min_TOF = (TOF_matrix(ROW_v_inf_min,COLUMN_v_inf_min)*86400);

r1_sub_arc = r1(ROW_v_inf_min,:);
r2_sub_arc = r2(COLUMN_v_inf_min,:);
[A,P,E,ERROR,v1_sub_arc,v2_sub_arc,TPAR,THETA] = lambertMR(r1_sub_arc,r2_sub_arc,v_inf_min_TOF,ksun);

[rx_sub_arc, ry_sub_arc, rz_sub_arc, vx_sub_arc, vy_sub_arc, vz_sub_arc] = intARC_lamb(r1_sub_arc,v1_sub_arc,ksun,v_inf_min_TOF,86400);


%% ---------------------------- Plotting ---------------------------------

% Orbits plot.

figure(1)
whitebg(figure(1), 'black')
hold on
grid on
axis equal
title('Orbits and best transfer arc rapresentation ')
plotorbit(a_dep,e_dep,i_dep,OMG_dep,omg_dep,ksun,5);
plotorbit(a_arr,e_arr,i_arr,OMG_arr,omg_arr,ksun,4);

% Best transfer arc plot.

plot3(r1_arc(1),r1_arc(2),r1_arc(3),'b*')
plot3(r2_arc(1),r2_arc(2),r2_arc(3),'r*')
plot3(rx_arc, ry_arc, rz_arc,'y')

% Sub-optimal transfer arc plot

plot3(r1_sub_arc(1),r1_sub_arc(2),r1_sub_arc(3),'w*')
plot3(r2_sub_arc(1),r2_sub_arc(2),r2_sub_arc(3),'m*')
plot3(rx_sub_arc, ry_sub_arc, rz_sub_arc,'g')

legend('Earth Orbit','Florence Orbit','Earth Departure Position','Florence Arrival Position','Transfer arc',...
    'Earth sub-optimal departure','Florence sub-optimal arrival','Sub-optimal transfer arc', 'Location', 'NorthWest')

% Time of departure, Time of fligt, Delta v plot. 

figure(2)
hold on
grid on
title('Pork chop plot');
xlabel('Time of departure');
ylabel('Time of Fligth');
zlabel('DeltaV')

plot3(t_dep_sec,TOF_matrix*86400,Dv_matrix);

% Pork chop plot contour. 
figure(3)
hold on
grid on
title('Pork chop plot contour')
xlabel('Time of arrivals');
ylabel('Time of departure');
axis equal

contour(t_arr,t_dep,Dv_matrix,50);
caxis([10 80]);
colormap jet

datetick('x','yy/mm/dd')
datetick('y','yy/mm/dd')

%  Pork chop plot DV,TOF.

figure(4)
hold on
grid on
title('Pork chop plot contour and TOF')
xlabel('Time of arrivals');
ylabel('Time of departure');
axis equal

contour(t_arr,t_dep,Dv_matrix,50);
caxis([10 80]);
colormap jet
contour(t_arr,t_dep,TOF_matrix,20,'r','ShowText','on');

datetick('x','yy/mm/dd')
datetick('y','yy/mm/dd')

% Pork chop plot V infinity.

figure(5)
hold on
grid on
title('Pork chop plot V infinity')
xlabel('Time of arrivals');
ylabel('Time of departure');
axis equal

contour(t_arr,t_dep,Dv_matrix,50);
caxis([10 80]);
colormap jet
contour(t_arr,t_dep,TOF_matrix,20,'r');
contour(t_arr,t_dep,v_inf_matrix,10,'ShowText','on')

datetick('x','yy/mm/dd')
datetick('y','yy/mm/dd')

% 3D Pork chop plot contour.

figure(6)
hold on
grid on
title('3D Pork chop plot')
xlabel('Time of arrivals');
ylabel('Time of departure');
zlabel('Delta V')
axis equal

contour3(t_arr,t_dep,Dv_matrix,125);
caxis([10 80]);
[X,Y]=meshgrid(t_arr,t_dep);
surface(X,Y,Dv_matrix); 

datetick('x','yy/mm/dd')
datetick('y','yy/mm/dd')



