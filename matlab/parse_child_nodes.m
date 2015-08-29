function [children, data] = parse_child_nodes(node)
%
% Purpose:              Parse through children of an XML node
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

children = [];
data = [];
if node.hasChildNodes
    childNodes = node.getChildNodes;
    
    % Identify child nodes that are XML elements rather than comments or
    % emtpy spaces:
    child_vec = [];
    for child_ind = 1 : childNodes.getLength,
        theChild = childNodes.item(child_ind-1);
        
        nodeName = char(theChild.getNodeName);
        if ~strcmp(nodeName, '#comment') && ~isempty(nodeName) && ~strcmp(nodeName, '#text'),
            child_vec(end+1) = child_ind;
        end;
    end;
    numChildNodes = length(child_vec);
    
    % If all child nodes are either a comment, empty or text but there are
    % valid child nodes:
    if numChildNodes == 0 && childNodes.getLength == 1,
        theChild = childNodes.item(0);
        nodeName = theChild.getNodeName;
        if strcmp(nodeName, '#text') && any(strcmp(methods(theChild), 'getData'))
            data = char(theChild.getData);
            return;
        end;
    end;
        
    % If the child/children are not the last leaf in the tree, continue
    % recursion:
    allocCell = cell(1, numChildNodes);
    children = struct(             ...
        'Name', allocCell, 'Attributes', allocCell,    ...
        'Data', allocCell, 'Children', allocCell);
    
    for count = 1:length(child_vec),
        theChild = childNodes.item(child_vec(count)-1);
        
        % Ensure only XML elements are included in structure and comments
        % are omitted. Comments contain prepended #-sign:
        children(count) = node2struct(theChild);
    end    
end

return;