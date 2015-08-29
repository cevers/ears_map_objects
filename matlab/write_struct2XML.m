function write_struct2XML( xmlStruct, tempname )
%
% Purpose:              Write map to XML file from Matlab structure
%
% Method:               Recursively parses through Matlab structure
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

% Create XML node and root:
docNode = com.mathworks.xml.XMLUtils.createDocument(xmlStruct(1).Name);

% Create map node:
docMapNode = docNode.getDocumentElement;
docMapNode = set_node_attributes(docMapNode, xmlStruct(1).Attributes);

docMapNode = parse_substruct( docMapNode, docNode, xmlStruct(1).Children );

xmlFileName = [tempname,'.xml'];
xmlwrite(xmlFileName,docNode);
type(xmlFileName);

end

