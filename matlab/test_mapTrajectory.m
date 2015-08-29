% test_mapMemory_getSpeaker

room_dim = 10*rand(3,1);

num_samples = 50;
max_num_speakers = 5;
order = 3;
NAO_settings = {'order', order, 'colour', [1 0 0], 'marker', 'x', 'coordinateSystem', 'cartesian'};
speaker_map_settings = {'order', order, 'colour', [0 1 0], 'marker', 'o', 'coordinateSystem', 'cartesian'};

myMap = mapTrajectory(num_samples);
disp('mapTrajectory after constructor: ');
disp(myMap)

%% Initialise NAO & speaker maps
%
% Results in traj. oflength num_samples, each containing 1 NAO and 1
% speaker field with settings as specified (otherwise set to default)

disp('Initial map object: ');
myMap.data(5)

%% Increase number of speakers in some of the time slots
%
% Pick random time slots, then increase number of speakers to random number

num_slots = 5;
time_slots = unique(randi(num_samples, num_slots, 1));
num_slots = length(time_slots);
num_speakers = randi(max_num_speakers, num_slots, 1);

for ind = 1:num_slots,
    time_ind = time_slots(ind);    
    
    % Add NAO:
    myMap.data(time_ind).add_feature('NAO', NAO_settings);
    myMap.data(time_ind).NAO.position = 5*rand(order,1);
    
    % Assign IDs to speakers
    for speaker_ind = 1 : num_speakers(ind),
        myMap.data(time_ind).add_feature( 'speaker', speaker_map_settings );
        myMap.data(time_ind).speaker(speaker_ind).position = 10*rand(order,1);
    end;
end;

disp('The following time slots were updated:');
for ind = 1 : num_slots,
    time_ind = time_slots(ind);
    
    disp(['Time ', num2str(time_ind), ' --> Number of speakers: ', num2str(num_speakers(ind))]);
    disp('Speaker IDs: ');
    for speaker_ind = 1 : num_speakers(ind),
        disp(myMap.data(time_ind).speaker(speaker_ind).ID);
    end;
    disp('NAO position:');
    disp(myMap.data(time_ind).NAO.position)
end;

%% Extract trajectory of one speaker

speaker_ID = 2;
mySpeaker = myMap.get_speaker( speaker_ID );

%% Plot mapTrajectory for myMap and mySpeaker

f_ref = [];
mySpeaker.plot3( room_dim, f_ref );