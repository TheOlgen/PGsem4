% Funkcja generate_circles.m
function [rand_counts, counts_mean, circles, a, b, r_max]= generate_circles(n_max)
    % Losowanie wymiarów prostokąta
    a = randi([150, 250]);
    b = randi([50, 100]);
    r_max = randi([20, 50]);

    % Inicjalizacja macierzy wynikowej
    circles = zeros(n_max, 3);
    rand_counts = zeros(1, n_max);
    counts_mean = zeros(1, n_max);
    count = 0;
    count_sum =0;

    % Pętla losująca okręgi
    for i = 1:n_max
        count = 0;
        while true
            count = count+1;
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
                count_sum = count_sum + count;
                rand_counts(i) = count;
                counts_mean(i) = count_sum/i;
                break;
            end
        end
    end
    subplot(2,1,1);
    plot(rand_counts);
    xlabel('K-okrąg');
    ylabel('Ilośc losowań');
    title('Ilość losowań dla K-okręgu');
    subplot(2,1,2);
    plot(counts_mean);
    xlabel('K-okrąg');
    ylabel('Srednia ilośc losowań');
    title('Średnia ilość losowań dla K-okręgów');
end
