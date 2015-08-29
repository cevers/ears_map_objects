%% Test 2 - Plotting
%
% Plot objects from example map:

global iVec

iVec = vector_indices;

num_samples = 100;
order = 3;
time_step = 0.1;
time_vec = cumsum( time_step*ones(num_samples,1));
track.vx = 0.2;
track.vy = 0.2;
track.vz = 0;
NAO.vx = 0.5;
NAO.vy = 0.5;
NAO.vz = 0;

% Generate trajectory of speaker positions:
F = eye(order);
Q = 0.001 * eye(order);
speaker_velocity([iVec.x,iVec.y,iVec.z],1) = [track.vx, track.vy, track.vz]';
NAO_velocity([iVec.x,iVec.y,iVec.z],1) = [NAO.vx, NAO.vy, NAO.vz]';

speaker_trajectory = position_trajectory(num_samples, order, time_vec, F, Q, speaker_velocity, [5; 5; 1.0] );
NAO_trajectory = position_trajectory(num_samples, order, time_vec, F, Q, NAO_velocity, [2;2;0.8] );

speaker_trajectory_absolute = speaker_trajectory + NAO_trajectory;
room_dim = [max([speaker_trajectory_absolute(iVec.x,:),NAO_trajectory(iVec.x,:)]);
            max([speaker_trajectory_absolute(iVec.y,:),NAO_trajectory(iVec.y,:)]);
            max([speaker_trajectory_absolute(iVec.z,:),NAO_trajectory(iVec.z,:)])];

num_objects = 2;        % track + NAO

%% Plot NAO
        
NAO_settings = {'order', order, 'ID', 1, 'coordinateSystem', 'cartesian', 'colour', [0 1 0]};

newmap = mapTrajectory(num_samples);

% Write trajectories to mapTrajectory:
for time_ind = 1 : num_samples,
    newmap.data(time_ind).add_feature( 'NAO', NAO_settings );
    newmap.data(time_ind).NAO.position = NAO_trajectory(:,time_ind);
end;

% Plot NAO path:
f_ref = [];
newmap.plot3(room_dim, f_ref);

%% Plot speaker

speaker_settings = {'order', order, 'ID', 1, 'coordinateSystem', 'cartesian', 'colour', [1 1 0]};

% Write trajectories to mapTrajectory:
speaker_ind = 1;
for time_ind = 1 : num_samples,
    newmap.data(time_ind).add_feature('speaker', speaker_settings);
    newmap.data(time_ind).speaker(speaker_ind).position = speaker_trajectory(:,time_ind);
end;

% Test that speakers cannot be added to map directly (without usign
% add_feature)
try 
    newmap.data(time_ind).speaker(end+1) = mapFeature();
    disp('Feature added manually. Something is wrong.');
catch
    disp('Feature cannot be added manually. All fine.');
end;

% Test that properties can, however, be modified once added to the map
try
    newmap.data(time_ind).speaker(end).position = randn( size(newmap.data(time_ind).speaker(end).position) );
    disp('Feature property modified manually. All fine.');
catch
    disp('Feature property cannot be modified manually. Something is wrong.');
end;
    
% Plot NAO path:
f_ref = [];
newmap.plot3(room_dim, f_ref);

%% Plot movie

newmap.movie('plot3', room_dim);

%% Plot individual properties

sphericals = {'range', 'azimuth', 'inclination'};
cartesians = {'x', 'y', 'z'};

% NAO's spherical coordinates:
for sph_ind = 1 : length(sphericals),
    newmap.plot2( [], 'speaker', 1, sphericals{sph_ind} );
end;

for cart_ind = 1 : length(cartesians),
    newmap.plot2( [], 'speaker', 1, cartesians{cart_ind} );
end;

