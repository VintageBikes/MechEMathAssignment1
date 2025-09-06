%Definition of the test function and its derivative
test_func01 = @(x) (x.^3)/100 - (x.^2)/8 + 2*x + 6*sin(x/2+6) -.7 - exp(x/6);
test_derivative01 = @(x) 3*(x.^2)/100 - 2*x/8 + 2 +(6/2)*cos(x/2+6) - exp(x/6)/6;

%Newtons Method Tests
newton_solver({test_func01, test_derivative01}, 0)
newton_solver({test_func01, test_derivative01}, 30)

%Newton's Method Solver Function
function x = newton_solver(fun,x0)
    %Termination if the slope is zero
    if fun{2}(x0) == 0
        x = "Terminating: division by 0";
    else
        x1 = x0 - (fun{1}(x0) / fun{2}(x0)); %calculate rise from run and slope
        if 0 <= abs(fun{1}(x1)) && abs(fun{1}(x1)) < 10^-13 %stop at small eno
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