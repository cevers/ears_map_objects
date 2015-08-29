function xmlStruct = read_XML2struct( filename )
%
% Purpose:              Read map from XML file to Matlab structure
%
% Method:               Recursively parses through XML structure
%
% Known issues:         NA
%
% Revision history:
%   2014/06/19, CE, v1.0:   Baseline.
%       Change: N/A
%
% Matlab functions used:
%
% Own functions called:
%
% Input parameters:
%
% Internal parameters:
%
% Output parameters:
%
% References:
% 
%**************************************************************************

%% Read XML file:

xmlDoc = xmlread(filename);
    
%% Recursively  parse through file:
xmlStruct = parse_child_nodes(xmlDoc);

%% Fail safe for reading from manually generated xml files:
if strcmp(xmlStruct(1).Name, 'map') && isempty(xmlStruct(1).Attributes) && isempty(xmlStruct(1).Data) && isempty(xmlStruct(1).Children)
    xmlStruct(1) = [];
end;

end