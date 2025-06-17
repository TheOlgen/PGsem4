function [matrix_sizes, condition_numbers, interpolation_error_exact, interpolation_error_perturbed] = ...
        ill_conditioning_effects()
% Określa wpływ współczynnika uwarunkowania macierzy Vandermonde'a na dokładność interpolacji.
% Generuje trzy wykresy ilustrujące uwarunkowanie macierzy i błędy interpolacji.

    matrix_sizes = 5:100;
    num_points = length(matrix_sizes);

    condition_numbers = zeros(1, num_points);
    interpolation_error_exact = zeros(1, num_points);
    interpolation_error_perturbed = zeros(1, num_points);

    % Część 1: Obliczanie współczynnika uwarunkowania
    for index = 1:num_points
        size_n = matrix_sizes(index);
        interpolation_nodes = linspace(-1, 1, size_n)';
        V = get_vandermonde_matrix(interpolation_nodes);
        condition_numbers(index) = cond(V);
    end

    threshold_index = find(condition_numbers >= 1e8, 1);

    tiledlayout(3, 1, 'Padding', 'compact', 'TileSpacing', 'compact');
    nexttile;
    semilogy(matrix_sizes, condition_numbers, 'b');
    xlabel('Rozmiar macierzy');
    ylabel('cond(V)');
    title('Współczynnik uwarunkowania macierzy Vandermonde''a');

    if ~isempty(threshold_index)
        size_threshold = matrix_sizes(threshold_index);
        xline(size_threshold, '--', 'cond(V) > 10^8', 'LabelOrientation',...
            'horizontal', 'LabelVerticalAlignment', 'top',...
            'LabelHorizontalAlignment', 'left', 'Color', [0.494 0.184 0.556]);
    end
    grid on;

    % Część 2: Błąd interpolacji dla danych dokładnych
    for index = 1:num_points
        size_n = matrix_sizes(index);
        interpolation_nodes = linspace(-1, 1, size_n)';
        V = get_vandermonde_matrix(interpolation_nodes);

        a2 = 1;
        b_exact = a2 * interpolation_nodes.^2;
        computed_coefficients = V \ b_exact;

        reference_coefficients = [0; 0; a2; zeros(size_n - 3, 1)];
        interpolation_error_exact(index) = max(abs(computed_coefficients - reference_coefficients));
    end

    nexttile;
    plot(matrix_sizes, interpolation_error_exact, 'r');
    xlabel('Rozmiar macierzy');
    ylabel('Błąd interpolacji (dokładne dane)');
    title('Błąd współczynników interpolacji funkcji f(x) = x^2');
    grid on;

    % Część 3: Błąd interpolacji dla danych zaburzonych
    for index = 1:num_points
        size_n = matrix_sizes(index);
        interpolation_nodes = linspace(-1, 1, size_n)';
        V = get_vandermonde_matrix(interpolation_nodes);

        a2 = 1;
        b_perturbed = a2 * interpolation_nodes.^2 + rand(size_n, 1) * 1e-9;
        computed_coefficients = V \ b_perturbed;

        reference_coefficients = [0; 0; a2; zeros(size_n - 3, 1)];
        interpolation_error_perturbed(index) = max(abs(computed_coefficients - reference_coefficients));
    end

    nexttile;
    semilogy(matrix_sizes, interpolation_error_perturbed, 'g');
    xlabel('Rozmiar macierzy');
    ylabel('Błąd interpolacji (zaburzone dane)');
    title('Błąd interpolacji dla funkcji f(x) = x^2 (zaburzenia 10^{-9})');
    grid on;
end

function V = get_vandermonde_matrix(x)
    N = length(x);
    V = ones(N, N);
    for i = 1:N
        for j = 2:N
            V(i, j) = x(i)^(j-1);
        end
    end
end
