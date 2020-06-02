
% TODO
%   add multiple layers to feedforward
%   test params multiple times

function executeTest(X, D, hiddenFcn, outputFcn, hiddenSize)
    % size of testing set
    p = [ 0.3 0.5 0.7 ];

    for d = D
       for set_size = p
           [x_l, d_l, x_t, d_t] =  divideSet(set_size, X, d);
           [mse_l, mse_t] = testParameters(hiddenFcn, outputFcn, hiddenSize, x_l', d_l', x_t', d_t');

           disp(['MSE uczenia ' num2str(mse_l) ' MSE testowania ' num2str(mse_t)]);
       end
    end
end

function [x_learn, d_learn, x_test, d_test] = divideSet(p, x, d)
    s = length(x);
    i_inputs = randperm(s, round(s * (1 - p)));
    i_test = setdiff(1:s, i_inputs)';

    x_learn = x( i_inputs, : );
    d_learn = d( i_inputs, : );
    x_test = x( i_test, : );
    d_test = d( i_test, : );
end

function [mse_l, mse_t] = testParameters(hiddenFcn, outputFcn, hiddenSize, x, d, x_test, d_expected)
    net = feedforwardnet(hiddenSize);
    net.divideFcn='dividetrain';
    
    net.layers{1}.transferFcn = hiddenFcn;  % hidden
    net.layers{2}.transferFcn = outputFcn;  % output

    net = configure(net, x, d);
    net.IW{1} = rand(size(net.IW{1}));
    net.LW{2, 1} = rand(size(net.LW{2, 1}));
    net.b{1} = zeros(size(net.b{1}));
    net.b{2} = zeros(size(net.b{2}));
    
    %view(net);
    net = train(net, x, d);
    
    d_learnt = net(x);
    d_test = net(x_test);
    
    % round values - results should be integers
    d_learnt = round(d_learnt);
    d_test = round(d_test);
    
    % calculate mse
    mse_l = perform(net, d, d_learnt);
    plotResults(d, d_learnt, "Uczenie");
    mse_t = perform(net, d_expected, d_test);
    plotResults(d_expected, d_test, "Test");
end

function plotResults(expected, learnt, t)
    figure;
    hold on;
    plot(learnt, " *");
    plot(expected, " *");
    title(t);
    legend('learnt', 'expected');
    hold off;
end