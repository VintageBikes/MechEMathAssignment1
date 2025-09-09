%Bisection Solver Function
function x = bisectionsolver(fun,x_left,x_right)
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
        x = bisectionsolver(fun, x_left, x_mid);
    else
        x = bisectionsolver(fun, x_mid, x_right);
    end
end