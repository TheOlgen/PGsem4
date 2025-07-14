function [N, x_uniform, y_fine_uniform, x_chebyshev, y_fine_chebyshev] = ...
        compare_uniform_vs_chebyshev()
    N = 14; % liczba węzłów interpolacji 

    x_fine = linspace(-1, 1, 1000);
    runge_function = @(x) 1 ./ (1 + 25 * x.^2);
    y_fine_reference = runge_function(x_fine);

    % 1. Węzły równomierne
    x_uniform = linspace(-1, 1, N);
    y_uniform = runge_function(x_uniform);
    V_uniform = get_vandermonde_matrix(x_uniform);
    coeff_uniform = V_uniform \ y_uniform';  % wyznaczenie współczynników
    coeff_uniform = coeff_uniform(end:-1:1); % dostosowanie do polyval
    y_fine_uniform = polyval(coeff_uniform, x_fine);

    % 2. Węzły Czebyszewa II rodzaju
    x_chebyshev = get_chebyshev_nodes(N);
    y_chebyshev = runge_function(x_chebyshev);
    V_chebyshev = get_vandermonde_matrix(x_chebyshev);
    coeff_chebyshev = V_chebyshev \ y_chebyshev';
    coeff_chebyshev = coeff_chebyshev(end:-1:1);
    y_fine_chebyshev = polyval(coeff_chebyshev, x_fine);

    % 3. Wykresy
    subplot(2,1,1);
    plot(x_fine, y_fine_reference, 'k--', 'LineWidth', 2, 'DisplayName', 'Funkcja wzorcowa');
    hold on;
    plot(x_fine, y_fine_uniform, 'm', 'DisplayName', ['Interpolacja N = ', num2str(N)]);
    plot(x_uniform, y_uniform, 'mo', 'DisplayName', ['Wartości węzłów. N = ', num2str(N)]);
    hold off;
    title('Interpolacja funkcji Rungego (węzły równomierne)');
    legend show;
    legend('Location', 'eastoutside');
    xlabel('x');
    ylabel('y');

    subplot(2,1,2);
    plot(x_fine, y_fine_reference, 'k--', 'LineWidth', 2, 'DisplayName', 'Funkcja wzorcowa');
    hold on;
    plot(x_fine, y_fine_chebyshev, 'b', 'DisplayName', ['Interpolacja N = ', num2str(N)]);
    plot(x_chebyshev, y_chebyshev, 'bo', 'DisplayName', ['Wartości węzłów. N = ', num2str(N)]);
    hold off;
    title('Interpolacja funkcji Rungego (węzły Czebyszewa II rodzaju)');
    legend show;
    legend('Location', 'eastoutside');
    xlabel('x');
    ylabel('y');

    % Zapis wykresu
    saveas(gcf, 'zadanie2.png');
end

function x = get_chebyshev_nodes(N)
    % Węzły Czebyszewa drugiego rodzaju w [-1, 1]
    k = 0:N-1;
    x = cos(pi * k / (N - 1));
end

function V = get_vandermonde_matrix(x)
    N = length(x);
    V = ones(N, N);
    for i = 1:N
        for j = 0:N-1
            V(i,j+1) = x(i)^j;
        end
    end
end
