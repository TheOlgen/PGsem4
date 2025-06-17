function [x, y, z, zmin, lake_volume] = compute_lake_volume_monte_carlo()
    % Wyznacza objętość jeziora metodą Monte Carlo.
    %
    % x/y/z - wektory wierszowe, które zawierają współrzędne x/y/z punktów
    %       wylosowanych w celu wyznaczenia przybliżonej objętości jeziora
    % zmin - minimalna dopuszczalna wartość współrzędnej z losowanych punktów
    % lake_volume - objętość jeziora wyznaczona metodą Monte Carlo
    
    % Zakresy przestrzeni ograniczającej jezioro

    xmin = 0;
    xmax = 100;
    ymin = 0;
    ymax = 100;
    zmin = -50;
    zmax = 50;  % przyjmowana maksymalna głębokość

    N = 1000000;  % liczba punktów Monte Carlo

    % Losowanie punktów
    x = xmin + (xmax - xmin) * rand(1, N);
    y = ymin + (ymax - ymin) * rand(1, N);
    z = zmin * rand(1, N);  % z w zakresie [zmin, 0], np. [-50, 0]

    % Oblicz głębokość dna jeziora w punktach (x, y)
    depth = get_lake_depth(x, y);  % depth < 0, np. -25

    % Sprawdź, czy punkt z znajduje się nad dnem jeziora
    % tzn. z >= depth (np. z = -20, depth = -25 → z wyżej = wewnątrz jeziora)
    is_inside = z >= depth;

    % Liczba punktów w jeziorze
    n_inside = sum(is_inside);

    % Objętość prostopadłościanu
    V_box = (xmax - xmin) * (ymax - ymin) * abs(zmin);  % = 100 * 100 * 50

    % Objętość jeziora
    lake_volume = (n_inside / N) * V_box;
end

