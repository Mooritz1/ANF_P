%% Vorlage Initialisierungsskript
% Dieses Skript soll zu Beginn die nötigen Variablen und Matlabskripte
% aufrufen, die das Simulinkmodell benötigt, um das Automated Valet Parking
% zu starten. Anschließend soll das Skript das Simulinkmodell aufrufen und
% starten.
%--------------------------------------------------------------------------
%% Aufruf der benötigten Daten
% Es ist hilfreich zu Beginn die Befehle "clc" und "clear" aufzurufen.
% Diese sorgen dafür, dass alle Meldungen aus dem Command Window
% und alle gespeicherten Werte aus dem Workspace gelöscht werden.

% Der eigentliche Code beginnt mit dem Laden der Datei "routePlanSL.mat".
% Diese Datei enthält die Start- und EndPosen sowie Attribute,
% die später vom Behavior Planner verarbeitet werden. Ein Aufruf dieser
% Datei ist durch den Befehl "data = load('Dateiname');" möglich.
% Um den routePlan direkt in den Workspace zu bekommen, ist zusätzlich der
% Befehl 'routePlan = data.routePlan;' zu tätigen. Dies liegt daran, dass
% die Tabelle mit den Posen in einem struct in der Datei "routePlanSL.mat"
% liegt.

% Als nächstes sollte die Costmap geladen werden. Dies ist durch den Aufruf
% der bereits erstellten function aus Aufgabe 1 möglich.

% Das Simulinkmodell benötigt weiterhin die startPose aus dem routePlan.
% Dadurch dass der routePlan zuvor schon geladen wurde, kann die startPose
% automatisch entnommen werden. Der routePlan besteht aus einer Tabelle.
% Durch die Eingabe der zuvor definierten Bezeichnung dieser Tabelle lassen
% sich alle Daten auf einmal aufrufen. 
% Für den Aufruf einzelner Werte aus dieser Tabelle lautet 
% der Befehl: "Tabellenbezeichnung.Spaltenbezeichnung(Zeilennummer,
% Spaltennummer);" 

% Zusätzlich muss auch noch eine helper-Datei geladen werden. Dies ist
% durch den einfachen Aufruf 'helperCreateBus' möglich. Diese
% helper Datei ermöglicht später die Weitergabe von Signalen zwischen den
% eizelnen Simulink-Blöcken in Form von Bus Signalen.

%% Simulationsstart
% Für das Öffnen des Simulinkmodells kann der Befehl "open_system(obj)"
% getätigt werden. Das "obj" ist in dem Fall die Simulink-Datei
% (.slx-Datei)

% Nach dem Öffnen des Simulinkmodells müssen die Parameter aktualisiert
% werden. Dies geschieht durch den
% Befehl "set_param(object,parameter1,value1,...,parameterN,valueN)". Hilfe
% zu diesem Befehl finden Sie unter Rechtsklick auf dem Befehl 'Help on
% "set_param"'. In dieser Beschreibung finden Sie unter 
% "After you set parameters in the MATLAB workspace, to see the changes 
% in a model, update the diagram." eine Hilfestellung.

% Durch den Befehl "sim('object');" wird die Simulation automatisch
% gestartet.

clc;
clear all;

% Laden des routePlan
data = load('routePlanSL.mat');
routePlan = data.routePlan;

% Aufruf der Costmap-Funktion, die in Aufgabe 1 erstellt wurde
costmap = VorlageCostmapErstellen();

% Extrahieren der Startpose
% (Nimmt die X, Y und Theta Werte aus der ersten Zeile der StartPose Spalte)
startPose = [routePlan.StartPose(1,1), routePlan.StartPose(1,2), routePlan.StartPose(1,3)];

% Fahrzeugdimensionen aus Costmap holen
vehDims = costmap.CollisionChecker.VehicleDimensions;

%Für Aufgabe 5
% Dynamische Parameter für Lateral Controller Stanley (Dynamic bicycle model)
lf   = vehDims.FrontOverhang + (vehDims.Wheelbase / 2);  % CoM → Vorderachse
lr   = vehDims.RearOverhang  + (vehDims.Wheelbase / 2);  % CoM → Hinterachse

% Aufruf der helper-Datei zur Erstellung der Bus-Signale
helperCreateBus;

%% Simulationsstart
% Simulink-Modell öffnen
open_system('AutomatedValetParking.slx');

% Simulink Diagramm updaten, damit die geladenen Workspace-Variablen ins Modell übernommen werden
set_param('AutomatedValetParking', 'SimulationCommand', 'update');
