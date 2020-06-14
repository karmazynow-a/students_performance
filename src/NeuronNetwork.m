classdef NeuronNetwork
    properties(Constant)
        p = [ 0.3 0.5 0.7 ]; % Sizes of testing set
        testSize = 5; % 20
    end
    
    properties
        DAO;
    end
    
    methods
        function obj = NeuronNetwork(dao)
            obj.DAO = dao;
        end
        
        function testMLP(obj, hiddenFcn, outputFcn, hiddenSize)
            % for each SAT result
            for d = obj.DAO.D
                mse_l = zeros(NeuronNetwork.testSize, length(NeuronNetwork.p));
                mse_t = zeros(NeuronNetwork.testSize, length(NeuronNetwork.p));
                
                for t = 1:NeuronNetwork.testSize
                    for k = 1:length(NeuronNetwork.p)
                        set_size = NeuronNetwork.p(k);
                        [x_l, d_l, x_t, d_t] =  NeuronNetwork.divideSet(set_size, obj.DAO.X, d);
                        [mse_l(t, k), mse_t(t, k)] = NeuronNetwork.testMLPParameters(hiddenFcn, outputFcn, hiddenSize, x_l', d_l', x_t', d_t');
                        disp(['MSE uczenia ' num2str(mse_l(t, k)) ' MSE testowania ' num2str(mse_t(t, k))]);
                    end
                end
                
                % plot MSE
                NeuronNetwork.plotNetworkPerformance(mse_l, 'Błąd uczenia MLP');
                NeuronNetwork.plotNetworkPerformance(mse_t, 'Błąd testowania MLP');
            end
        end
        
        function testFitnet(obj, hiddenSize)
            for d = obj.DAO.D
                mse_l = zeros(NeuronNetwork.testSize, length(NeuronNetwork.p));
                mse_t = zeros(NeuronNetwork.testSize, length(NeuronNetwork.p));
                
                for t = 1:NeuronNetwork.testSize
                    for k = 1:length(NeuronNetwork.p)
                        set_size = NeuronNetwork.p(k);
                        [x_l, d_l, x_t, d_t] =  NeuronNetwork.divideSet(set_size, obj.DAO.X, d);
                        [mse_l(t, k), mse_t(t, k)] = NeuronNetwork.testFitnetParameters(hiddenSize, x_l', d_l', x_t', d_t');
                        disp(['MSE uczenia ' num2str(mse_l(t, k)) ' MSE testowania ' num2str(mse_t(t, k))]);
                    end
                end
                
                NeuronNetwork.plotNetworkPerformance(mse_l, 'Błąd uczenia FITNET');
                NeuronNetwork.plotNetworkPerformance(mse_t, 'Błąd testowania FITNET');
            end
        end
        
    end
    
    methods(Static)
        function [x_learn, d_learn, x_test, d_test] = divideSet(p, x, d)
            s = length(x);
            i_inputs = randperm(s, round(s * (1 - p)));
            i_test = setdiff(1:s, i_inputs)';
            
            x_learn = x( i_inputs, : );
            d_learn = d( i_inputs, : );
            x_test = x( i_test, : );
            d_test = d( i_test, : );
        end
        
        
        function [mse_l, mse_t] = testMLPParameters(hiddenFcns, outputFcn, hiddenSizes, x, d, x_test, d_expected)
            net = feedforwardnet(hiddenSizes);
            net.divideFcn = 'dividetrain';
            
            numberOfHiddenLayers = length(hiddenSizes);
            
            % set transfer fcns
            for k = 1:numberOfHiddenLayers
                net.layers{k}.transferFcn = hiddenFcns(k);
            end
            
            net.layers{end}.transferFcn = outputFcn;
            
            net = configure(net, x, d);
            
            % set randome weights ans bias
            net.IW{1} = rand(size(net.IW{1}));
            net.b{end} = zeros(size(net.b{end}));
            
            for k = 1:numberOfHiddenLayers
                net.LW{k+1, k} = rand(size(net.LW{k+1, k}));
                net.b{k} = zeros(size(net.b{k}));
            end
            
            %view(net);
            net = train(net, x, d);
            
            d_learnt = net(x);
            d_test = net(x_test);
            
            % round values - results should be integers
            d_learnt = round(d_learnt);
            d_test = round(d_test);
            
            % Calculate mse
            mse_l = perform(net, d, d_learnt);
            %NeuronNetwork.plotResults(d, d_learnt, "Uczenie");
            mse_t = perform(net, d_expected, d_test);
            %NeuronNetwork.plotResults(d_expected, d_test, "Test");
        end
      
        function [mse_l, mse_t] = testFitnetParameters(hiddenSize, x, d, x_test, d_expected)
            disp(['Testing FITNET network with ' num2str(hiddenSize) ' hidden layer size']);
            net = fitnet(hiddenSize);
            net.divideFcn = 'dividetrain';
            
            net = configure(net, x, d);
            net.IW{1} = rand(size(net.IW{1}));
            net.LW{2, 1} = rand(size(net.LW{2, 1}));
            net.b{1} = zeros(size(net.b{1}));
            net.b{2} = zeros(size(net.b{2}));
            
            %view(net);
            net = train(net, x, d);
            
            d_learnt = net(x);
            d_test = net(x_test);
            
            % Round values - results should be integers
            d_learnt = round(d_learnt);
            d_test = round(d_test);
            
            % Calculate mse
            mse_l = perform(net, d, d_learnt);
            %NeuronNetwork.plotResults(d, d_learnt, "Uczenie");
            mse_t = perform(net, d_expected, d_test);
            %NeuronNetwork.plotResults(d_expected, d_test, "Test");
        end
        
        % FIXME: Move to another class?
        function plotResults(expected, learnt, t)
            figure;
            hold on;
            plot(learnt, " *");
            plot(expected, " *");
            title(t);
            legend('learnt', 'expected');
            hold off;
        end
        
        function plotNetworkPerformance(errs, t)
            y = zeros(size(NeuronNetwork.p));
            s = zeros(size(NeuronNetwork.p));
            for k = 1:length(NeuronNetwork.p)
                y(k) =  mean(errs(:, k));
                s(k) = std(errs(:, k));
            end
    
            figure;
            hold on;
            errorbar(NeuronNetwork.p, y, s, '-o');
            xlim([0.0 1.0]);
            title(t);
            xlabel('Parametr p');
            ylabel('Błąd średniokwadratowy');
            hold off;
        end
    end
end








