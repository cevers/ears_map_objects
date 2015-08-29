function out_map = DOAcell2map( in_cell, mic_pos )

global iVec 

out_map = map();

% Specify NAO in 3D Cartesian space:
NAO_settings = {'order', 3, 'coordinateSystem', 'cartesian', 'position', mic_pos};
out_map.add_feature( 'NAO', NAO_settings );

% Speaker is bearing only relative to NAO:
speaker_settings = {'order', 2, 'isEstimate', 1, 'coordinateSystem', 'spherical', 'isBearingOnly', 1, 'makesSound', 1 };
for window_ind = 1 : length(in_cell),
    for speaker_ind = 1 : size(in_cell{window_ind}, 1),
        out_map.add_feature( 'speaker', speaker_settings );
        
        % Settings for speaker
        out_map.speaker(end).azimuth = in_cell{window_ind}(speaker_ind,iVec.az);
        out_map.speaker(end).inclination = in_cell{window_ind}(speaker_ind,iVec.incl);
    end;
end;