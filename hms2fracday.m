function fracDay = hms2fracday(hrs, mn, sec)

%HMS2FRACDAY Convert hours, minutes, and seconds into a fraction of day.
%
% FRACDAY = HMS2FRACDAY(HRS, MN, SEC) converts the fraction of day to
% hours, minutes, and seconds.
%
% INPUT
%    hrs        Number of hours as integer greater or equal to 0 and lower
%               or equal to 23.
%    mn         Number of minutes as integer greater or equal to 0 and
%               lower or equal to 59.
%    sec        Number of seconds as a real greater or equal to 0 and
%               strictly lower than 60.
%
% OUTPUT
%    fracDay    A single real greater or equal to 0 and strictly lower than
%               1.
%
% See also FRACDAY2HMS.
%
% FUNCTIONS CALLED
%   none
%
% - Nicolas Croisard - 16/02/2008
% - Revised by Camilla Colombo - 29/02/2008
%
% ------------------------- - SpaceART Toolbox - --------------------------


% Check the inputs
%------------------

% Number of inputs
if nargin ~= 3
    error('HMS2FRACDAY:incorrectInput',...
          'Not enough inputs, 3 inputs are required');
end

% Check the hours
if numel(hrs) ~= 1
    error('HMS2FRACDAY:incorrectInput',...
          'The hours must be given as a single integer');
elseif floor(hrs)~=hrs || hrs<0 || hrs>23
    error('HMS2FRACDAY:incorrectInput',...
          ['The hours must be given as an integer greater or equal ',...
           'to 0 and lower or equal to 23']);
end

% Check the minutes
if numel(mn) ~= 1
    error('HMS2FRACDAY:incorrectInput',...
          'The minutes must be given as a single integer');
elseif floor(mn)~=mn || mn<0 || mn>59
    error('HMS2FRACDAY:incorrectInput',...
          ['The minutes must be given as an integer greater or equal ',...
           'to 0 and lower or equal to 59']);
end

% Check the minutes
if numel(sec) ~= 1
    error('HMS2FRACDAY:incorrectInput',...
          'The seconds must be given as a single real');
elseif sec<0 || sec>60
    error('HMS2FRACDAY:incorrectInput',...
          ['The seconds must be given as an real greater or equal ',...
           'to 0 and strictly lower then 60']);
end


% Compute the fraction of day
%-----------------------------
fracDay = (hrs + (mn + sec/60)/60) / 24;


return