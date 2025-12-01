function [ result ] = LBPMean( datas, range )
    result = cell(10,10,10);
    switch (range)
        case 'UTTERANCE'
            for gridno = 1:10
                for subject = 1:16
                    for word = 1:10
                        [col, countcnt] = size(datas{gridno, subject, word});
                        for(count=1:countcnt)
                            mean_mat = mean(datas{gridno, subject, word}{count}.speech_seg);
                            std_mat = std(datas{gridno, subject, word}{count}.speech_seg);
                            datas{gridno, subject, word}{count}.speech_seg = ...
                                MeanNormalization(datas{gridno, subject, word}{count}.speech_seg, mean_mat, std_mat);
                        end
                    end
                end
            end
       
    end
    result = datas; 
end

function [ result ] = MeanNormalization( data, mean_data, std_data )
    mean_mat = repmat(mean_data, [size(data, 1), 1]);
    std_mat = repmat(std_data, [size(data, 1), 1]);
    result = (data-mean_mat)./std_mat;
    nanidx = find(isnan(result)==1);
    result(nanidx) = 0;
end