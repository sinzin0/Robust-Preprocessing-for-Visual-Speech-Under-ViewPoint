function [datas] = AVLETTERSAppMean(datas)
    for gridno=1:10
        for word = 1:26
            for subject = 1:10
                [~, countcnt] = size(datas{gridno, word, subject});
                for count=1:countcnt
                    mean_mat = mean(datas{gridno, word, subject}{count}.gray);
                    std_mat = std(datas{gridno, word, subject}{count}.gray);
                    datas{gridno, word, subject}{count}.gray = ...
                        MeanNormalization(datas{gridno, word, subject}{count}.gray, mean_mat, std_mat);

                    clear mean_mat, std_mat;
                    
                    mean_mat = mean(datas{gridno, word, subject}{count}.diff_gray);
                    std_mat = std(datas{gridno, word, subject}{count}.diff_gray);
                    datas{gridno, word, subject}{count}.diff_gray = ...
                        MeanNormalization(datas{gridno, word, subject}{count}.diff_gray, mean_mat, std_mat);

                    clear mean_mat, std_mat;
                end
            end
        end
    end
end

function [ result ] = MeanNormalization( data, mean_data, std_data )
    mean_mat = repmat(mean_data, [size(data, 1), 1]);
    std_mat = repmat(std_data, [size(data, 1), 1]);
    result = (data-mean_mat)./std_mat;
    nanidx = find(isnan(result)==1);
    result(nanidx) = 0;
end