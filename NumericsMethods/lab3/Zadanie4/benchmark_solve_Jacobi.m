function [A, b, x, vec_loop_times, vec_iteration_count] = benchmark_solve_Jacobi(vN)
    % Pomiar wydajności metody Jacobiego dla różnych rozmiarów macierzy A
    % vN - wektor rozmiarów macierzy
    % A, b - tablice komórkowe przechowujące macierze i wektory prawej strony
    % x - tablica komórkowa przechowująca rozwiązania dla każdego N
    % vec_loop_times - czas obliczeń dla każdego N
    % vec_iteration_count - liczba iteracji dla każdego N

    vec_loop_times = zeros(1, length(vN));
    vec_iteration_count = zeros(1, length(vN));

    for i = 1:length(vN)
        N = vN(i);

        % Generowanie macierzy A i wektora b
        [A{i}, b{i}] = generate_matrix(N);
        x{i} = ones(N, 1);

        % Definiowanie macierzy D, L, U
        D = diag(diag(A{i}));  % Macierz diagonalna
        L = tril(A{i}, -1);    % Macierz dolna (poniżej diagonali)
        U = triu(A{i}, 1);     % Macierz górna (powyżej diagonali)

        % Obliczenie macierzy M i wektora w zgodnie z metodą Jacobiego
        M = -D \ (L + U);
        w = D \ b{i};

        % Początkowe przybliżenie x jako wektor jedynek
        x{i} = ones(N, 1);
        inorm = norm(A{i} * x{i} - b{i});
        iteration_count = 0;

        % Pomiar czasu iteracyjnego procesu
        tic
        while inorm > 1e-12 && iteration_count < 1000
            x{i} = M * x{i} + w;
            inorm = norm(A{i} * x{i} - b{i});
            iteration_count = iteration_count + 1;
        end
        vec_loop_times(i) = toc;
        vec_iteration_count(i) = iteration_count;
    end
    % Tworzenie wykresu
    figure;

    % Wykres górny: czas obliczeń w zależności od N
    subplot(2,1,1);
    plot(vN, vec_loop_times, '-o', 'LineWidth', 2, 'MarkerSize', 6);
    xlabel('Rozmiar macierzy N');
    ylabel('Czas obliczeń [s]');
    title('Czas obliczeń metody Jacobiego');
    grid on;

    % Wykres dolny: liczba iteracji w zależności od N
    subplot(2,1,2);
    plot(vN, vec_iteration_count, '-s', 'LineWidth', 2, 'MarkerSize', 6, 'Color', 'r');
    xlabel('Rozmiar macierzy N');
    ylabel('Liczba iteracji');
    title('Liczba iteracji wymaganych do konwergencji');
    grid on;

    % Zapis wykresu do pliku
    saveas(gcf, 'zadanie4.png');
end

