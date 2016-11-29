function out = astroConstants(in)

% astroConstants.m - Returns astrodynamic-related physical constants.
%
% PROTOTYPE:
%   out = astro_constants(in)
%
% DESCRIPTION:
%   Returns a row vector of constants, in which there is the corresponding
%   constant for each element of the input vector.
%
%   List of identifiers:
%       Generic astronomical constants:
%           1   Universal gravity constant (G) (from DITAN) [km^3/(kg*s^2)]
%           2   Astronomical Unit (AU) (from DITAN) [km]
%       Sun related:
%           3   Sun mean radius (from DITAN) [km]
%           4   Sun planetary constant (mu = mass * G) (from DITAN)
%               [km^3/s^2]
%           31  Energy flux density of the Sun (from Wertz,SMAD)
%               [W/m2 at 1 AU]
%       Other:
%           5   Speed of light in the vacuum (definition in the SI) [km/s]
%           6   Standard free fall (the acceleration due to gravity on the
%               Earth's surface at sea level) (from Wertz,SMAD) [m/s^2]
%           7   Mean distance Earth-Moon (from Wertz,SMAD) [km]
%           8   Obliquity (angle) of the ecliptic at Epoch 2000 (from
%               Wertz,SMAD) [rad]
%           9   Gravitatonal field constant of the Earth (from Wertz,SMAD,
%               taken from JGM-2). This should be used in conjunction to
%               Earth radius = 6378.1363 km 
%       Planetary constants of the planets (mu = mass * G) [km^3/s^2]:
%           11  Me      (from DITAN)
%           12  V       (from DITAN)
%           13  E       (from DITAN)
%           14  Ma      (from DITAN)
%           15  J       (from DITAN)
%           16  S       (from DITAN)
%           17  U       (from DITAN)
%           18  N       (from DITAN)
%           19  P       (from DITAN)
%           20  Moon    (from DITAN)
%       Mean radius of the planets [km]:
%           21  Me      (from DITAN)
%           22  V       (from DITAN)
%           23  E       (from DITAN)
%           24  Ma      (from DITAN)
%           25  J       (from DITAN)
%           26  S       (from DITAN)
%           27  U       (from DITAN)
%           28  N       (from DITAN)
%           29  P       (from DITAN)
%           30  Moon    (from DITAN)
%
%   Notes for upgrading this function:
%       It is possible to add new constants.
%       - DO NOT change the structure of the function, as well as its
%           prototype.
%       - DO NOT change the identifiers of the constants that have already
%           been defined in this function. If you want to add a new
%           constant, use an unused identifier.
%       - DO NOT add constants that can be easily computed starting form
%           other ones (avoid redundancy).
%       Contact the author for modifications.
%
% INPUT:
%   in      Vector of identifiers of required constants.
%
% OUTPUT:
%   out     Vector of constants.
%
% EXAMPLE:
%   astroConstants([2, 4, 26])
%      Returns a row vector in which there is the value of the AU, the Sun
%      planetary constant and the mean radius of Saturn.
%
%   astroConstants(10 + [1:9])
%      Returns a row vector with the planetary constant of each planet.
%
% REFERENCES:
%   - DITAN (Direct Interplanetary Trajectory Analysis), Massimiliano
%       Vasile, 2006.
%	- Wertz J. R., Larson W. J., "Space Mission Analysis and Design", Third
%       Edition, Space Technology Library 2003.
%
% CALLED FUNCTIONS:
%   (none)
%
% AUTHOR:
%   Matteo Ceriotti, 2006, MATLAB, astroConstants.m
%
% PREVIOUS VERSION:
%   Matteo Ceriotti, 2006, MATLAB, astro_constants.m, Ver. 1.2
%       - Header and function name in accordance with guidlines.
%
% CHANGELOG:
%   26/10/2006, Camilla Colombo: Updated.
%   22/10/2007, Camilla Colombo: astroConstants(8) added (Obliquity (angle)
%       of the ecliptic at Epoch 2000).
%   02/10/2009, Camilla Colombo: Header and function name in accordance
%       with guidlines.
%   12/11/2010, Camilla Colombo: astroConstants(9) added (J2) Note: the
%       present value of J2 is not consistent with the value of the Earth
%       radius. This value of J2 should be used in conjunction to Earth
%       radius = 6378.1363 km 
%
% -------------------------------------------------------------------------

for i=1:length(in)
    switch in(i)
        case 1
            out(i)=6.67259e-20; % From DITAN
        case 2
            out(i)=149597870.7; % From DITAN
        case 3
            out(i)=700000; % From DITAN
        case 4
            out(i)=0.19891000000000E+31*6.67259e-20; % From DITAN
        case 5
            out(i)=299792.458; % Definition in the SI
        case 6
            out(i)=9.80665; % Definition in Wertz, SMAD
        case 7
            out(i)=384401; % Definition in Wertz, SMAD
        case 8
            out(i)=23.43928111*pi/180; % Definition in Wertz, SMAD
        case 9
            out(i)=0.1082626925638815e-2; % Definition in Wertz, SMAD
        case 11
            out(i)=0.33020000000000E+24*6.67259e-20; % From DITAN
        case 12
            out(i)=0.48685000000000E+25*6.67259e-20; % From DITAN
        case 13
            out(i)=0.59736990612667E+25*6.67259e-20; % From DITAN
        case 14
            out(i)=0.64184999247389E+24*6.67259e-20; % From DITAN
        case 15
            out(i)=0.18986000000000E+28*6.67259e-20; % From DITAN
        case 16
            out(i)=0.56846000000000E+27*6.67259e-20; % From DITAN
        case 17
            out(i)=0.86832000000000E+26*6.67259e-20; % From DITAN
        case 18
            out(i)=0.10243000000000E+27*6.67259e-20; % From DITAN
        case 19
            out(i)=0.14120000000000E+23*6.67259e-20; % From DITAN
        case 20
            out(i)=0.73476418263373E+23*6.67259e-20; % From DITAN
        case 21
            out(i)=0.24400000000000E+04; % From DITAN
        case 22
            out(i)=0.60518000000000E+04; % From DITAN
        case 23
            out(i)=0.63781600000000E+04; % From DITAN
        case 24
            out(i)=0.33899200000000E+04; % From DITAN
        case 25
            out(i)=0.69911000000000E+05; % From DITAN
        case 26
            out(i)=0.58232000000000E+05; % From DITAN
        case 27
            out(i)=0.25362000000000E+05; % From DITAN
        case 28
            out(i)=0.24624000000000E+05; % From DITAN
        case 29
            out(i)=0.11510000000000E+04; % From DITAN
        case 30
            out(i)=0.17380000000000E+04; % From DITAN
        case 31
            out(i)=1367; % From Wertz, SMAD
        % Add an identifier and constant here. Prototype:
        % case $identifier$
        %     out(i)=$constant_value$;
        otherwise
            warning('Constant identifier %d is not defined!',in(i));
            out(i)=0;
    end
end
