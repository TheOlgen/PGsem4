function [x, residuum_norm] = solve_Gauss_Seidel(A, b)
    N = size(A, 1);
    x = ones(N, 1);  % Inicjalizacja
    U = triu(A, 1);
    T = A - U;  % Macierz dolna (D + L)
    
    max_iter = 500;
    for iter = 1:max_iter
        x = T \ (b - U * x);  % Iteracja Gaussa-Seidla
    end
    
    residuum_norm = norm(A*x - b);  % Norma residuum
end
