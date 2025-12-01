function [ result ] = Mean( datas, range )
    result = cell(10,10,10);
    switch (range)
        case 'UTTERANCE'
            [numGrid, numSubs, numWords] = size(datas);

            for gridno = 1:numGrid
                for subject = 1:numSubs
                    for word = 1:numWords
                        [col, countcnt] = size(datas{gridno, subject, word});
                        for(count=1:countcnt)
%                             mean_mat = mean(datas{gridno, subject, word}{count}.full.gray);
%                             std_mat = std(datas{gridno, subject, word}{count}.full.gray);
%                             datas{gridno, subject, word}{count}.full.gray = ...
%                                 MeanNormalization(datas{gridno, subject, word}{count}.full.gray, mean_mat, std_mat);
%                             mean_mat = mean(datas{gridno, subject, word}{count}.full.sobel);
%                             std_mat = std(datas{gridno, subject, word}{count}.full.sobel);
%                             datas{gridno, subject, word}{count}.full.sobel = ...
%                                 MeanNormalization(datas{gridno, subject, word}{count}.full.sobel, mean_mat, std_mat);
%                             mean_mat = mean(datas{gridno, subject, word}{count}.full.of);
%                             std_mat = std(datas{gridno, subject, word}{count}.full.of);
%                             datas{gridno, subject, word}{count}.full.of = ...
%                                 MeanNormalization(datas{gridno, subject, word}{count}.full.of, mean_mat, std_mat);
%                             datas{gridno, subject, word}{count}.full.of(find(isnan(datas{gridno, subject, word}{count}.full.of) == 1)) = 0;
%                             mean_mat = mean(datas{gridno, subject, word}{count}.full.diff_gray);
%                             std_mat = std(datas{gridno, subject, word}{count}.full.diff_gray);
%                             datas{gridno, subject, word}{count}.full.diff_gray = ...
%                                 MeanNormalization(datas{gridno, subject, word}{count}.full.diff_gray, mean_mat, std_mat);
% 
%                             mean_mat = mean(datas{gridno, subject, word}{count}.img_seg.gray);
%                             std_mat = std(datas{gridno, subject, word}{count}.img_seg.gray);
%                             datas{gridno, subject, word}{count}.img_seg.gray = ...
%                                 MeanNormalization(datas{gridno, subject, word}{count}.img_seg.gray, mean_mat, std_mat);
%                             mean_mat = mean(datas{gridno, subject, word}{count}.img_seg.sobel);
%                             std_mat = std(datas{gridno, subject, word}{count}.img_seg.sobel);
%                             datas{gridno, subject, word}{count}.img_seg.sobel = ...
%                                 MeanNormalization(datas{gridno, subject, word}{count}.img_seg.sobel, mean_mat, std_mat);
%                             mean_mat = mean(datas{gridno, subject, word}{count}.img_seg.of);
%                             std_mat = std(datas{gridno, subject, word}{count}.img_seg.of);
%                             datas{gridno, subject, word}{count}.img_seg.of = ...
%                                 MeanNormalization(datas{gridno, subject, word}{count}.img_seg.of, mean_mat, std_mat);
%                             datas{gridno, subject, word}{count}.img_seg.of(find(isnan(datas{gridno, subject, word}{count}.img_seg.of) == 1)) = 0;
%                             mean_mat = mean(datas{gridno, subject, word}{count}.img_seg.diff_gray);
%                             std_mat = std(datas{gridno, subject, word}{count}.img_seg.diff_gray);
%                             datas{gridno, subject, word}{count}.img_seg.diff_gray = ...
%                                 MeanNormalization(datas{gridno, subject, word}{count}.img_seg.diff_gray, mean_mat, std_mat);
                            mean_mat = mean(datas{gridno, subject, word}{count}.diff_gray);
                            std_mat = std(datas{gridno, subject, word}{count}.diff_gray);
                            datas{gridno, subject, word}{count}.diff_gray = ...
                                MeanNormalization(datas{gridno, subject, word}{count}.diff_gray, mean_mat, std_mat);
%                             mean_mat = mean(datas{gridno, subject, word}{count}.speech_seg.gray);
%                             std_mat = std(datas{gridno, subject, word}{count}.speech_seg.gray);
%                             datas{gridno, subject, word}{count}.speech_seg.gray = ...
%                                 MeanNormalization(datas{gridno, subject, word}{count}.speech_seg.gray, mean_mat, std_mat);
%                             mean_mat = mean(datas{gridno, subject, word}{count}.speech_seg.sobel);
%                             std_mat = std(datas{gridno, subject, word}{count}.speech_seg.sobel);
%                             datas{gridno, subject, word}{count}.speech_seg.sobel = ...
%                                 MeanNormalization(datas{gridno, subject, word}{count}.speech_seg.sobel, mean_mat, std_mat);
%                             mean_mat = mean(datas{gridno, subject, word}{count}.speech_seg.of);
%                             std_mat = std(datas{gridno, subject, word}{count}.speech_seg.of);
%                             datas{gridno, subject, word}{count}.speech_seg.of = ...
%                                 MeanNormalization(datas{gridno, subject, word}{count}.speech_seg.of, mean_mat, std_mat);
%                             datas{gridno, subject, word}{count}.speech_seg.of(find(isnan(datas{gridno, subject, word}{count}.speech_seg.of) == 1)) = 0;
%                             mean_mat = mean(datas{gridno, subject, word}{count}.speech_seg.diff_gray);
%                             std_mat = std(datas{gridno, subject, word}{count}.speech_seg.diff_gray);
%                             datas{gridno, subject, word}{count}.speech_seg.diff_gray = ...
%                                 MeanNormalization(datas{gridno, subject, word}{count}.speech_seg.diff_gray, mean_mat, std_mat);
                        end
                    end
                end
            end
        case 'SUBJECT'
            for gridno = 1:10
                for subject = 1:16
                    all_gray_data = [];
                    all_sobel_data = [];
                    all_of_data = [];
                    imgseg_gray_data = [];
                    imgseg_sobel_data = [];
                    imgseg_of_data = [];
                    speechseg_gray_data = [];
                    speechseg_sobel_data = [];
                    speechseg_of_data = [];
                    for word = 1:10
                        [col, countcnt] = size(datas{gridno, subject, word});
                        for(count=1:countcnt)
                            all_gray_data = [all_gray_data; datas{gridno, subject, word}{count}.full.gray];
                            all_sobel_data = [all_sobel_data; datas{gridno, subject, word}{count}.full.sobel];
                            all_of_data = [all_of_data; datas{gridno, subject, word}{count}.full.of];
                            imgseg_gray_data = [imgseg_gray_data; datas{gridno, subject, word}{count}.img_seg.gray];
                            imgseg_sobel_data = [imgseg_sobel_data; datas{gridno, subject, word}{count}.img_seg.sobel];
                            imgseg_of_data = [imgseg_of_data; datas{gridno, subject, word}{count}.img_seg.of];
                            speechseg_gray_data = [speechseg_gray_data; datas{gridno, subject, word}{count}.speech_seg.gray];
                            speechseg_sobel_data = [speechseg_sobel_data; datas{gridno, subject, word}{count}.speech_seg.sobel];
                            speechseg_of_data = [speechseg_of_data; datas{gridno, subject, word}{count}.speech_seg.of];
                        end
                    end
                    
                    for word = 1:10
                        [col, countcnt] = size(datas{gridno, subject, word});
                        for(count=1:countcnt)
                            datas{gridno, subject, word}{count}.full.gray = ...
                                MeanNormalization(datas{gridno, subject, word}{count}.full.gray, mean(all_gray_data), std(all_gray_data));
                            datas{gridno, subject, word}{count}.full.sobel = ...
                                MeanNormalization(datas{gridno, subject, word}{count}.full.sobel, mean(all_sobel_data), std(all_sobel_data));
                            datas{gridno, subject, word}{count}.full.of = ...
                                MeanNormalization(datas{gridno, subject, word}{count}.full.of, mean(all_of_data), std(all_of_data));
                            datas{gridno, subject, word}{count}.full.of(find(isnan(datas{gridno, subject, word}{count}.full.of) == 1)) = 0;

                            datas{gridno, subject, word}{count}.img_seg.gray = ...
                                MeanNormalization(datas{gridno, subject, word}{count}.img_seg.gray, mean(imgseg_gray_data), std(imgseg_gray_data));
                            datas{gridno, subject, word}{count}.img_seg.sobel = ...
                                MeanNormalization(datas{gridno, subject, word}{count}.img_seg.sobel, mean(imgseg_sobel_data), std(imgseg_sobel_data));
                            datas{gridno, subject, word}{count}.img_seg.of = ...
                                MeanNormalization(datas{gridno, subject, word}{count}.img_seg.of, mean(imgseg_of_data), std(imgseg_of_data));
                            datas{gridno, subject, word}{count}.img_seg.of(find(isnan(datas{gridno, subject, word}{count}.img_seg.of) == 1)) = 0;
                            
                            datas{gridno, subject, word}{count}.speech_seg.gray = ...
                                MeanNormalization(datas{gridno, subject, word}{count}.speech_seg.gray, mean(speechseg_gray_data), std(speechseg_gray_data));
                            datas{gridno, subject, word}{count}.speech_seg.sobel = ...
                                MeanNormalization(datas{gridno, subject, word}{count}.speech_seg.sobel, mean(speechseg_sobel_data), std(speechseg_sobel_data));
                            datas{gridno, subject, word}{count}.speech_seg.of = ...
                                MeanNormalization(datas{gridno, subject, word}{count}.speech_seg.of, mean(speechseg_of_data), std(speechseg_of_data));
                            datas{gridno, subject, word}{count}.speech_seg.of(find(isnan(datas{gridno, subject, word}{count}.speech_seg.of) == 1)) = 0;
                        end
                    end
                end
            end
        case 'WORD'
            for gridno = 1:10
                for word = 1:10
                    all_gray_data = [];
                    all_sobel_data = [];
                    all_of_data = [];
                    imgseg_gray_data = [];
                    imgseg_sobel_data = [];
                    imgseg_of_data = [];
                    speechseg_gray_data = [];
                    speechseg_sobel_data = [];
                    speechseg_of_data = [];
                    for subject = 1:16
                        [col, countcnt] = size(datas{gridno, subject, word});
                        for(count=1:countcnt)
                            all_gray_data = [all_gray_data; datas{gridno, subject, word}{count}.full.gray];
                            all_sobel_data = [all_sobel_data; datas{gridno, subject, word}{count}.full.sobel];
                            all_of_data = [all_of_data; datas{gridno, subject, word}{count}.full.of];
                            imgseg_gray_data = [imgseg_gray_data; datas{gridno, subject, word}{count}.img_seg.gray];
                            imgseg_sobel_data = [imgseg_sobel_data; datas{gridno, subject, word}{count}.img_seg.sobel];
                            imgseg_of_data = [imgseg_of_data; datas{gridno, subject, word}{count}.img_seg.of];
                            speechseg_gray_data = [speechseg_gray_data; datas{gridno, subject, word}{count}.speech_seg.gray];
                            speechseg_sobel_data = [speechseg_sobel_data; datas{gridno, subject, word}{count}.speech_seg.sobel];
                            speechseg_of_data = [speechseg_of_data; datas{gridno, subject, word}{count}.speech_seg.of];
                        end
                    end
                    
                    for subject = 1:16
                        [col, countcnt] = size(datas{gridno, subject, word});
                        for(count=1:countcnt)
                            datas{gridno, subject, word}{count}.full.gray = ...
                                MeanNormalization(datas{gridno, subject, word}{count}.full.gray, mean(all_gray_data), std(all_gray_data));
                            datas{gridno, subject, word}{count}.full.sobel = ...
                                MeanNormalization(datas{gridno, subject, word}{count}.full.sobel, mean(all_sobel_data), std(all_sobel_data));
                            datas{gridno, subject, word}{count}.full.of = ...
                                MeanNormalization(datas{gridno, subject, word}{count}.full.of, mean(all_of_data), std(all_of_data));
                            datas{gridno, subject, word}{count}.full.of(find(isnan(datas{gridno, subject, word}{count}.full.of) == 1)) = 0;

                            datas{gridno, subject, word}{count}.img_seg.gray = ...
                                MeanNormalization(datas{gridno, subject, word}{count}.img_seg.gray, mean(imgseg_gray_data), std(imgseg_gray_data));
                            datas{gridno, subject, word}{count}.img_seg.sobel = ...
                                MeanNormalization(datas{gridno, subject, word}{count}.img_seg.sobel, mean(imgseg_sobel_data), std(imgseg_sobel_data));
                            datas{gridno, subject, word}{count}.img_seg.of = ...
                                MeanNormalization(datas{gridno, subject, word}{count}.img_seg.of, mean(imgseg_of_data), std(imgseg_of_data));
                            datas{gridno, subject, word}{count}.img_seg.of(find(isnan(datas{gridno, subject, word}{count}.img_seg.of) == 1)) = 0;
                            
                            datas{gridno, subject, word}{count}.speech_seg.gray = ...
                                MeanNormalization(datas{gridno, subject, word}{count}.speech_seg.gray, mean(speechseg_gray_data), std(speechseg_gray_data));
                            datas{gridno, subject, word}{count}.speech_seg.sobel = ...
                                MeanNormalization(datas{gridno, subject, word}{count}.speech_seg.sobel, mean(speechseg_sobel_data), std(speechseg_sobel_data));
                            datas{gridno, subject, word}{count}.speech_seg.of = ...
                                MeanNormalization(datas{gridno, subject, word}{count}.speech_seg.of, mean(speechseg_of_data), std(speechseg_of_data));
                            datas{gridno, subject, word}{count}.speech_seg.of(find(isnan(datas{gridno, subject, word}{count}.speech_seg.of) == 1)) = 0;
                        end
                    end
                end
            end
        case 'ALL'
            for gridno = 1:10
                all_gray_data = [];
                all_sobel_data = [];
                all_of_data = [];
                imgseg_gray_data = [];
                imgseg_sobel_data = [];
                imgseg_of_data = [];
                speechseg_gray_data = [];
                speechseg_sobel_data = [];
                speechseg_of_data = [];
                for subject = 1:16
                    for word = 1:10
                        [col, countcnt] = size(datas{gridno, subject, word});
                        for(count=1:countcnt)
                            all_gray_data = [all_gray_data; datas{gridno, subject, word}{count}.full.gray];
                            all_sobel_data = [all_sobel_data; datas{gridno, subject, word}{count}.full.sobel];
                            all_of_data = [all_of_data; datas{gridno, subject, word}{count}.full.of];
                            imgseg_gray_data = [imgseg_gray_data; datas{gridno, subject, word}{count}.img_seg.gray];
                            imgseg_sobel_data = [imgseg_sobel_data; datas{gridno, subject, word}{count}.img_seg.sobel];
                            imgseg_of_data = [imgseg_of_data; datas{gridno, subject, word}{count}.img_seg.of];
                            speechseg_gray_data = [speechseg_gray_data; datas{gridno, subject, word}{count}.speech_seg.gray];
                            speechseg_sobel_data = [speechseg_sobel_data; datas{gridno, subject, word}{count}.speech_seg.sobel];
                            speechseg_of_data = [speechseg_of_data; datas{gridno, subject, word}{count}.speech_seg.of];
                        end
                    end
                end
                for subject = 1:16    
                    for word = 1:10
                        [col, countcnt] = size(datas{gridno, subject, word});
                        for(count=1:countcnt)
                            datas{gridno, subject, word}{count}.full.gray = ...
                                MeanNormalization(datas{gridno, subject, word}{count}.full.gray, mean(all_gray_data), std(all_gray_data));
                            datas{gridno, subject, word}{count}.full.sobel = ...
                                MeanNormalization(datas{gridno, subject, word}{count}.full.sobel, mean(all_sobel_data), std(all_sobel_data));
                            datas{gridno, subject, word}{count}.full.of = ...
                                MeanNormalization(datas{gridno, subject, word}{count}.full.of, mean(all_of_data), std(all_of_data));

                            datas{gridno, subject, word}{count}.img_seg.gray = ...
                                MeanNormalization(datas{gridno, subject, word}{count}.img_seg.gray, mean(imgseg_gray_data), std(imgseg_gray_data));
                            datas{gridno, subject, word}{count}.img_seg.sobel = ...
                                MeanNormalization(datas{gridno, subject, word}{count}.img_seg.sobel, mean(imgseg_sobel_data), std(imgseg_sobel_data));
                            datas{gridno, subject, word}{count}.img_seg.of = ...
                                MeanNormalization(datas{gridno, subject, word}{count}.img_seg.of, mean(imgseg_of_data), std(imgseg_of_data));
                            
                            datas{gridno, subject, word}{count}.speech_seg.gray = ...
                                MeanNormalization(datas{gridno, subject, word}{count}.speech_seg.gray, mean(speechseg_gray_data), std(speechseg_gray_data));
                            datas{gridno, subject, word}{count}.speech_seg.sobel = ...
                                MeanNormalization(datas{gridno, subject, word}{count}.speech_seg.sobel, mean(speechseg_sobel_data), std(speechseg_sobel_data));
                            datas{gridno, subject, word}{count}.speech_seg.of = ...
                                MeanNormalization(datas{gridno, subject, word}{count}.speech_seg.of, mean(speechseg_of_data), std(speechseg_of_data));
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
end