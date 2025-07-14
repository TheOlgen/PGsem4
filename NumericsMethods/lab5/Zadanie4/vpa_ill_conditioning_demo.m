function [matrix_sizes, condition_numbers, interpolation_error_exact, interpolation_error_perturbed] = vpa_ill_conditioning_demo()
% Określa wpływ współczynnika uwarunkowania macierzy Vandermonde'a na dokładność interpolacji.

    a = vpa(-1);
    b = vpa(1);

    digits(50);  % ustaw precyzję

    matrix_sizes = 4:48:100;
    num_points = length(matrix_sizes);

    condition_numbers = zeros(1, num_points);
    interpolation_error_exact = zeros(1, num_points);
    interpolation_error_perturbed = zeros(1, num_points);

    %----------------------
    % Część 1: Uwarunkowanie
    %----------------------
    for index = 1:num_points
        size_n = matrix_sizes(index);
        indices = vpa(0:size_n-1)';
        interpolation_nodes = a + indices * (b - a) / vpa(size_n - 1);

        V = get_vandermonde_matrix(interpolation_nodes);
        condition_numbers(index) = double(cond(V));
    end

    % Prog złego uwarunkowania
    threshold_index = find(condition_numbers >= 1e8, 1);

    % Rysowanie wykresu 1
    tiledlayout(3, 1, 'Padding', 'compact', 'TileSpacing', 'compact');
    nexttile;
    semilogy(matrix_sizes, condition_numbers, 'b-o');
    title('Współczynnik uwarunkowania macierzy Vandermonde''a');
    xlabel('Rozmiar macierzy');
    ylabel('cond(V)');
    
    title('Uwarunkowanie macierzy Vandermonde’a');
    grid on;
    if ~isempty(threshold_index)
        xline(matrix_sizes(threshold_index), ':', 'cond(V) > 10^8', ...
            'LabelOrientation', 'horizontal', ...
            'LabelVerticalAlignment', 'top', ...
            'LabelHorizontalAlignment', 'left', ...
            'LineWidth', 2, ...
            'Color', [0.494 0.184 0.556]);
    end

    %----------------------
    % Część 2: Dokładne dane
    %----------------------
    for index = 1:num_points
        size_n = matrix_sizes(index);
        indices = vpa(0:size_n-1)';
        interpolation_nodes = a + indices * (b - a) / vpa(size_n - 1);

        V = get_vandermonde_matrix(interpolation_nodes);
        b_exact = interpolation_nodes.^2;
        reference_coefficients = [zeros(2,1); vpa(1); vpa(zeros(size_n - 3, 1))];
        computed_coefficients = V \ b_exact;

        interpolation_error_exact(index) = double(max(abs(computed_coefficients - reference_coefficients)));
    end

    % Rysowanie wykresu 2
    nexttile;
    plot(matrix_sizes, interpolation_error_exact, 'r-o');
    title('Błąd interpolacji (dokładne dane, f(x) = x^2)');
    xlabel('Rozmiar macierzy');
    ylabel('Maksymalny błąd współczynników');


    %----------------------
    % Część 3: Zaburzone dane
    %----------------------
    for index = 1:num_points
        size_n = matrix_sizes(index);
        interpolation_nodes = a + (0:size_n-1)' * (b - a) / vpa(size_n - 1);
        V = get_vandermonde_matrix(interpolation_nodes);

        noise = vpa(rand(size_n, 1) * 1e-9);
        b_perturbed = interpolation_nodes.^2 + noise;

        reference_coefficients = [zeros(2,1); vpa(1); vpa(zeros(size_n - 3, 1))];
        computed_coefficients = V \ b_perturbed;

        interpolation_error_perturbed(index) = double(max(abs(computed_coefficients - reference_coefficients)));
    end

    % Rysowanie wykresu 3
    nexttile;
    semilogy(matrix_sizes, interpolation_error_perturbed, 'k-o');
    title('Błąd interpolacji (dane zaburzone)');
    xlabel('Rozmiar macierzy');
    ylabel('Maksymalny błąd współczynników');

    grid on;

    % Zapis wykresów do pliku
    saveas(gcf, 'zadanie4.png');
end

function V = get_vandermonde_matrix(x)
    N = length(x);
    V = vpa(zeros(N));
    for j = 1:N
        V(:, j) = x.^(j - 1);
    end
end
