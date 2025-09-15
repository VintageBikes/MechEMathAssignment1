%% Steps 1 and 2
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


% %% Step 3
% % Create list of initial guesses
% x0_list = linspace(-5, 5, 1000);
% x0_list2 = linspace(0, 10, 1000);
% 
% % % Bisection Method
% % plot_convergence(1, test_func01, x0_list)
% % 
% % % Newtons Method
% % plot_convergence(2, [test_func01, test_derivative01], x0_list)
% % 
% % % Secant Method
% % plot_convergence(3, test_func01, x0_list)
% % 
% % % Fzero Method
% % plot_convergence(4, test_func01, x0_list)
% 
% % Function to combine initial x guesses
% function combined_x0_list = combine_x0(x0_list1, x0_list2)
% 
% end
% 

function [fval,dfdx] = test_function(x)
    fval = (x.^3)/100 - (x.^2)/8 + 2*x + 6*sin(x/2+6) -.7 - exp(x/6);
    dfdx =  3*(x.^2)/100 - 2*x/8 + 2 +(6/2)*cos(x/2+6) - exp(x/6)/6;
end