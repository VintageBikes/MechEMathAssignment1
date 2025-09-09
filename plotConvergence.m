
function x = plotConvergence(solver, func, x0_list, options)
    arguments
        solver double
        func function_handle
        x0_list double
        options.x0_list2 double = NaN
        options.derivative function_handle = @NOP
    end
    global input_list;
    %% Step 4
    x_current_list = [];
    x_next_list = [];
    index_list = [];
    %loop through each trial
    for n = length(x0_list)
        %pull out the left and right guess for the trial
        x0 = x0_list(n);
        %clear the input_list global variable   
        input_list = x0;
        %run the solver
        if solver == 1
            if isnan(options.x0_list2)
                x = "Error: Bisection solver requires two list inputs";
                return
            end
            other_x0 = options.x0_list2(n);
            x_root = bisection_solver(func, x0, other_x0);
        elseif solver == 2
            if isequal(options.derivative, @NOP)
                x = "Error: Newton solver requires derivative function input";
                return
            else
                x_root = newton_solver({func, options.derivative},x0);
            end
        elseif solver == 3
            if isnan(options.x0_list2)
                x = "Error: Bisection solver requires two list inputs";
                return
            end
            other_x0 = options.x0_list2(n);
            x_root = secant_solver(func, x0, other_x0);
        elseif solver == 4
            x_root = fzero(func, x0);
        else
            x = "Error: solver option must be an integer between 1 and 4";
            return
        end

        if isstring(x_root)
            x = x_root;
            return
        end
        %at this point, input_list will be populated with the values that
        %the solver called at each iteration.
        %In other words, it is now [x_1,x_2,...x_n-1,x_n]
        %append the collected data to the compilation
            x_current_list = [x_current_list,input_list(1:end-1)];
            x_next_list = [x_next_list,input_list(2:end)];
            index_list = [index_list,1:length(input_list)-1];
    end
    
    e_list0 = abs(x_current_list-x_root);
    e_list1 = abs(x_next_list-x_root);
    loglog(e_list0,e_list1,'ro','MarkerFaceColor','r','MarkerSize',1)
    hold on

    
    e_list0 = abs(x_current_list-x_root);
    e_list1 = abs(x_next_list-x_root);
    loglog(e_list0,e_list1,'ro','MarkerFaceColor','r','MarkerSize',1)
    hold on

    %% Step 5
    x_regression = [];
    y_regression = [];
    
    for n=1:length(index_list)
        %if the error is not too big or too small
        %and it was enough iterations into the trial...
        if e_list0(n)>1e-15 && e_list0(n)<1e-2 && e_list1(n)>1e-14 && e_list1(n)<1e-2 && index_list(n)>2
            %then add it to the set of points for regression
            x_regression(end+1) = e_list0(n);
            y_regression(end+1) = e_list1(n);
        end
    end
    loglog(x_regression,y_regression,'b','MarkerFaceColor','r','MarkerSize',2)
    
    %% Step 6
    
    [p, k] = generate_error_fit(x_regression, y_regression);
    
    %generate x data on a logarithmic range
    fit_line_x = 10.^[-16:.01:1];
    %compute the corresponding y values
    fit_line_y = k*fit_line_x.^p;
    %plot on a loglog plot.
    loglog(fit_line_x,fit_line_y,'k-','linewidth',2)
    
    
    
    
    %% Step 7 TODO FIX THIS BECAUSE IT ONLY WORKS FOR NEWTONS METHOD
    
    expected_p = 2;
    [approximate_dfdx, approximate_d2fdx2] = approximate_derivative(func, x_root);
    expected_k = abs(approximate_d2fdx2/(2*approximate_dfdx));
    
    p; expected_p; k; expected_k;
end
    


%% Bisection Solver Function
function x = bisection_solver(fun,x_left,x_right)
    global input_list;
    %Test to ensure there is a solution between inputs
    if fun(x_left) * fun(x_right) > 0
        x = "Terminating: possibly no root between inputs";
        return
    end
    x_mid = (x_left+x_right)/2; %Create a midpoint between inputs
    input_list = [input_list, x_mid];
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

%% Newton's Method Function
%Newton's Method Solver Function
function x = newton_solver(fun,x0)
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
                x = newton_solver(fun, x1);
            end
        end
    end
end

%% Secant Method Solver Function
function x = secant_solver(fun, x0, x1)
    global input_list
    f_of_x0 = fun(x0);
    f_of_x1 = fun(x1);
    if f_of_x1 - f_of_x0 == 0
        x = "Terminating: division by 0";
        return
    end
    x2 = (f_of_x1*x0 - f_of_x0*x1) / (f_of_x1 - f_of_x0);
    input_list = [input_list, x2];
    if 0 <= abs(fun(x2)) && abs(fun(x2)) < 10^-13
        x = x2;
    else
        if abs(x1 - x0) >= 1000
            x = "Terminating: step size too large";
            return
        end
        x = secant_solver(fun, x1, x2);
    end
end

%% Function to generate error
function [p,k] = generate_error_fit(x_regression,y_regression)
    %generate Y, X1, and X2
    Y = log(y_regression)';
    X1 = log(x_regression)';
    X2 = ones(length(X1),1);
    %run the regression
    coeff_vec = regress(Y,[X1,X2]);
    %pull out the coefficients from the fit
    p = coeff_vec(1);
    k = exp(coeff_vec(2));
end

%% example of how to implement finite difference approximation
%for the first and second derivative of a function
%INPUTS:
%fun: the mathetmatical function we want to differentiate
%x: the input value of fun that we want to compute the derivative at
%OUTPUTS:
%dfdx: approximation of fun’(x)
%d2fdx2: approximation of fun’’(x)
function [dfdx,d2fdx2] = approximate_derivative(fun,x)
    %set the step size to be tiny
    delta_x = 1e-6;
    %compute the function at different points near x
    f_left = fun(x-delta_x);
    f_0 = fun(x);
    f_right = fun(x+delta_x);
    %approximate the first derivative
    dfdx = (f_right-f_left)/(2*delta_x);
    %approximate the second derivative
    d2fdx2 = (f_right-2*f_0+f_left)/(delta_x^2);
end
