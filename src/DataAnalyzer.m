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
        
        function obj = showHistogramsDependingOnAttributes(obj)
            import brewermap.*;
            import histf.*;
            import legalpha.*;
            genders = obj.DAO.matrix(:, 1);
            
            mathScore =  obj.DAO.matrix(:, 6);
            mathScoreFemale  = mathScore(genders == 1);
            mathScoreMale =  mathScore(genders == 2);
            
            map = brewermap(2,'Set1'); 
            
            fig = figure;
            histf(mathScoreFemale,0:1:100,'facecolor',map(1,:),'facealpha',.5,'edgecolor','none')
            hold on;
            histf(mathScoreMale,0:1:100,'facecolor',map(2,:),'facealpha',.5,'edgecolor','none')
            box off;
            axis tight;
            legalpha('Female','Male','location','northwest');
            legend boxoff;
            title("Math result depending on gender");
            xlabel('Score');
            ylabel('Count');
            
            set(fig, 'PaperPosition', [0 0 10 10]); 
            set(fig, 'PaperSize', [10 10]); 
            saveas(gca, ['../images/hist_math_score_per_gender.pdf']);
            
            
            raceEthnicity = obj.DAO.matrix(:, 2);
            mathScoreGroupA  = mathScore(raceEthnicity == 1);
            mathScoreGroupB  = mathScore(raceEthnicity == 2);
            mathScoreGroupC  = mathScore(raceEthnicity == 3);
            mathScoreGroupD  = mathScore(raceEthnicity == 4);
            map = brewermap(4,'Set2');   
            fig = figure;
            histf(mathScoreGroupA,0:10:100,'facecolor',map(1,:),'facealpha',.5,'edgecolor','none')
            hold on;
            histf(mathScoreGroupB,0:10:100,'facecolor',map(2,:),'facealpha',.5,'edgecolor','none')
            histf(mathScoreGroupC,0:10:100,'facecolor',map(3,:),'facealpha',.5,'edgecolor','none')
            histf(mathScoreGroupD,0:10:100,'facecolor',map(4,:),'facealpha',.5,'edgecolor','none')
            box off;
            axis tight;
            legalpha('Group A','Group B', 'Group C', 'Group D', 'location','northwest');
            legend boxoff;
            title("Math result depending on race");
            xlabel('Score');
            ylabel('Count');
            
            set(fig, 'PaperPosition', [0 0 10 10]); 
            set(fig, 'PaperSize', [10 10]); 
            saveas(gca, ['../images/hist_math_score_per_race.pdf']);
            
            % bachelor = 2, some college = 5, master = 4, associate = 1,
            % high school = 3, some high school = 6
            parent = obj.DAO.matrix(:, 3);
            college  = mathScore(parent == 5);
            college = [college; mathScore(parent == 4)];
            bachelor  = mathScore(parent == 2);
            bachelor = [bachelor; mathScore(parent == 2)];
            highSchool  = mathScore(parent == 6);
            highSchool = [highSchool; mathScore(parent == 3)];
            map = brewermap(5,'Set3');   
            fig = figure;
            histf(college,0:10:100,'facecolor',map(1,:),'facealpha',.5,'edgecolor','none')
            hold on;
            histf(bachelor,0:10:100,'facecolor',map(2,:),'facealpha',.5,'edgecolor','none')
            histf(highSchool,0:10:100,'facecolor',map(3,:),'facealpha',.5,'edgecolor','none')
         
            axis tight;
            legalpha('High School','Bachelor degree', 'Master', 'location','northwest');
            legend boxoff;
            title("Math result depending on parents education");
            xlabel('Score');
            ylabel('Count');
            
            set(fig, 'PaperPosition', [0 0 10 10]); 
            set(fig, 'PaperSize', [10 10]); 
            saveas(gca, ['../images/hist_math_score_per_parent_education.pdf']);
            
            
            lunch = obj.DAO.matrix(:, 4);
            standard  = mathScore(lunch == 2);
            free  = mathScore(lunch == 1);
           
            map = brewermap(2,'Set3');   
            fig = figure;
            histf(standard,0:1:100,'facecolor',map(1,:),'facealpha',.5,'edgecolor','none')
            hold on;
            histf(free,0:1:100,'facecolor',map(2,:),'facealpha',.5,'edgecolor','none')
         
            axis tight;
            legalpha('Standard','Reduced', 'location','northwest');
            legend boxoff;
            title("Math result depending on lunch");
            xlabel('Score');
            ylabel('Count');
            
            set(fig, 'PaperPosition', [0 0 10 10]); 
            set(fig, 'PaperSize', [10 10]); 
            saveas(gca, ['../images/hist_math_score_per_lunch.pdf']);
            
            testPrep = obj.DAO.matrix(:, 5);
            completed  = mathScore(testPrep == 1);
            none  = mathScore(testPrep == 2);
           
            map = brewermap(2,'Set2');   
            fig = figure;
            histf(none,0:1:100,'facecolor',map(1,:),'facealpha',.5,'edgecolor','none')
            hold on;
            histf(completed,0:1:100,'facecolor',map(2,:),'facealpha',.5,'edgecolor','none')
         
            axis tight;
            legalpha('None','Completed', 'location','northwest');
            legend boxoff;
            title("Math result depending on test preparation");
            xlabel('Score');
            ylabel('Count');
            
            set(fig, 'PaperPosition', [0 0 10 10]); 
            set(fig, 'PaperSize', [10 10]); 
            saveas(gca, ['../images/hist_math_score_per_test_prep.pdf']);
        end
    end
    
end