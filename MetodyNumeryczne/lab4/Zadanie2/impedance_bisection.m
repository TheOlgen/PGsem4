function [xvec, xdif, xsolution, ysolution, iterations] = impedance_bisection()
% Wyznacza miejsce zerowe funkcji impedance_difference metodą bisekcji.
% xvec - wektor z kolejnymi przybliżeniami miejsca zerowego, gdzie xvec(1)= (a+b)/2
% xdif - wektor różnic kolejnych przybliżeń miejsca zerowego
%   xdif(i) = abs(xvec(i+1)-xvec(i));
% xsolution - obliczone miejsce zerowe
% ysolution - wartość funkcji impedance_difference wyznaczona dla f=xsolution
% iterations - liczba iteracji wykonana w celu wyznaczenia xsolution

    a = 1; % lewa granica przedziału poszukiwań miejsca zerowego
    b = 10; % prawa granica przedziału poszukiwań miejsca zerowego
    ytolerance = 1e-12; % tolerancja wartości funkcji w przybliżonym miejscu zerowym.
    max_iterations = 1000; % maksymalna liczba iteracji wykonana przez alg. bisekcji
    
    % wartości w przedziale <a,b>
    fa = impedance_difference(a);
    fb = impedance_difference(b);

    if fa * fb > 0
        error('Funkcja nie zmienia znaku w przedziale [%f, %f]', a, b);
    end

    xvec = []; % kolejne przybliżenia
    xdif = []; % różnice między kolejnymi przybliżeniami
    xsolution = Inf;
    ysolution = Inf;
    iterations = max_iterations;

    for i = 1:max_iterations
        c = (a + b) / 2;
        xvec(i,1) = c;
        fc = impedance_difference(c); % punkt środkowy
        
        if i > 1
            xdif(i-1,1) = abs(xvec(i) - xvec(i-1)); % różnica między przybliżeniami
        end

        if abs(fc) < ytolerance
            xsolution = c;
            ysolution = fc;
            iterations = i;
            break 
        end

        % aktualizacja przedziału na podstawie znaku
        if fa * fc < 0
            b = c;
            fb = fc;
        else
            a = c;
            fa = fc;
        end
    end

    % rysowanie wykresów
    figure;
    subplot(2,1,1);
    plot(xvec, '-');
    xlabel('Numer iteracji');
    ylabel('Przybliżenie miejsca zerowego');
    title('Kolejne przybliżenia miejsca zerowego (skala liniowa)');
    grid on;

    subplot(2,1,2);
    semilogy(xdif, '-');
    xlabel('Numer iteracji');
    ylabel('Różnica x(i+1) i x(i)');
    title('Różnice między przybliżeniami (skala logarytmiczna)');
    grid on;
    print -dpng zadanie2.png 

end
