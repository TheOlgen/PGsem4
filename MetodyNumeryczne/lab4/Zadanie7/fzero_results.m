function [x1, y1, x2, y2] = fzero_results()
% UWAGA: w tej funkcji nie należy wywoływać funkcji fzero, tan.
% x1 - miejsce zerowe funkcji tangens obliczone dla x=4.5
% x2 - miejsce zerowe funkcji tangens obliczone dla x=6
% y1 - wartość funkcji tan wyznaczona dla argumentu x1
% y2 - wartość funkcji tan wyznaczona dla argumentu x2


options = optimset('Display', 'iter');
x1 = fzero(@tan, 4.5, options);
x2=  fzero(@tan, 6.0, options);

y1= tan(4.712388980384688);
y2= tan(6.283185307179586);

%x1 = 4.712388980384688;
%x2 = 6.283185307179586;

%y1 = 5.101900620073971e+14;
%y2 = -2.449293598294706e-16;

end