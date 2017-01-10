function [deltaV_cp_1,deltaV_cp_2,w_2_1,w_2_2,teta_manovra1,teta_manovra2]=planechange(a1,e1,i1,omega1,w1,i2,omega2,mu)

deltaomega=omega2-omega1;
deltai=i2-i1;

alfa=acos(sin(i1)*sin(i2)*cos(deltaomega)+cos(i1)*cos(i2));

if deltaomega*deltai>0
    cosu1=(cos(i1)*cos(alfa)-cos(i2))/(sin(i1)*sin(alfa));
    sinu1=(sin(deltaomega)*sin(i2))/sin(alfa);
    u1=atan2(sinu1,cosu1);
    cosu2=(cos(i1)-cos(i2)*cos(alfa))/(sin(i2)*sin(alfa));
    sinu2=(sin(i1)*sin(deltaomega))/sin(alfa);
    u2=atan2(sinu2,cosu2);
   
    teta_manovra1=u1-w1;
    teta_manovra2=teta_manovra1+pi;
    
    w_2_1=u2-teta_manovra1;
    w_2_2=u2-teta_manovra2;
    
else
    cosu1=(-cos(i1)*cos(alfa)+cos(i2))/(sin(i1)*sin(alfa));
    sinu1=(sin(deltaomega)*sin(i2))/sin(alfa);
    u1=atan2(sinu1,cosu1);
    cosu2=(-cos(i1)+cos(i2)*cos(alfa))/(sin(i2)*sin(alfa));
    sinu2=(sin(i1)*sin(deltaomega))/sin(lafa);
    u2=atan2(sinu2,cosu2);
    
    teta_manovra1=2*pi-w1-u1;
    teta_manovra2=teta_manovra1+pi;
    
    w_2_1=2*pi-u2-teta_manovra1;
    w_2_2=2*pi-u2-teta_manovra2;
    
end

if teta_manovra1<0
    teta_manovra1=teta_manovra1+2*pi;
end
if teta_manovra2<0
    teta_manovra2=teta_manovra2+2*pi;
end
if w_2_1<0
    w_2_1=w_2_1+2*pi;
end
if w_2_2<0
    w_2_2=w_2_2+2*pi;
end

    p=a1*(1-e1^2);
    v_teta1=sqrt(mu/p)*(1+e1*cos(teta_manovra1));
    deltaV_cp_1=2*v_teta1*sin(alfa/2);
    v_teta2=sqrt(mu/p)*(1+e1*cos(teta_manovra2));
    deltaV_cp_2=2*v_teta2*sin(alfa/2);
end