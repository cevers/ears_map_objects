classdef mapFeature <hgsetget
    %mapFeature
    %
    % Purpose:
    %
    % Method:
    %
    % Known issues:         NA
    %
    % Revision history:
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
    %**************************************************************************
    
    properties
        vx
        vy
        vz
        orientation = 0
        velocity
        
        version = '1.0';
    end
    
    properties (SetAccess = private, GetAccess = private)
        map_markers = 'o';
        map_coordinateSystems = {'cartesian', 'spherical'};
        map_colours = [1 0 0];
                
        iVec = vector_indices;
    end
        
    properties (Access  = private)
        privateOrder
        privateCoordinateSystem@char = 'cartesian';
        privateAzimuth@double
        privateInclination@double
        privateElevation@double
        privateRange@double
        privateX@double
        privateY@double
        privateZ@double
    end
    
    properties (Dependent)
        position
        order
        coordinateSystem
        
        azimuth
        inclination
        elevation
        range
        x
        y
        z
    end
    
    properties
        % Properties
        ID@uint32 scalar = 0;
        trackID@uint32 scalar = 0;
        observationID@uint32 scalar
        time@double
        soundURL@char
        
        % Object properties
        isMoving@uint32 scalar
        makesSound@uint32 scalar
        reflectsSound@uint32 scalar
        isVisible@uint32 scalar
        isPerson@uint32 scalar
        
        % Trajectory due to true target, the estimate or the observations:
        isTruth@uint32 scalar
        isEstimate@uint32 scalar
        isObservation@uint32 scalar
        
        % Spatial description - dependent on order. Set and get method available.
        isBearingOnly@uint32 scalar
        
        % Cartesian coordinates
        covariance@double matrix
       
        % Plot properties
        marker@char
        colour@double
    end
    
    properties (Dependent=true)
        isTrack@uint32 scalar
    end
    
    methods
        %% Constructor
        function obj = mapFeature(ID)
            if nargin == 0
                ID = 1;
            end;
            obj.ID      = ID;
            obj.marker  = obj.map_markers;
            obj.colour  = obj.map_colours;
        end
        
        %% Dependent variables
        
        function order = get.order(obj)
            order = obj.privateOrder;
        end

        function obj = set.order(obj, val)
            if val > 0 && mod(val,1) == 0,
                obj.privateOrder = val;
            else
                error('Order must be strictly positive integer.');
            end
        end
        
        %% Position
        % 
        % Reference function only. Gets / sets values from individual fields
        % depending on coordinate system. 

        function pos = get.position(obj)
            switch obj.coordinateSystem
                case 'spherical'
                    if ~obj.isBearingOnly,
                        pos([obj.iVec.az, obj.iVec.incl, obj.iVec.r], 1) = [obj.azimuth; obj.inclination; obj.range];
                    else
                        pos([obj.iVec.az,obj.iVec.incl],1) = [obj.azimuth; obj.inclination];
                    end;
                case 'cartesian'
                    pos([obj.iVec.x, obj.iVec.y, obj.iVec.z],1) = [obj.x; obj.y; obj.z];
                otherwise
                    error('Position cannot be extracted from specified coordinate system');
            end;
        end
        
        function obj = set.position(obj, val)
            if size(val,1) ~= obj.order || size(val,2) ~= 1,
                error(['Position must be of size [', num2str(obj.order), ',1]']);
            end;
            
            switch obj.coordinateSystem
                case 'spherical'
                    obj.privateAzimuth = val(obj.iVec.az,1);
                    obj.privateInclination = val(obj.iVec.incl,1);
                    
                    if ~obj.isBearingOnly,
                        obj.privateRange = val(obj.iVec.range,1);
                    else 
                        obj.privateRange = [];
                    end;
                    
                    [obj.privateX, obj.privateY, obj.privateZ] = mysph2cart(obj.privateAzimuth, obj.privateInclination, obj.privateRange);
                case 'cartesian'
                    obj.privateX = val(obj.iVec.x,1);
                    obj.privateY = val(obj.iVec.y,1);
                    obj.privateZ = val(obj.iVec.z,1);
                    
                    [obj.privateAzimuth, obj.privateInclination, obj.privateRange] = mycart2sph(obj.privateX, obj.privateY, obj.privateZ);
                otherwise
                    error('Position cannot be extracted from specified coordinate system');
            end;
        end
        
        %% Coordinate system
        %
        % Referenced by other properties. Routes via private property.
        
        function coordinateSystem = get.coordinateSystem(obj)
            coordinateSystem = obj.privateCoordinateSystem;
        end
        
        function obj = set.coordinateSystem(obj,val)
            type_ind = strcmp( val, obj.map_coordinateSystems );
            if sum( type_ind ) ~= 1
                error('Invalid coordinate system');
            end
            obj.privateCoordinateSystem = val;
        end
        
        %% Spherical coordinates
        
        function azimuth = get.azimuth(obj)
            azimuth = obj.privateAzimuth;
        end
        
        function inclination = get.inclination(obj)
            inclination = obj.privateInclination;
        end
        
        function elevation = get.elevation(obj)
            if isempty(obj.privateElevation),
                obj.privateElevation = pi/2 - obj.privateInclination;
            end;
            elevation = obj.privateElevation;
        end
        
        function range = get.range(obj)
            range = obj.privateRange;
        end
        
        function obj = set.azimuth(obj,val)            
            obj.privateAzimuth = val;

            % Update Cartesian position of object:
            [obj.privateX, obj.privateY, obj.privateZ] = mysph2cart(val, obj.inclination, obj.range);
        end
        
        function obj = set.inclination(obj,val)
            obj.privateInclination = val;
            obj.privateElevation = pi/2-val;
            
            % Update Cartesian position of object:
            [obj.privateX, obj.privateY, obj.privateZ] = mysph2cart(obj.azimuth, val, obj.range);
        end
        
        
        function obj = set.elevation(obj,val)
            obj.privateElevation = val;
            obj.privateInclination = pi/2-val;
            
            % Update Cartesian position of object:
            [obj.privateX, obj.privateY, obj.privateZ] = sph2cart(obj.azimuth, val, obj.range);
        end
        
        function obj = set.range(obj,val)
            obj.privateRange = val;
            
            % Update Cartesian position of object:
            [obj.privateX, obj.privateY, obj.privateZ] = mysph2cart(obj.azimuth, obj.inclination, val);
        end
        
        %% Cartesian coordinates
        %
        
        function x = get.x(obj)
            x = obj.privateX;
        end
        
        function y = get.y(obj)
            y = obj.privateY;
        end
        
        function z = get.z(obj)
            z = obj.privateZ;
        end
        
        function obj = set.x(obj, val)
            obj.privateX = val;
            
            % Update spherical position of object:
            [obj.privateAzimuth, obj.privateInclination, obj.privateRange] = mycart2sph( val, obj.y, obj.z );
            obj.privateElevation = pi/2 - obj.privateInclination;
        end
        
        function obj = set.y(obj, val)
            obj.privateY = val;
            
            % Update spherical position of object:
            [obj.privateAzimuth, obj.privateInclination, obj.privateRange] = mycart2sph( obj.x, val, obj.z );
            obj.privateElevation = pi/2 - obj.privateInclination;
        end
        
        function obj = set.z(obj, val)
            obj.privateZ = val;
            
            % Update spherical position of object:
            [obj.privateAzimuth, obj.privateInclination, obj.privateRange] = mycart2sph( obj.x, obj.y, val );
            obj.privateElevation = pi/2 - obj.privateInclination;
        end
           
        
        %% Setters
        
        function obj = set.vx(obj,val)
            obj.vx = val;
        end;
        
        function obj = set.vy(obj,val)
            obj.vy = val;
        end;
        
        function obj = set.vz(obj,val)
            obj.vz = val;
        end;
        
        function obj = set.orientation(obj,val)
            obj.orientation = val;
        end;
        
        function obj = set.isBearingOnly(obj,val)
            if val ~= 0 && val ~= 1
                error('Property isBearingOnly is a binary integer. Set to 0 (false) or 1 (true).');
            end;
            obj.isBearingOnly = val;
        end;
        
        function obj = set.isMoving(obj,val)
            if val ~= 0 && val ~= 1
                error('Property isMoving is a binary integer. Set to 0 (false) or 1 (true).');
            end
            obj.isMoving = val;
        end
        
        function obj = set.makesSound(obj,val)
            if val ~= 0 && val ~= 1
                error('Property makesSound is a binary integer. Set to 0 (false) or 1 (true).');
            end
            obj.makesSound = val;
        end
        
        function obj = set.reflectsSound(obj,val)
            if val ~= 0 && val ~= 1
                error('Property reflectsSound is a binary integer. Set to 0 (false) or 1 (true).');
            end
            obj.reflectsSound = val;
        end
        
        function obj = set.isVisible(obj,val)
            if val ~= 0 && val ~= 1
                error('Property isVisible is a binary integer. Set to 0 (false) or 1 (true).');
            end
            obj.isVisible = val;
        end
        
        function obj = set.isTruth(obj,val)
            if val ~= 0 && val ~= 1,
                error('Property isTruth is a binary integer. Set to 0 (false) or 1 (true).');
            end;
            obj.isTruth = val;
            
            if obj.isTruth && obj.isEstimate
                error('Object already specified as estimate, cannot set to truth.');
            elseif obj.isTruth && obj.isObservation
                error('Object already specified as observation, cannot set to truth.');
            end;
        end;
        
        function obj = set.isEstimate(obj,val)
            if val ~= 0 && val ~= 1,
                error('Property isEstimate is a binary integer. Set to 0 (false) or 1 (true).');
            end;
            obj.isEstimate = val;
            
            if obj.isEstimate && obj.isTruth
                error('Object already specified as truth, cannot set to estimate.');
            elseif obj.isEstimate && obj.isObservation
                error('Object already specified as observation, cannot set to estimate.');
            end;
        end;
        
        function obj = set.isObservation(obj,val)
            if val ~= 0 && val ~= 1,
                error('Property isObservation is a binary integer. Set to 0 (false) or 1 (true).');
            end;
            obj.isObservation = val;
            
            if obj.isObservation && obj.isEstimate
                error('Object already specified as estimate, cannot set to observation.');
            elseif obj.isObservation && obj.isTruth
                error('Object already specified as truth, cannot set to observation.');
            end;
        end;
        
        function isTrack = get.isTrack( obj )
            isTrack = ( obj.trackID ~= 0 );
        end
        
        %% Initialisation of mapFeature object
        obj = init(obj, settings);
        
        %% Conversion of covariance matrix between spherical and Cartesian
        function cov = covariance_cartesian(obj)
            if strcmp( obj.coordinateSystem, 'cartesian' ),
                cov = obj.covariance;
            else
                J = jacobian_sph2cart( obj.position(obj.iVec.azimuth), obj.position(obj.iVec.inclination), obj.position( obj.iVec.range) );
                cov = J * obj.covariance * J.';
            end
        end
        
        function cov = covariance_spherical(obj)
            iVec = vector_indices;
            if strcmp( obj.coordinateSystem, 'spherical' ),
                cov = obj.covariance;
            else
                J = jacobian_cart2sph( obj.position(obj.iVec.x), obj.position(obj.iVec.y), obj.position( obj.iVec.z) );
                J = J(iVec.pos_vec,iVec.pos_vec);
                cov = J * obj.covariance * J.';
            end
        end
        
        %% Plotting
        %
        f_ref = plot3( obj, f_ref, varargin );
        
    end
end