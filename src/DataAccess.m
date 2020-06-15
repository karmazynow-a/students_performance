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

        % Creates a new matrix without desired column
        function newDao = removeColumn(obj, columnIndex)
            newDao = obj;
            newDao.matrix(:, columnIndex) = [];
        end
        
        % Creates input and output for testing from processed data
        function obj = prepareInputAndOutpuForTesting(obj)
            % Input
            obj.X = obj.matrix(:, 1:5);
            % Output
            obj.D(:, 1) = obj.matrix(:, 6);
            obj.D(:, 2) = obj.matrix(:, 7);
            obj.D(:, 3) = obj.matrix(:, 8);
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


