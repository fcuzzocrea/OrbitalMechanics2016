function []= plotorbit(a,e,i,OMG,omg,mu,color_orbit)
%% This Script plot the orbit calculatede after using kep2car to obtain the position vector.

% Input
% a              - semimajor axis
% e              - eccentricity
% i              - inclination
% OMG            - right ascension
% omg            - pericenter anomaly
% mu             - planetary constant
% color_orbit    - Color orbit selection
                    % color_orbit = 1   - blue
                    % color_orbit = 2   - green
                    % color_orbit = 3   - yellow
                    % color_orbit = 4   - red
                    % color_orbit = 5   - magenta
                    % color_orbit = 6   - cyan
                    % color_orbit = 7   - black
                    % color_orbit = 8   - white


% Definition of true anomaly  
theta_deg =[0:1:360];
theta = theta_deg.*(2*pi)./360;
r = zeros(3,length(theta_deg));
v = zeros(3,length(theta_deg));

% Evaluation of all position vector of the orbit
for k = 1:length(theta_deg)
    [r(:,k),v(:,k)]=kep2car(a,e,i,OMG,omg,theta(k),mu);
end

% Definition of vector for plotting
rx=r(1,:);
ry=r(2,:);
rz=r(3,:);

% Plotting

figure(1)
whitebg(figure(1), 'black')
hold on
grid on
title('Orbits rapresentation')

if (color_orbit == 1)
    plot3(rx,ry,rz,'b--','lineWidth',1.5);
else if (color_orbit == 2)
        plot3(rx,ry,rz,'g--','lineWidth',1.5);
else if (color_orbit == 3)
        plot3(rx,ry,rz,'y--','lineWidth',1.5);
else if (color_orbit == 4)
        plot3(rx,ry,rz,'r--','lineWidth',1.5);
else if (color_orbit == 5)
        plot3(rx,ry,rz,'c--','lineWidth',1.5);
else if (color_orbit == 6)
        plot3(rx,ry,rz,'m--','lineWidth',1.5);
else if (color_orbit == 7)
        plot3(rx,ry,rz,'k--','lineWidth',1.5);
else if (color_orbit == 8)
        plot3(rx,ry,rz,'w--','lineWidth',1.5);
    end
    end
    end
    end
    end
    end
    end
end
%% SUN Plotting 
 
  SUN = imread('Sun.png','png');
  R_SUN = 695700;
  props.FaceColor='texture';
  props.EdgeColor='none';
  props.FaceLighting='phong';
  props.Cdata = SUN;
  Center = [0; 0; 0];
  [XX, YY, ZZ] = ellipsoid(Center(1),Center(2),Center(3),R_SUN,R_SUN,R_SUN,30);
  surface(-XX, -YY, -ZZ,props);

end

          
