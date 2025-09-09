%% Newton's Method Function
%Newton's Method Solver Function
function x = newtonsolver(fun,x0)
    global input_list
    %Termination if the slope is zero
    if fun{2}(x0) == 0
        x = "Terminating: division by 0";
    else
        x1 = x0 - (fun{1}(x0) / fun{2}(x0)); %calculate rise from run and slope
        input_list = [input_list, x1];
        if 0 <= abs(fun{1}(x1)) && abs(fun{1}(x1)) < 10^-13 %stop at small eno
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