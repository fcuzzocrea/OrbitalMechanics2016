function [kep,mass,M] = ephNEO(time,id)

% ephNEO.m - Ephemerides of Near Earth Objects
%
% PROTOTYPE:
%	[kep, mass, M] = ephNEO(time, id)
%
% DESCRIPTION:
%   This function returns the orbital parameters, the mass, and the mean
%   anomaly of some NEOs. Each NEO is identified by an id.
%
% INPUT:
%   time[1]     MJD2000 [d].
%   id[1]       NEO identifier. It is a number starting from 12 (because
%               the identifiers from 1 to 11 are reserved for the Solar
%               System).
%
% OUTPUT:
%   kep[1,6]    Keplerian parameters. It is a 6 entry vector:
%               [a e i Om om wom] where:
%                   a is the semimajor axis [km];
%                   e is the eccentricity;
%                   i is the inclination [rad];
%                   Om is the anomaly of the ascending node [rad];
%                   om is the anomaly of the pericentre [rad];
%                   wom is the true anomaly (from the pericentre) [rad].
%   mass        Mass of the NEO [kg]. It can be read from the database, or,
%               if not available, estimated by an approximate equation.
%   M           Mean anomaly at time [rad].
% 
% CALLED FUNCTIONS:
%   astroConstants
%
% AUTHOR:
%   Paolo De Pascale,  November 2004, MATLAB, ephNEO.m
%
% PREVIOUS VERSION:
%   Paolo De Pascale,  November 2004, MATLAB, NeoEphemeris.m
%       - Header and function name in accordance with guidlines.
%
% CHANGELOG:
%   20/06/2006, Christie Maddock, Camilla Colombo, Pau Sanchez
%   20/06/2006, Matteo Ceriotti: Ccleaned up code, added references to
%       astro_constants.
% 	07/07/2006, Pau Sanchez: Added data on more NEOs.
%   25/08/2006, Pau Sanchez: Added data on more NEOs.
% 	12/02/2007, Pau Sanchez: Modified mass Itokawa from 6.01e10 kg to
%       3.51e10 kg - updated from papers.
% 	16/05/2007, Camilla Colombo: added new PHO form Paolo and Max database
%                      Note for Paolo and Max: id = 57 to 72 of your
%                      code is here id 68 to 83.
% 	07/06/2008, Camilla Colombo: added 2002AA29.
%   04/10/2010, Camilla Colombo: Header and function name in accordance
%       with guidlines.
%   12/11/2012, Camilla Colombo: Added body 85 for SysNova.
%   13/03/2013, Michele Stramacchia: Added body 88 etc.
%
% -------------------------------------------------------------------------

id=round(id)-11;
neo = zeros(84,9);

% to UPDATE use this layout:
% %   name, class
% neo(id,1)=semimajor axis [AU]     neo(id,2)=eccentricity
% neo(id,3)=inclination [deg]     neo(id,4)=asc. node/raan [deg]
% neo(id,5)=arg. perigee [deg]     neo(id,6)=mean anomoly, M at time given in neo(id,8) [deg]
% neo(id,7)=abs magnitude (i.e. intrinsic brightness)     neo(id,8)=time at which Mo is given [MJD]   neo(id,9)=mass [kg]

%   Apollo Apollo
neo(1,1)=1.471;     neo(1,2)=0.56;
neo(1,3)=6.4;       neo(1,4)=35.9;
neo(1,5)=285.7;     neo(1,6)=40.5;
%   Nereus Apollo
neo(2,1)=1.489;     neo(2,2)=0.360;
neo(2,3)=1.4;       neo(2,4)=314.6;
neo(2,5)=157.9;     neo(2,6)=60.7;
%   Toutatis Apollo
neo(3,1)=2.51;      neo(3,2)=0.634;
neo(3,3)=0.5;       neo(3,4)=128.2;
neo(3,5)=274.8;     neo(3,6)=135.8;
%   Adonis Apollo
neo(4,1)=1.874;     neo(4,2)=0.765;
neo(4,3)=1.3;       neo(4,4)=350.6;
neo(4,5)=42.4;      neo(4,6)=321.5;
%   Hermes Apollo
neo(5,1)=1.639;     neo(5,2)=0.624;
neo(5,3)=6.1;       neo(5,4)=34.7;
neo(5,5)=91.9;      neo(5,6)=335.6;
%   Oljato Apollo
neo(6,1)=2.172;     neo(6,2)=0.713;
neo(6,3)=2.5;       neo(6,4)=76.6;
neo(6,5)=96.2;      neo(6,6)=334.1;
%   Icarus Apollo
neo(7,1)=1.078;     neo(7,2)=0.827;
neo(7,3)=22.9;      neo(7,4)=88.1;
neo(7,5)=31.3;      neo(7,6)=139.9;
%   Geographos 
neo(8,1)=1.246;     neo(8,2)=0.335;
neo(8,3)=13.3;      neo(8,4)=337.3;
neo(8,5)=276.8;     neo(8,6)=235.1;
%   Orpheus Apollo
neo(9,1)=1.209;     neo(9,2)=0.323;
neo(9,3)=2.7;       neo(9,4)=189.7;
neo(9,5)=301.6;     neo(9,6)=70.8;
%   Dionysus  Apollo
neo(10,1)=2.2;      neo(10,2)=0.542;
neo(10,3)=13.6;     neo(10,4)=82.4;
neo(10,5)=203.9;    neo(10,6)=172.5;
%   Nyx Amor
neo(11,1)=1.926;    neo(11,2)=0.459;
neo(11,3)=2.2;      neo(11,4)=261.8;
neo(11,5)=125.9;    neo(11,6)=25.4;
%   Minos Apollo
neo(12,1)=1.151;    neo(12,2)=0.413;
neo(12,3)=3.9;      neo(12,4)=344.8;
neo(12,5)=239.6;    neo(12,6)=164.4;
neo(12,7)=17.4;
%   EY2 Apollo
neo(13,1)=1.699;    neo(13,2)=0.471;
neo(13,3)=20.9;     neo(13,4)=343.6;
neo(13,5)=51.0;     neo(13,6)=78.2;
neo(13,7)=20.4;
%   YE4 Aten
neo(14,1)=0.677;    neo(14,2)=0.541;
neo(14,3)=4.8;      neo(14,4)=306.0;
neo(14,5)=318.4;    neo(14,6)=89.7;
neo(14,7)=20.9;
%   SG286 Apollo
neo(15,1)=1.361;    neo(15,2)=0.348;
neo(15,3)=7.8;      neo(15,4)=241.3;
neo(15,5)=55.8;     neo(15,6)=176.5;
neo(15,7)=21.1;
%   YB5 Apollo 
neo(16,1)=2.356;    neo(16,2)=0.863;
neo(16,3)=5.5;      neo(16,4)=109.4;
neo(16,5)=114.2;    neo(16,6)=21.3;
neo(16,7)=20.9;
%   VD35 Apollo
neo(17,1)=1.565;    neo(17,2)=0.476;
neo(17,3)=7.0;      neo(17,4)=227.6;
neo(17,5)=295.9;    neo(17,6)=223.7;
neo(17,7)=20.4;
%   VF32 Aten
neo(18,1)=0.852;    neo(18,2)=0.446;
neo(18,3)=24.0;     neo(18,4)=236.4;
neo(18,5)=320.8;    neo(18,6)=47.4;
neo(18,7)=21.1;
%   WR12 Athen
neo(19,1)=0.754;    neo(19,2)=0.406;
neo(19,3)=7.1;      neo(19,4)=63;
neo(19,5)=205.8;    neo(19,6)=259.6;
neo(19,7)=22.0;
%   SG344 Aten
neo(20,1)=0.977604185;  neo(20,2)=0.066984528;
neo(20,3)=0.1093591;    neo(20,4)=192.54;
neo(20,5)=274.611;      neo(20,6)=144.44;
neo(20,7)=24.79;
%   UG Apollo class
neo(21,1)=1.226;    neo(21,2)=0.246;
neo(21,3)=4.5;      neo(21,4)=12.4;
neo(21,5)=225.9;    neo(21,6)=131.8;
neo(21,7)=21.0;
%   GK Apollo
neo(22,1)=1.920599; neo(22,2)=0.596128;
neo(22,3)=5.60457;  neo(22,4)=15.228;
neo(22,5)=111.6655; neo(22,6)=315.684644;
neo(22,7)=24.2;
%   SB45  Apollo class
neo(23,1)=1.55979;  neo(23,2)=0.39703;
neo(23,3)=3.6755144;neo(23,4)=195.55755;
neo(23,5)=216.35;   neo(23,6)=175.39;
neo(23,7)=24.34;
%   Florence between apollo and amor
neo(24,1)=1.768;    neo(24,2)=0.423;
neo(24,3)=22.2;     neo(24,4)=336.2;
neo(24,5)=27.6;     neo(24,6)=164.9;
neo(24,7)=20.0;
%   Castalia  Apollo class
neo(25,1)=1.063;    neo(25,2)=0.483;
neo(25,3)=8.9;      neo(25,4)=325.7;
neo(25,5)=121.3;    neo(25,6)=152.1;
neo(25,7)=20.0;
%   Pan Apollo class
neo(26,1)=1.442;    neo(26,2)=0.587;
neo(26,3)=5.5;      neo(26,4)=312.1;
neo(26,5)=291.5;    neo(26,6)=205.7;
neo(26,7)=17.2;
%   1989UQ Aten Class
neo(27,1)=0.915;    neo(27,2)=0.265;
neo(27,3)=1.29;     neo(27,4)=178.4;
neo(27,5)=14.9;     neo(27,6)=321.6;
neo(27,7)=19.2;
%   2001CC21 Apollo
neo(28,1)=1.032;    neo(28,2)=0.219;
neo(28,3)=4.8;      neo(28,4)=75.8;
neo(28,5)=179.2;    neo(28,6)=340.2;
neo(28,7)=18.4;
%   1996FG3 Apollo Class
neo(29,1)=1.054;    neo(29,2)=0.350;
neo(29,3)=2.0;      neo(29,4)=299.9;
neo(29,5)=23.9;     neo(29,6)=125.6;
neo(29,7)=18.2;
%   1999YB Amor Class
neo(30,1)=1.321;    neo(30,2)=0.075;
neo(30,3)=6.8;      neo(30,4)=31.1;
neo(30,5)=192.8;    neo(30,6)=78.3;
neo(30,7)=18.2;
%   1994CN2 Apollo class
neo(31,1)=1.573;    neo(31,2)=0.395;
neo(31,3)=1.4;      neo(31,4)=99.4;
neo(31,5)=248.1;    neo(31,6)=204.2;
neo(31,7)=16.4;
%   2003gg21 Apollo class
neo(32,1)=2.14347;  neo(32,2)=0.709359;
neo(32,3)=10.121;   neo(32,4)=13.236;
neo(32,5)=94.975;   neo(32,6)=161.221;
neo(32,7)=16.4;
%   1989ML Amor class
neo(33,1)=1.27248557;   neo(33,2)=0.13653409;
neo(33,3)=4.3777308;    neo(33,4)=104.410943;
neo(33,5)=183.2673284;  neo(33,6)=302.620;
neo(33,7)=16.4;
neo(33,8)=53400.5;
%   1999JU3 Apollo class
neo(34,1)=1.18905723;   neo(34,2)=0.18996304;
neo(34,3)=5.884246;     neo(34,4)=251.712219;
neo(34,5)=211.293457;   neo(34,6)= 259.1554; %315.075562;
neo(34,7)=16.4;
neo(34,8)=53400.5;
%   1999AO10 Aten class
neo(35,1)=0.91220084;   neo(35,2)=0.1102457;
neo(35,3)=2.6257975;    neo(35,4)=313.491555;
neo(35,5)=7.4322027;    neo(35,6)=124.02719;
neo(35,7)=16.4;
neo(35,8)=53400.5;
%   2000LG6 Aten classs
neo(36,1)=0.9161588;    neo(36,2)=0.11212602;
neo(36,3)=2.8299234;    neo(36,4)=72.77002;
neo(36,5)=7.74968;      neo(36,6)=283.0520;
neo(36,7)=16.4;
neo(36,8)=53400.5;

%   1999AO10
% neo(36,1)=0.91220084; neo(36,2)=0.1102457;
% neo(36,3)=2.6257975; neo(36,4)=72.7702;
% neo(36,5)=7.4322027; neo(36,6)=283.0520;
% neo(36,7)=16.4;
% neo(36,8)=53400.5;

%   2003WP25  Aten class
neo(37,1)=0.99051724;   neo(37,2)=0.1210865;
neo(37,3)=2.525204;     neo(37,4)=42.4259902;
neo(37,5)=225.466896;   neo(37,6)=217.03135;
neo(37,7)=16.4;
neo(37,8)=53400.5;
%  2002 at4  Amor class
neo(38,1)=1.8662367;   	neo(38,2)=0.44718511;
neo(38,3)=1.50648696;   neo(38,4)=323.7736115;
neo(38,5)=202.739310;   neo(38,6)=51.0357;
neo(38,8)=53400.5;
%  2002MN4 Athen Class
neo(39,1)=0.9224497;    neo(39,2)=0.19102395;
neo(39,3)=3.3309594;    neo(39,4)=204.466790;
neo(39,5)=126.37336;    neo(39,6)=359.740965;
neo(39,8)=53600.5;

%  2002VD17 Apollo Class
neo(40,1)=1.508007426008;   neo(40,2)=0.588761;
neo(40,3)=4.22285;          neo(40,4)=224.25043;
neo(40,5)=90.697416;        neo(40,6)=74.07288;
neo(40,8)=53400.5;

%  1997XR2  APOLLO class
neo(41,1)=1.0767572;        neo(41,2)=0.20111914;
neo(41,3)=7.17074853;       neo(41,4)=250.882416;
neo(41,5)=84.63416;         neo(41,6)=218.8824;
neo(41,8)=53400.5;

%  2001 TW229
neo(42,1)=2.5897261;        neo(42,2)=0.2734625;
neo(42,3)=6.40734 ;         neo(42,4)=128.347;
neo(42,5)=264.78691;        neo(42,6)=320.47955;
neo(42,8)=53600;

%--------------------------------------------------------------------------
%Potentially Hazardous Objects PHO
%da qui ti aggiungo i nuovi che dobbiamo studiare, ci sono alcune
%ripetizioni con asteroidi gi� presenti sopra , ma almeno li hai tutti in
%fila il che pu� essere piu' comodo . Ti aggiungo anche la magnitudine
%degli asteroidi.

%  2004VD17
neo(43,1)=1.5081126;        neo(43,2)=0.58867;
neo(43,3)=4.2229069 ;       neo(43,4)=224.2431;
neo(43,5)=90.69111;         neo(43,6)=286.993493;
neo(43,8)=53800.5;          neo(43,9)=2.7e11;

%  Apophis
neo(44,1)=0.9223958;        neo(44,2)=0.19104004;
neo(44,3)=3.331224 ;        neo(44,4)=204.46221;
neo(44,5)=126.3557;         neo(44,6)=222.272919;
neo(44,8)=53800.5;          neo(44,9)=4.6e10;

%  2005WY5
neo(45,1)=2.479628;         neo(45,2)=0.721465;
neo(45,3)=7.263452 ;        neo(45,4)=248.4368;
neo(45,5)=285.9634;         neo(45,6)=3.30448;
neo(45,8)=53800.5;          neo(45,9)=1.9e10;

%------------------------------------------------------------------------
% da qui iniziano quelli lost o non recentemente osservati
% direi che sono interessanti sia per il discorso impatto, che peril
% discorso rendezvous...quelli sopra sono stati osservati recentemente, il
% che nono vuol dire che una missione di rendezvous non sia comunque
% importante visto che comunque c' � incertezza nella conoscenza
% orbitale...
%  1997XR2
neo(46,1)=1.0767077;        neo(46,2)=0.20111;
neo(46,3)=7.171158 ;        neo(46,4)=250.8767;
neo(46,5)=84.6441;          neo(46,6)=211.8440;
neo(46,8)=53800.5;          neo(46,9)=1.7e10;

%  1994WR12
neo(47,1)=0.756488;         neo(47,2)=0.398411;
neo(47,3)=6.871 ;           neo(47,4)=62.854;
neo(47,5)=205.877;          neo(47,6)=27.311;
neo(47,8)=53700;            neo(47,9)=2.0e9;

%  1979XB
neo(48,1)=2.35003;          neo(48,2)=0.726471;
neo(48,3)=25.143;           neo(48,4)=85.513;
neo(48,5)=75.746;           neo(48,6)=62.027;
neo(48,8)=53700;            neo(48,9)=4.4e11;

%  2000SG344
neo(49,1)=0.977396;         neo(49,2)=0.066949;
neo(49,3)=0.11011 ;         neo(49,4)=192.335;
neo(49,5)=274.9239;         neo(49,6)=132.351;
neo(49,8)=53800.5;          neo(49,9)=7.1e7;

%  2000QS7
neo(50,1)=2.6819581;        neo(50,2)=0.66247;
neo(50,3)=3.1941 ;          neo(50,4)=153.491;
neo(50,5)=218.777254;       neo(50,6)=84.83071;
neo(50,8)=53800.5;          neo(50,9)=9.9e10; 
 
%  1998HJ3
neo(51,1)=1.986867;         neo(51,2)=0.743997;
neo(51,3)=6.540717 ;        neo(51,4)=224.901;
neo(51,5)=92.766901;        neo(51,6)=333.6471;
neo(51,8)=50926.5;          neo(51,9)=4.5e11;

%  2005TU45
neo(52,1)=1.9736201;        neo(52,2)=0.495785;
neo(52,3)=28.5464701;       neo(52,4)=120.286954;
neo(52,5)=76.858129;        neo(52,6)=34.170088;
neo(52,8)=53651.5;          neo(52,9)=3.3e12;

%  2004XK3
neo(53,1)=1.211611;         neo(53,2)=0.25502727;
neo(53,3)=1.430988 ;        neo(53,4)=58.10905;
neo(53,5)=302.262661;       neo(53,6)=22.053122;
neo(53,8)=53800.5;          neo(53,9)=1.1e8;

%  1994GK
neo(54,1)=1.920599;         neo(54,2)=0.597122;
neo(54,3)=5.602629;         neo(54,4)=15.400906;
neo(54,5)=111.477717;       neo(54,6)=17.3688866;
neo(54,8)=49450.5;          neo(54,9)=1.5e8;

%  2000SB45
neo(55,1)=1.5595;           neo(55,2)=0.397151;
neo(55,3)=3.677 ;           neo(55,4)=195.536;
neo(55,5)=216.387;          neo(55,6)=214.411;
neo(55,8)=53700;            neo(55,9)=1.3e8;

%  2001CA21
neo(56,1)=1.66048;          neo(56,2)=0.773838;
neo(56,3)=4.938;            neo(56,4)=46.466;
neo(56,5)=218.823;          neo(56,6)=65.552;
neo(56,8)=53700;            neo(56,9)=4.3e11;

% Aggiunto da Camilla -----------------------------------------------------
%  1991RB - usato da Conway

% from NeoDys
% neo(57,1)=1.45448;      neo(57,2)=0.485596;
% neo(57,3)=19.592;       neo(57,4)=359.48;
% neo(57,5)=68.755;       neo(57,6)=59.111;
% neo(57,8)=53800;        neo(57,9)=0;

% from http://cfa-www.harvard.edu/iau/lists/Dangerous.html
% io usavo questo con l'epoca sbagliata
neo(57,1)=1.454;            neo(57,2)=0.486;
neo(57,3)=19.6;             neo(57,4)=359.5;
neo(57,5)=68.8;             neo(57,6)=59.1;
neo(57,8)= 53795.0+6; 
neo(57,9)=0;

% from Conway paper
% neo(57,1)=1.45;        neo(57,2)=0.484;
% neo(57,3)=19.5;        neo(57,4)=359.6;
% neo(57,5)=68.7;        neo(57,6)=320.1;
% neo(57,8)= 48500.0 1/09/1991
% neo(57,9)=0;

%  1996JA1 -usato da Carusi
% from NeoDys
neo(58,1)=2.56062;      neo(58,2)=0.702157;
neo(58,3)=21.847;       neo(58,4)=57.248;
neo(58,5)=247.049;      neo(58,6)=128.795;
neo(58,8)=53800;        neo(58,9)=0;

% 433 Eros
neo(59,1)=1.458;        neo(59,2)=0.223;
neo(59,3)=10.829;       neo(59,5)=162.753;
neo(59,4)=304.401;      neo(59,6)=63.919;
neo(59,8)=53300;        neo(59,9) = 7.2e15;

% Itokawa
neo(60,1)=1.32385;      neo(60,2)=0.280107;
neo(60,3)=1.622;        neo(60,5)=178.664;
neo(60,4)=69.095;       neo(60,6)=320.215;
neo(60,8)=53800;        neo(60,9)= 3.51e10;
% earlier neo(60,9) was 6.01e10 -> updated from papers


%Castalia 
neo(61,1)=1.063;        neo(61,2)=0.483;
neo(61,3)=8.9;          neo(61,4)=325.7;
neo(61,5)=121.3;        neo(61,6)=152.1;
neo(61,8)=53800;        neo(61,9)=1.4091e12;

% 1999KW4 
neo(62,1)=0.642306;     neo(62,2)=0.688411;
neo(62,3)=38.891;       neo(62,4)=244.932;
neo(62,5)=192.597;      neo(62,6)=237.363;
neo(62,8)=53800;        neo(62,9)=2.33e12;

% 2062 Aten 
neo(63,1)=0.966699;     neo(63,2)=0.182684;
neo(63,3)=18.932;       neo(63,4)=108.629;
neo(63,5)=147.94;       neo(63,6)=127.527;
neo(63,8)=53800;        neo(63,9)=7.6e11;

% 3908 Nyx 
neo(64,1)=1.92795;      neo(64,2)=0.458751;
neo(64,3)=2.178;        neo(64,4)=261.601;
neo(64,5)=126.116;      neo(64,6)=181.442;
neo(64,8)=53800;        neo(64,9)=5e12;

% 1036 Ganymed 
neo(65,1)=2.66602;      neo(65,2)=0.534257;
neo(65,3)=26.682;       neo(65,4)=215.623;
neo(65,5)=132.448;      neo(65,6)=265.767;
neo(65,8)=53800;        neo(65,9)=3.3e16;

% 1620 Geographos 
neo(66,1)=1.24543;      neo(66,2)=0.335436;
neo(66,3)=13.341;       neo(66,4)=337.293;
neo(66,5)=276.793;      neo(66,6)=147.839;
neo(66,8)=53800;        neo(66,9)=2.6e13;

% Quetzalcoatl
neo(67,1)=2.54093;      neo(67,2)=0.571841;
neo(67,3)=20.422;       neo(67,4)=162.992;
neo(67,5)=347.905;      neo(67,6)=120.221;
neo(67,8)=54000;        neo(67,9)=6.5411e10;

%--------------------------------------------------------------------------
% - new PHO -

% 2005QK76
neo(68,1)=1.39923469750022;     neo(68,2)=0.51827286187414;
neo(68,3)=22.9012303705835;     neo(68,4)=337.590220332861;
neo(68,5)=266.128652615749;     neo(68,6)=36.1190734189986;
neo(68,8)=53613.5;              neo(68,9)=4.1e+07;

% 2002TX55
neo(69,1)=2.22888844705841;     neo(69,2)=0.570254217832557;
neo(69,3)=4.3767639326669;      neo(69,4)=190.267592544221;
neo(69,5)=148.823875125375;     neo(69,6)=16.8554771863143;
neo(69,8)=53800.5;              neo(69,9)=3.4e+08;

% 2005EL70
neo(70,1)= 2.27147187823415;	neo(70,2)=0.925969442461181;
neo(70,3)=16.1898614527821;     neo(70,4)=167.57868553608;
neo(70,5)=167.57868553608;      neo(70,6)=12.0968701357691;
neo(70,8)=53438.5;              neo(70,9)=1.9e+08;

% 2001BB16
neo(71,1)=0.854230242109529;	neo(71,2)=0.172355409787467;
neo(71,3)=2.02615313281559;     neo(71,4)=122.571055330757;
neo(71,5)=195.577098562118;     neo(71,6)=327.404543834094;
neo(71,8)=53800.5;              neo(71,9)=1.5e+09;

% 2002VU17
neo(72,1)=2.47390400231025;     neo(72,2)=0.616595711921088;
neo(72,3)=1.49784657951333;     neo(72,4)=55.6763169120594;
neo(72,5)=308.755792192987;     neo(72,6)=11.375212802578;
neo(72,8)=52599.5;              neo(72,9)=7.3e+07;

% 2000TU28
neo(73,1)=1.07367642567135;     neo(73,2)=0.182962067410402;
neo(73,3)=15.648260271564;      neo(73,4)=203.119701285924;
neo(73,5)=280.591828968153;     neo(73,6)=227.023188431711;
neo(73,8)=53800.5;              neo(73,9)=3.0e+10;

% 2001Av43
neo(74,1)=1.27691262027621;     neo(74,2)=0.238094964007586;
neo(74,3)=0.278186074234568;	neo(74,4)=30.7322553324687;
neo(74,5)=43.0665849345991;     neo(74,6)= 226.999450886699;
neo(74,8)=53800.5;              neo(74,9)=1.2e+08;

% 2003RB182
neo(75,1)= 2.54379838866801;	neo(75,2)=0.650202154757456;
neo(75,3)=0.227659680347365;	neo(75,4)=165.507836202557;
neo(75,5)=254.306439945023;     neo(75,6)=347.421743814778;
neo(75,8)=52532.5;              neo(75,9)=1.1e+09;

% 2002GJ8
neo(76,1)= 2.9572834630743;     neo(76,2)= 0.827855877451362;
neo(76,3)=5.30888425644401;     neo(76,4)=144.240518643861;
neo(76,5)= 180.32141333275;     neo(76,6)=261.307924483229 ;
neo(76,8)=53800.5;              neo(76,9)=1.3e+11;

% 2001FB90
neo(77,1)=2.48241733449612;     neo(77,2)=0.785607496207711;
neo(77,3)=1.92810209347585;     neo(77,4)=266.295257525742;
neo(77,5)=14.5090391404192;     neo(77,6)=343.339456624282;
neo(77,8)=51993.5;              neo(77,9)=5.7e+10;

% 2005NX55
neo(78,1)= 1.52275631441764;	neo(78,2)=0.587826615576974;
neo(78,3)= 26.1687162393635;	neo(78,4)=106.426701101299;
neo(78,5)=277.259426020471;     neo(78,6)=327.238661680905;
neo(78,8)=53563.5;              neo(78,9)=3.8e+09;

% 1996TC1
neo(79,1)= 1.86752674102478;	neo(79,2)=0.720075922938991;
neo(79,3)=14.5312017232753;     neo(79,4)=5.01200840180918;
neo(79,5)=258.813109703959;     neo(79,6)=22.8521323505275;
neo(79,8)=50363.5;              neo(79,9)=2.3e+08;

% 6344P-L
neo(80,1)=2.64495202309071;     neo(80,2)=0.644754002670867;
neo(80,3)=4.66355794763787;     neo(80,4)=184.9825763296176;
neo(80,5)= 232.607461670593;	neo(80,6)=349.851936680136;
neo(80,8)=37203.5;              neo(80,9)=1.2e+10;

% 2004ME6
neo(81,1)=2.36483862231406;     neo(81,2)=0.574756165900979;
neo(81,3)=9.44309731234872;     neo(81,4)=112.238777776509;
neo(81,5)=210.345796034097;     neo(81,6)=346.122339310222;
neo(81,8)=53182.5;              neo(81,9)=1.5e+09;

% 2001QJ96
neo(82,1)=1.59976348839403;     neo(82,2)=0.799695476858452;
neo(82,3)=5.87431522652613;     neo(82,4)=339.115295230357;
neo(82,5)=121.324139073609;     neo(82,6)=333.90204543185;
neo(82,8)=52147.5;              neo(82,9)=3.3e+09;

% 2004GE2
neo(83,1)= 2.04796343369688;	neo(83,2)=0.707178099914178;
neo(83,3)= 2.16350077638417;	neo(83,4)= 45.127453780029;
neo(83,5)=259.924040899382;     neo(83,6)=341.61637169622;
neo(83,8)=53112.5;              neo(83,9)=8.0e+09;

% 2002AA29
% from http://neo.jpl.nasa.gov/cgi-bin/neo_elem 07/06/2008
neo(84,1) = 0.99349120;         neo(84,2) = 0.013026682;
neo(84,3) = 10.7450282;         neo(84,4) = 106.4251554;
neo(84,5) = 101.6052515;        neo(84,6) = 40.8467224;
neo(84,8) = 54600; 

% % 2008JL24
% % from SysNova
% neo(85,1) = 1.03826844970543;         neo(85,2) = 0.106559869181477;
% neo(85,3) = 0.5501064109470443;       neo(85,4) = 225.822449694026;
% neo(85,5) = 281.9655686889383;        neo(85,6) = 124.186109529154;
% neo(85,8) = date2mjd([2012, 05, 19, 16, 46,  32.9053440000004]);
% neo(85,7) = 29.572;


% % 2006RH120
% % from SysNova before encounter
% neo(86,1) = 1.033252056035198;         neo(86,2) = 0.02447403062284801;
% neo(86,3) = 0.5952660003048117;        neo(86,4) = 51.14334927580387;
% neo(86,5) = 10.14353817485877;         neo(86,6) = 221.2498016727181;
% neo(86,8) = date2mjd([2013, 02, 24, 20, 32,  38.4881]);
% neo(86,7) = 29.527;

% % 2006RH120
% % from SysNova  after encounter      
% neo(86,1) = 1.04643027676643;          neo(86,2) = 0.0376850093860971;
% neo(86,3) = 0.599558332889997;         neo(86,4) = 41.3425820340707;
% neo(86,5) = 9.35221730232587;         neo(86,6) = 354.534392920444;
% neo(86,8) = date2mjd([2029, 12, 3, 18, 30,  40.3551757335663]);
% neo(86,7) = 29.527;


% % Max
% % from SysNova
% neo(87,1) = 1.0;         neo(87,2) = 0.00001;
% neo(87,3) = 5;        neo(87,4) = 0;
% neo(87,5) = 0;         neo(87,6) = 10;
% neo(87,8) = date2mjd([2013, 02, 24, 20, 32,  38.4881]);
% neo(87,7) = 29.527;

%  Apophis
% neo(88,1)=ainAU;        neo(88,2)=e;
% neo(88,3)=i in deg ;        neo(88,4)=Om in deg;
% neo(88,5)=om in deg ;         neo(88,6)=M in deg;
% neo(88,8)=date2mjd([2029, 12, 3, 18, 30,  40.3551757335663]); ref time in data



%=====================================================

AU  =   astroConstants(2);         % km
mu_sun  =   astroConstants(4);         % km^3/s^2 Sun gravitational constant

a  =neo(id,1)*AU;
e  =neo(id,2);
di =neo(id,3);
omm=neo(id,4);
om =neo(id,5);
m  =neo(id,6);
n  =sqrt(mu_sun/a^3);

t0 =m*pi/180/n;

if id>=33
    timediff=neo(id,8)-51544.5; % Convert to MJD2000
    t=(time-timediff)*86400+t0;
else
    t  =(time-856)*86400+t0;
end

p=2*pi*sqrt(a^3/mu_sun);
np=floor(t/p);
t=t-p*np;
phi=n*t;
M  = phi;
if M>pi
    M = M-2*pi;
end

% Ciclo di Newton: devo mandare a zero la funzione
%f=(M-E+esinE)...parto da E=M...deltaE=-fdot^-1*f
for i=1:5
    ddf=(e*cos(phi)-1);
    phi=phi-t*n/ddf+(phi-e*sin(phi))/ddf;
end

wom=2*atan(sqrt((1+e)/(1-e))*tan(phi*0.5)); % In radians
kep=[a e di*pi/180 omm*pi/180 om*pi/180 wom];
 
if neo(id,9) ~= 0
    mass=neo(id,9);
else
    %   polynomial fit to the H-d diagram which gives the diameter of the NEO as a function of its magnitude.
    %   polynomial of fifth order, Note: NOT VERY ACCURATE!
    d=-2.522e-2*neo(id,7)^5+3.2961*neo(id,7)^4-1.7249e2*neo(id,7)^3+4.5231e3*neo(id,7)^2-5.9509e4*neo(id,7)+3.1479e5;
    %   estimated mass of the NEO computed considering a density of 2 kg/dm^3
    mass=4*pi/3*(0.5*d)^3*2*1000;
end

return
