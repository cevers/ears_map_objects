function node = set_node_attributes(node, attributes)
%
% Purpose:              Parse through attributes of XML node
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

num_attributes = length( attributes );
for att_ind = 1 : num_attributes,
    % Need to explicitly write name and value into separate value,
    % otherwise setAttribute is in a huff:
    Name = attributes(att_ind).Name;
    Value = attributes(att_ind).Value;
    node.setAttribute( Name, Value );
end;

return;