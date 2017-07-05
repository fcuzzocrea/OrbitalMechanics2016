function status = odewbar(t,~,flag,varargin)
%ODEWBAR Graphical waitbar printing ODE solver progress.
%   When the function odewbar is passed to an ODE solver as the 'OutputFcn'
%   property, i.e. options = odeset('OutputFcn',@odewbar), the solver calls
%   ODEWBAR(T,Y,'') after every timestep. The ODEWBAR function shows a
%   waitbar with the progress of the integration every 0.2 seconds.
%
%   At the start of integration, a solver calls ODEWBAR(TSPAN,Y0,'init') to
%   initialize the output function.  After each integration step to new time
%   point T with solution vector Y the solver calls STATUS = ODEWBAR(T,Y,'').
%	When the integration is complete, the solver calls ODEWBAR([],[],'done').
%
%   See also ODEPLOT, ODEPHAS2, ODEPHAS3, ODE45, ODE15S, ODESET.
%
%   José Pina, 22-11-2006
%

persistent tfinal hwbar tlast

% regular call -> increment wbar
if nargin < 3 || isempty(flag)
    
    % update only if more than 0.2 sec elapsed
    if cputime-tlast>0.2
        tlast = cputime;
        waitbar(t(1)/tfinal,hwbar);
        % terminate if less than one second elapsed
    else
        status = 0;
        return
    end
    
    % initialization / end
else
    switch(flag)
        case 'init'               % odeprint(tspan,y0,'init')
            hwbar = waitbar(0,'ODE integration','Name','ODE integration');
            tfinal = t(end);
            tlast = cputime;
            figure(hwbar)
        case 'done'               % odeprint([],[],'done')
            close(hwbar)
            
    end
end

status = 0;

end