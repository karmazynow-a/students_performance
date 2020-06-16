classdef DataAccess
    
    properties
        matrix; % Processed data
        X; % Input values
        D; % Output values
    end
    
    methods
        % Constructor
        function obj = DataAccess(fileName)
            obj.matrix = load(fileName).tmp;
            obj.X = obj.matrix(:, 1:end-3);  % Input
            obj.D = obj.matrix(:, end-2:end);  % Output
        end
        
        % Loads data form M file
        function obj = loadFromMFile(obj, fileName)
            obj.matrix = load(fileName).tmp;
            obj.X = obj.matrix(:, 1:end-3);  % Input
            obj.D = obj.matrix(:, end-2:end);  % Output
        end

        % Creates a new matrix without desired column
        function newDao = removeColumn(obj, columnIndex)
            newDao = obj;
            newDao.matrix(:, columnIndex) = [];
            newDao.X = newDao.matrix(:, 1:end-3);  % Input
            newDao.D = newDao.matrix(:, end-2:end);  % Output
        end
    end
    
    methods(Static)
        % Convert string data to numeric values
        function matrix = convertDataFromCSV(fileName)
            a = table2array(readtable(fileName, 'HeaderLines', 1));
            matrix = zeros(size(a));
            for i=1:size(a, 2)
                matrix(:, i) = grp2idx(categorical(a(:, i)));
            end
        end
    end
end


