clear; clc; close all;

% 0. Preparing data
import DataAccess.*;
fileName = '../data/inputData.mat';
%tmp = DataAccess.convertDataFromCSV();
%save(fileName, 'tmp');
dao = DataAccess(fileName);
dao = dao.prepareInputAndOutpuForTesting();

% 1. Test for the best net
import NeuronNetwork.*;
net = NeuronNetwork(dao);
%net.executeTest('tansig', 'purelin', 10);

% 2. test performance without some features
%   use best net parameters!

for i = 1:5
    % Remove column i from net input
    newX = dao.removeColumn(i);
    
    % Test net performance without i column
    % these params are exampe ones!
    % TODO: change after finding best ones
    % newX.executeTest('tansig', 'tansig', 10);  
end

% 3. Predict exam results based on other exams