function [A, b, U, T, w, x, r_norm, iteration_count] = solve_Gauss_Seidel()
    % Rozwiązywanie równania macierzowego metodą Gaussa-Seidla
    % A - macierz współczynników
    % b - wektor prawej strony równania
    % U - macierz trójkątna górna z elementami powyżej diagonali
    % T - macierz trójkątna dolna (D+L)
    % w - wektor pomocniczy opisany w instrukcji
    % x - rozwiązanie układu równań
    % r_norm - norma residuum dla kolejnych iteracji
    % iteration_count - liczba iteracji

    % Definiujemy rozmiar macierzy N
    N = randi([5000, 8000]);

    % Generujemy macierz A oraz wektor b
    [A, b] = generate_matrix(N);

    % Inicjalizacja iteracji
    iteration_count = 0;
    x = ones(N, 1);

    % Definiujemy macierze T, U
    U = triu(A, 1);        % Macierz górna (elementy powyżej diagonali)
    T = A - U;             % Macierz dolna (D+L)

    % Wektor pomocniczy w = T \ b
    w = T \ b;

    % Inicjalizacja normy residuum
    r_norm = norm(A * x - b);
    tol = 1e-12;
    
    % Iteracyjny proces Gaussa-Seidla
    while r_norm(end) > tol && iteration_count < 1000
        x = T \ (b - U * x); % Zastosowanie bardziej efektywnego sposobu iteracji
        r_norm = [r_norm, norm(A * x - b)];
        iteration_count = iteration_count + 1;
    end
        % Generowanie wykresu norm residuum
    figure;
    semilogy(0:iteration_count, r_norm, '-', 'LineWidth', 2, 'MarkerSize', 6);
    xlabel('Liczba iteracji');
    ylabel('Norma residuum');
    title('Zbieżność metody Gaussa_Seidela');
    grid on;

    % Zapis wykresu do pliku
    saveas(gcf, 'zadanie5.png');

end

