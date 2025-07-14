function [ft_5, yrmax, Nt, xr, yr, integration_error] = monte_carlo_accuracy_evaluation()
    % Numeryczne całkowanie metodą Monte Carlo.
    %
    % ft_5 - gęstość funkcji prawdopodobieństwa dla n=5
    %
    % yrmax - maksymalna dopuszczalna wartość współrzędnej y losowanych punktów
    %
    % Nt - wektor wierszowy zawierający liczby losowań, dla których obliczano
    %     wektor błędów całkowania integration_error.
    %
    % [xr, yr] - tablice komórkowe zawierające informacje o wylosowanych punktach.
    %     Tablice te mają rozmiar [1, length(Nt)]. W komórkach xr{1,i} oraz yr{1,i}
    %     zawarte są współrzędne x oraz y wszystkich punktów zastosowanych
    %     do obliczenia całki przy losowaniu Nt(1,i) punktów.
    %
    % integration_error - wektor wierszowy. Każdy element integration_error(1,i)
    %     zawiera błąd całkowania obliczony dla liczby losowań równej Nt(1,i).
    %     Zakładając, że obliczona wartość całki dla Nt(1,i) próbek wynosi
    %     integration_result, błąd jest definiowany jako:
    %     integration_error(1,i) = abs(integration_result - reference_value),
    %     gdzie reference_value to wartość referencyjna całki.

 
    reference_value = 0.0473612919396179; % wartość referencyjna całki

    ft_5 = failure_density_function(5);
    xrmax = 5;
    
    % Znajdź maksymalną wartość funkcji w przedziale [0, xrmax]
    x_test = linspace(0, xrmax, 1000);
    ft_test = failure_density_function(x_test);
    yrmax = max(ft_test) * 1.05; % Dodajemy 5% marginesu
    
    Nt = 5:50:10^4;
    xr = cell(1, length(Nt));
    yr = cell(1, length(Nt));
    integration_error = zeros(1, length(Nt));
    
    for i = 1:length(Nt)
        N = Nt(i);
        [integral_approx, xr{i}, yr{i}] = monte_carlo_integral(N, xrmax, yrmax);
        integration_error(i) = abs(integral_approx - reference_value);
    end
    
    figure;
    loglog(Nt, integration_error);
    xlabel('liczba punktów ');
    ylabel('błąd całkowania');
    title('zależność błędu całkowania od liczby punktów - monte carlo');
    grid on;

    saveas(gcf, 'zadanie4.png');
end

function [integral_approximation, x, y] = monte_carlo_integral(N, xmax, ymax)
    % Oblicza przybliżoną wartość całki oznaczonej z funkcji gęstości
    % prawdopodobieństwa (failure_density_function) przy użyciu
    % metody Monte Carlo.
    %
    % N – liczba losowanych punktów
    % xmax – koniec przedziału całkowania [0, xmax]
    % ymax – górna granica wartości funkcji w przedziale [0, xmax]
    %        (musi spełniać warunek ymax ≥ max(f(x)))
    % integral_approximation – przybliżona wartość całki
    % x – wektor wierszowy o długości N z wylosowanymi wartościami x z [0, xmax]
    % y – wektor wierszowy o długości N z wylosowanymi wartościami y z [0, ymax]
    
 
    
    
    x = xmax * rand(1, N);
    y = ymax * rand(1, N);
    
    % Obliczenie wartości funkcji dla wylosowanych x
    ft_values = failure_density_function(x);
    
    % Zliczenie punktów pod krzywą
    points_under_curve = sum(y <= ft_values);
    
    % Obliczenie przybliżonej wartości całki
    integral_approximation = (points_under_curve / N) * (xmax * ymax);
end

function ft = failure_density_function(t)
    % Zwraca wartości funkcji gęstości prawdopodobieństwa wystąpienia awarii
    % urządzenia elektronicznego dla zadanych wartości czasu t.
    %
    % t – wektor wartości czasu (wyrażonych w latach), dla których obliczane
    %   są wartości funkcji gęstości prawdopodobieństwa.
    %
    % ft – wektor zawierający wartości funkcji gęstości prawdopodobieństwa
    %      odpowiadające kolejnym elementom wektora t.
    o = 3;
    u = 10;
    
    ft = (1/(o*sqrt(2*pi))) * exp(-(t-u).^2 / (2*o^2));
end