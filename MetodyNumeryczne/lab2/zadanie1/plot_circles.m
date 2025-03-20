% Funkcja plot_circles.m
function plot_circles(a, b, circles)
    figure;
    axis equal;
    axis([0 a 0 b]);
    hold on;
    
    for i = 1:size(circles, 1)
        X = circles(i, 1);
        Y = circles(i, 2);
        R = circles(i, 3);
        plot_circle( R,X, Y);
    end
    
    hold off;
end