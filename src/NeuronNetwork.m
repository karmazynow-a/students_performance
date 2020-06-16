classdef NeuronNetwork
    properties(Constant)
        p = [ 0.3 0.5 0.7 ]; % Sizes of testing set
        testSize = 20;
    end
    
    properties
        DAO;
    end
    
    methods
        function obj = NeuronNetwork(dao)
            obj.DAO = dao;
        end
        
        function obj = testMutlipleLayersConfigurations(obj, neuronsPerLayerVector)
            for n=neuronsPerLayerVector
                % tansig + purelin is like fitnet
                obj.testMLP(["purelin"], 'tansig', [n], ['purelin_tansig_' num2str(n)]); 
                obj.testMLP(["purelin"], 'purelin', [n],  ['purelin_purelin_'  num2str(n)]); 
                obj.testMLP(["tansig"], 'purelin', [n], ['tansig_purelin_' num2str(n)]);
                obj.testMLP(["tansig"], 'tansig', [n], ['tansig_tansig_' num2str(n)]);
                obj.testMLP(["logsig" "tansig"], 'tansig', [n n], ['logsig_tansig_tansig_' num2str(n)]);
                obj.testMLP(["radbas" "tansig"], 'purelin', [n * 2 n], ['radbas_tansig_purelin_' num2str(n)]);
                obj.testMLP(["purelin" "purelin"], 'purelin', [n  n], ['purelin_purelin_purelin_' num2str(n)]);
            end
        end
        
        function obj = testNetworkAfterColumnRemoval(obj, innerLayerFn, outerLayerFn, neuronsPerLayer, fileName)
            for column = 1:5
                daoWithoutIColumn = obj.DAO.removeColumn(column);
                net = NeuronNetwork(daoWithoutIColumn);
                net.testMLP(innerLayerFn, outerLayerFn, neuronsPerLayer, [fileName num2str(column)]);  
            end
        end
        
        
        function testMLP(obj, hiddenFcn, outputFcn, hiddenSize, filename)
            mse_l = zeros(NeuronNetwork.testSize, size(obj.DAO.D, 2));
            mse_t = zeros(NeuronNetwork.testSize, size(obj.DAO.D, 2));
            
            % for each SAT result
            for k = 1:size(obj.DAO.D, 2)
                disp(['Exam ' num2str(k)]);
                d = obj.DAO.D(:, k);
                for t = 1:NeuronNetwork.testSize
                    [mse_l(t, k), mse_t(t, k)] = NeuronNetwork.testParameters(hiddenFcn, outputFcn, hiddenSize, obj.DAO.X', d');
                	disp(['Learn MSE' num2str(mse_l(t, k)) 'Test MSE' num2str(mse_t(t, k))]);
                end
            end
            
            NeuronNetwork.plotNetworkPerformance(mse_l, 'Learn error MLP', [filename '_learn']);
            NeuronNetwork.plotNetworkPerformance(mse_t, 'Test error MLP', [filename '_test']);
            NeuronNetwork.plotNetworkPerformanceWithBoxPlot(mse_l, 'Learn error MLP', [filename '_learnBoxplot']);
            NeuronNetwork.plotNetworkPerformanceWithBoxPlot(mse_t, 'Test error MLP', [filename '_testBoxplot']);
        end
        
        function testExams(obj, hiddenFcn, outputFcn, hiddenSize, filename)
            mse_l = zeros(NeuronNetwork.testSize, size(obj.DAO.D, 2));
            mse_t = zeros(NeuronNetwork.testSize, size(obj.DAO.D, 2));
            
            % for each SAT result
            for k = 1:size(obj.DAO.D, 2)
                disp(['Egzamin ' num2str(k)]);
                d = obj.DAO.D(:, k);
                x = [obj.DAO.D(:, mod(k, 3)+1) obj.DAO.D(:, mod(k+1, 3)+1)];
                
                for t = 1:NeuronNetwork.testSize
                    [mse_l(t, k), mse_t(t, k)] = NeuronNetwork.testParameters(hiddenFcn, outputFcn, hiddenSize, x', d');
                	disp(['MSE uczenia ' num2str(mse_l(t, k)) ' MSE testowania ' num2str(mse_t(t, k))]);
                end
            end
            
            NeuronNetwork.plotNetworkPerformance(mse_l, 'Learn error MLP', [filename '_learn']);
            NeuronNetwork.plotNetworkPerformance(mse_t, 'Test error MLP', [filename '_test']);
           
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
        
        
        function [mse_l, mse_t] = testParameters(hiddenFcns, outputFcn, hiddenSizes, x, d)
            net = feedforwardnet(hiddenSizes);
            
            net.divideParam.trainRatio = 70/100;
            net.divideParam.valRatio = 15/100;
            net.divideParam.testRatio = 15/100;
            
            numberOfHiddenLayers = length(hiddenSizes);
            
            % set transfer fcns
            for k = 1:numberOfHiddenLayers
                net.layers{k}.transferFcn = hiddenFcns(k);
            end
            
            net.layers{end}.transferFcn = outputFcn;
          
            % set random weights and bias
            net.IW{1} = rand(size(net.IW{1}));
            net.b{end} = zeros(size(net.b{end}));
            
            for k = 1:numberOfHiddenLayers
                net.LW{k+1, k} = rand(size(net.LW{k+1, k}));
                net.b{k} = zeros(size(net.b{k}));
            end
            
            [net, tr ]= train(net, x, d);
            %view(net);
          
            % training mse
            trainX = x(:, tr.trainInd);
            trainD = d(:, tr.trainInd);
            
            trainY = net(trainX);
            mse_l = mse(net, trainD, trainY);
            %figure, ploterrhist(trainD - trainY);
            %figure, plotregression(trainD, trainY);
            
            % testing mse
            testX = x(:, tr.testInd);
            testD = d(:, tr.testInd);
            
            testY = net(testX);
            mse_t = mse(net, testD, testY);
            %figure, ploterrhist(testD - testY);
            %figure, plotregression(testD, testY);
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
        
        function plotNetworkPerformance(errors, t, fname)
            y = zeros(1, 3);
            s = zeros(1, 3);
            for k = 1:3
                y(k) =  mean(errors(:, k));
                s(k) = std(errors(:, k));
            end
    
            figure;
            hold on;
            errorbar(1:3, y, s, ' o');
            xlim([0 4]);
            set(gca, 'XTick', 1:3, 'XTickLabel', {'Exam 1 (Math)', 'Exam 2 (Reading)', 'Exam 3 (Writing)'});
            title(t);
            ylabel('MSE');
            hold off;
            
            saveas(gca, ['../images/' fname '.png']);
        end
        
        function plotNetworkPerformanceWithBoxPlot(errors, t, fname)
            figure;
            boxplot(errors, 'Labels',  {'Exam 1 (Math)', 'Exam 2 (Reading)', 'Exam 3 (Writing)'})
            hold on;
            plot(mean(errors), 'dg');
            hold off;
            title(t);
            ylabel('MSE');
            saveas(gca, ['../images/' fname '.png']);
        end
    end
end








