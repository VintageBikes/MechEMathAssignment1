%% Parts 1 and 2
% Initial guesses
x_guess0 = -5;
x_guess1 = 5;
dxtol = 1e-14;
ytol = 1e-14;
max_iter = 200;
dfdxmin = 1e-8;

bisection_solver(@test_function, x_guess0, x_guess1, dxtol, ytol, max_iter)
newton_solver(@test_function, x_guess0, dxtol, ytol, max_iter, dfdxmin)
secant_solver(@test_function, x_guess0, x_guess1, dxtol, ytol, max_iter, dfdxmin)
fzero(@test_function, x_guess0)


%% Part 3
% Create list of initial guesses
guess_list1 = linspace(-5, 5, 1000);
guess_list2 = linspace(0, 10, 1000);

figure();

% Bisection Method
subplot(2, 2, 1);
convergence_analysis(1, @test_function, x_guess0, guess_list1, guess_list2, 0)

% Newtons Method
subplot(2, 2, 2);
convergence_analysis(2, @test_function, x_guess0, guess_list1, guess_list2, 0)

% Secant Method
subplot(2, 2, 3);
convergence_analysis(3, @test_function, x_guess0, guess_list1, guess_list2, 0)

% Fzero Method
subplot(2, 2, 4);
convergence_analysis(4, @test_function, x_guess0, guess_list1, guess_list2, 0)


function [fval,dfdx] = test_function(x)
    fval = (x.^3)/100 - (x.^2)/8 + 2*x + 6*sin(x/2+6) -.7 - exp(x/6);
    dfdx =  3*(x.^2)/100 - 2*x/8 + 2 +(6/2)*cos(x/2+6) - exp(x/6)/6;
end