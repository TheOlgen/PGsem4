% Funkcja generate_circles.m
function [circles, a, b, r_max] = generate_circles(n_max)
    % Losowanie wymiarów prostokąta
    a = randi([150, 250]);
    b = randi([50, 100]);
    r_max = randi([20, 50]);

    circles = zeros(n_max, 3);
    
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
                break;
            end
        end
    end
end
