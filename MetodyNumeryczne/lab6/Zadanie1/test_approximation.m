function [dates, y, M, c, ya] = test_approximation()
    % Wyznacza aproksymację wielomianową danych przedstawiających produkcję energii.
    % Dla kraju C oraz źródła energii S:
    % dates - wektor energy_2025.C.S.Dates (daty pomiaru produkcji energii)
    % y - wektor energy_2025.C.S.EnergyProduction (poziomy miesięcznych produkcji energii)
    % M - stopień wielomianu aproksymacyjnego
    % c - współczynniki wielomianu aproksymacyjnego: c = [c_M; ...; c_1; c_0]
    % ya - wartości wielomianu aproksymacyjnego wyznaczone dla punktów danych

    load energy_2025.mat

    % ======== WYBÓR KRAJU I ŹRÓDŁA ENERGII ============
    % Zmieniamy C na konkretny kraj, S na konkretną technologię
    dates = energy_2025.Poland.Coal.Dates;
    y = energy_2025.Poland.Coal.EnergyProduction;

    if numel(y) < 100
        error('Wybrany zbiór danych musi zawierać co najmniej 100 elementów.');
    end

    M = 12; % stopień wielomianu aproksymacyjnego
    N = numel(y); % liczba punktów danych

    % Normalizacja osi x
    x = linspace(0, 1, N)';

    % Aproksymacja
    c = polyfit_qr(x, y, M); % współczynniki wielomianu w kolejności [c_0; ...; c_M]
    c = c(end:-1:1); % odwrócenie do postaci dla polyval: [c_M; ...; c_0]

    ya = polyval(c, x); % wartości wielomianu w punktach x

    % ======== WYKRES ============
    figure;
    plot(dates, y, 'b.-', 'DisplayName', 'Dane rzeczywiste');
    hold on;
    plot(dates, ya, 'r-', 'LineWidth', 2, 'DisplayName', sprintf('Aproksymacja %d st.', M));
    grid on;
    title(sprintf('Aproksymacja wielomianowa (%d stopnia) produkcji energii - Poland, Coal', M));
    xlabel('Data');
    ylabel('Produkcja energii [TWh]');
    legend('Location', 'best');
    hold off;

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
