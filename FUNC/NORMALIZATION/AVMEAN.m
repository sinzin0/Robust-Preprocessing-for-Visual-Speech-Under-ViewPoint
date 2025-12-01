function [datas] = AVMEAN(datas,type)
    switch(type)
        case 'RAW'
            for sub = 1:10
                for word = 1:26
                    [~, countcnt] = size(datas{sub, word});
                    for count=1:countcnt
                        mean_mat = mean(datas{sub, word}{count});
                        std_mat = std(datas{sub, word}{count});
                        datas{sub, word}{count} = ...
                            MeanNormalization(datas{sub, word}{count}, mean_mat, std_mat);

                        clear mean_mat, std_mat;
                    end
                end
            end
        case 'APPEARANCE'
            for gridno=1:10
                for sub = 1:10
                    for word = 1:26
                        [~, countcnt] = size(datas{gridno, sub, word});
                        for count=1:countcnt
                            mean_mat = mean(datas{gridno, sub, word}{count}.gray);
                            std_mat = std(datas{gridno, sub, word}{count}.gray);
                            datas{gridno, sub, word}{count}.gray = ...
                                MeanNormalization(datas{gridno, sub, word}{count}.gray, mean_mat, std_mat);

                            clear mean_mat, std_mat;
                            
                            mean_mat = mean(datas{gridno, sub, word}{count}.diff_gray);
                            std_mat = std(datas{gridno, sub, word}{count}.diff_gray);
                            datas{gridno, sub, word}{count}.diff_gray = ...
                                MeanNormalization(datas{gridno, sub, word}{count}.diff_gray, mean_mat, std_mat);

                            clear mean_mat, std_mat;
                            
                            mean_mat = mean(datas{gridno, sub, word}{count}.sobel);
                            std_mat = std(datas{gridno, sub, word}{count}.sobel);
                            datas{gridno, sub, word}{count}.sobel = ...
                                MeanNormalization(datas{gridno, sub, word}{count}.sobel, mean_mat, std_mat);

                            clear mean_mat, std_mat;
                            
                            mean_mat = mean(datas{gridno, sub, word}{count}.dct);
                            std_mat = std(datas{gridno, sub, word}{count}.dct);
                            datas{gridno, sub, word}{count}.dct = ...
                                MeanNormalization(datas{gridno, sub, word}{count}.dct, mean_mat, std_mat);

                            clear mean_mat, std_mat;
                            
                            mean_mat = mean(datas{gridno, sub, word}{count}.diff_dct);
                            std_mat = std(datas{gridno, sub, word}{count}.diff_dct);
                            datas{gridno, sub, word}{count}.diff_dct = ...
                                MeanNormalization(datas{gridno, sub, word}{count}.diff_dct, mean_mat, std_mat);

                            clear mean_mat, std_mat;
                        end
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

