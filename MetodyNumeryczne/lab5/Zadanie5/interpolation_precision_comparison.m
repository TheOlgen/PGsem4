function [coef_double, coef_vpa, y_double, y_vpa, y_mix] = ...
        interpolation_precision_comparison()
    f = @(x) 1 ./ (1 + 25 * x.^2); % interpolowana jest funkcja Rungego

    % Węzły interpolacji:
    n = 80;
    x_nodes = linspace(-1, 1, n);
    y_nodes = f(x_nodes);

    % Gęsta siatka punktów do testowania interpolacji
    x_fine = linspace(-1, 1, 1000);

    % Interpolacja z użyciem double
    V_double = get_vandermonde_matrix(x_nodes);
    coef_double = V_double \ y_nodes.';
    coef_double = coef_double(end:-1:1);  % odwracamy kolejność współczynników
    y_double = polyval(coef_double, x_fine);

    % Interpolacja z użyciem vpa
    digits(50);
    indices = vpa(0:n-1);
    a = vpa(-1);
    b = vpa(1);
    x_nodes_vpa = a + indices * (b - a) / vpa(n - 1);
    y_nodes_vpa = f(x_nodes_vpa);

    V_vpa = get_vandermonde_matrix_vpa(x_nodes_vpa);
    coef_vpa = V_vpa \ y_nodes_vpa.';
    coef_vpa = coef_vpa(end:-1:1);
    y_vpa = polyval_vpa(coef_vpa, vpa(x_fine));

    % Współczynniki vpa konwertowane na double
    coef_vpa_to_double = double(coef_vpa);
    y_mix = polyval(coef_vpa_to_double, x_fine);

    % Wykresy
    figure;
    
    subplot(3,1,1);
    plot(x_fine, f(x_fine), 'k--', 'LineWidth', 2, 'DisplayName', 'Funkcja wzorcowa');
    hold on
    plot(x_fine, y_double, 'b', 'DisplayName', 'Interpolacja double');
    title('Interpolacja funkcji Rungego - zmienne double');
    xlabel('x');
    ylabel('y');
    legend;
    axis([-1 1 -2 2]);

    subplot(3,1,2);
    plot(x_fine, f(x_fine), 'k--', 'LineWidth', 2, 'DisplayName', 'Funkcja wzorcowa');
    hold on
    plot(x_fine, double(y_vpa), 'r', 'DisplayName', 'Interpolacja vpa');
    title('Interpolacja funkcji Rungego - zmienne vpa (wysoka precyzja)');
    xlabel('x');
    ylabel('y');
    legend;
    axis([-1 1 -2 2]);

    subplot(3,1,3);
    plot(x_fine, f(x_fine), 'k--', 'LineWidth', 2, 'DisplayName', 'Funkcja wzorcowa');
    hold on
    plot(x_fine, y_mix, 'g', 'DisplayName', 'Interpolacja z coef\_vpa → double');
    title('Interpolacja funkcji Rungego - współczynniki vpa, obliczenia double');
    xlabel('x');
    ylabel('y');
    legend;
    axis([-1 1 -2 2]);

    set(gcf, 'Position', [1000 500 1000 900]);
    saveas(gcf, 'zadanie5.png');
end

function y = polyval_vpa(coefficients, x)
    n = length(coefficients);
    y = vpa(zeros(size(x)));  % inicjalizacja wyniku jako vpa

    for i = 1:n
        y = y .* x + coefficients(i);  % schemat Hornera
    end
end

function V = get_vandermonde_matrix(x)
    n = length(x);
    V = zeros(n);
    for i = 1:n
        V(:, i) = x'.^(i - 1);
    end
end

function V = get_vandermonde_matrix_vpa(x)
    n = length(x);
    V = vpa(zeros(n));
    for i = 1:n
        V(:, i) = x'.^(i - 1);
    end
end
