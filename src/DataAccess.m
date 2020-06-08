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
        end
        
        % Loads data form M file
        function obj = loadFromMFile(obj, fileName)
            obj.matrix = load(fileName).tmp;
        end
        
        % FIXME: is this working as intended? This can be prop done with
        % one line
        % Creates a new matrix withoud desired column
        function newDao = removeColumn(obj, columnIndex)
            newDao = obj;
            newDao.matrix = zeros(size(obj.matrix, 1), size(obj.matrix, 2) - 1);
            new_i = 1;
            for i = 1:size(newDao, 2)
                if i ~= columnIndex
                    newDao.matrix(:, new_i) =  newDao.matrix(:, i);
                    new_i = new_i + 1;
                end
            end
        end
        
        % Creates input and output for testing from processed data
        function obj = prepareInputAndOutpuForTesting(obj)
            % Input
            obj.X = obj.matrix(:, 1:5)
            % Output
            obj.D(:, 1) = obj.matrix(:, 6)
            obj.D(:, 2) = obj.matrix(:, 7);
            obj.D(:, 3) = obj.matrix(:, 8);
        end
    end
    
    
    
    methods(Static)
        function matrixData = convertDataFromCSV()
            % FIXME: file not in repo
            data = readtable('../data/datasets_74977_169835_StudentsPerformance.csv', 'HeaderLines', 1);
            matrixData = zeros(size(data));
            
            % Convert data to numeric
            % FIXME: better way
            j = 1; % gender
            for i = 1:height(data)
                tmp = data(i, j);
                tmp2 = tmp{1, 1};
                if (strcmp(tmp2{1}, 'female'))
                    matrixData(i, j) = 1;
                else
                    matrixData(i, j) = 1;
                end
            end
            
            j = 2; % race/ethnicity
            for i = 1:height(data)
                tmp = data(i, j);
                tmp2 = tmp{1, 1};
                if (strcmp(tmp2{1}, 'group A'))
                    matrixData(i, j) = 1;
                elseif (strcmp(tmp2{1}, 'group B'))
                    matrixData(i, j) = 2;
                elseif (strcmp(tmp2{1}, 'group C'))
                    matrixData(i, j) = 3;
                elseif (strcmp(tmp2{1}, 'group D'))
                    matrixData(i, j) = 4;
                else
                    matrixData(i, j) = 5;
                end
            end
            
            j = 3; % parental education
            for i = 1:height(data)
                tmp = data(i, j);
                tmp2 = tmp{1, 1};
                if (strcmp(tmp2{1}, 'some college'))
                    matrixData(i, j) = 1;
                elseif (strcmp(tmp2{1}, "associate's degree"))
                    matrixData(i, j) = 2;
                elseif (strcmp(tmp2{1}, 'high school'))
                    matrixData(i, j) = 3;
                elseif (strcmp(tmp2{1}, 'some high school'))
                    matrixData(i, j) = 4;
                elseif (strcmp(tmp2{1}, "master's degree"))
                    matrixData(i, j) = 5;
                else
                    matrixData(i, j) = 6;
                end
            end
            
            j = 4; % lunch
            for i = 1:height(data)
                tmp = data(i, j);
                tmp2 = tmp{1, 1};
                if (strcmp(tmp2{1}, 'standard'))
                    matrixData(i, j) = 1;
                else
                    matrixData(i, j) = 1;
                end
            end
            
            j = 5; % test preparation
            for i = 1:height(data)
                tmp = data(i, j);
                tmp2 = tmp{1, 1};
                if (strcmp(tmp2{1}, 'standard'))
                    matrixData(i, j) = 1;
                else
                    matrixData(i, j) = 1;
                end
            end
            
            matrixData(:, 6) = table2array(data(:, 6));
            matrixData(:, 7) = table2array(data(:, 7));
            matrixData(:, 8) = table2array(data(:, 8));
        end
    end
end


