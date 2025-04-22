function impedance_delta = impedance_difference(f)
% Wyznacza moduł impedancji równoległego obwodu rezonansowego RLC pomniejszoną o wartość M.
% f - częstotliwość (Hz)

    % Stałe
    R = 525; % rezystancja [ohm]
    C = 7e-5; % pojemnosc [F]
    L = 3; % indukcyjnosc [H]
    M = 75; % wartosc odniesienia [ohm]

    if f <= 0
        error('Częstotliwość musi być większa od zera.');
    end

    % obliczenie modułu impedancji
    omega = 2 * pi * f;
    term = omega * C - 1 / (omega * L);
    denominator = sqrt(1 / R^2 + term^2);
    Z = 1 / denominator;

    % roznica wzgledem wartosci odniesienia
    impedance_delta = Z - M;
end