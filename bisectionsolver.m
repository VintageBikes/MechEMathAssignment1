%Definition of the test function and its derivative
test_func01 = @(x) (x.^3)/100 - (x.^2)/8 + 2*x + 6*sin(x/2+6) -.7 - exp(x/6);
test_derivative01 = @(x) 3*(x.^2)/100 - 2*x/8 + 2 +(6/2)*cos(x/2+6) - exp(x/6)/6;

%Bisection Tests
bisection_solver(test_func01, 0, 1)
bisection_solver(test_func01, 1, 40)
bisection_solver(test_func01, 1, 7)

%Bisection Solver Function
function x = bisection_solver(fun,x_left,x_right)
    %Test to ensure there is a solution between inputs
    if fun(x_left) * fun(x_right) > 0
        x = "Terminating: possibly no root between inputs";
        return
    end
    x_mid = (x_left+x_right)/2; %Create a midpoint between inputs
    f_of_x_mid = fun(x_mid); %Find function between
    %Determine if the midpoint should be the new right point or left point
    if 0 <= abs(f_of_x_mid) && abs(f_of_x_mid) < 10^-13
        x = x_mid; %Failsafe to stop function if the value is close enough to zero
    elseif f_of_x_mid * fun(x_left) < 0
        x = bisection_solver(fun, x_left, x_mid);
    else
        x = bisection_solver(fun, x_mid, x_right);
    end
end