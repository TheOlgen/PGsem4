clear all
close all

vN = 100:100:800;
[A,b,x,vec_loop_times,vec_iteration_count] = benchmark_solve_Gauss_Seidel(vN);