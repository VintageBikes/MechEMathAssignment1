%% Bisection Solver Function
function x = bisection_solver(fun, x_left, x_right, dxtol, ytol, max_iter)
    global input_list;
    
    y_left = fun(x_left);
    y_right = fun(x_right);
    % Throw an error if there is no solution between inputs
    if sign(y_left) == sign(y_right)
        error("Possibly no root between bisection inputs");
    end

    for i = 1:max_iter
        % Create a midpoint between inputs
        x_mid = (x_left+x_right)/2;
        input_list = [input_list, x_mid];

        % Return the root if dx is small enough
        if abs(x_left - x_mid) <= dxtol
            x = x_mid;
            return;
        end

        % Calculate y_mid
        y_mid = fun(x_mid);
        
        % Return the root if the value is (basically) 0
        if 0 <= abs(y_mid) && abs(y_mid) < ytol
            x = x_mid;
            return
        end

        % Determine if the midpoint should be the new right point or left point
        if sign(y_mid) == sign(y_left)
            x_right = x_mid;
        else
            x_left = x_mid;
        end
    end
    % Return the root if enough iterations have passed
    x = x_mid;
end