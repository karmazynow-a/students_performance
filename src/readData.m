

function matrixData = readData()
    data = readtable('../data/datasets_74977_169835_StudentsPerformance.csv', 'HeaderLines', 1);
    matrixData = zeros(size(data));

    % convert data to numeric
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