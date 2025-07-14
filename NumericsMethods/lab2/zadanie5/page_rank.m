
function [index_number, Edges, I, B, A, b, r] = page_rank()
    index_number = 198421;
    L = mod(index_number,10); %1
    A = 1+ mod(L, 7); %2
    %disp(A);

    Edges = [1, 1, 1, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 5, 5, 5, 6, 6, 6, 7, 7;
             4, 6, 2, 3, 4, 5, 5, 6, 7, 2, 2, 5, 6, 2, 4, 6, 2, 4, 7, 2, 6];
    
    N = max(Edges(:));
    d = 0.85;
    
    I = speye(N);% Macierz jednostkowa
    B = sparse(Edges(2,:), Edges(1,:), 1, N, N);% Macierz sąsiedztwa
    
    d_out = sum(B, 1); % Liczba odnośników wychodzących z każdej strony
    A = spdiags(1 ./ d_out', 0, N, N);  % Macierz diagonalna 
    
    % Układ: (I - d * B * A) * r = (1 - d) / N
    b = ones(N, 1) * (1 - d) / N;
    r = (I - d * B * A) \ b; % Rozwiązanie układu równań
    
    figure;
    bar(r);
    title('Wartości PageRank dla stron');
    xlabel('Strona');
    ylabel('PageRank');
    grid on;
end