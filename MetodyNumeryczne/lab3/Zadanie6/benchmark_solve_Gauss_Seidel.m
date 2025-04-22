function [A, b, x, vec_loop_times, vec_iteration_count] = benchmark_solve_Gauss_Seidel(vN)
    % Pomiar wydajności metody Gaussa-Seidla dla różnych rozmiarów macierzy
    % A - komórkowa tablica macierzy współczynników
    % b - komórkowa tablica wektorów prawych stron
    % x - komórkowa tablica z rozwiązaniami
    % vec_loop_times - czas obliczeń dla każdego N
    % vec_iteration_count - liczba iteracji dla każdego N

    vec_loop_times = zeros(1, length(vN));
    vec_iteration_count = zeros(1, length(vN));

    for i = 1:length(vN)
        N = vN(i);

        % Generowanie macierzy A i wektora b
        [A{i}, b{i}] = generate_matrix(N);
        x{i} = ones(N, 1);

        % Definiowanie macierzy pomocniczych
        U = triu(A{i}, 1);  % Macierz górna
        T = A{i} - U;       % Macierz dolna (D+L)
        w = T \ b{i};       % Wektor pomocniczy

        % Inicjalizacja iteracji
        iteration_count = 0;
        x_new = x{i};
        r_norm = 1e22;

        % Pomiar czasu działania pętli iteracyjnej
        tic
        while (r_norm > 1e-12 && iteration_count < 1000)
            x_new = T \ (b{i} - U * x_new);
            r_norm = norm(A{i} * x_new - b{i});
            iteration_count = iteration_count + 1;
        end
        vec_loop_times(i) = toc;
        vec_iteration_count(i) = iteration_count;

        % Zapisz rozwiązanie
        x{i} = x_new;
    end
    % Tworzenie wykresu
    figure;
    subplot(2,1,1);
    plot(vN, vec_loop_times, '-o', 'LineWidth', 2);
    xlabel('Rozmiar macierzy N');
    ylabel('Czas obliczeń [s]');
    title('Czas obliczeń metody Gaussa-Seidla');

    subplot(2,1,2);
    plot(vN, vec_iteration_count, '-o', 'LineWidth', 2);
    xlabel('Rozmiar macierzy N');
    ylabel('Liczba iteracji');
    title('Liczba iteracji metody Gaussa-Seidla');

    saveas(gcf, 'zadanie6.png');  % Zapis wykresu
end


