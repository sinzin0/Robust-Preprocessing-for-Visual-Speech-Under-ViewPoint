function [ datas ] = RAWMean( datas)
    for subject = 1:16
        for word = 1:10
            [col, countcnt] = size(datas{subject, word});
            for(count=1:countcnt)
                mean_mat = mean(datas{subject, word}{count}.full);
                std_mat = std(datas{subject, word}{count}.full);
                datas{subject, word}{count}.full = ...
                    MeanNormalization(datas{subject, word}{count}.full, mean_mat, std_mat);

%                 mean_mat = mean(datas{subject, word}{count}.img_seg);
%                 std_mat = std(datas{subject, word}{count}.img_seg);
%                 datas{subject, word}{count}.img_seg = ...
%                     MeanNormalization(datas{subject, word}{count}.img_seg, mean_mat, std_mat);
                
                mean_mat = mean(datas{subject, word}{count}.speech_seg);
                std_mat = std(datas{subject, word}{count}.speech_seg);
                datas{subject, word}{count}.speech_seg = ...
                    MeanNormalization(datas{subject, word}{count}.speech_seg, mean_mat, std_mat);
                
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