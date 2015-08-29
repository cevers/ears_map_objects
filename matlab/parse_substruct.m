function node = parse_substruct( node, docNode, branch )
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

num_leaves = length(branch);
for leaf_ind = 1 : num_leaves,
    leaf = docNode.createElement(branch(leaf_ind).Name);
    leaf = set_node_attributes(leaf, branch(leaf_ind).Attributes);
    
    % If branch is the last leaf on the tree, write Data into Element:
    if ~isempty( branch(leaf_ind).Data )
        textleaf = docNode.createTextNode(branch(leaf_ind).Name);
        Data = branch(leaf_ind).Data;
        textleaf.setData( Data );
        
        leaf.appendChild(textleaf);
    elseif ~isempty( branch(leaf_ind).Children )
        % If branch contains children, recursively parse through branch:
        leaf = parse_substruct( leaf, docNode, branch(leaf_ind).Children );
    else
        error('No data and no Children available. Empty element?');
    end;
    
    node.appendChild(leaf);
end;

end

