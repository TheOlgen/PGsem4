% Wczytanie danych z pliku
load filtr_dielektryczny.mat

% Rozwiązanie układu równań trzema metodami
[x_direct, residuum_norm_direct] = solve_direct(A, b);
[x_Jacobi, residuum_norm_Jacobi] = solve_Jacobi(A, b);
[x_GS, residuum_norm_Gauss_Seidel] = solve_Gauss_Seidel(A, b);

% Wypisanie wyników
fprintf('Norma residuum - metoda bezpośrednia: %e\n', residuum_norm_direct);
fprintf('Norma residuum - metoda Jacobiego: %e\n', residuum_norm_Jacobi);
fprintf('Norma residuum - metoda Gaussa-Seidla: %e\n', residuum_norm_Gauss_Seidel);
