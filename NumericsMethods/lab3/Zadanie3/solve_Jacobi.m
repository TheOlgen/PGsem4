function [A, b, M, w, x, r_norm, iteration_count] = solve_Jacobi()
    % Ustawienie rozmiaru macierzy N w zakresie 5000-8000
    N = randi([5000, 8000]);

    % Generowanie macierzy A i wektora b
    [A, b] = generate_matrix(N);

    % Definiowanie macierzy D, L, U
    D = diag(diag(A));      % Macierz diagonalna
    L = tril(A, -1);        % Macierz dolna (poniżej diagonali)
    U = triu(A, 1);         % Macierz górna (powyżej diagonali)

    % Obliczenie macierzy M i wektora w zgodnie z metodą Jacobiego
    M = -D \ (L + U);
    w = D \ b;

    % Inicjalizacja rozwiązania x jako wektora jedynek
    x = ones(N, 1);

    % Obliczenie początkowej normy residuum
    r_norm = norm(A*x - b);
    iteration_count = 0;
    
    % Wektor do przechowywania norm residuum w każdej iteracji
    res_norms = r_norm;

    % Iteracyjny proces metody Jacobiego
    while (r_norm > 1e-12 && iteration_count < 1000)
        x = M * x + w;  % Iteracyjna aktualizacja x
        r_norm = norm(A*x - b);  % Aktualizacja normy residuum
        res_norms = [res_norms, r_norm];
        iteration_count = iteration_count + 1;
    end

    % Generowanie wykresu norm residuum
    figure;
    semilogy(0:iteration_count, res_norms, '-', 'LineWidth', 2, 'MarkerSize', 6);
    xlabel('Liczba iteracji');
    ylabel('Norma residuum');
    title('Zbieżność metody Jacobiego');
    grid on;

    % Zapis wykresu do pliku
    saveas(gcf, 'zadanie3.png');

    % Zwrócenie wartości r_norm jako wektora wierszowego
    r_norm = res_norms;
end
