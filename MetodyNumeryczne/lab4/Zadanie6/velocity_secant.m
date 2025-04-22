function [xvec,xdif,xsolution,ysolution,iterations] = velocity_secant()
% Wyznacza miejsce zerowe funkcji velocity_difference metodą siecznych.
% xvec - wektor z kolejnymi przybliżeniami miejsca zerowego;
%   xvec(1)=x2 przy założeniu, że x0 i x1 są punktami startowymi
% xdif - wektor różnic kolejnych przybliżeń miejsca zerowego
%   xdif(i) = abs(xvec(i+1)-xvec(i));
% xsolution - obliczone miejsce zerowe
% ysolution - wartość funkcji velocity_difference wyznaczona dla f=xsolution
% iterations - liczba iteracji wykonana w celu wyznaczenia xsolution

    x0 = 1; % pierwszy punkt startowy metody siecznych
    x1 = 40; % drugi punkt startowy metody siecznych
    ytolerance = 1e-12;% tolerancja wartości funkcji w przybliżonym miejscu zerowym.
    % Warunek abs(f1(xsolution))<ytolerance określa jak blisko zera ma znaleźć
    % się wartość funkcji w obliczonym miejscu zerowym funkcji f1(), aby obliczenia
    % zostały zakończone.
    max_iterations = 1000; % maksymalna liczba iteracji wykonana przez alg. bisekcji


    f0 = velocity_difference(x0);
    f1 = velocity_difference(x1);

    xvec = [];
    xdif = [];
    xsolution = Inf;
    ysolution = Inf;
    iterations = max_iterations;

    for i = 1:max_iterations
        if abs(f1 - f0) < eps
            warning('Zbyt mała różnica w mianowniku – możliwa dzielność przez zero');
            break;
        end

        % oblicz nowe przybliżenie
        x2 = x1 - f1 * (x1 - x0) / (f1 - f0);
        f2 = velocity_difference(x2);

        % zapisz przybliżenie
        xvec(i, 1) = x2;

        if i > 1
            xdif(i-1, 1) = abs(xvec(i) - xvec(i-1));
        end

        % sprawdź warunek zakończenia
        if abs(f2) < ytolerance
            xsolution = x2;
            ysolution = f2;
            iterations = i;
            break;
        end

        % przygotuj dane do kolejnej iteracji
        x0 = x1;
        f0 = f1;
        x1 = x2;
        f1 = f2;
    end

    % wykresy
    figure;
    subplot(2,1,1)
    plot(xvec, '-');
    title('Kolejne przybliżenia miejsca zerowego (skala liniowa)');
    xlabel('Iteracja');
    ylabel('x');

    subplot(2,1,2)
    semilogy(xdif, '-');
    title('Różnice między kolejnymi przybliżeniami (skala logarytmiczna)');
    xlabel('Iteracja');
    ylabel('Różnica x(i+1) - x(i)');
    grid on;

    print -dpng zadanie6.png
end

function velocity_delta = velocity_difference(t)
% t - czas od startu rakiety

    if t <= 0
        error('Czas musi być większy od zera.');
    end

    u = 2000; % [m/s]
    m0 = 150000; % [kg]
    q = 2700; % [kg/s]
    g = 1.622; % [m/s^2]
    M = 700; % [m/s]

    % oblicz predkosc
    v = u * log(m0 / (m0 - q * t)) - g * t;

    % oblicz roznice
    velocity_delta = v - M;
end