function [xvec,xdif,xsolution,ysolution,iterations] = velocity_bisection()
% Wyznacza miejsce zerowe funkcji velocity_difference metodą bisekcji.
% xvec - wektor z kolejnymi przybliżeniami miejsca zerowego, gdzie xvec(1)= (a+b)/2
% xdif - wektor różnic kolejnych przybliżeń miejsca zerowego
%   xdif(i) = abs(xvec(i+1)-xvec(i));
% xsolution - obliczone miejsce zerowe
% ysolution - wartość funkcji velocity_difference wyznaczona dla t=xsolution
% iterations - liczba iteracji wykonana w celu wyznaczenia xsolution

    a = 1; % lewa granica przedziału poszukiwań miejsca zerowego
    b = 40; % prawa granica przedziału poszukiwań miejsca zerowego
    ytolerance = 1e-12; % tolerancja wartości funkcji w przybliżonym miejscu zerowym.
    % Warunek abs(f1(xsolution))<ytolerance określa jak blisko zera ma znaleźć
    % się wartość funkcji w obliczonym miejscu zerowym funkcji f1(), aby obliczenia
    % zostały zakończone.
    max_iterations = 1000; % maksymalna liczba iteracji wykonana przez alg. bisekcji

    % wartości w przedziale <a,b>
    fa = velocity_difference(a);
    fb = velocity_difference(b);

    if fa * fb > 0
        error('Brak zmiany znaku. Nie można zastosować metody bisekcji.');
    end

    xvec = []; % kolejne przybliżenia
    xdif = []; % różnice między kolejnymi przybliżeniami
    xsolution = Inf;
    ysolution = Inf;
    iterations = max_iterations;

    for i = 1:max_iterations
        c = (a + b) / 2;
        xvec(i, 1) = c;
        fc = velocity_difference(c); % punkt srodkowy

        if i > 1
            xdif(i-1, 1) = abs(xvec(i) - xvec(i-1)); % różnica między przybliżeniami
        end

        if abs(fc) < ytolerance
            xsolution = c;
            ysolution = fc;
            iterations = i;
            break;
        end

        if sign(fc) == sign(fa) % aktualizacja przedziału
            a = c;
            fa = fc;
        else
            b = c;
            fb = fc;
        end

        
    end

    % Wykresy
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
    ylabel('Różnica x(i+1) i x(i)');
    print -dpng zadanie5.png 

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