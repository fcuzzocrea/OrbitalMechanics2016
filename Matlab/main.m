% ESERCITAZIONE 1 - SPAZIO

clear all
close all 
clc

% Asse dei poli

l = 25000;
Z = zeros(l);
Z(:,3) = linspace(-l/2,l/2,l);

% IMPORTA I DATI TODO : MAT-FILE

	% Dati punto iniziale
		r_x_i = 6.48276760E+03;
		r_y_i = -1.36249110E+03;
		r_z_i = -1.19976370E+04;
		v_x_i = 2.5000E+00;
		v_y_i = 4.4130E+00;
		v_z_i = 4.5900E-01;
	% Dati punto finale
		a_f = 3.4410E+04;
		e_f = 2.1170E-01;
		i_f = 3.1040E+00;
		OMEGA_f = 2.1130E+00;
		omega_f = 6.0520E-01;
		theta_f = 1.7170E+00;

	% Costruisco i vettori colonna
	        r_i = [r_x_i; r_y_i; r_z_i];
                v_i = [v_x_i ; v_y_i ; v_z_i];
    
    	% Parametro mu terra
                mu_t = 398600;
	% Applico gli algoritmi per calcolarmi 
		% Calcolo i parametri orbiati per il punto iniziale
			[a_i,e_i,i_i,omega_i,OMEGA_i,theta_i] = pos2par(r_i,v_i,mu_t)
			e_i = norm(e_i);
		% Calcolo i vettori r,v per il punto finale
			[r_f,v_f] = par2pos(a_f,e_f,i_f,OMEGA_f,omega_f,theta_f,mu_t)

% Provo a fare il plot delle orbite
	% Calcolo posizioni iniziali e finali al variare di theta, da 0 a 360
		theta_deg = [1:1:360];
		theta_rad = theta_deg.*(2*pi)./360;
		% Preallocazione memoria
    		r_iniz = zeros(3,length(theta_deg));
    		r_fin = zeros(3,length(theta_deg));
     		v_iniz = zeros(3,length(theta_deg));
    		v_fin = zeros(3,length(theta_deg));

    		for k = 1:length(theta_deg)    
        		[r_iniz(:,k),v_iniz(:,k)] = par2pos(a_i,e_i,i_i,OMEGA_i,omega_i,theta_rad(k),mu_t);
        		[r_fin(:,k),v_fin(:,k)] = par2pos(a_f,e_f,i_f,OMEGA_f,omega_f,theta_rad(k),mu_t);
    
    		end  

    		plot3(r_iniz(1,:),r_iniz(2,:),r_iniz(3,:),'m',r_fin(1,:),r_fin(2,:),r_fin(3,:),'r','linewidth',2)
	% Plot Terra
    		RT = 6378;
    		load('topo.mat','topo','topomap1');
            hold on
            grid on

	% Crea la superficie
		[x,y,z] = sphere(50);
		x = x*RT;
		y = y*RT;
		z = z*RT;
		props.AmbientStrength = 0.1;
		props.DiffuseStrength = 1;
		props.SpecularColorReflectance = .5;
		props.SpecularExponent = 20;
		props.SpecularStrength = 1;
		props.FaceColor= 'texture';
		props.EdgeColor = 'none';
		props.FaceLighting = 'phong';
		props.Cdata = topo;
		eh=surface(x,y,z,props);

