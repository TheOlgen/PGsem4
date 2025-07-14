function [A, b, x, vec_time_direct] = benchmark_solve_direct(vN)
    % Pomiar czasu rozwiązania równań metodą LU dla różnych rozmiarów macierzy
    
    % Inicjalizacja zmiennych
    A = cell(1, length(vN));
    b = cell(1, length(vN));
    x = cell(1, length(vN));
    vec_time_direct = zeros(1, length(vN));

    % Pętla po różnych rozmiarach macierzy
    for i = 1:length(vN)
        N = vN(i);
        
        % Generowanie macierzy A i wektora b
        [A{i}, b{i}] = generate_matrix(N);
        
        % Pomiar czasu rozwiązania metodą LU
        tic;
        [L, U, P] = lu(A{i});
        y = L \ (P * b{i});  % Forward substitution
        x{i} = U \ y;        % Back substitution
        vec_time_direct(i) = toc;
    end
    
    % Tworzenie wykresu czasu obliczeń
    figure;
    plot(vN, vec_time_direct, '-o', 'LineWidth', 2, 'MarkerSize', 8);
    xlabel('Rozmiar macierzy N');
    ylabel('Czas obliczeń [s]');
    title('Zależność czasu obliczeń metody LU od rozmiaru macierzy');
    grid on;

    % Zapis wykresu do pliku
    saveas(gcf, 'zadanie2.png');
end
