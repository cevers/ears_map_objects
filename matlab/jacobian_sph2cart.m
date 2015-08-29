function jacobian = jacobian_sph2cart( az, incl, r )
%jacobian_sph2cart Summary of this function goes here
%   Detailed explanation goes here

global iVec

% Jacobian for conversion from spherical to Cartesian:
% [ -r*sin(az)*sin(incl), r*cos(az)*cos(incl), cos(az)*sin(incl)]
% [  r*cos(az)*sin(incl), r*cos(incl)*sin(az), sin(az)*sin(incl)]
% [                    0,         r*sin(incl),        -cos(incl)]
% [   -sin(az)*sin(incl),   cos(az)*cos(incl),                 0]
% [    cos(az)*sin(incl),   cos(incl)*sin(az),                 0]
% [                    0,           sin(incl),                 0]
%  

Jxr     = cos(az)*sin(incl);
Jxaz    = -r*sin(az)*sin(incl);
Jxinc   = r*cos(az)*cos(incl);
Jyr     = sin(az)*sin(incl);
Jyaz    = r*cos(az)*sin(incl);
Jyinc   = r*cos(incl)*sin(az);
Jzr     = -cos(incl);
Jzaz    = 0;
Jzinc   = r*sin(incl);

Jvxr    = 0;
Jvxaz   = -sin(az)*sin(incl);
Jvxinc  = cos(az)*cos(incl);
Jvyr    = 0;
Jvyaz   = cos(az)*sin(incl);
Jvyinc  = cos(incl)*sin(az);
Jvzr    = 0;
Jvzaz   = 0;
Jvzinc  = sin(incl);


% Jxr     = cos(az)*sin(incl);
% Jxaz    = -r*sin(az)*sin(incl);
% Jxinc   = r*cos(az)*cos(incl);
% Jyr     = sin(az)*sin(incl);
% Jyaz    = r*cos(az)*sin(incl);
% Jyinc   = r*cos(incl)*sin(az);
% Jzr     =  cos(incl);
% Jzaz    = 0;
% Jzinc   = -r*sin(incl);
% 
% Jvxr    = 0;
% Jvxaz   = -sin(az)*sin(incl);
% Jvxinc  = cos(az)*cos(incl);
% Jvyr    = 0;
% Jvyaz   = cos(az)*sin(incl);
% Jvyinc  = cos(incl)*sin(az);
% Jvzr    = 0;
% Jvzaz   = 0;
% Jvzinc  = -sin(incl);

jacobian(iVec.x,[iVec.r,iVec.az,iVec.incl]) = [ Jxr,  Jxaz,   Jxinc];
jacobian(iVec.y,[iVec.r,iVec.az,iVec.incl]) = [ Jyr,  Jyaz,   Jyinc];
jacobian(iVec.z,[iVec.r,iVec.az,iVec.incl]) = [ Jzr,  Jzaz,   Jzinc];

% Velocities:
% jacobian(iVec.vx,[iVec.r,iVec.az,iVec.incl]) = [ Jvxr,  Jvxaz,   Jvxinc];
% jacobian(iVec.vy,[iVec.r,iVec.az,iVec.incl]) = [ Jvyr,  Jvyaz,   Jvyinc];
% jacobian(iVec.vz,[iVec.r,iVec.az,iVec.incl]) = [ Jvzr,  Jvzaz,   Jvzinc];
jacobian(iVec.velocity, [iVec.r,iVec.az,iVec.incl]) = zeros(1,3);

% 
% [ cos(az)*sin(incl), -r*sin(az)*sin(incl), r*cos(az)*cos(incl)]
% [ sin(az)*sin(incl),  r*cos(az)*sin(incl), r*cos(incl)*sin(az)]
% [         cos(incl),                    0,        -r*sin(incl)]
% [                 0,   -sin(az)*sin(incl),   cos(az)*cos(incl)]
% [                 0,    cos(az)*sin(incl),   cos(incl)*sin(az)]
% [                 0,                    0,          -sin(incl)]


end

