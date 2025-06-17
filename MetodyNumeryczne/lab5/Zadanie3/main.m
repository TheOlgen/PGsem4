clear all
close all


[matrix_sizes, condition_numbers, interpolation_error_exact, interpolation_error_perturbed] = ill_conditioning_effects();
saveas(gcf, 'zadanie3.png');
