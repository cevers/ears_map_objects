function nodeStruct = node2struct(node)
%
% Purpose:              Convert XML node to structure
%
% Method:               
%
% Known issues:         NA
%
% Revision history:
%   2014/04/10, CE, v1.0:   Baseline.
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

[children, data] = parse_child_nodes(node);

nodeStruct = struct(                        ...
   'Name', char(node.getNodeName),       ...
   'Attributes', parse_attributes(node),  ...
   'Data', '',                              ...
   'Children', '');

% If the current node is the last leaf in the tree, children is empty and
% data is nonempty. If more children are in the tree, children will be nonempty and data is empty.
if isempty(children),
    nodeStruct.Data = data;
elseif isempty(data),
    nodeStruct.Children = children;
else
    error('Neither children nor data returned.');
end;

return;