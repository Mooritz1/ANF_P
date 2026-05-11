function helperCreateBus(varargin) 

if nargin == 1
    is3DSimulation = varargin{1};
else
    is3DSimulation = false;
end

elemsSpeedConfig(1)                  = Simulink.BusElement;
elemsSpeedConfig(1).Name             = 'StartSpeed';
elemsSpeedConfig(1).Dimensions       = 1;
elemsSpeedConfig(1).DimensionsMode   = 'Fixed';
elemsSpeedConfig(1).DataType         = 'double';
elemsSpeedConfig(1).SampleTime       = -1;
elemsSpeedConfig(1).Complexity       = 'real';

elemsSpeedConfig(2)                  = Simulink.BusElement;
elemsSpeedConfig(2).Name             = 'EndSpeed';
elemsSpeedConfig(2).Dimensions       = 1;
elemsSpeedConfig(2).DimensionsMode   = 'Fixed';
elemsSpeedConfig(2).DataType         = 'double';
elemsSpeedConfig(2).SampleTime       = -1;
elemsSpeedConfig(2).Complexity       = 'real';

speedConfigBus                       = Simulink.Bus;
speedConfigBus.Elements              = elemsSpeedConfig;

elemsPlannerConfig(1)                = Simulink.BusElement;
elemsPlannerConfig(1).Name           = 'ConnectionDistance';
elemsPlannerConfig(1).Dimensions     = 1;
elemsPlannerConfig(1).DimensionsMode = 'Fixed';
elemsPlannerConfig(1).DataType       = 'double';
elemsPlannerConfig(1).SampleTime     = -1;
elemsPlannerConfig(1).Complexity     = 'real';

elemsPlannerConfig(2)                = Simulink.BusElement;
elemsPlannerConfig(2).Name           = 'MinIterations';
elemsPlannerConfig(2).Dimensions     = 1;
elemsPlannerConfig(2).DimensionsMode = 'Fixed';
elemsPlannerConfig(2).DataType       = 'double';
elemsPlannerConfig(2).SampleTime     = -1;
elemsPlannerConfig(2).Complexity     = 'real';

elemsPlannerConfig(3)                = Simulink.BusElement;
elemsPlannerConfig(3).Name           = 'GoalTolerance';
elemsPlannerConfig(3).Dimensions     = [1 3];
elemsPlannerConfig(3).DimensionsMode = 'Fixed';
elemsPlannerConfig(3).DataType       = 'double';
elemsPlannerConfig(3).SampleTime     = -1;
elemsPlannerConfig(3).Complexity     = 'real';

elemsPlannerConfig(4)                = Simulink.BusElement;
elemsPlannerConfig(4).Name           = 'MinTurningRadius';
elemsPlannerConfig(4).Dimensions     = 1;
elemsPlannerConfig(4).DimensionsMode = 'Fixed';
elemsPlannerConfig(4).DataType       = 'double';
elemsPlannerConfig(4).SampleTime     = -1;
elemsPlannerConfig(4).Complexity     = 'real';

if is3DSimulation
    elemsPlannerConfig(5)                = Simulink.BusElement;
    elemsPlannerConfig(5).Name           = 'IsParkManeuver';
    elemsPlannerConfig(5).Dimensions     = 1;
    elemsPlannerConfig(5).DimensionsMode = 'Fixed';
    elemsPlannerConfig(5).DataType       = 'boolean';
    elemsPlannerConfig(5).SampleTime     = -1;
    elemsPlannerConfig(5).Complexity     = 'real';
end

plannerConfigBus                     = Simulink.Bus;
plannerConfigBus.Elements            = elemsPlannerConfig;

clear elemsPlannerConfig;
assignin('base','speedConfigBus',   speedConfigBus);
assignin('base','plannerConfigBus', plannerConfigBus);