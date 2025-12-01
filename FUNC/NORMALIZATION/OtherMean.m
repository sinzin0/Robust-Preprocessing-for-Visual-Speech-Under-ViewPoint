function [datas] = OtherMean(datas)
    [wordcnt, subcnt] = size(datas);
    for word = 1:wordcnt
        for subject = 1:subcnt
            [col, countcnt] = size(datas{word, subject});
            for(count=1:countcnt)
                mean_mat = mean(datas{word, subject}{count});
                std_mat = std(datas{word, subject}{count});
                datas{word, subject}{count} = ...
                    MeanNormalization(datas{word, subject}{count}, mean_mat, std_mat);
                
                clear mean_mat, std_mat;
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