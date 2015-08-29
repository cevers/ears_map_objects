function write_XML( obj, filename )

%% Class to struct
%
% xmlStruct is a linear structure, i.e., not nested. Convert all children
% to map objects and create structure of objects:
num_mapObjects = length(obj);

%% Setup structure
base_struct = struct( 'Name', '', 'Attributes', [], 'Data', '');

xmlStruct = base_struct;
xmlStruct.Name                  = 'map';
xmlStruct.Attributes(1).Name    = 'date';
xmlStruct.Attributes(1).Value   = datestr(now);
xmlStruct.Attributes(2).Name    = 'version';
xmlStruct.Attributes(2).Value   = obj(1).version;

xmlStruct.Children(1:num_mapObjects) = base_struct;

%% Extract properties of class map that are public and not dependent:
meta_obj        = ?map;
meta_properties = meta_obj.PropertyList;
meta_names      = {meta_properties(:).Name};
meta_getaccess  = {meta_properties(:).GetAccess};
meta_dependent  = [meta_properties(:).Dependent];

% Indices of private, dependent and public properties:
ind_private     = find(strcmp(meta_getaccess, 'private'));
ind_dependent   = find(meta_dependent);
ind_public      = 1:length(meta_names);
ind_public([ind_private,ind_dependent]) = [];

fields = [meta_names(ind_public)];
num_fields = length(fields);

%% Assign all public and non-dependent properties
for map_ind = 1 : num_mapObjects,
    xmlStruct.Children(map_ind).Name = 'mapObject';
    xmlStruct.Children(map_ind).Attributes.Name = 'objectID';
    xmlStruct.Children(map_ind).Attributes.Value = [obj(map_ind).type, '_', num2str(map_ind)];
    
    xmlStruct.Children(map_ind).Children(1:num_fields) = base_struct;
    
    for field_ind = 1 : num_fields,
        xmlStruct.Children(map_ind).Children(field_ind).Name = fields{field_ind};
        xmlStruct.Children(map_ind).Children(field_ind).Data = mat2str(obj(map_ind).(fields{field_ind}));
        xmlStruct.Children(map_ind).Children(field_ind).Children = '';
    end;
end

%% Write struct to XML
% 
write_struct2XML( xmlStruct, filename );

end