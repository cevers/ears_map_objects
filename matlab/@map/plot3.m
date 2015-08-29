function f_ref  = plot3( obj, room_dim, f_ref )

iVec = vector_indices;

%% Setup figure

if exist( 'f_ref', 'var' ) && ~isempty( f_ref )
    figure(f_ref);
else
    f_ref = figure;
    h = plot3(0,1,1); hold on;
    delete(h);
    axis([0, room_dim(iVec.x), 0 room_dim(iVec.y), 0, room_dim(iVec.z)]);
    grid on;
    
    % Labels
    xlabel('East, x [m]');
    ylabel('North, y [m]');
    zlabel('Up, z [m]');
    
    title('Map plot')
end;

%% Plot estimate source directions

% NAO object trajectory:

f_ref = obj.NAO.plot3( room_dim, f_ref );

% track object trajectory:
NAO_pos([iVec.x,iVec.y,iVec.z],1) = [obj.NAO.x; obj.NAO.y; obj.NAO.z];
for speaker_ind = 1 : obj.num_speakers,
    f_ref = obj.speaker(speaker_ind).plot3(room_dim, f_ref, 'reference_point', NAO_pos, 'sensor_orientation', obj.NAO.orientation);
end;

end