function [delta_v,theta_1,omega_2]=inclinationchange(a,e,i_1,OMEGA_1,i_2,OMEGA_2,omega_1,point,mu)

%
% OUTPUT :
% 
% delta_v             delta_v
% theta_1			  true anomaly when the manouver start
% omega_2			  pericenter anomaly at the end of the manouver


% Compute delta i and delta_OMEGA

delta_i = i_2 - i_1;
delta_OMEGA = OMEGA_2 - OMEGA_1;

% Whe need to know in wich case we are for sine therem
delta_check = delta_i*delta_OMEGA;

% Compute alpha by cosine theorem (colombo)
%
% 	 cos(alpha) = sin(beta)*sin(gamma)*cos(a) - cos(beta)*cos(gamma)
% 

cos_alpha = sin(i_1)*sin(i_2)*cos(delta_OMEGA) + cos(i_1)*cos(i_2);
alpha = acos(cos_alpha);

% We compute u1 e u2

if delta_check > 0
	    cos_u_1 = (cos(i_1)*cos(alpha) - cos(i_2)) / (sin(i_1)*sin(alpha));   % NaN
	    cos_u_2 = (cos(i_1) - cos(i_2)*cos(alpha)) / (sin(i_2)*sin(alpha));	
else
	    cos_u_1 = (cos(i_2) - cos(alpha)*cos(i_1)) / (sin(alpha)*sin(i_1));
    	cos_u_2 = (cos(alpha)*cos(i_2) - cos(i_1)) / (sin(alpha)*sin(i_2));
end


sin_u_1 = sin(i_2)*(sin(delta_OMEGA)/sin(alpha));
sin_u_2 = sin(i_1)*(sin(delta_OMEGA)/sin(alpha));

u_1 = atan2(sin_u_1,cos_u_1);
u_2 = atan2(sin_u_2,cos_u_2);


% Compute theta and omega_2

switch point
    case 0
        if delta_check >  0
            theta_1 = u_1 - omega_1;
            omega_2 = u_2 - theta_1;
        else
            theta_1 = 2*pi - (omega_1 + u_1);
            omega_2 = 2*pi - u_2 - theta_1;
        end
        
        p = a*(1 - e^2);
               
        v_theta = sqrt(mu/p)*(1 + e*cos(theta_1));
        delta_v = 2*v_theta*sin(alpha/2);
    case 1       
        if delta_check >  0
            theta_1 = u_1 - omega_1 + pi;
            omega_2 = u_2 - theta_1;
        else
            theta_1 = 2*pi - (omega_1 + u_1) + pi;
            omega_2 = 2*pi - u_2 - theta_1;
        end
        
        p = a*(1 - e^2);
        
        v_theta = sqrt(mu/p)*(1 + e*cos(theta_1));
        delta_v = 2*v_theta*sin(alpha/2);
end
        
if theta_1 < 0
    theta_1 = theta_1 + 2*pi;
end

end
