function [xvec,xdif,xsolution,ysolution,iterations] = impedance_secant()
% Wyznacza miejsce zerowe funkcji impedance_difference metodą siecznych.
% xvec - wektor z kolejnymi przybliżeniami miejsca zerowego;
%   xvec(1)=x2 przy założeniu, że x0 i x1 są punktami startowymi
% xdif - wektor różnic kolejnych przybliżeń miejsca zerowego
%   xdif(i) = abs(xvec(i+1)-xvec(i));
% xsolution - obliczone miejsce zerowe
% ysolution - wartość funkcji impedance_difference wyznaczona dla f=xsolution
% iterations - liczba iteracji wykonana w celu wyznaczenia xsolution

    x0 = 1; % pierwszy punkt startowy metody siecznych
    x1 = 10; % drugi punkt startowy metody siecznych
    ytolerance = 1e-12;% tolerancja wartości funkcji w przybliżonym miejscu zerowym.
    % Warunek abs(f1(xsolution))<ytolerance określa jak blisko zera ma znaleźć
    % się wartość funkcji w obliczonym miejscu zerowym funkcji f1(), aby obliczenia
    % zostały zakończone.
    max_iterations = 1000; % maksymalna liczba iteracji wykonana przez alg. bisekcji

    f0 = impedance_difference(x0);
    f1 = impedance_difference(x1);
    
    xvec = zeros(max_iterations,1);
    xdif = zeros(max_iterations-1,1);
    xsolution = Inf;
    ysolution = Inf;
    iterations = max_iterations;
    
    for i = 1:max_iterations
        % zastosowanie wzoru dla siecznych
        x2 = x1 - f1 * (x1 - x0) / (f1 - f0);
        f2 = impedance_difference(x2);
    
        xvec(i) = x2;
        if i > 1
            xdif(i-1) = abs(xvec(i) - xvec(i-1)); % różnica między przybliżeniami
        end
    
        % sprawdzenie warunku dokładności
        if abs(f2) < ytolerance
            xsolution = x2;
            ysolution = f2;
            iterations = i;
            break
        end
    
        % aktualizacja zmiennych do kolejnej iteracji
        x0 = x1;
        f0 = f1;
        x1 = x2;
        f1 = f2;
    end
    
    
        
    xvec = xvec(1:iterations); % wybór tylko iteracji z wektora
    if iterations > 1
        xdif = xdif(1:iterations-1);
    else
        xdif = [];
    end
    
    % wykresy
    figure;
    subplot(2,1,1);
    plot(xvec, '-');
    xlabel('Iteracja');
    ylabel('Przybliżenie');
    title('Kolejne przybliżenia (skala liniowa)');
    grid on;
    
    subplot(2,1,2);
    semilogy(xdif, '-');
    xlabel('Iteracja');
    ylabel('Różnica x(i+1) i x(i)');
    title('Różnice między przybliżeniami (skala logarytmiczna)');
    grid on;
    print -dpng zadanie3.png 
end


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