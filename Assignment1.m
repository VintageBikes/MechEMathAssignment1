%Definition of the test function and its derivative
test_func01 = @(x) (x.^3)/100 - (x.^2)/8 + 2*x + 6*sin(x/2+6) -.7 - exp(x/6);
test_derivative01 = @(x) 3*(x.^2)/100 - 2*x/8 + 2 +(6/2)*cos(x/2+6) - exp(x/6)/6;

% Create list of initial guesses
x0_list = linspace(-5, 5, 1000);
x0_list2 = linspace(0, 10, 1000);

%% 
% Bisection Method Tests
plot_Convergence(1, test_func01, x0_list, x0_list2)
%% 
% Newtons Method Tests
plot_Convergence(2, test_func01, x0_list, x0_list2)
%% 
% Secant Method Test
plot_Convergence(3, test_func01, x0_list, x0_list2)
%% 
% Fzero Method Test
plot_Convergence(4, test_func01, x0_list, x0_list2)