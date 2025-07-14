function [dates, y, rmse_values, M, c_vpa, ya] = calculate_rmse_vpa()
% W tej funkcji obliczenia wykonywane są na zmiennych vpa, jednakże spośród
% zwracanych zmiennych tylko c_vpa jest wektorem zmiennych vpa.
%
% Funkcja calculate_rmse_vpa:
% 1) Wyznacza pierwiastek błędu średniokwadratowego w zależności od stopnia
%    aproksymacji wielomianowej danych przedstawiających produkcję energii.
% 2) Wyznacza i przedstawia na wykresie aproksymację wielomianową wysokiego
%    stopnia danych przedstawiających produkcję energii.
% Dla kraju C oraz źródła energii S:
% dates - wektor energy_2025.C.S.Dates (daty pomiaru produkcji energii)
% y - wektor energy_2025.C.S.EnergyProduction (poziomy miesięcznych produkcji energii)
% rmse_values(i,1) - RMSE wyznaczony dla wektora y i wielomianu i-tego stopnia
%     Rozmiar kolumnowego wektora wynosi length(y)-1.
% M - stopień wielomianu aproksymacyjnego przedstawionego na wykresie
% c_vpa - współczynniki wielomianu aproksymacyjnego przedstawionego na wykresie:
%       c = [c_M; ...; c_1; c_0]
% ya - wartości wielomianu aproksymacyjnego wyznaczone dla punktów danych
%       (rozmiar wektora ya powinien być taki sam jak rozmiar wektora y)

    digits(120); % ustawienie precyzji dla zmiennych vpa

    M = 70; % stopień wielomianu do wykresu

    load energy_2025.mat

    % TODO: wybierz kraj i źródło energii
    dates = energy_2025.Poland.Solar.Dates;
    y = energy_2025.Poland.Solar.EnergyProduction;

    % Przycięcie danych
    trim = 80;
    if numel(y) > trim
        dates = dates(1:trim,1);
        y = y(1:trim,1);
    end

    N = numel(y);
    degrees = [N-10, N-1]; % wymagane przez treść zadania

    x_vpa = linspace(vpa(0), vpa(1), N)';
    y_vpa = vpa(y);

    rmse_values = zeros(numel(degrees),1);

    % Oblicz RMSE dla każdego stopnia
    id = 1;
    for m = degrees
        c_m = polyfit_qr_vpa(x_vpa, y_vpa, m);
        ya_m = polyval_vpa(flipud(c_m), x_vpa); % dopasowanie kolejności
        rmse = sqrt(mean((ya_m - y_vpa).^2));
        rmse_values(id) = double(rmse);
        id = id + 1;
    end

    % Aproksymacja dla wykresu
    c_vpa = polyfit_qr_vpa(x_vpa, y_vpa, M);
    c_vpa = flipud(c_vpa); % dostosowanie do polyval
    ya_vpa = polyval_vpa(c_vpa, x_vpa);

    x = double(x_vpa);
    ya = double(ya_vpa); % konwersja do double

    % Wykresy
    figure;
    
    % Górny wykres - RMSE
    subplot(2,1,1);
    plot(degrees, rmse_values, 'o-', 'LineWidth', 1.5);
    title('RMSE vs stopień wielomianu (vpa)');
    xlabel('Stopień wielomianu');
    ylabel('RMSE');
    grid on;

    % Dolny wykres - Aproksymacja
    subplot(2,1,2);
    plot(x, y, 'b-', 'DisplayName', 'Dane rzeczywiste');
    hold on;
    plot(x, ya, 'r--', 'DisplayName', sprintf('Wielomian stopnia %d', M));
    title('Aproksymacja produkcji energii (vpa)');
    xlabel('x (przeskalowane)');
    ylabel('Produkcja energii');
    legend;
    grid on;

    saveas(gcf, 'zadanie3.png');
end

function c_vpa = polyfit_qr_vpa(x, y, M)
    % Tworzenie macierzy Vandermonde'a
    n = numel(x);
    A = vpa(zeros(n, M+1));
    for j = 0:M
        A(:, j+1) = x.^j;
    end

    % Rozkład QR
    [Q, R] = qr(A, 0);
    c_vpa = R \ (Q' * y);
end

function y = polyval_vpa(coefficients, x)
    % Schemat Hornera
    n = length(coefficients);
    y = vpa(zeros(size(x)));
    for i = 1:n
        y = y .* x + coefficients(i);
    end
end