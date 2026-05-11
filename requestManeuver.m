
% Dieses Script dient zur Bestimmung der nächsten Zielpose, der
% Geschwindigkeitsvorgaben und der Einstellungen für den RRT-Algorithmus.
% Dazu dienen die aktuelle Pose, der GoalIndex, die aktuelle Geschwindigkeit 
% und der RoutePlan als Eingabedaten. Der Goalindex ist eine laufende
% Nummer, mit der nacheinander die entsprechende Zielpose aus dem RoutePlan
% entnommen wird.
% Ausgabedaten sollen die nächste Zielpose, die
% Geschwindigkeitseinstellungen und die Einstellung des RRT-Algorithmus
% sein.
%----------------------------------------------------------------------------------------------------------

function [y] = requestManeuver(u)

% Die Function wird in zwei weitere Unterfunktionen aufgeteilt. 
% Die erste ist für die Bestimmung der nächsten Zielpose und der
% Einstellungen des RRT-Algorithmus zuständig. Die nächste Zielpose wird dem
% RoutePlan entnommen.
% Die Zweite Function dient für die Bestimmung der Geschwindigkeiten.
% Diese werden auch aus den im RoutePlan enthaltenen Attributen entnommen.
% Nach der Durchführung der beiden Unterfunktionen, soll der Goalindex um 
% einen Zähler erhöht werden, um beim nächsten Aufruf, die nächste Zeile im
% RoutePlan aufzurufen. Wenn der GoalIndex nur hier in dem Skript
% eingesetzt wird, sollte dieser auch wieder als persistent deklariert
% werden, damit dieser gespeichert wird.

    %% Aufgabe 11
    % Bestimmung der nächsten Zielpose und der RRT*-Einstellungen
    [y] = plannerSettings(u);
    
    %% Aufgabe 12
    % Geschwindigkeitseinstellung
    y = speedSettings(u);
    
    %% Aufgabe 11
    % GoalIndex
end

%--------------------------------------------------------------------------------------------------------
%% Aufgabe 11
% Function für die Bestimmung der nächsten Zielpose und den Einstellungen
% der RRT-Einstellungen
function [y] = plannerSettings(u)

% Die Zielpose wird mithilfe des GoalIndex aus dem routePlanStruct
% entnommen. Dies ist mit dem Befehl routePlanStruct(Index).EndPose
% möglich.                                 |           |       |
%                                    Variablenname  Zeilennr. Spalte

%------------
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
% Beispiel: Structname.Variable_a = 5;
%           Structname.Variable_b = 7;
% Dieser soll die genannten Variablen umfassen.
% ConnectionDistance = 10 
% MinIterations = 1000 
% GoalTolerance = [0.5, 0.5, 5]
% Die Bezeichnung der Variablen müssen mit den Namen aus dem Skript
% "helperSLCreateUtilityBus.m" übereinstimmen, damit diese später über den
% Bus übermittelt werden können. 

%--
% Für den Fall, dass gerade eine Parkmaneuver abläuft, soll die Abfrage
% gestellt werden, ob der GoalIndex gerade den höchstmöglichen Wert
% erreicht hat (letzte Zielpose im RoutePlan)
% Falls dies der Fall ist, soll gelten:
% GoalTolerance = [0.5 0.5 10] 
% ConnectionDistance = 6
% Für diesen Fall bietet sich der Befehl 'length()' an. Dieser Befehl gibt
% die Anzahl der Zeilen einer Variable aus. Falls ein Struct_a 5 Zeilen
% umfasst, gibt der Befehl length(Struct_a) den Wert 5 aus.
% Über diesen Weg kann eine if-Bedingung eingestellt werden die abgleicht,
% ob der GoalIndex der Zeilenanzahl des RoutePlans entspricht. Wenn dies
% der Fall ist, fährt das Ego-Fahrzeug auch gerade die Zielpose an. Damit
% handelt es sich um ein Parkmanöver.


% --
% Sobald die Distanz zum Zielpunkt den Wert 10m unterschreitet, soll die 
% ConnectionDistance auf den Wert 6 reduziert werden.

%--           
% In den im RoutePlan enthaltenen Attributen ist zudem der Wert
% "TurnManeuver" enthalten. Dafür soll eine zweifache if-else-Schleife 
% erstellt werden.
% if ...
% ...
% else
%       if ...
%           ...
%       else
%           ...
%       end
% end
% Wenn das Attribut "TurnManeuver" auf 0 gesetzt ist, soll der Wert
% MinTurningRadius auf 20 eingestellt werden. Ansonsten soll bei einem
% TurnManeuver und gleichzeitigem ParkManeuver der Wert MinTurningRadius 
% auf 4 eingestellt werden. Wenn aber ein TurnManeuver vorliegt und kein 
% ParkManeuver herrscht soll dieser auf 5 eingestellt sein.
    
end

% ----------------------------------------------------------------------------
%% Aufgabe 12
% Geschwindigkeitseinstellungen
% Diese Funktion soll aus dem RoutePlan die Geschwindigkeitsvorgaben
% extrahieren.
function y = speedSettings(u)

% Für die Ausgabe der Geschwindigkeitseinstellungen bietet sich
% die Bildung eines Structs an.
% Ein Struct lässt sich bilden indem man den Name des Structs aufruft und 
% durch einen Punkt getrennt in derselben Zeile den eigentlichen 
% Variablennamen aufruft.
% Beispiel: Structname.Variable_a = 5;
%           Structname.Variable_b = 7;
%
% Die Bezeichnung der Variablen müssen mit den Namen aus dem Skript
% "helperSLCreateUtilityBus.m" übereinstimmen, damit diese später über den
% Bus übermittelt werden können.
%
% Zu Beginn soll die aktuelle Geschwindigkeit als "StartSpeed" deklariert
% werden.

% Für den Aufruf der Attribute, muss erneut der RoutePlan aufgerufen
% und mit dem GoalIndex die entsprechende Zeile ausgewählt werden.

% Nun kann EndSpeed deklariert werden. Auch hier ist es
% empfehlenswert alle Attribute in einem struct zu exportieren.

end
