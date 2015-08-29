function [f_ref, movie_frames] = plot_property( obj, property_name, time_vec, MOVIE_FLAG )

if nargin < 2
    time_vec = 1:obj.num_samples;
    xlabel_str = 'Number of samples';
    
    MOVIE_FLAG = 0;
else
    xlabel_str = 'Time, t [s]';
end;
switch property_name
    case 'range'
        ylabel_str = 'Range, r_t [m]';
    case 'azimuth'
        ylabel_str = 'Azimuth, \phi_t [rad]';
    case 'inclination'
        ylabel_str = 'Inclination, \theta_t [rad]';
    case 'x'
        ylabel_str = 'East position, x [m]';
    case 'y'
        ylabel_str = 'North position, y [m]';
    case 'z' 
        ylabel_str = 'Up/down position, z [m]';
    otherwise
        ylabel_str = property_name;
end;

est_legend_flag = 0;
truth_legend_flag = 0;
doa_legend_flag = 0;
legend_handles = [];
legend_str = {};

f_ref = figure; hold on;
movie_frames(obj.num_samples) = struct('cdata',[],'colormap',[]);
for time_ind = 1 : obj.num_samples,
    for speaker_ind = 1 : obj.data(time_ind).num_speakers,
        % Plot state
        if ~isempty(obj.data(time_ind).speaker(speaker_ind).(property_name)),
            h = plot(time_vec(time_ind), obj.data(time_ind).speaker(speaker_ind).(property_name), ...
                'marker', obj.data(time_ind).speaker(speaker_ind).marker, 'color', obj.data(time_ind).speaker(speaker_ind).colour);

            if obj.data(time_ind).speaker(speaker_ind).isEstimate && est_legend_flag == 0,
                legend_handles = [legend_handles, h];
                legend_str{end+1} = 'Estimate';
                est_legend_flag = 1;
            end
            if obj.data(time_ind).speaker(speaker_ind).isTruth && truth_legend_flag == 0,
                legend_handles = [legend_handles, h];
                legend_str{end+1} = 'Truth';
                truth_legend_flag = 1;
            end;
            if obj.data(time_ind).speaker(speaker_ind).isObservation && doa_legend_flag == 0,
                legend_handles = [legend_handles, h];
                legend_str{end+1} = 'DoA';
                doa_legend_flag = 1;
            end;
        end;
    end;
    if time_ind == 1,
        grid on;
        xlabel(xlabel_str);
        ylabel(ylabel_str);

        % Set x axis to full time_vec
        v = axis;
        v(2) = time_vec(end);

        % Set y axis to [0,2pi] for az or [0,pi] for incl
        if strcmp(property_name, 'azimuth'),
            v(4) = 2*pi;
            v(3) = 0;
        elseif strcmp(property_name, 'inclination'),
            v(4) = pi;
            v(3) = 0;
        else
            all_speakers = [obj.data(:).speaker];
            all_props = [all_speakers(:).(property_name)];
            max_props = max(all_props,[],2);
            min_props = min(all_props,[],2);
            v(4) = max_props;
            v(3) = min_props;
        end
        
        axis(v);
    end;
    
    set(gca,'FontSize',18)
    set(findall(gcf,'type','text'),'FontSize',18)
    set(gcf,'color','w');
    
    if MOVIE_FLAG
        drawnow;
        movie_frames(time_ind) = getframe(f_ref);
    end;
end
% legend(legend_handles, legend_str, 'Location', 'Best');

end