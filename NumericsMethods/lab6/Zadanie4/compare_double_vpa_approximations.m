function [dates, y, M, x_fine, c, ya, c_vpa, yv] = compare_double_vpa_approximations()
% W tej funkcji obliczenia wykonywane są na zmiennych vpa, jednakże spośród
% zwracanych zmiennych tylko c_vpa jest wektorem zmiennych vpa.
%
% Funkcja compare_double_vpa_approximations generuje trzy wykresy:
% 1) Górny wykres przedstawia aproksymację wyznaczoną na liczbach w podwójnej precyzji.
% 2) Środkowy wykres przedstawia aproksymację wyznaczoną na zmiennych vpa.
% 3) Dolny wykres przedstawia zakres wartości współczynników wielomianu
%    aproksymacyjnego wyznaczonych w precyzji double i vpa.
% 
% Dla kraju C oraz źródła energii S:
% dates - wektor energy_2025.C.S.Dates (daty pomiaru produkcji energii)
% y - wektor energy_2025.C.S.EnergyProduction (poziomy miesięcznych produkcji energii)
% M - stopień wielomianu aproksymacyjnego przedstawionego na wykresie
% x_fine - definiuje siatkę gęstą dla której obliczany jest wektor ya
%   Zachowaj jego definicję do oceny w Matlab Grader:
%   nodes = 4; % określa stopień zagęszczenia siatki gęstej
%   x_fine_vpa = linspace(vpa(0),vpa(1),(N-1)*nodes+1)';
%   x_fine = double(x_fine_vpa);
% c - współczynniki wielomianu aproksymacyjnego wyznaczone w obliczeniach
%   wykonywanych na zmiennych double. c = [c_M; ...; c_1; c_0]
% ya - wartości wielomianu aproksymacyjnego wyznaczone w punktach x_fine
%       z zastosowaniem zmiennych w podwójnej precyzji.
% c_vpa - współczynniki wielomianu aproksymacyjnego wyznaczone w obliczeniach
%       z zastosowaniem zmiennych vpa. c_vpa = [c_vpa_M; ...; c_vpa_0]
% yv - wartości wielomianu aproksymacyjnego wyznaczone w punktach x_fine_vpa
%       z zastosowaniem zmiennych vpa.

    digits(120); % określa liczbę cyfr dziesiętnych w zmiennych vpa

    M = 90; % stopień wielomianu aproksymacyjnego

    load energy_2025

    dates = energy_2025.Poland.Coal.Dates;
    y = energy_2025.Poland.Wind.EnergyProduction;

    N = numel(y);

    % siatka rzadka
    x_vpa = linspace(vpa(0),vpa(1),N)';
    x = double(x_vpa);

    % siatka gęsta
    nodes = 4; % określa stopień zagęszczenia siatki gęstej
    x_fine_vpa = linspace(vpa(0),vpa(1),(N-1)*nodes+1)';
    x_fine = double(x_fine_vpa);

    % obliczenia dla wykresu górnego (precyzja double)
    c = polyfit_qr(x, y, M);
    c = c(end:-1:1); % dostosowanie do polyval
    ya = polyval(c, x_fine);


    % obliczenia dla wykresu środkowego (precyzja vpa)
    y_vpa = vpa(y);

    c_vpa = polyfit_qr_vpa(x_vpa, y_vpa, M);
    c_vpa = c_vpa(end:-1:1); % odwrócenie kolejności wektora c: dostosowanie do polyval
    yv = double(polyval_vpa(c_vpa, x_fine_vpa));

    % TODO:
    % Wykresy
    ymax = max(y)*2;
    ymin = -0.25*ymax;

    figure;
    
    % Górny wykres: double
    subplot(3,1,1);
    plot(x_fine, ya, 'b', x, y, 'ro');
    title('Aproksymacja (double)');
    xlabel('x');
    ylabel('y');
    legend('ya (double)', 'dane oryginalne');
    ax = axis;
    ax(3) = ymin;
    ax(4) = ymax;
    axis(ax);
    
    % Środkowy wykres: vpa
    subplot(3,1,2);
    plot(x_fine, yv, 'g', x, y, 'ro');
    title('Aproksymacja (vpa)');
    xlabel('x');
    ylabel('y');
    legend('yv (vpa)', 'dane oryginalne');
    ax = axis;
    ax(3) = ymin;
    ax(4) = ymax;
    axis(ax);
    
    % Dolny wykres: porównanie współczynników
    subplot(3,1,3);
    plot_c_range(c, c_vpa);

    saveas(gcf, 'zadanie4.png');
end

function c = polyfit_qr(x, y, M)
    A = zeros(numel(x), M+1);
    for j = 0:M
        A(:, j+1) = x.^j;
    end
    [Q, R] = qr(A, 0);
    c = R \ (Q' * y);
end


function c_vpa = polyfit_qr_vpa(x, y, M)
    % Tworzenie macierzy Vandermonde'a (symbolicznie)
    n = numel(x);
    A = vpa(zeros(n, M+1));
    for j = 0:M
        A(:, j+1) = x.^j;
    end

    % Rozkład QR (pełny) i redukcja wymiaru
    [Q, R] = qr(A);  % dla vpa nie ma opcji economy size
    Q = Q(:, 1:(M+1)); % redukcja Q
    R = R(1:(M+1), :); % redukcja R

    % Rozwiązanie równania QR * c = y
    c_vpa = R \ (Q' * y);
end


function y = polyval_vpa(coefficients, x)
% Oblicza wartość wielomianu w punktach x dla współczynników coefficients.
% Obliczenia wykonywane są na zmiennych vpa.
% coefficients – wektor współczynników wielomianu w kolejności od najwyższej potęgi
% x – wektor argumentów (vpa)
% y – wektor wartości wielomianu (vpa)

    n = length(coefficients);
    y = vpa(zeros(size(x)));  % inicjalizacja wyniku jako vpa

    for i = 1:n
        y = y .* x + coefficients(i);  % schemat Hornera
    end
end

function plot_c_range(c, c_vpa)
    c1log = sort(log10(abs(c)+1e-50)); % 1e-50: zabezpieczenie przez c(i)=0
    c2log = sort(log10(abs(c_vpa)+1e-50));

    plot(c1log,'kx-'); hold on
    plot(c2log,'bo-')
    hold off

    title('Zakres wartości współczynników c: double vs. vpa')
    xlabel('Indeks po sortowaniu według |c|')
    ylabel('$$\log_{10}\left(10^{-50} + |c|\right)$$', 'Interpreter', 'latex')

    legend('precyzja double', 'precyzja vpa', 'Location', 'eastoutside' );
end