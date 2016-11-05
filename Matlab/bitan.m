function [delta_V,delta_T] = bitan(a1,e1,a2,e2,delta_omega,choice,mu)
% Questa funzione esegue un trasferimento da un orbita con semiasse maggiore
% a1 ed eccentricità e1 ad un'orbita con semiasse maggiore a2 ed
% eccentrità e2. Viene utilizzato un trasferimento BITANGENTE

h = waitbar(0,'Computing times...');

if nargin == 6
    w = msgbox('Hai dimenticato mu, lo sto automaticamente settando a 398600');
    mu = 398600;
end

% Calcolo parametro p
p1 = a1*(1 - e1^2);
p2 = a2*(1 - e2^2);
    % Caclcolo raggi di pericentro ed apocentro
    r_per_1 = p1/(1+e1);
    r_apo_1 = p1/(1-e1);
    r_per_2 = p2/(1+e2);
    r_apo_2 = p2/(1-e2);

switch choice
    case 1
        % apocentro
        if delta_omega == 0
            delta_V1 = sqrt(2*mu*(1/r_per_1 - 1/(r_per_1 + r_apo_2))) - sqrt(2*mu*(1/r_per_1 - 1/(r_per_1 + r_apo_1)));
            delta_V2 = sqrt(2*mu*(1/r_apo_2 - 1/(r_per_2 + r_apo_2))) - sqrt(2*mu*(1/r_apo_2 - 1/(r_per_1 + r_apo_2)));
            delta_V = abs(delta_V1 + delta_V2);
            a_t = (r_per_1 + r_apo_2)/2;
            e_t = (r_apo_2 - r_per_1)/(r_per_1 + r_apo_2);
            delta_T = pi*a_t^(3/2)/sqrt(mu);              % Periodo orbita
        else
            if r_per_1 < r_per_2
               delta_V1 = sqrt(2*mu*(1/r_per_1 - 1/(r_per_1 + r_per_2))) - sqrt(2*mu*(1/r_per_1 - 1/(r_per_1 + r_apo_1)));
               delta_V2 = sqrt(2*mu*(1/r_apo_2 - 1/(r_per_2 + r_apo_2))) - sqrt(2*mu*(1/r_per_2 - 1/(r_per_1 + r_per_2))); 
               delta_V = abs(delta_V1 + delta_V2);
               a_t = (r_per_1 + r_apo_2)/2;
               e_t = (r_apo_2 - r_per_1)/(r_per_1 + r_apo_2);
               delta_T = pi*a_t^(3/2)/sqrt(mu);              % Periodo orbita 
            else
               delta_V1 = sqrt(2*mu*r_per_2/(r_per_1*(r_per_1+r_per_2))) - sqrt(2*mu*(1/r_per_1 - 1/(r_per_1 + r_apo_1)));
               delta_V2 = sqrt(2*mu*(1/r_apo_2 - 1/(r_per_2 + r_apo_2))) - sqrt(2*mu*r_per_1/(r_per_2*(r_per_1+r_per_2)));
               delta_V = abs(delta_V1 + delta_V2);
               a_t = (r_per_1 + r_apo_2)/2;
               e_t = (r_apo_2 - r_per_1)/(r_per_1 + r_apo_2);
               delta_T = pi*a_t^(3/2)/sqrt(mu);              % Periodo orbita
            end
        end
    case 2
        % Calcola al pericentro
        if delta_omega == 0
            if r_apo_1 < r_per_2
                delta_V1 = sqrt(2*mu*r_per_2/(r_apo_1*(r_apo_1+r_per_2))) - sqrt(2*mu*(1/r_per_1 - 1/(r_per_1 + r_apo_1)));
                delta_V2 = sqrt(2*mu*(1/r_apo_2 - 1/(r_per_2 + r_apo_2))) - sqrt(2*mu*r_apo_1/(r_per_2*(r_apo_1+r_per_2)));
                delta_V = abs(delta_V1 + delta_V2);
                a_t = (r_apo_1 + r_per_2)/2;
                e_t = (r_per_2 - r_apo_1)/(r_apo_1 + r_per_2);
                rp_t = a_t*(1-e_t)
                ra_t = a_t*(1+e_t)
                delta_T = pi*a_t^(3/2)/sqrt(mu);   % Periodo orbita
            else
                delta_V1 = sqrt(2*mu*r_per_2/(r_apo_1*(r_apo_1+r_per_2))) - sqrt(2*mu*(1/r_per_1 - 1/(r_per_1 + r_apo_1)));
                delta_V2 = sqrt(2*mu*(1/r_apo_2 - 1/(r_per_2 + r_apo_2))) - sqrt(2*mu*r_apo_1/(r_per_2*(r_apo_1+r_per_2)));
                delta_V = abs(delta_V1 + delta_V2); 
                a_t = (r_apo_1 + r_per_2)/2;
                e_t = (r_apo_1 - r_per_2)/(r_apo_1 + r_per_2);
                delta_T = pi*a_t^(3/2)/sqrt(mu);  % Periodo orbita
            end
        else
            delta_V1 = sqrt(2*mu*r_apo_2/(r_apo_1*(r_apo_1+r_apo_2))) - sqrt(2*mu*(1/r_per_1 - 1/(r_per_1 + r_apo_1)));
            delta_V2 = sqrt(2*mu*(1/r_apo_2 - 1/(r_per_2 + r_apo_2))) - sqrt(2*mu*r_apo_1/(r_apo_2*(r_apo_1+r_apo_2)));
            delta_V = abs(delta_V1 + delta_V2); 
            a_t = (r_apo_1 + r_apo_2)/2;
            e_t = (r_apo_2 - r_apo_1)/(r_apo_1 + r_apo_2);
            delta_T = pi*a_t^(3/2)/sqrt(mu);     % Periodo orbita
        end
    otherwise       
        error('Non mi hai fornito il punto in cui effettuare la manovra')
end 
close(h);
end


        