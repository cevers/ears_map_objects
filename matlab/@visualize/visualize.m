classdef visualize < hgsetget
    properties
        f_ref           % figure reference
        movie_frames      % movie frames
    end
    
    methods
        %% Plot properties
        %
        % Compare property of all mapFeature objects in mapTrajectory over time
        [f_ref, movie_frames] = plot_property( obj, property_name, time_vec, MOVIE_FLAG )
        
        % Call plot_property to plot azimuth with time - can be used to
        % compare truth, estimates, and observations of property over time
        function [f_ref, movie_frames] = plot_azimuth( obj, time_vec, MOVIE_FLAG )
            [f_ref, movie_frames] = plot_property( obj, 'azimuth', time_vec, MOVIE_FLAG );
        end;
        
        % Call plot_property to plot azimuth with time - can be used to
        % compare truth, estimates, and observations of property over time
        function [f_ref, movie_frames] = plot_inclination( obj, time_vec, MOVIE_FLAG )
            [f_ref, movie_frames] = plot_property( obj, 'inclination', time_vec, MOVIE_FLAG );
        end;
        
        % Call plot_property to plot azimuth with time - can be used to
        % compare truth, estimates, and observations of property over time
        function [f_ref, movie_frames] = plot_range( obj, time_vec, MOVIE_FLAG )
            [f_ref, movie_frames] = plot_property( obj, 'range', time_vec, MOVIE_FLAG );
        end;
        
        function [f_ref, movie_frames] = plot_x( obj, time_vec, MOVIE_FLAG )
            [f_ref, movie_frames] = plot_property( obj, 'x', time_vec, MOVIE_FLAG );
        end;
        
        % Call plot_property to plot azimuth with time - can be used to
        % compare truth, estimates, and observations of property over time
        function [f_ref, movie_frames] = plot_y( obj, time_vec, MOVIE_FLAG )
            [f_ref, movie_frames] = plot_property( obj, 'y', time_vec, MOVIE_FLAG );
        end;
        
        % Call plot_property to plot azimuth with time - can be used to
        % compare truth, estimates, and observations of property over time
        function [f_ref, movie_frames] = plot_z( obj, time_vec, MOVIE_FLAG )
            [f_ref, movie_frames] = plot_property( obj, 'z', time_vec, MOVIE_FLAG );
        end;

        %% 3D plot of scene
        
        [f_ref, movie_frames] = plot3( obj, room_dim, f_ref, varargin )
        
        %% Birds-eye view of scene
        
        %% Plot confidence intervals of estimates
        %
        % 
        [f_ref, movie_frames] = plot_confidence_property( obj, property_name, time_vec, MOVIE_FLAG );
        
        % Call plot_confidence_property to plot azimuth with time - can be used to
        % compare truth, estimates, and observations of property over time.
        % Confidence interval will be plotted for mapFeatures with
        % isEstimate = 1 only.
        function [f_ref, movie_frames] = plot_confidence_azimuth( obj, time_vec, MOVIE_FLAG )
            [f_ref, movie_frames] = plot_confidence_property( obj, 'azimuth', time_vec, MOVIE_FLAG );
        end
        
        % Call plot_confidence_property to plot inclination with time - can be used to
        % compare truth, estimates, and observations of property over time.
        % Confidence interval will be plotted for mapFeatures with
        % isEstimate = 1 only.
        function [f_ref, movie_frames] = plot_confidence_inclination( obj, time_vec, MOVIE_FLAG )
            [f_ref, movie_frames] = plot_confidence_property( obj, 'inclination', time_vec, MOVIE_FLAG );
        end
        
        % Call plot_confidence_property to plot range with time - can be used to
        % compare truth, estimates, and observations of property over time.
        % Confidence interval will be plotted for mapFeatures with
        % isEstimate = 1 only.
        function [f_ref, movie_frames] = plot_confidence_range( obj, time_vec, MOVIE_FLAG )
            [f_ref, movie_frames] = plot_confidence_property( obj, 'range', time_vec, MOVIE_FLAG );
        end
    end
end