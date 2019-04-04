classdef RightArrow < handle
    %% This class holds the parameters required to draw a right-pointing arrow
    
    properties
        center_coor ; %This holds the value corresponding to the center coor where the arrow will be drawn
        top_point ;
        middle_point ;
        bottom_point ;
        color ;
        width = 5;
    end
    
    methods
        %Instantiation method
        function obj = RightArrow(center, color)
            obj.center_coor = center; %1 by 2 array
            obj.color = color; %1 by 3 array, or signular value for luminance
        end
        
        function getPoints(obj)
            obj.top_point = [obj.center_coor(1) - 0.75, obj.center_coor(2) + 0.75]; %relative to center point
            obj.middle_point = [obj.center_coor(1) + 0.75, obj.center_coor(2) + 0];
            obj.bottom_point = [obj.center_coor(1) - 0.75, obj.center_coor(2) - 0.75]; 
            
            %^ note that the coordinates are currently defined in CM (e.g., 0.75
            %cm difference from the center point, etc.). Might need to change
        end
    end
    
end

