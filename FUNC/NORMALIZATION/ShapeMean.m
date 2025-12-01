function [result] = ShapeMean(datas, range )
     [numSubs, numWords] = size(datas);
    result = cell(numSubs, numWords);

    switch (range)
        case 'UTTERANCE'
            % ★ 여기만 우리 구조에 맞게 수정
            for subject = 1:numSubs
                for word = 1:numWords

                    % speech_seg가 없는 (subject,word)는 스킵
                    if ~isfield(datas{subject, word}, 'speech_seg')
                        continue;
                    end

                    [~, countcnt] = size(datas{subject, word}.speech_seg);

                    for count = 1:countcnt
                        % ----- 1) speech_seg -----
                        seq = datas{subject, word}.speech_seg{count};
                        if ~isempty(seq)
                            mean_mat = mean(seq);
                            std_mat  = std(seq);
                            datas{subject, word}.speech_seg{count} = ...
                                MeanNormalization(seq, mean_mat, std_mat);
                        end

                        % ----- 2) speech_seg_diff 도 있으면 같이 정규화 -----
                        if isfield(datas{subject, word}, 'speech_seg_diff') && ...
                           count <= numel(datas{subject, word}.speech_seg_diff)

                            dseq = datas{subject, word}.speech_seg_diff{count};
                            if ~isempty(dseq)
                                mean_mat = mean(dseq);
                                std_mat  = std(dseq);
                                datas{subject, word}.speech_seg_diff{count} = ...
                                    MeanNormalization(dseq, mean_mat, std_mat);
                            end
                        end
                    end
                end
            end
        case 'SUBJECT'
            for subject = 1:16
                non_seg_data = [];
                img_seg_data = [];
                speech_seg_data = [];
                for word = 1:10
                    [col, countcnt] = size(datas{subject, word}.full);
                    for(count=1:countcnt)
                        non_seg_data = [non_seg_data; datas{subject, word}.full{count}];
                        img_seg_data = [img_seg_data; datas{subject, word}.img_seg{count}];
                        speech_seg_data = [speech_seg_data; datas{subject, word}.speech_seg{count}];
                    end
                end

                for word = 1:10
                    [col, countcnt] = size(datas{subject, word}.full);
                    for(count=1:countcnt)
                        datas{subject, word}.full{count} = ...
                            MeanNormalization(datas{subject, word}.full{count}, mean(non_seg_data), std(non_seg_data));
                        datas{subject, word}.img_seg{count} = ...
                            MeanNormalization(datas{subject, word}.img_seg{count}, mean(img_seg_data), std(img_seg_data));
                        datas{subject, word}.speech_seg{count} = ...
                            MeanNormalization(datas{subject, word}.speech_seg{count}, mean(speech_seg_data), std(speech_seg_data));
                    end
                end
            end
        case 'WORD'
            for word = 1:10
                non_seg_data = [];
                img_seg_data = [];
                speech_seg_data = [];
                for subject = 1:16
                    [col, countcnt] = size(datas{subject, word}.full);
                    for(count=1:countcnt)
                        non_seg_data = [non_seg_data; datas{subject, word}.full{count}];
                        img_seg_data = [img_seg_data; datas{subject, word}.img_seg{count}];
                        speech_seg_data = [speech_seg_data; datas{subject, word}.speech_seg{count}];
                    end
                end

                for subject = 1:16
                    [col, countcnt] = size(datas{subject, word}.full);
                    for(count=1:countcnt)
                        datas{subject, word}.full{count} = ...
                            MeanNormalization(datas{subject, word}.full{count}, mean(non_seg_data), std(non_seg_data));
                        datas{subject, word}.img_seg{count} = ...
                            MeanNormalization(datas{subject, word}.img_seg{count}, mean(img_seg_data), std(img_seg_data));
                        datas{subject, word}.speech_seg{count} = ...
                            MeanNormalization(datas{subject, word}.speech_seg{count}, mean(speech_seg_data), std(speech_seg_data));
                    end
                end
            end
        case 'ALL'
            non_seg_data = [];
            img_seg_data = [];
            speech_seg_data = [];
            for subject = 1:16
                for word = 1:10
                    [col, countcnt] = size(datas{subject, word}.full);
                    for(count=1:countcnt)
                        non_seg_data = [non_seg_data; datas{subject, word}.full{count}];
                        img_seg_data = [img_seg_data; datas{subject, word}.img_seg{count}];
                        speech_seg_data = [speech_seg_data; datas{subject, word}.speech_seg{count}];
                    end
                end
            end
            for subject = 1:16    
                for word = 1:10
                    [col, countcnt] = size(datas{subject, word}.full);
                    for(count=1:countcnt)
                        datas{subject, word}.full{count} = ...
                            MeanNormalization(datas{subject, word}.full{count}, mean(non_seg_data), std(non_seg_data));

                        datas{subject, word}.img_seg{count} = ...
                            MeanNormalization(datas{subject, word}.img_seg{count}, mean(img_seg_data), std(img_seg_data));

                        datas{subject, word}.speech_seg{count} = ...
                            MeanNormalization(datas{subject, word}.speech_seg{count}, mean(speech_seg_data), std(speech_seg_data));
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

