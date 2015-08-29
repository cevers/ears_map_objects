function [f_ref, movie_frames] = plot_confidence_property( obj, property_name, time_vec, MOVIE_FLAG )

iVec = vector_indices;

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

est_legend_flag     = 0;
truth_legend_flag   = 0;
doa_legend_flag     = 0;
legend_handles      = [];
legend_str          = {};
FaceAlpha           = 0.5;


switch property_name,
    case {'x', 'y', 'z'},
        coordinate_frame = 'cartesian';
    case {'range', 'azimuth', 'inclination'}  
        coordinate_frame = 'spherical';
    otherwise
        error('Requested property not available');
end

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
    
    % Extract covariance for all estimates:
    all_speakers = [obj.data(1:time_ind).speaker];
    all_estimates = find([all_speakers(:).isEstimate] == 1);
    property_val = [all_speakers(all_estimates).(property_name)].';
    property_time = [all_speakers(all_estimates).time].';
    
    if ~isempty(all_estimates),
        cov_val = zeros(all_speakers(all_estimates(end)).order, all_speakers(all_estimates(end)).order, length(all_estimates));
        if strcmp(coordinate_frame, 'spherical'),
            for est_ind = 1 : length(all_estimates)
                cov_val(:,:,est_ind) = all_speakers(all_estimates(est_ind)).covariance_spherical;
            end;
        elseif strcmp(coordinate_frame, 'cartesian'),
            for est_ind = 1 : length(all_estimates)
                cov_val(:,:,est_ind) = all_speakers(all_estimates(est_ind)).covariance_cartesian;
            end;
        end;        
        
        % Extract confidence interval for property:
        property_cov =  2*sqrt(squeeze(cov_val(iVec.(property_name), iVec.(property_name),:)));
        
        % Create patch object for plotting:
        x_fill = [property_time; flipud(property_time)];
        cov_fill = [property_val+property_cov; flipud(property_val-property_cov)];
        
        % Plot fill-plot:
        h = fill( x_fill, cov_fill, obj.data(time_ind).speaker(speaker_ind).colour, 'FaceAlpha', FaceAlpha, ...
            'EdgeColor', obj.data(time_ind).speaker(speaker_ind).colour);
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