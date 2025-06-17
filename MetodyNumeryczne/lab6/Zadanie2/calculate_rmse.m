function [dates, y, rmse_values, M, c, ya] = calculate_rmse()
    % 1) Wyznacza RMSE w zależności od stopnia aproksymacji wielomianowej
    % 2) Wyznacza i przedstawia na wykresie aproksymację wielomianową wysokiego stopnia
    
    M = 90; % Stopień wielomianu aproksymacyjnego dla dolnego wykresu

    load energy_2025

    % --- WYBÓR DANYCH: kraj i źródło energii ---
    % Przykład: Polska, energia z węgla
    dates = energy_2025.Poland.Coal.Dates;
    y = energy_2025.Poland.Coal.EnergyProduction;

    % --- Normalizacja dziedziny ---
    N = numel(y);
    x = linspace(0,1,N)';

    % --- Inicjalizacja RMSE ---
    degrees = 1:N-1;
    rmse_values = zeros(length(degrees),1);

    % --- Obliczanie RMSE dla każdego stopnia ---
    for m = degrees
        c_temp = polyfit_qr(x, y, m);
        c_temp = c_temp(end:-1:1); % dostosowanie do polyval
        y_fit = polyval(c_temp, x);
        rmse_values(m) = sqrt(mean((y - y_fit).^2));
    end

    % --- Aproksymacja wysokiego stopnia ---
    c = polyfit_qr(x, y, M);
    c = c(end:-1:1);
    ya = polyval(c, x);

    % --- Wykresy ---
    figure;

    % Górny wykres – RMSE vs stopień wielomianu
    subplot(2,1,1);
    plot(degrees, rmse_values, 'b.-');
    xlabel('Stopień wielomianu');
    ylabel('RMSE');
    title('RMSE w zależności od stopnia wielomianu');
    grid on;

    % Dolny wykres – dane oryginalne i aproksymacja
    subplot(2,1,2);
    plot(dates, y, 'ko', 'DisplayName', 'Dane oryginalne');
    hold on;
    plot(dates, ya, 'r-', 'LineWidth', 1.5, 'DisplayName', ['Wielomian stopnia ' num2str(M)]);
    xlabel('Data');
    ylabel('Produkcja energii (TWh)');
    title(['Aproksymacja wielomianowa stopnia ' num2str(M)]);
    legend;
    grid on;

    % Eksport wykresu
    saveas(gcf, 'zadanie2.png');
end

function c = polyfit_qr(x, y, M)
    % Wyznacza współczynniki wielomianu aproksymacyjnego stopnia M
    % z zastosowaniem rozkładu QR.
    % Zwraca: kolumnowy wektor wsp. c = [c_0; ...; c_M]

    n = numel(x);
    A = zeros(n, M+1);

    % Budowa macierzy Vandermonde'a
    for j = 0:M
        A(:, j+1) = x.^j;
    end

    % Zredukowany rozkład QR i obliczenie współczynników
    [Q, R] = qr(A, 0);
    c = R \ (Q' * y);
end