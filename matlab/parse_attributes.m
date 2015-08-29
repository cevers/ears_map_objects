function attributes = parse_attributes(node)
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

attributes = [];
if node.hasAttributes
   theAttributes = node.getAttributes;
   numAttributes = theAttributes.getLength;
   allocCell = cell(1, numAttributes);
   attributes = struct('Name', allocCell, 'Value', ...
                       allocCell);

   for count = 1:numAttributes
      attrib = theAttributes.item(count-1);
      attributes(count).Name = char(attrib.getName);
      attributes(count).Value = char(attrib.getValue);
   end
end

return;