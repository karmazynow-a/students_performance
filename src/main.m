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

% tansig + purelin is just like fitnet
%{
net.testMLP(["tansig"], 'purelin', [20], 'cz1_1');
net.testMLP(["tansig"], 'tansig', [20], 'cz1_2');
net.testMLP(["logsig" "tansig"], 'tansig', [20 20], 'cz1_3');
%}
%net.testMLP(["radbas" "tansig"], 'purelin', [40 20]);

% 2. test performance without some features
%   use best net parameters!

for i = 1:5
    % Remove column i from net input
    newX = dao.removeColumn(i);
    
    % Test net performance without i column
    % these params are exampe ones!
    % TODO: change after finding best ones
    net = NeuronNetwork(newX);
    %net.testMLP(["tansig"], 'purelin', [20], ['cz2_' num2str(i)]);  
end

% 3. Predict exam results based on other exams
net.testExams(["tansig"], 'purelin', [20], ['cz3_egz']);  

% *** Correlation
% correlation coeffitient - how good linear model can show relation between two columns
% a. between all exams results:
%{
disp(corr(dao.D));

% plots for exams correlation
figure;
title("Zależność pomiędzy wynikami egzaminu 1 i 2");
plot(dao.D(:, 1), dao.D(:, 2), ' *');
xlabel("Egzamin 1");
ylabel("Egzamin 2");
saveas(gca, '../images/korelacja_egzamin12.png');
%}

% b. between exams and input data:
%{
for i = 1:5
    disp(corr([dao.D dao.X(:, i)]));
end
%}
