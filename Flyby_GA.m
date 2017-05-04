function [DV_MIN, r1_arc, r2_arc, r3_arc, v_saturn, t_saturn] = Flyby_GA(ga_it)

if ga_it
    ObjectiveFunction = @dv_optimizator;
    nvars = 3;    % Number of variables
    A = [1, -1, 0; 0 , 1, -1];
    b = [0; 0];
    LB = 5844*[1 1.1 1.2];
    UB = 20044*[1 1 1];
    vectx(ga_it,3) = 0;
    options = optimoptions('ga','Display','off');
    
    parfor i = 1:ga_it
        x = ga(ObjectiveFunction,nvars,A,b,[],[],LB,UB,[],options);
        vectx(i,:) = x;
    end

    x_MIN = min(vectx);
else
    x_MIN = 1e4*[0.649799190637866, 0.834549018712001, 2.004399559036041];
end

[DV_MIN, r1_arc, r2_arc, r3_arc, v_saturn] = dv_optimizator(x_MIN);
t_saturn = x_MIN(2);

end