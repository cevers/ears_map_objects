function obj = init( obj, settings )
%init       Initialisation of map objects
%
% Purpose:              Initialise map object properties using settings
%
% Method:               NA
%
% Known issues:         NA
%
% Revision history:
%   1 August 2014, CE:      Baseline
%       Changes:            NA
%
% Matlab functions used:
%
% Own functions called:
%
% Input parameters:
%   obj:        Map object
%   settings:   1x2N Cell of settings of the form
%               settings = {propertyName_1, propertyValue_1, ..., propertyName_N, propertyValue_N };
%               propertyName_i is a property name as defined in 'map',
%               propertyValue_i is the value to set the property to.
%
% Output parameters:
%   obj:        Initialised map object.
%
% References:
%   NA
%**************************************************************************

%% Structure settings input
%
% Can be either cell or object.

if ~iscell( settings ) && ~isa( settings, 'mapFeature' ),
    error('Input settings must be either a cell or mapFeature');
end;

% If settings are provided as structure, ensure that each property name is
% followed by a property value:
if iscell( settings ),
    names = settings(1:2:end);
    vals = settings(2:2:end);
    
    if length(names) ~= length(vals),
        error('Invalid number of input arguments. Each settings name must have a corresponding value');
    end;
end;

%% Generate mapFeature from settings
%
% Allocate order first

if iscell(settings),
    order_ind = strcmp( names, 'order' );
    if sum(order_ind) == 1,
        obj.order = vals{ order_ind };
        
        % Remove from values / names:
        remaining_ind = 1:length(names);
        remaining_ind(order_ind) = [];
        names = names(remaining_ind);
        vals = vals(remaining_ind);
    end;
    
    for arg_ind = 1 : length(names),
        obj.(names{arg_ind}) = vals{arg_ind};
    end;
elseif isa( settings, 'mapFeature' ),
    fields = settings.fieldnames;
    obj.order = settings.order;
    
    % Remove "order" from fields:
    fields = setdiff(fields, 'order');
    
    % Choose which coordinate system to set the position in
    if strcmp(settings.coordinateSystem, 'spherical')
        obj.range = settings.range;
        obj.azimuth = settings.azimuth;
        obj.inclination = settings.inclination;
        obj.elevation = settings.elevation;        
    else
        obj.x = settings.x;
        obj.y = settings.y;
        obj.z = settings.z;    
    end;
    fields = setdiff(fields, {'range', 'azimuth', 'inclination', 'elevation', 'x', 'y', 'z', 'position'});
    
    for field_ind = 1 : length(fields),
        try
            obj.(fields{field_ind}) = settings.(fields{field_ind});
        catch
            % Skip properties that do not have set access (e.g. Dependent
            % properties)
        end;
    end;
end;

%% Check all dimensions are populated

if isempty(obj.order),
    error('Order must be specified.');
end;

% Initialisation of vectors / matrices required for read_XML functionality
% in map():
if isempty(obj.x) && isempty(obj.azimuth)
    obj.position = zeros(obj.order,1);
end;

if isempty(obj.covariance)
    obj.covariance = zeros(obj.order);
end;

end