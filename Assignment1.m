%Definition of the test function and its derivative
test_func01 = @(x) (x.^3)/100 - (x.^2)/8 + 2*x + 6*sin(x/2+6) -.7 - exp(x/6);
test_derivative01 = @(x) 3*(x.^2)/100 - 2*x/8 + 2 +(6/2)*cos(x/2+6) - exp(x/6)/6;


bisection_solver(test_func01, 0, 1)
bisection_solver(test_func01, 1, 40)
bisection_solver(test_func01, 1, 7)

newton_solver({test_func01, test_derivative01}, 0)
newton_solver({test_func01, test_derivative01}, 30)

secant_solver(test_func01, 0, 1)
secant_solver(test_func01, 1, 40)
secant_solver(test_func01, 36, 40)


function x = bisection_solver(fun,x_left,x_right)
    if fun(x_left) * fun(x_right) > 0
        x = "Terminating: possibly no root between inputs";
        return
    end
    x_mid = (x_left+x_right)/2;
    f_of_x_mid = fun(x_mid);
    if 0 <= abs(f_of_x_mid) && abs(f_of_x_mid) < 10^-13
        x = x_mid;
    elseif f_of_x_mid * fun(x_left) < 0
        x = bisection_solver(fun, x_left, x_mid);
    else
        x = bisection_solver(fun, x_mid, x_right);
    end
end

%Note that fun(x) should output [f,dfdx], where dfdx is the derivative of f
function x = newton_solver(fun,x0)
    if fun{2}(x0) == 0
        x = "Terminating: division by 0";
    else
        x1 = x0 - (fun{1}(x0) / fun{2}(x0));
        if 0 <= abs(fun{1}(x1)) && abs(fun{1}(x1)) < 10^-13
            x = x1;
        else
            if abs(x1 - x0) >= 1000
                x = "Terminating: step size too large";
            else
                x = newton_solver(fun, x1);
            end
        end
    end
end

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

