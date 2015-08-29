function [h_mean, h_conf] = plot_confidence( x, mean, cov, varargin)
%plot_confidence    Plot confidence interval
%
% Purpose:              
%
% Method:               
%
% Known issues:         NA
%
% Revision history:
%   2014/08/28, CE, v1.0:   Stable working baseline
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
%   N/A
%**************************************************************************

%% Default parameters
%
color = 'k';
marker = '-x';
FaceAlpha = 0.5;

axes_handle = gca;

%% Optional parameters
%
if nargin > 2
    if mod(length(varargin),2) ~= 0
        error('Optional parameters must be specified as pair of parameter name and value');
    end;
    
    for var_ind = 1 : 2 : length(varargin)
        assign( varargin{var_ind}, varargin{var_ind+1} );
    end;
end
FaceColor = color;
EdgeColor = color;

if size(x,1) == 1 && size(x,2) > 1,
    x = x';
end;
if size(cov,1) == 1 && size(cov,2) > 1,
    cov = cov';
end;
if size(mean,1) == 1 && size(mean,2) > 1,
    mean = mean';
end;

% There appears to be a bug with fill in that areas of 0 cannot be plotted.
% The limit is roughly 1e-10 tested by hacking cov until fill plots the
% correct interval. If any values are below 1e-10, add a fudge factor to
% cov here:
thresh = eps;
if ~isempty( find( cov < thresh, 1 ) )
    cov = cov + thresh;
end;

%% Plot
%
% Plot mean:
h_mean = plot( x, mean, marker, 'color', color );

% Plot confidence interval:
x_fill = [x; flipud(x)];

cov_fill = [mean+cov; flipud(mean-cov)];

h_conf = fill( x_fill, cov_fill, FaceColor, 'FaceAlpha', FaceAlpha, 'EdgeColor', EdgeColor, 'Parent', axes_handle);

return