classdef map < hgsetget
    
    properties (SetAccess = private, GetAccess = public)
        % NOTE: Need to make sure that assigned_IDs and assigned_trackIDs
        % are updated if ID is written to mapFeature object directly.
        assigned_IDs
        assigned_trackIDs
        NAO@mapFeature
        speaker@mapFeature        
    end
    
    properties (Dependent=true)
        num_speakers
    end
    
    methods
        function obj = map()
            obj.NAO = mapFeature.empty();
            obj.speaker = mapFeature.empty();
        end
        
        %% Getters
        function num_speakers = get.num_speakers( obj )
            num_speakers = length(obj.speaker);
        end;
        
        %% Custom
        
        function obj = add_feature( obj, feature_type, settings )
            if strcmp(feature_type,'NAO') && ~isempty(obj.NAO),
                error('The map already contains a NAO object.');
            end;
                
            obj.(feature_type)(end+1) = mapFeature();
            
            if nargin == 3,
                obj.(feature_type)(end) = obj.(feature_type)(end).init( settings );
            end;
            
            % Set unique ID:
            ID = 1;
            if ~isempty(obj.assigned_IDs)
                ID = obj.assigned_IDs(end) + 1;
            end
            obj.(feature_type)(end).ID = ID;
            obj.assigned_IDs = [obj.assigned_IDs; ID];
        end;
                
        function new_obj = get_speaker( obj, ID, ID_type )
            % Function can extract either ID or trackID, specified by
            % ID_type. Default to ID:
            if nargin == 2,
                ID_type = 'ID';
            end;
            
            new_obj = [];
            for speaker_ind = 1 : length( obj.speaker ),
                if obj.speaker(speaker_ind).(ID_type) == ID,
                    new_obj = map();
                    new_obj.add_feature( 'speaker' );
                    new_obj.speaker = obj.speaker(speaker_ind);

                    % IDs are unique, break once identified:
                    return;
                end;
            end
        end
        
        function new_obj = get_NAO( obj )
            new_obj = [];
            if ~isempty( obj.NAO ),
                new_obj = map();
                new_obj.add_feature( 'NAO' );
                new_obj.NAO = obj.NAO;
            end;
        end
        
        %% Recording
        %
        % Write mapFeature trajectory to XML file
        write_XML( obj, filename );

    end
end