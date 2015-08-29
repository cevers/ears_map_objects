% test_map_readWrite_XML

%% Test 1 - Reading / writing of XML file

% Generate map object:
mymap = mapTrajectory();

xml_file = 'example_map.xml';

% Read pre-populated object from example XML file:
mymap = mymap.read_XML(xml_file);

% Change some parameters:
mymap(2).position = [10;5;3].* rand( size(mymap(2).position));

% Using direct access of dependent variable:
range = mymap(2).range;
disp(['Current range is: ', num2str(range), ' m.']);

% Using get:
range_get = get( mymap(2), 'range' );
disp(['Current range using get method is: ', num2str(range_get), ' m.']);

% Write back to XML:
mymap.write_XML('test_map_XML');