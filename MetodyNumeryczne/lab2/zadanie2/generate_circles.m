
function [circle_areas, circles, a, b, r_max] = generate_circles(n_max)
    % Losowanie wymiarów prostokąta
    a = randi([150, 250]);
    b = randi([50, 100]);
    r_max = randi([20, 50]);

    %zmienne do zadania 2
    P = a*b;
    sk = 0;

    % Inicjalizacja macierzy wynikowej
    circles = zeros(n_max, 3);
    circle_areas = zeros(r_max,1); %kolumna
    
    % Pętla losująca okręgi
    for i = 1:n_max
        while true
            % Losowanie promienia i środka okręgu
            R = rand() *r_max;
            X = rand()* a;
            Y = rand() * b;
            
            % Sprawdzenie, czy okrąg mieści się w prostokącie
            if X - R < 0 || X + R > a || Y - R < 0 || Y + R > b
                continue;
            end
            
            % Sprawdzenie kolizji
            is_valid = true;
            for j = 1:i-1
                Xj = circles(j, 1);
                Yj = circles(j, 2);
                Rj = circles(j, 3);
                
                dist = sqrt((X - Xj)^2 + (Y - Yj)^2);
                
                % Sprawdzenie czy okręgi się przecinają lub zawierają
                if dist < (R + Rj)
                    is_valid = false;
                    break;
                end
            end
            
            if is_valid
                circles(i, :) = [X, Y, R];
                sk = sk + pi * R^2; %dodajemy pole k do sumy
                circle_areas(i) = sk/P * 100;
                break;
            end
        end
    end
    plot(circle_areas);
    xlabel('K');
    ylabel('zapełnienie pola prostokąta');
    title('Procent zapełnienia pola prostokąta przez zsumowane pola K pierwszysch kół');
end
