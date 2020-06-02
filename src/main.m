
% 0. read data
%import readData.*;
%tmp = readData();
%save('../data/inputData.mat', 'tmp');
load('../data/inputData.mat');

% input values
X = tmp(:, 1:5);

% output values
D(:, 1) = tmp(:, 6);
D(:, 2) = tmp(:, 7);
D(:, 3) = tmp(:, 8);

% 1. test for the best net
import executeTest.*;

%executeTest(X, D, 'tansig', 'tansig', 10);
%executeTest(X, D, 'radbas', 'radbas', 10);

% 2. test performance without some features
%   use best net parameters!

import removeColumn.*;

for i = 1:5
    % remove column i from net input
    X_tmp = removeColumn(X, i);
    
    % test net performance without i column
    %   these params are exampe ones!
    %   TODO change after finding best ones
    executeTest(X, D, 'tansig', 'tansig', 10);  
end

% 3. predict exam results based on other exams