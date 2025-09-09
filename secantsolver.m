%Secant Method Solver Function
function x = secantsolver(fun,x0, x1)
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
                x = secantsolver(fun, x1, x2);
            end
        end
    end
end