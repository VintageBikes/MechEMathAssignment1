%% Newton's Method Function
%Newton's Method Solver Function
function x = newtonsolver(fun,x0)
    global input_list
    %Termination if the slope is zero
    [fval,dfdx] = fun(x0);

    if dfdx == 0
        x = "Terminating: division by 0";
    else
        x1 = x0 - (fval / dfdx); %calculate rise from run and slope
        input_list = [input_list, x1];
        if 0 <= abs(fval) && abs(fval) < 10^-13 %stop at small eno
            x = x1;
        else
            if abs(x1 - x0) >= 1000
                x = "Terminating: step size too large";
            else
                x = newtonsolver(fun, x1);
            end
        end
    end
end