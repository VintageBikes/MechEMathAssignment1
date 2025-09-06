%Definition of the test function and its derivative
test_func01 = @(x) (x.^3)/100 - (x.^2)/8 + 2*x + 6*sin(x/2+6) -.7 - exp(x/6);
test_derivative01 = @(x) 3*(x.^2)/100 - 2*x/8 + 2 +(6/2)*cos(x/2+6) - exp(x/6)/6;

%Secant Solver Tests
secant_solver(test_func01, 0, 1)
secant_solver(test_func01, 1, 40)
secant_solver(test_func01, 36, 40)

%Secant Method Solver Function
function x = secant_solver(fun,x0, x1)
    f_of_x0 = fun(x0);
    f_of_x1 = fun(x1);
    if f_of_x1 - f_of_x0 == 0
        x = "Terminating: division by 0";
    else
        x2 = (f_of_x1*x0 - f_of_x0*x1) / (f_of_x1 - f_of_x0);
        if 0 <= abs(fun(x2)) && abs(fun(x2)) < 10^-13
            x = x2;
        else
            if abs(x1 - x0) >= 1000
                x = "Terminating: step size too large";
            else
                x = secant_solver(fun, x1, x2);
            end
        end
    end
end