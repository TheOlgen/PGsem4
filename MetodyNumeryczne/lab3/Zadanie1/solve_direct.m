function [A,b,L,U,P,y,x,r_norm,t_factorization,t_substitution,t_direct] = ...
        solve_direct()

    % Ustawienie rozmiaru macierzy N w zakresie 5000-9000
    N = randi([5000, 9000]);

    % Generowanie macierzy A i wektora b
    [A, b] = generate_matrix(N);

    % Pomiar czasu faktoryzacji LU
    t_start = tic;
    [L, U, P] = lu(A);
    t_factorization = toc(t_start);

    % Rozwiązanie równań z macierzami trójkątnymi
    t_start = tic;
    y = L \ (P * b);  % Forward substitution
    x = U \ y;        % Back substitution
    t_substitution = toc(t_start);

    % Norma residuum
    r_norm = norm(A * x - b);

    % Całkowity czas metody LU
    t_direct = t_factorization + t_substitution;

    % Wykres czasów obliczeń
    figure;
    r = [t_direct, t_factorization, t_substitution];
    bar(r);
    set(gca, 'XTickLabel', {'t_{direct}', 't_{factorization}', 't_{substitution}'});
    ylabel('Czas [s]');
    xlabel('metody obliczenia równania macierzowego');
    title('Czas obliczeń metodą LU');
    
    % Zapis wykresu do pliku
    saveas(gcf, 'zadanie1.png');
end


