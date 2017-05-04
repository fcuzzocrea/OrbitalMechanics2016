function [DV_MIN, Dv_min_TOF_1, Dv_min_TOF_2, r1_arc, r2_arc, r3_arc, v_saturn, t_saturn, dv_ga] = Flyby_GA(ga_it)

if ga_it
    ObjectiveFunction = @dv_optimizator;
    nvars = 3;    % Number of variables
    A = [1, -1, 0; 0 , 1, -1];
    b = [0; 0];
    LB = 5844*[1 1.1 1.2];
    UB = 20044*[1 1 1];
    vect_t(ga_it,3) = 0;
    vect_dv(ga_it) = 0;
    options = optimoptions('ga','Display','off');
    
    parfor i = 1:ga_it
        [t, dv_val] = ga(ObjectiveFunction,nvars,A,b,[],[],LB,UB,[],options);
        vect_t(i,:) = t;
        vect_dv(i) = dv_val;
    end
    
    DV_MIN = min(vect_dv);
    T_DV_MIN = vect_t(vect_dv == DV_MIN,:);
else
    T_DV_MIN = 1e4*[0.649799190637866, 0.834549018712001, 2.004399559036041];
end

[DV_MIN, r1_arc, r2_arc, r3_arc, v_saturn, dv_ga] = dv_optimizator(T_DV_MIN);
Dv_min_TOF_1 = (T_DV_MIN(2)-T_DV_MIN(1))*86400;
Dv_min_TOF_2 = (T_DV_MIN(3)-T_DV_MIN(2))*86400;
t_saturn = T_DV_MIN(2);

end