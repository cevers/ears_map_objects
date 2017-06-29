function f_ref = plot3( obj, room_dim, f_ref, varargin )
%   plot    Plots the object position in 3D

iVec = vector_indices;

%% Default settings

% Default reference point (assume origin of coordinate system. If relative
% to another point, e.g., to microphone, specify different reference point:
reference_point = zeros(obj.order,1);
sensor_orientation = 0;

% Default colour and transparency:
colour = obj.colour;
marker = obj.marker;

%% Setup additional parameters

num_argin = length(varargin);
if mod( num_argin, 2 ) ~= 0
    error('Invalid number of input arguments');
end

for arg_ind = 1 : 2 : num_argin
    % Assign variable value to variable name in this function workspace:
    assign( varargin{arg_ind}, varargin{arg_ind+1} );
end

%% Setup figure

if exist( 'f_ref', 'var' ) && ~isempty( f_ref )
    figure(f_ref);
else
    f_ref = figure;
    h = plot3(0,1,1); hold on;
    delete(h);
    axis([0,room_dim(iVec.x), 0 room_dim(iVec.y), 0, room_dim(iVec.z)]);
    grid on;
    
    % Labels
    xlabel('East, x [m]');
    ylabel('North, y [m]');
    zlabel('Up, z [m]');
    
    title('Map plot')
end

%% Plot estimate source directions

% If the object contains range & bearing, plot point. If this is a
% bearing-only object, plot a line:
if obj.isBearingOnly && strcmp(obj.coordinateSystem, 'spherical')
    % Plot vector that spans along the room:
    temp_range = 100;
    [x,y,z] = mysph2cart( obj.azimuth , obj.inclination, temp_range );
    absolute_position = relative2absolute([x;y;z], reference_point, sensor_orientation, iVec);
    absolute_position = [reference_point([iVec.x,iVec.y,iVec.z],1) absolute_position ];
    h_ref = line( absolute_position(iVec.x,:), absolute_position(iVec.y,:), absolute_position(iVec.z,:), 'marker', obj.marker );
elseif ~obj.isBearingOnly && strcmp(obj.coordinateSystem, 'spherical')
    % Compensate for reference position:
    [x,y,z] = mysph2cart( obj.azimuth, obj.inclination, obj.range );
    absolute_position = relative2absolute([x;y;z], reference_point, sensor_orientation, iVec);

    % Plot point:
    h_ref = plot3( absolute_position(iVec.x), absolute_position(iVec.y), absolute_position(iVec.z), marker );
else
    cart_position([iVec.x,iVec.y,iVec.z],1) = [obj.x;obj.y;obj.z];    
    cart_position_abs = relative2absolute(cart_position, reference_point, sensor_orientation, iVec);

    % Plot point:
    h_ref = plot3( cart_position_abs(iVec.x), cart_position_abs(iVec.y), cart_position_abs(iVec.z), marker );
end
set(h_ref, 'Color', colour);

end