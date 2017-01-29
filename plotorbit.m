function []= plotorbit(a,e,i,OMG,omg,mu,color_orbit)
%
% plotorbit.m 
% 
% PROTOTYPE:
%     []= plotorbit(a,e,i,OMG,omg,mu,color_orbit)
% 
% DESCRIPTION:
%     This function plot the orbit computed after using kep2car to obtain the position vector.
%
% INPUT:
%     a[1]               Semimajor axis
%     e[1]               Eccentricity
%     i[1]               Inclination
%     OMG[1]             Right Ascension
%     omg[1]             Pericenter Anomaly
%     mu[1]              Planetary Constant
%     color_orbit[1]     Color selection :
%                                         color_orbit = 1   - blue
%                                         color_orbit = 2   - green
%                                         color_orbit = 3   - yellow
%                                         color_orbit = 4   - red
%                                         color_orbit = 5   - magenta
%                                         color_orbit = 6   - cyan
%                                         color_orbit = 7   - black
%                                         color_orbit = 8   - white
%
% OUTPUT:
%     Plotting of the orbit 
%
% AUTHOR:
%     Alfonso Collogrosso


% Definition of true anomaly  
theta_deg = 0:360;
theta = theta_deg.*(2*pi)./360;
r = zeros(3,length(theta_deg));
v = zeros(3,length(theta_deg));

% Evaluation of all position vector of the orbit
for k = 1:length(theta_deg)
    kep = [a, e, i, OMG, omg, theta(k)];
    [r(:,k),v(:,k)]=kep2car(kep,mu);
end

% Definition of vector for plotting
rx=r(1,:);
ry=r(2,:);
rz=r(3,:);

% Plotting

whitebg(gcf, 'black')
grid on
title('Orbits rapresentation')

if (color_orbit == 1)
    plot3(rx,ry,rz,'b--','lineWidth',1.5);
elseif (color_orbit == 2)
        plot3(rx,ry,rz,'g--','lineWidth',1.5);
elseif (color_orbit == 3)
        plot3(rx,ry,rz,'y--','lineWidth',1.5);
elseif (color_orbit == 4)
        plot3(rx,ry,rz,'r--','lineWidth',1.5);
elseif (color_orbit == 5)
        plot3(rx,ry,rz,'c--','lineWidth',1.5);
elseif (color_orbit == 6)
        plot3(rx,ry,rz,'m--','lineWidth',1.5);
elseif (color_orbit == 7)
        plot3(rx,ry,rz,'k--','lineWidth',1.5);
elseif (color_orbit == 8)
        plot3(rx,ry,rz,'w--','lineWidth',1.5);
end

end
