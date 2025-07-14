function [x, residuum_norm] = solve_Jacobi(A, b)
    N = size(A, 1);
    x = ones(N, 1);  % Inicjalizacja
    D = diag(diag(A));
    R = A - D;
    
    max_iter = 500;
    for iter = 1:max_iter
        x = D \ (b - R * x);  % Iteracja Jacobiego
    end
    
    residuum_norm = norm(A*x - b);  % Norma residuum
end
