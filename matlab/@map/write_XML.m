function write_XML( obj, filename )

%% Class to struct
%
% xmlStruct is a linear structure, i.e., not nested. Convert all children
% to map objects and create structure of objects:
if isempty(obj.NAO)
    disp('Nothing to write. map object is empty.');
    return
else
    num_mapObjects = obj.num_speakers + 1;
end;

%% Setup structure
base_struct = struct( 'Name', '', 'Attributes', [], 'Data', '');

xmlStruct = base_struct;
xmlStruct.Name                  = 'map';
xmlStruct.Attributes(1).Name    = 'date';
xmlStruct.Attributes(1).Value   = datestr(now);
xmlStruct.Attributes(2).Name    = 'version';
xmlStruct.Attributes(2).Value   = obj.NAO.version;

xmlStruct.Children(1:num_mapObjects) = base_struct;

%% Extract properties of class map that are public and not dependent:
meta_obj        = ?mapFeature;
meta_properties = meta_obj.PropertyList;
meta_names      = {meta_properties(:).Name};
meta_getaccess  = {meta_properties(:).GetAccess};
meta_dependent  = [meta_properties(:).Dependent];

% Indices of private, dependent and public properties:
ind_private     = find(strcmp(meta_getaccess, 'private'));
ind_dependent   = find(meta_dependent);
ind_public      = 1:length(meta_names);
ind_public(ind_private) = [];

fields = [meta_names(ind_public)];
num_fields = length(fields);

%% Write NAO position
xmlStruct.Children(1).Name = 'mapObject';
xmlStruct.Children(1).Attributes.Name = 'objectID';
xmlStruct.Children(1).Attributes.Value = ['NAO_', num2str(1)];

xmlStruct.Children(1).Children(1:num_fields) = base_struct;

for field_ind = 1 : num_fields,
    xmlStruct.Children(1).Children(field_ind).Name = fields{field_ind};
    xmlStruct.Children(1).Children(field_ind).Data = mat2str(obj.NAO.(fields{field_ind}));
    xmlStruct.Children(1).Children(field_ind).Children = '';
end;

%% Assign all public and non-dependent properties
for map_ind = 2 : num_mapObjects,
    xmlStruct.Children(map_ind).Name = 'mapObject';
    xmlStruct.Children(map_ind).Attributes.Name = 'objectID';
    xmlStruct.Children(map_ind).Attributes.Value = ['track_', num2str(map_ind-1)];
    
    xmlStruct.Children(map_ind).Children(1:num_fields) = base_struct;
    
    for field_ind = 1 : num_fields,
        xmlStruct.Children(map_ind).Children(field_ind).Name = fields{field_ind};
        xmlStruct.Children(map_ind).Children(field_ind).Data = mat2str(obj.speaker(map_ind-1).(fields{field_ind}));
        xmlStruct.Children(map_ind).Children(field_ind).Children = '';
    end;
end

%% Write struct to XML
% 

write_struct2XML( xmlStruct, filename );

end