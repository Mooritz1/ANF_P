%% Matlab Skript für die Erstellung einer Costmap

% Dieser Code soll von einem übergeordneten Skript aufgerufen werden. Für
% diesen Zweck muss eine function erstellt werden. Mit dem Aufruf dieser
% function soll das übergeordnete Skript die Costmap erhalten.

%% Hinweis:
% Für einen Probedurchlauf, mit einer Auflistung aller Variablen 
% im Workspace, müssen die Teile
% 'function Ausgabevariable = Name_der_function(Eingabevariable)' und 'end'
% auskommentiert werden. Dies ist durch das Setzen eines % am Anfang der 
% jeweiligen Zeile realisierbar. Ansonsten kann ein Test nur über den
% regulären externen Aufruf der function ablaufen.

%------------------------------------------------------------------------------

%% Initialisierung der function
% Ein function wird durch die Zeile 
% 'function Ausgabevariable = Name_der_function(Eingabevariable)'
% erstellt. In diesem Falle kann diese Zeile beispielsweise
% 'function costmap = generiereCostmap()' lauten.
% Durch diese Zeile wird definiert, wie die function von einem anderen
% Skript aus aufgerufen werden kann, welche Eingabevariablen dieser 
% übergeben werden müssen und welche Ausgabevariablen das andere Skript im
% Gegenzug bekommt.
% 
% In dem übergeordneten Skript kann anschließend durch den einfachen Befehl
% 'costmap = generiereCostmap();' die erstellte function aufgerufen werden.
% Wichtig ist dabei, dass das Skript mit der function und das übergeordnete
% Skript in demselben Ordner gespeichert sind.
function Costmap = VorlageCostmapErstellen()

%% Aufruf der .bmp-Dateien
% Die Costmap wird durch das Übereinanderlegen dreier .bmp-Dateien
% generiert. Dafür müssen nun die drei Dateien in das Skript geladen
% werden. Die ist durch den Befehl 'A = imread(Dateiname);' möglich.
parkedCars = imread('parked_cars.bmp');
roadMarkings = imread('road_markings.bmp');
stationary = imread('stationary.bmp');
%% Kombinierung der .bmp-Dateien
% Nach dem erfolgreichen Laden der .bmp-Dateien müssen diese zu einer
% Variable kombiniert werden. Dies ist durch eine einfache Addition
% möglich.
combinedMap = parkedCars + roadMarkings + stationary;
%% Umwandlung des Datentyps
% Bisher liegt die Costmap in einem im Datentyp uint8 vor. Für die weitere
% Verarbeitung soll dieser aber single lauten.
% Mit dem Befehl 'J = im2single(I);' lässt sich dies realisieren.
combinedMapSingle = im2single(combinedMap);
%% Erstellung der finalen Costmap
% Der Befehl 'costmap = vehicleCostmap(combinedMap, 'CellSize', res);'
% wandelt das bisher erstellte Objekt in ein Objekt, das für Pfadplanungs-
% Algorithmen nutzbar ist. Die Costmap enthält Hindernisse und nicht
% befahrbare Umgebungen. Der Befehl 'vehicleCostmap' führt zudem den
% CollisionChecker ein. Dies beinhaltet, dass um Hindernisse und Umgebungen
% ein "inflation radius" gelegt wird. Dies sorgt für eine erhöhte
% Sicherheit, dass keine Kollisionen auftreten.
% Der CollisionChecker legt zudem in dem Objekt costmap eine Kategorie
% namens "VehicleDimensions" an. Hier liegen Standardwerte für
% Fahrzeugmaße, die später auch für die Darstellung des Fahrzeugs im Plot
% und für den RRT*-Algorithmus relevant sind.
% Durch die Auflösung der einzelnen Bits lässt sich definieren wie groß die
% Costmap sein soll. Dies geschieht mit dem Teil 'CellSize', res' im
% Befehl 'costmap = vehicleCostmap(combinedMap, 'CellSize', res);'
% In diesem Fall soll die Auflösung bei res = 0.5 liegen.
res = 0.5;
Costmap = vehicleCostmap(combinedMapSingle, 'CellSize', res);
%% Einstellung des CollisionCheckers
% Durch Einstellung der "NumCircles" über den Befehl
% 'costmap.CollisionChecker.NumCircles = 2;' lässt sich die Genauigkeit
% und die Geschwindigkeit des CollisionCheckers verändern. Bei steigender
% Anzahl läuft die Kontrolle langsamer aber präziser ab.

%% Costmap plotten
% Mit dem Befehl 'plot(Variablenname);' lässt sich die erstellte Costmap
% anzeigen.
plot(Costmap);
title('Costmap mit eingezeichneten inflated areas');

%% function beenden
% Durch den einfachen Befehl 'end' kann die function abgeschlossen werden.

% Für einen Probedurchlauf, mit einer Auflistung aller Variablen 
% im Workspace, müssen die Teile
% 'function Ausgabevariable = Name_der_function(Eingabevariable)' und 'end'
% auskommentiert werden. Dies ist durch das Setzen eines % am Anfang der 
% jeweiligen Zeile realisierbar. Ansonsten kann ein Test nur über den
% regulären externen Aufruf der function ablaufen.
end