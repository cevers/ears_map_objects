classdef mapTrajectory < hgsetget & visualize
    properties
        data@map
    end
    
    properties (Dependent=true)
        num_samples
    end
    
    methods
        %% Constructor
        function obj = mapTrajectory( num_samples, num_speakers )
            if nargin == 0,
                obj.data = map.empty();
            else
                for time_ind = 1 : num_samples,
                    if nargin == 2,
                        obj.data(time_ind) = map(num_speakers);
                    else
                        obj.data(time_ind) = map();
                    end;
                end;
            end;
        end
        
        %% Getters
        function num_samples = get.num_samples( obj )
            num_samples = length(obj.data);
        end
        
        %% Custom functions
        
        % Get trajectory of specified property
        function new_obj = get_speaker( obj, ID, ID_type )
            % Function can extract either ID or trackID, specified by
            % ID_type. Default to ID:
            if nargin == 2,
                ID_type = 'ID';
            end;
            
            % Returns an array of length num_samples containing one speaker
            % map each.
            obj_length = length(obj.data);
            
            new_obj = mapTrajectory;
            for time_ind = 1 : obj_length,
                % Check if speaker with the requested ID exists at this
                % time step and extract
                temp_data = obj.data(time_ind).get_speaker( ID, ID_type );
                
                % Could write the call to get_speaker directly into
                % new_obj.data(time_ind). By checking if temp_data is empty,
                % only populated data is written to the new_obj.
                % get_speaker may therefore return a "condensed" version of
                % obj. (E.g., obj.data may contain 100 samples, whereas
                % new_obj contains only 5).
                if ~isempty(temp_data),
                    new_obj.data(end+1) = temp_data;
                    
                    % Speaker position is relative to NAO, so attach NAO
                    % data to the speaker trajectory:
                    new_obj.data(end).add_feature('NAO', obj.data(time_ind).NAO );
                end;
            end;            
        end;
        
        function new_obj = get_NAO( obj )
            obj_length = length(obj.data);
            new_obj = mapTrajectory;
            for time_ind = 1 : obj_length,
                temp_data = obj.data(time_ind).get_NAO;
                if ~isempty(temp_data),
                    new_obj.data(end+1) = temp_data;
                end;
            end;
        end;
        
        %% Movie - 3D
%         movie_frames = movie(obj, plot_fct_name, room_dim)
        
        %% Replay
        %
        % Read mapFeature trajectory from XML file
        obj = read_XML( obj, filename );
        
        %% Recording
        %
        % Write mapFeature trajectory to XML file
        write_XML( obj, filename );
    end;
    
end