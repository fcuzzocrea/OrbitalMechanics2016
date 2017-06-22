function[deltaV_a_t1,deltaV_a_t2,Tt_1,Tt_2,e_t1,e_t2,a_t1,a_t2]=homann(a1,e1,a2,e2,mu)

% hohmann.m
% 
% PROTOTYPE:
%   [deltaV_a_t1,deltaV_a_t2,Tt_1,Tt_2,e_t1,e_t2,a_t1,a_t2]=homann(a1,e1,a2,e2,mu)
%
% DESCRIPTION:
% 	This function implements the Hohmann transfer from a smaller orbit to a
% 	bigger one
%
% INPUT:
%	a_1[1]           Semimajoraxis first orbit
%   e_1[1]           Eccentricity first orbit
%	a_2[1]           Semimajoraxis second orbit
%   e_2[1]           Eccentricity second orbit
%   mu_p [1]
%
% OUTPUT:
%   delta_V_a_t1[1]        Delta V reguired in KM\s
%   delta_V_a_t2[1]        Delta V reguired in KM\s
%   Tt_1[1]                
%   Tt_2[1]
%   e_t1[1]
%   e_t2[1]
%   a_t1[1]
%   a_t2[1]
%
% AUTHOR:
%   Francescodario Cuzzocrea
%

p1=a1*(1-e1^2);
p2=a2*(1-e2^2);

rp1=p1/(1+e1);
ra1=p1/(1-e1);

rp2=p2/(1+e2);
ra2=p2/(1-e2);

va1=sqrt(mu/p1)*(1-e1);
vp1=sqrt(mu/p1)*(1+e1);

va2=sqrt(mu/p2)*(1-e2);
vp2=sqrt(mu/p2)*(1+e2);

% peric1-->apoc2
rp_t1=rp1;
ra_t1=ra2;

e_t1=(ra_t1-rp_t1)/(ra_t1+rp_t1);
p_t1=(2*rp_t1*ra_t1)/(ra_t1+rp_t1);
a_t1 = (ra_t1 + rp_t1)/2;

vp_t1=sqrt(mu/p_t1)*(1+e_t1);
va_t1=sqrt(mu/p_t1)*(1-e_t1);

deltaV1_t1=abs(vp_t1-vp1);
deltaV2_t1=(va2-va_t1);
deltaV_a_t1=deltaV1_t1+deltaV2_t1;

Tt_1=(pi/sqrt(mu))*a_t1^(3/2);
Tt_1=Tt_1/3600;

% apoc1-->peric2
if ra1<rp2
    rp_t2=ra1;
    ra_t2=rp2;
else 
    rp_t2=rp2;
    ra_t2=ra1;
end

e_t2=(ra_t2-rp_t2)/(ra_t2+rp_t2);
p_t2=(2*rp_t2*ra_t2)/(ra_t2+rp_t2);
a_t2 = (ra_t2 + rp_t2)/2;

vp_t2=sqrt(mu/p_t2)*(1+e_t2);
va_t2=sqrt(mu/p_t2)*(1-e_t2);

if ra1 < rp2
    deltaV1_t2=abs(vp_t2-va1);
    deltaV2_t2=abs(vp2- va_t2);
else 
    deltaV1_t2=abs(va_t2-va1);
    deltaV2_t2=abs(vp2-vp_t_2);
end

deltaV_a_t2=deltaV1_t2+deltaV2_t2;

Tt_2=(pi/sqrt(mu))*a_t2^(3/2);
Tt_2=Tt_2/3600;

end