function costmap = generiereCostmap()
%% Matlab Skript für die Erstellung einer Costmap

% Aufruf der .bmp-Dateien
% Die Costmap wird durch das Übereinanderlegen dreier .bmp-Dateien
% generiert. Dafür müssen nun die drei Dateien in das Skript geladen
% werden.
map1 = imread('parked_cars.bmp');
map2 = imread('road_markings.bmp');
map3 = imread('stationary.bmp');

%% Kombinierung der .bmp-Dateien
% Nach dem erfolgreichen Laden der .bmp-Dateien müssen diese zu einer
% Variable kombiniert werden. Dies ist durch eine einfache Addition
% möglich.
combinedMap = map1 + map2 + map3;

%% Umwandlung des Datentyps
% Bisher liegt die Costmap in einem im Datentyp uint8 vor. Für die weitere
% Verarbeitung soll dieser aber single lauten.
combinedMapSingle = im2single(combinedMap);

%% Erstellung der finalen Costmap
% Der Befehl 'costmap = vehicleCostmap(combinedMap, 'CellSize', res);'
% wandelt das bisher erstellte Objekt in ein Objekt, das für Pfadplanungs-
% Algorithmen nutzbar ist. Die Costmap enthält Hindernisse und nicht
% befahrbare Umgebungen.
% In diesem Fall soll die Auflösung bei res = 0.5 liegen.
res = 0.5;
costmap = vehicleCostmap(combinedMapSingle, 'CellSize', res);

%% Einstellung des CollisionCheckers
% Durch Einstellung der "NumCircles" über den Befehl
% 'costmap.CollisionChecker.NumCircles = 2;' lässt sich die Genauigkeit
% und die Geschwindigkeit des CollisionCheckers verändern.
costmap.CollisionChecker.NumCircles = 2;

%% Costmap plotten
% Mit dem Befehl 'plot(Variablenname);' lässt sich die erstellte Costmap
% anzeigen.
% Der Plot muss nur während der Testphase angezeigt werden, für den normalen 
% Ablauf sollte das plotten auskommentiert werden, da es sonst bei jedem 
% Aufruf neu geplottet wird.

% plot(costmap);
% title('Costmap mit Hindernissen und freiem Parkraum')

end
