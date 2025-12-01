function [ datas ] = AEMean( datas)
    for subject = 1:16
        for word = 1:10
            [col, countcnt] = size(datas{subject, word});
            for(count=1:countcnt)
                mean_mat = mean(datas{subject, word}{count});
                std_mat = std(datas{subject, word}{count});
                datas{subject, word}{count} = ...
                    MeanNormalization(datas{subject, word}{count}, mean_mat, std_mat);
                
                clear mean_mat, std_mat;
            end
        end
    end
    datas; 
end

function [ result ] = MeanNormalization( data, mean_data, std_data )
    mean_mat = repmat(mean_data, [size(data, 1), 1]);
    std_mat = repmat(std_data, [size(data, 1), 1]);
    result = (data-mean_mat)./std_mat;
    nanidx = find(isnan(result)==1);
    result(nanidx) = 0;
end