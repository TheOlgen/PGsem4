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