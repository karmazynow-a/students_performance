clear; clc; close all;

% 0. Preparing data
import DataAccess.*;
fileName = '../data/inputData.mat';
%tmp = DataAccess.convertDataFromCSV('../data/datasets_74977_169835_StudentsPerformance.csv')
%save(fileName, 'tmp');
dao = DataAccess(fileName);
dao = dao.prepareInputAndOutpuForTesting();

% 1. Test for the best net
import NeuronNetwork.*;
net = NeuronNetwork(dao);
%net.testMLP(["logsig" "tansig"], 'purelin', [20 20]);
%net.testMLP(["radbas" "tansig"], 'purelin', [40 20]);

hiddenNetSizes = [5 10 15 20 30 40];
for h = hiddenNetSizes
    %net.testFitnet(h);
end

net.testFitnet(10);

% 2. test performance without some features
%   use best net parameters!

for i = 1:5
    % Remove column i from net input
    newX = dao.removeColumn(i);
    
    % Test net performance without i column
    % these params are exampe ones!
    % TODO: change after finding best ones
    %net = NeuronNetwork(newX);
    %net.executeTest('tansig', 'tansig', 10);  
end

% 3. Predict exam results based on other exams