function iVec = vector_indices( varargin )

iVec.x = 1;
iVec.y = 2;
iVec.z = 3;
% iVec.vx = 4;
% iVec.vy = 5;
% iVec.vz = 6;
iVec.velocity = 4;

iVec.az = 1;
iVec.incl = 2;
iVec.el = 2;
iVec.r = 3;
iVec.azimuth = iVec.az;
iVec.inclination = iVec.incl;
iVec.elevation = iVec.el;
iVec.range = iVec.r;

%% Disable invalid parameters in observtions or states

val_iVec = iVec;

if nargin ~= 0
    ind_settings = varargin{1};
    
    if mod(length(ind_settings),2) ~= 0,
        error('Each variable name in ind_settings must be followed by a value');
    end;
    for ind = 1 : 2 : length(ind_settings),
        var = ind_settings{ind};
        val = ind_settings{ind+1};

        % Disable variables:
        if ~val
            val_iVec.(var) = [];
        end;
    end;
end

iVec.pos_vec = [val_iVec.x; val_iVec.y; val_iVec.z];
% iVec.vel_vec = [val_iVec.vx; val_iVec.vy; val_iVec.vz];
iVec.obser_vec = [val_iVec.az; val_iVec.incl; val_iVec.r];
% iVec.state_vec = [val_iVec.x; val_iVec.y; val_iVec.z; val_iVec.vx; val_iVec.vy; val_iVec.vz];
iVec.state_vec = [val_iVec.x; val_iVec.y; val_iVec.z; val_iVec.velocity];

%% Image vector indices

iVec.im.width = 2;      % Columns in image
iVec.im.height = 1;      % Rows in image
iVec.im.depth = 3;      % Depth

%% Robot vector indices

iVec.NAO.x              = 1;
iVec.NAO.y              = 2;
iVec.NAO.z              = 3;
iVec.NAO.velocity       = 3;
iVec.NAO.pos_vec        = [iVec.NAO.x; iVec.NAO.y; iVec.NAO.z];
iVec.NAO.state_vec      = [iVec.NAO.x; iVec.NAO.y; iVec.NAO.velocity];


