function [f_ref, movie_frames] = birds_view( obj, room_dim, f_ref, MOVIE_FLAG )

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
    view([0,90]);

    % Labels
    xlabel('East, x [m]');
    ylabel('North, y [m]');
    zlabel('Up, z [m]');
    
    title('Map plot')
end;

%% Plot estimate source directions

movie_frames(obj.num_samples) = struct('cdata',[],'colormap',[]);
alpha_vec = linspace(0,1,obj.num_samples);
rem_ind = [];
for time_ind = 1 : obj.num_samples,
    if ~isempty( obj.data(time_ind).NAO ),
        % NAO object trajectory:
        figure(f_ref); hold on;
        f_ref = obj.data(time_ind).NAO.plot3( room_dim, f_ref );
        
        for speaker_ind = 1 : obj.data(time_ind).num_speakers,
            old_colour = obj.data(time_ind).speaker(speaker_ind).colour;
            if sum(obj.data(time_ind).speaker(speaker_ind).colour) == 0,
                obj.data(time_ind).speaker(speaker_ind).colour = obj.data(time_ind).speaker(speaker_ind).colour + alpha_vec(time_ind);
            else
                obj.data(time_ind).speaker(speaker_ind).colour = obj.data(time_ind).speaker(speaker_ind).colour * alpha_vec(time_ind);
            end;
            f_ref = obj.data(time_ind).speaker(speaker_ind).plot3(room_dim, f_ref, 'reference_point', obj.data(time_ind).NAO.position);
            
            obj.data(time_ind).speaker(speaker_ind).colour = old_colour;
        end;
        
        if MOVIE_FLAG
            drawnow;
            movie_frames(time_ind) = getframe(f_ref);
        end;
    else
        rem_ind(end+1) = time_ind;
    end;
end;

% Remove empty movie frames:
movie_frames(rem_ind) = [];


end