global input_list;

%Definition of the test function and its derivative
test_func01 = @(x) (x.^3)/100 - (x.^2)/8 + 2*x + 6*sin(x/2+6) -.7 - exp(x/6);
test_derivative01 = @(x) 3*(x.^2)/100 - 2*x/8 + 2 +(6/2)*cos(x/2+6) - exp(x/6)/6;

%Newtons Method Tests
newtonsolver({test_func01, test_derivative01}, 0)
newtonsolver({test_func01, test_derivative01}, 30)

%% Step 4

num_iter = 1000;
x0_list = linspace(-5,5,num_iter);
x_current_list = [];
x_next_list = [];
index_list = [];
%loop through each trial
for n = 1:num_iter
    %pull out the left and right guess for the trial
    x0 = x0_list(n);
    %clear the input_list global variable   
    input_list = x0;
    %run the newton solver
    x_root = newtonsolver({test_func01, test_derivative01},x0);
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




%% Step 7

expected_p = 2;
[approximate_dfdx, approximate_d2fdx2] = approximate_derivative(test_func01, x_root);
expected_k = abs(approximate_d2fdx2/(2*approximate_dfdx));

p, expected_p, k, expected_k


%example of how to implement finite difference approximation
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




%% More Step 6
function [p,k] = generate_error_fit(x_regression,y_regression)
    %generate Y, X1, and X2
    %note that I use the transpose operator (’)
    %to convert the result from a row vector to a column
    %If you are copy-pasting, the ’ character may not work correctly
    Y = log(y_regression)';
    X1 = log(x_regression)';
    X2 = ones(length(X1),1);
    %run the regression
    coeff_vec = regress(Y,[X1,X2]);
    %pull out the coefficients from the fit
    p = coeff_vec(1);
    k = exp(coeff_vec(2));
end