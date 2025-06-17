function [node_counts, exact_runge, exact_sine, V, interpolated_runge, interpolated_sine] = plot_runge_sine_interpolations()
% Generuje dwa wykresy przedstawiające interpolacje funkcji Rungego oraz
% funkcji sinusoidalnej. Funkcja zwraca
% 1) trzy wektory wierszowe
% 2) trzy tablice komórkowe (cell arrays) o rozmiarze [1,4].
% node_counts - wektor zawierający liczby węzłów, dla których wyznaczana
%   była interpolacja wielomianowa
% exact_runge - wektor wierszowy wartości funkcji Runge wyznaczonych
%       w punktach x_fine = linspace(-1, 1, 1000);
% exact_sine - wektor wierszowy wartości funkcji sinusoidalnej wyznaczonych
%       w punktach x_fine = linspace(-1, 1, 1000);
% V{i}: macierz Vandermonde'a wyznaczona dla node_counts(i) węzłów interpolacji
% interpolated_runge{i}: wektor wierszowy wartości wielomianu interpolującego
%       funkcję Runge'go dla stopnia wielomianu równego node_counts(i)-1.
% interpolated_sine{i}: wektor wierszowy wartości wielomianu interpolującego
%       funkcję sinusoidalną dla stopnia wielomianu równego node_counts(i)-1.

    % Wektor liczby węzłów - niepowtarzające się wartości z przedziału [2, 16]
    node_counts = [4, 8, 11, 14];  % co najmniej jedna > 12

    % Definicja funkcji
    runge_function = @(x) 1 ./ (1 + 25 * x.^2);
    sine_function = @(x) sin(2 * pi * x);

    % Gęsta siatka punktów do oceny interpolacji
    x_fine = linspace(-1, 1, 1000);

    % Wartości funkcji wzorcowych
    exact_runge = runge_function(x_fine);
    exact_sine = sine_function(x_fine);

    % Inicjalizacja komórek
    V = cell(1, length(node_counts));
    interpolated_runge = cell(1, length(node_counts));
    interpolated_sine = cell(1, length(node_counts));

    % Przygotowanie kolorów
    colors = lines(length(node_counts));

    % === Wykres funkcji Rungego ===
    subplot(2,1,1);
    plot(x_fine, exact_runge, 'k--', 'LineWidth', 2, 'DisplayName', 'Runge - wzorcowa');
    hold on;

    % === Wykres funkcji sinusoidalnej ===
    subplot(2,1,2);
    plot(x_fine, exact_sine, 'k--', 'LineWidth', 2, 'DisplayName', 'Sine - wzorcowa');
    hold on;

    % === Pętla po liczbach węzłów ===
    for i = 1:length(node_counts)
        N = node_counts(i);
        x_nodes = linspace(-1, 1, N)';

        % Macierz Vandermonde’a
        V{i} = get_vandermonde_matrix(x_nodes);

        % === Interpolacja Rungego ===
        y_runge = runge_function(x_nodes);
        coefficients_runge = V{i} \ y_runge;
        coefficients_runge = coefficients_runge(end:-1:1);
        interpolated_runge{i} = polyval(coefficients_runge, x_fine);

        subplot(2,1,1);
        plot(x_fine, interpolated_runge{i}, 'Color', colors(i,:), ...
            'DisplayName', sprintf('Runge, N=%d', N));

        % === Interpolacja sinusoidalna ===
        y_sine = sine_function(x_nodes);
        coefficients_sine = V{i} \ y_sine;
        coefficients_sine = coefficients_sine(end:-1:1);
        interpolated_sine{i} = polyval(coefficients_sine, x_fine);

        subplot(2,1,2);
        plot(x_fine, interpolated_sine{i}, 'Color', colors(i,:), ...
            'DisplayName', sprintf('Sine, N=%d', N));
    end

    % === Opisy wykresów ===
    subplot(2,1,1);
    title('Interpolacja funkcji Rungego');
    xlabel('x');
    ylabel('f(x)');
    legend('show', 'Location', 'eastoutside');

    subplot(2,1,2);
    title('Interpolacja funkcji sinusoidalnej');
    xlabel('x');
    ylabel('f(x)');
    legend('show', 'Location', 'eastoutside');

    % Zapis wykresu do pliku
    set(gcf, 'Position', [100, 100, 1200, 800]);
    saveas(gcf, 'zadanie1.png');
end

function V = get_vandermonde_matrix(x)
    % Budowa macierzy Vandermonde'a na podstawie węzłów x
    N = length(x);
    V = ones(N,N);
    for i = 1:N
        for j = 0:(N-1)
            V(i,j+1) = x(i)^j;
        end
    end
end
