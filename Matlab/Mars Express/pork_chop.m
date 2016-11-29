function [DV_vect, DV_min, DV_max, V_I, V_F] = pork_chop(r1_vect, r2_vect, v1_vect, v2_vect, t1_vect, t2_vect, mu)


%% This function solve the Lambert's problem for each possible transfer arcs in the time window assigned


%% Preallocation 


V_I = [];
V_F = [];
dv1_vect = [];
dv2_vect = [];
DV_vect = [];
dv1 = [];
dv2 = [];


%% Computation of initial and final velocity of all arcs


for k = 1 : length(r1_vect)
    r = r1_vect(k,:);
    t1 = t1_vect(k);
    
    for j = 1 : length(r2_vect);
        tof = t2_vect(j) - t1;
        [A,P,E,ERROR,VI,VF,TPAR,THETA] = lambertMR(r,r2_vect(j,:),tof,mu);
        V_I = [V_I; VI];
        V_F = [V_F; VF];
     end
end




%% Delta V computation and evaluation of max and min


 for i = 1 : length(v1_vect)
     v1 = v1_vect(i,:);
     for j = 1 : length(v2_vect)
         dv_1 = V_I(j,:) - v1;
         dv1_vect = [dv1_vect; dv_1];
         dv1_n = norm(dv1_vect(j,:));
         dv1 = [dv1; dv1_n];
     end
     j = j + length(v2_vect);  
 end
  
 for i = 1 : length(v2_vect)
     v2 = v2_vect(i,:);
     for j = 1 : length(v1_vect)
         dv_2 = v2 - V_F(j,:);
         dv2_vect = [dv2_vect; dv_2];
         dv2_n = norm(dv2_vect(j,:));
         dv2 = [dv2; dv2_n];
     end
     j = j + length(v1_vect);
 end
 
for i = 1 : length(dv1)
    dv_tot = abs(dv1(i))+abs(dv2(i)); 
    DV_vect = [DV_vect dv_tot];
end


DV_min = min(min(DV_vect));
DV_max = max(max(DV_vect)); 
