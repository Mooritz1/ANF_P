function [NextGoal, speedConfig, plannerConfig] = requestManeuver(routePlanStruct, currentPose, currentSpeed)
% Dieses Script dient zur Bestimmung der nächsten Zielpose, der
% Geschwindigkeitsvorgaben und der Einstellungen für den RRT-Algorithmus.
% Dazu dienen die aktuelle Pose, der GoalIndex, die aktuelle Geschwindigkeit
% und der RoutePlan als Eingabedaten.
% Der Goalindex ist eine laufende Nummer, mit der nacheinander die
% entsprechende Zielpose aus dem RoutePlan entnommen wird.
% Ausgabedaten sollen die nächste Zielpose, die
% Geschwindigkeitseinstellungen und die Einstellung des RRT-Algorithmus
% sein.
% ----------------------------------------------------------------------------------------------------------
persistent GoalIndex
if isempty(GoalIndex)
    GoalIndex = 1;
end
numGoals = length(routePlanStruct);
%% Aufgabe 11
% Bestimmung der nächsten Zielpose und der RRT*-Einstellungen
[NextGoal, plannerConfig] = plannerSettings(routePlanStruct, GoalIndex, currentPose);

%% Aufgabe 12
% Geschwindigkeitseinstellun
speedConfig = speedSettings(routePlanStruct, GoalIndex, currentSpeed);

%% Aufgabe 11
% GoalIndex
dist = norm(currentPose(1:2) - NextGoal(1:2));
Toleranz = 0.8;
if dist < Toleranz
    if GoalIndex < numGoals
        GoalIndex = GoalIndex + 1;
    end
end

% Nach einer möglichen Erhöhung des GoalIndex sollen die Ausgabewerte
% erneut mit dem aktuellen GoalIndex bestimmt werden.
[NextGoal, plannerConfig] = plannerSettings(routePlanStruct, GoalIndex, currentPose);
speedConfig = speedSettings(routePlanStruct, GoalIndex, currentSpeed);
end
% --------------------------------------------------------------------------------------------------------
%% Aufgabe 11
% Function für die Bestimmung der nächsten Zielpose und den Einstellungen
% der RRT-Einstellungen
function [NextGoal, plannerConfig] = plannerSettings(routePlanStruct, GoalIndex, currentPose)
% Die Zielpose wird mithilfe des GoalIndex aus dem routePlanStruct
% entnommen. Dies ist mit dem Befehl routePlanStruct(Index).EndPose
% möglich.
%                                 |           |       |
%                            Variablenname  Zeilennr. Spalte
% ------------
NextGoal = routePlanStruct(GoalIndex).EndPose;

%% Aufgabe 13
% Einstellungen des RRT-Algorithmus
% Der RRT-Algorithmus hat mehrere Einstellungsmöglichkeiten, die die
% Genauigkeit der Routenführung beeinflussen. Diese Möglichkeiten umfassen
% die ConnectionDistance, MinIterations, GoalTolerance und
% MinTurningRadius.
% Für ein besseres Verständnis ist es ratsam sich die Beschreibung von
% Mathworks durchzulesen. Diese finden Sie unter:
% https://de.mathworks.com/help/driving/ref/pathplannerrrt.html?s_tid=srchtitle_support_results_1_pathplannerRRT
% Hier ist die Erstellung eines Structs empfehlenswert. Ein Struct lässt
% sich bilden indem man den Name des Structs aufruft und durch einen Punkt
% getrennt in derselben Zeile den eigentlichen Variablennamen aufruft.
% Beispiel:
% Structname.Variable_a = 5;
% Structname.Variable_b = 7;
% Dieser soll die genannten Variablen umfassen.
% ConnectionDistance = 10
% MinIterations = 1000
% GoalTolerance = [0.5, 0.5, 5]
% Die Bezeichnung der Variablen müssen mit den Namen aus dem Skript
% "helperCreateBus.m" übereinstimmen, damit diese später über den
% Bus übermittelt werden können.
plannerConfig.ConnectionDistance = 10;

plannerConfig.MinIterations = 1000;

plannerConfig.GoalTolerance = [0.5 0.5 5];

plannerConfig.MinTurningRadius = 20;

% --
% Für den Fall, dass gerade eine Parkmaneuver abläuft, soll die Abfrage
% gestellt werden, ob der GoalIndex gerade den höchstmöglichen Wert
% erreicht hat (letzte Zielpose im RoutePlan).
% Falls dies der Fall ist, soll gelten:
% GoalTolerance = [0.5 0.5 10]
% ConnectionDistance = 6

ParkManeuver = false;

if GoalIndex == length(routePlanStruct)

    ParkManeuver = true;

    plannerConfig.GoalTolerance = [0.5 0.5 10];

    plannerConfig.ConnectionDistance = 6;

end
% --
% Sobald die Distanz zum Zielpunkt den Wert 10m unterschreitet, soll die
% ConnectionDistance auf den Wert 6 reduziert werden.
dist = norm(currentPose(1:2) - NextGoal(1:2));

if dist < 10

    plannerConfig.ConnectionDistance = 6;

end
% --
% In den im RoutePlan enthaltenen Attributen ist zudem der Wert
% "TurnManeuver" enthalten. Dafür soll eine zweifache if-else-Schleife
% erstellt werden
% Da die Attribute nach der Umwandlung des routePlans in einem Struct in der
% Spalte "Attributes" liegen, werden diese über
% routePlanStruct(GoalIndex).Attributes aufgerufen.
TurnManeuver = 0;
if isfield(routePlanStruct(GoalIndex), 'Attributes')
    attr = routePlanStruct(GoalIndex).Attributes;
    if isstruct(attr)
        if isfield(attr, 'TurnManeuver')
            TurnManeuver = attr.TurnManeuver;
        end
    end
end

if TurnManeuver == 0
    plannerConfig.MinTurningRadius = 20;
else
    if ParkManeuver
        plannerConfig.MinTurningRadius = 4;
    else
        plannerConfig.MinTurningRadius = 5;
    end
end
end
% -------------------------------------------------------------------------------------------------------
%% Aufgabe 12
% Function für die Bestimmung der Geschwindigkeitseinstellungen
function speedConfig = speedSettings(routePlanStruct, GoalIndex, currentSpeed)
% Diese Function soll die Geschwindigkeitseinstellungen für den
% Velocity Profiler bestimmen.
% Die Werte sollen in einem Struct zusammengefasst werden, damit sie über
% einen Bus weitergegeben werden können.
% Die Variablennamen müssen mit den Einträgen aus "helperCreateBus.m"
% übereinstimmen.
speedConfig.StartSpeed = currentSpeed;

speedConfig.EndSpeed = 0;
% Falls im RoutePlan Attribute hinterlegt sind, sollen diese genutzt
% werden, um die Geschwindigkeitsvorgaben anzupassen.

if isfield(routePlanStruct(GoalIndex), 'Attributes')
    attr = routePlanStruct(GoalIndex).Attributes;
    if isstruct(attr)
        if isfield(attr, 'EndSpeed')
            speedConfig.EndSpeed = attr.EndSpeed;
        end
    end
end
% Falls sich das Fahrzeug bereits nahe am Ziel befindet, kann die
% Endgeschwindigkeit direkt angefordert werden.

dist = norm(routePlanStruct(GoalIndex).EndPose(1:2) - routePlanStruct(GoalIndex).EndPose(1:2));
if currentSpeed < speedConfig.EndSpeed

    speedConfig.EndSpeed = currentSpeed;
end
end
