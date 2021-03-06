clear; clc; close all;

% 0. Preparing data
import DataAccess.*;
fileName = '../data/inputData.mat';
%tmp = DataAccess.convertDataFromCSV('../data/datasets_74977_169835_StudentsPerformance.csv')
%save(fileName, 'tmp');
dao = DataAccess(fileName);

% 1. Test multiple configurations to find best net
import NeuronNetwork.*;
net = NeuronNetwork(dao);
%net.testMutlipleLayersConfigurations(10:10:50);

% 2. Test performance without some features with best configuration found
% in previous point
%net.testNetworkAfterColumnRemoval(["purelin"], 'purelin', [20], ['purelin_purelin_20_without_']);


% 3. Predict exam results based on other exams
%net.testExams(["tansig"], 'purelin', [20], ['cz3_egz']);  

% *** Correlation
% correlation coeffitient - how good linear model can show relation between two columns
% a. between all exams results:
disp(corr(dao.D));

% plots for exams correlation
%{
figure;
fig = figure;
plot(dao.D(:, 2), dao.D(:, 3), ' *');
title("Correlation between reading and writing exam score");
xlabel("Reading score");
ylabel("Writing score");
set(fig, 'PaperPosition', [0 0 12 12]); 
set(fig, 'PaperSize', [12 12]); 
saveas(gca, '../images/korelacja_egzamin23.pdf');
%}

% b. between exams and input data:

for i = 1:5
    disp(corr([dao.D dao.X(:, i)]));
end

%{
fig = figure;
plot(dao.X(:, 5), dao.D(:, 3), ' *');
xlim([0 3]);
xticks([1 2])
title(["Correlation between completing test preparation " "course and writing exam score"]);
xticklabels({'Completed', 'None'})
xlabel("Test preparation course");
ylabel("Writing score");
set(fig, 'PaperPosition', [0 0 12 12]); 
set(fig, 'PaperSize', [12 12]); 
saveas(gca, '../images/korelacja_kurs_egzamin_3.pdf');
%}

% 4. Plot some histograms for data analysis
import DataAnalyzer.*;
da = DataAnalyzer(dao);
da.showScoreDistribution();
da.showScoreDependingOnGender();
da.showHistogramsDependingOnAttributes();

