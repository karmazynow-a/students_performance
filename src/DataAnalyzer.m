classdef DataAnalyzer 
    properties
        DAO;
    end
    
    methods
        function obj = DataAnalyzer(dao)
            obj.DAO = dao;
        end
        
        function obj =  showScoreDistribution(obj) 
            fig = figure;
            histogram( obj.DAO.matrix(:, 6), 0:10:100);
            title("Math score distribution");
            ylabel('Count');
            xlabel('Math Score');
            set(fig, 'PaperPosition', [0 0 10 10]); 
            set(fig, 'PaperSize', [10 10]); 
            saveas(gca, ['../images/math_score_distribution.pdf']);
            
            fig = figure;
            histogram( obj.DAO.matrix(:, 7), 0:10:100);
            title("Reading score distribution");
            ylabel('Count');
            xlabel('Reading Score');
            set(fig, 'PaperPosition', [0 0 10 10]); 
            set(fig, 'PaperSize', [10 10]); 
            saveas(gca, ['../images/reading_score_distribution.pdf']);
            
            fig = figure;
            histogram( obj.DAO.matrix(:, 8), 0:10:100);
            title("Writing score distribution");
            ylabel('Count');
            xlabel('Writing Score');
            set(fig, 'PaperPosition', [0 0 10 10]); 
            set(fig, 'PaperSize', [10 10]); 
            saveas(gca, ['../images/writing_score_distribution.pdf']);
        end
        
        function obj = showScoreDependingOnGender(obj) 
            genders = obj.DAO.matrix(:, 1);
            
            mathScore =  obj.DAO.matrix(:, 6);
            mathScoreFemale  = mathScore(genders == 1);
            mathScoreMale =  mathScore(genders == 2);
            x = [mathScoreFemale; mathScoreMale];
            g = [zeros(length(mathScoreFemale), 1); ones(length(mathScoreMale), 1)];
            fig = figure;
            boxplot(x, g, 'Labels',  {'Female', 'Male'})
            hold on;
            plot([mean(mathScoreFemale) mean(mathScoreMale)], 'dg');
            hold off;
            title("Math result depending on gender");
            ylabel('Score');
            set(fig, 'PaperPosition', [0 0 10 10]); 
            set(fig, 'PaperSize', [10 10]); 
            saveas(gca, ['../images/math_score_per_gender.pdf']);
            
            readingScore =  obj.DAO.matrix(:, 7);
            readingScoreFemale  = readingScore(genders == 1);
            readingScoreMale =  readingScore(genders == 2);
            x = [readingScoreFemale; readingScoreMale];
            g = [zeros(length(readingScoreFemale), 1); ones(length(readingScoreMale), 1)];
  
            fig = figure;
            boxplot(x, g, 'Labels',  {'Female', 'Male'})
            hold on;
            plot([mean(readingScoreFemale) mean(readingScoreMale)], 'dg');
            hold off;
            title("Reading result depending on gender");
            ylabel('Score');
            set(fig, 'PaperPosition', [0 0 10 10]); 
            set(fig, 'PaperSize', [10 10]); 
            saveas(gca, ['../images/reading_score_per_gender.pdf']);
            
            writingScore =  obj.DAO.matrix(:, 8);
            writingScoreFemale  = writingScore(genders == 1);
            writingScoreMale =  writingScore(genders == 2);
            x = [writingScoreFemale; writingScoreMale];
            g = [zeros(length(writingScoreFemale), 1); ones(length(writingScoreMale), 1)];
  
            fig = figure;
            boxplot(x, g, 'Labels',  {'Female', 'Male'})
            hold on;
            plot([mean(writingScoreFemale) mean(writingScoreMale)], 'dg');
            hold off;
            title("Writing result depending on gender");
            ylabel('Score');
            set(fig, 'PaperPosition', [0 0 10 10]); 
            set(fig, 'PaperSize', [10 10]); 
            saveas(gca, ['../images/writing_score_per_gender.pdf']);
        end
    end
    
end