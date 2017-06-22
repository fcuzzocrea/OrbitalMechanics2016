function dv = powerflyby(v_inf_min,v_inf_plus,k)

% powerflyby.m 
% 
% PROTOTYPE:
%   dv = powerflyby(v_inf_min,v_inf_plus,k)
%
% DESCRIPTION:
% 	 This function give the perturbed dynamics orbit equations
%    
% INPUT:
%   v_inf_min              Infinite velocity minus
%   v_inf_plus             Infinite velocity plus
%   k                      Saturn Gravitational constant
% 
% OUTPUT:
%   [dv]                   Delta velocity obtained by the powered flyby
%
% AUTHOR:
%    Benedetto Lui
%    Francescodario Cuzzocrea
%

delta = acos(dot(v_inf_min,v_inf_plus)/(norm(v_inf_min)*norm(v_inf_plus)));

f = @(r_p) delta - asin(1./(1+(r_p*norm(v_inf_min)^2/k))) - asin(1./(1+(r_p*norm(v_inf_plus)^2/k)));
try
    r_p = fzero(f,[1e5 1e9]);
catch err
    if (strcmp(err.identifier,'MATLAB:fzero:ValuesAtEndPtsSameSign'))
        dv = nan;
        return
    elseif (strcmp(err.identifier,'MATLAB:fzero:ValuesAtEndPtsComplexOrNotFinite'))
        dv = nan;
        return
    else
        rethrow(err)
    end
end

DELTA_min = r_p*sqrt(1 + 2*(k/(r_p*norm(v_inf_min)^2)));
DELTA_plus = r_p*sqrt(1 + 2*(k/(r_p*norm(v_inf_plus)^2)));

vp_min = (DELTA_min*norm(v_inf_min))/(r_p);
vp_plus = (DELTA_plus*norm(v_inf_plus))/(r_p);

dv = abs(vp_plus - vp_min);

end