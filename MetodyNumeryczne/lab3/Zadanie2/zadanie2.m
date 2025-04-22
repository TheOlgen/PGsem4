clear all
close all

% Zakres rozmiarów macierzy
vN = 1000:1000:8000;

% Wywołanie funkcji benchmarkującej
[A, b, x, vec_time_direct] = benchmark_solve_direct(vN);