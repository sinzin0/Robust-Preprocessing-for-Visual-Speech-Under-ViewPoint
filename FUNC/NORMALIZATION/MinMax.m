function [ datas ] = MinMax( datas, range )
    switch(range)
        case 'RAW'
            for sub=1:16
                for word=1:10
                    [col, countcnt] = size(datas{sub, word});
                    for(count=1:countcnt)
                        max_v = max(datas{sub, word}{count}.full);
                        min_v = min(datas{sub, word}{count}.full);
                        a = (datas{sub, word}{count}.full-min_v)./(max_v-min_v);
                        datas{sub, word}{count}.full = a;
                        clear a;
                        max_v = max(datas{sub, word}{count}.speech_seg);
                        min_v = min(datas{sub, word}{count}.speech_seg);
                        a = (datas{sub, word}{count}.speech_seg-min_v)./(max_v-min_v);
                        datas{sub, word}{count}.speech_seg = a;
                        clear a;
                    end
                end
            end
        case 'AE'
            for sub=1:16
                for word=1:10
                    [col, countcnt] = size(datas{sub, word});
                    for(count=1:countcnt)
                        max_v = max(datas{sub, word}{count});
                        min_v = min(datas{sub, word}{count});
                        datas{sub, word}{count} = (datas{sub, word}{count}-min_v)./(max_v-min_v);
                        clear a;
                    end
                end
            end
        case 'ECT'
            [numGrid, numSubs, numWords] = size(datas);   % ★ 실제 크기 읽기
            for gridno = 1:numGrid
                for subject = 1:numSubs
                    for word = 1:numWords
                        [col, countcnt] = size(datas{gridno, subject, word});
                        for(count=1:countcnt)
                            max_v = max(datas{gridno, subject, word}{count}.diff_gray);
                            min_v = min(datas{gridno, subject, word}{count}.diff_gray);
                            datas{gridno, subject, word}{count}.diff_gray = ...
                                (datas{gridno, subject, word}{count}.diff_gray-min_v)./(max_v-min_v);
                            
                        end
                    end
                end
            end
        case 'OF'
            for gridno=1:10
                for subject = 1:16
                    for word = 1:10
                        [col, countcnt] = size(datas{gridno, subject, word});
                        for(count=1:countcnt)
                            max_v = max(datas{gridno, subject, word}{count}.full);
                            min_v = min(datas{gridno, subject, word}{count}.full);
                            datas{gridno, subject, word}{count}.full = ...
                                (datas{gridno, subject, word}{count}.full-min_v)./(max_v-min_v);
                            datas{gridno, subject, word}{count}.full(find(isnan(datas{gridno, subject, word}{count}.full) == 1)) = 0;

                            max_v = max(datas{gridno, subject, word}{count}.img_seg);
                            min_v = min(datas{gridno, subject, word}{count}.img_seg);
                            datas{gridno, subject, word}{count}.img_seg = ...
                                (datas{gridno, subject, word}{count}.img_seg-min_v)./(max_v-min_v);
                            datas{gridno, subject, word}{count}.img_seg(find(isnan(datas{gridno, subject, word}{count}.img_seg) == 1)) = 0;
                        
                            max_v = max(datas{gridno, subject, word}{count}.speech_seg);
                            min_v = min(datas{gridno, subject, word}{count}.speech_seg);
                            datas{gridno, subject, word}{count}.speech_seg = ...
                                (datas{gridno, subject, word}{count}.speech_seg-min_v)./(max_v-min_v);
                            datas{gridno, subject, word}{count}.speech_seg(find(isnan(datas{gridno, subject, word}{count}.speech_seg) == 1)) = 0;
                        end
                    end
                end
            end
        case 'DCT'
            for gridno = 1:10
                for subject = 1:16
                    for word = 1:10
                        [col, countcnt] = size(datas{gridno, subject, word});
                        for(count=1:countcnt)
                            max_v = max(datas{gridno, subject, word}{count}.full.dct);
                            min_v = min(datas{gridno, subject, word}{count}.full.dct);
                            datas{gridno, subject, word}{count}.full.dct = ...
                                (datas{gridno, subject, word}{count}.full.dct-min_v)./(max_v-min_v);
                            max_v = max(datas{gridno, subject, word}{count}.full.diff_dct);
                            min_v = min(datas{gridno, subject, word}{count}.full.diff_dct);
                            datas{gridno, subject, word}{count}.full.diff_dct = ...
                                (datas{gridno, subject, word}{count}.full.diff_dct-min_v)./(max_v-min_v);

                            max_v = max(datas{gridno, subject, word}{count}.img_seg.dct);
                            min_v = min(datas{gridno, subject, word}{count}.img_seg.dct);
                            datas{gridno, subject, word}{count}.img_seg.dct = ...
                                (datas{gridno, subject, word}{count}.img_seg.dct-min_v)./(max_v-min_v);
                            max_v = max(datas{gridno, subject, word}{count}.img_seg.diff_dct);
                            min_v = min(datas{gridno, subject, word}{count}.img_seg.diff_dct);
                            datas{gridno, subject, word}{count}.img_seg.diff_dct = ...
                                (datas{gridno, subject, word}{count}.img_seg.diff_dct-min_v)./(max_v-min_v);
                            
                            max_v = max(datas{gridno, subject, word}{count}.speech_seg.dct);
                            min_v = min(datas{gridno, subject, word}{count}.speech_seg.dct);
                            datas{gridno, subject, word}{count}.speech_seg.dct = ...
                                (datas{gridno, subject, word}{count}.speech_seg.dct-min_v)./(max_v-min_v);
                            max_v = max(datas{gridno, subject, word}{count}.speech_seg.diff_dct);
                            min_v = min(datas{gridno, subject, word}{count}.speech_seg.diff_dct);
                            datas{gridno, subject, word}{count}.speech_seg.diff_dct = ...
                                (datas{gridno, subject, word}{count}.speech_seg.diff_dct-min_v)./(max_v-min_v);
                        end
                    end
                end
            end
        case 'SHAPE'
            % ➜ SHAPE_DATA_45.mat 구조에 맞춰서
            %    datas{subject, word}.speech_seg{count}
            %    datas{subject, word}.speech_seg_diff{count} 만 정규화

            [numSubs, numWords] = size(datas);   % 예: 5 x 10

            for subject = 1:numSubs
                for word = 1:numWords

                    % speech_seg 없으면 이 (sub,word)는 그냥 스킵
                    if ~isfield(datas{subject, word}, 'speech_seg')
                        continue;
                    end

                    [~, countcnt] = size(datas{subject, word}.speech_seg);

                    for count = 1:countcnt

                        % ----- 1) speech_seg 정규화 -----
                        seq = datas{subject, word}.speech_seg{count};
                        if ~isempty(seq)
                            max_v = max(seq);
                            min_v = min(seq);

                            if all(max_v == min_v)      % 전부 같은 값이면 0으로
                                seq(:) = 0;
                            else
                                seq = (seq - min_v) ./ (max_v - min_v);
                            end

                            datas{subject, word}.speech_seg{count} = seq;
                        end

                        % ----- 2) speech_seg_diff 도 있으면 같이 정규화 -----
                        if isfield(datas{subject, word}, 'speech_seg_diff') && ...
                           count <= numel(datas{subject, word}.speech_seg_diff)

                            dseq = datas{subject, word}.speech_seg_diff{count};
                            if ~isempty(dseq)
                                max_v = max(dseq);
                                min_v = min(dseq);

                                if all(max_v == min_v)
                                    dseq(:) = 0;
                                else
                                    dseq = (dseq - min_v) ./ (max_v - min_v);
                                end

                                datas{subject, word}.speech_seg_diff{count} = dseq;
                            end
                        end
                    end
                end
            end
        case 'LBP'
            for gridno = 1:10
                for subject = 1:16
                    for word = 1:10
                        [col, countcnt] = size(datas{gridno, subject, word});
                        for(count=1:countcnt)
                            max_v = max(datas{gridno, subject, word}{count}.speech_seg);
                            min_v = min(datas{gridno, subject, word}{count}.speech_seg);
                            datas{gridno, subject, word}{count}.speech_seg = ...
                                (datas{gridno, subject, word}{count}.speech_seg-min_v)./(max_v-min_v);
                        end
                    end
                end
            end
        case 'OF'
            for gridno = 1:10
                for subject = 1:16
                    for word = 1:10
                        [col, countcnt] = size(datas{gridno, subject, word});
                        for(count=1:countcnt)
                            max_v = max(datas{gridno, subject, word}{count}.speech_seg);
                            min_v = min(datas{gridno, subject, word}{count}.speech_seg);
                            datas{gridno, subject, word}{count}.speech_seg = ...
                                (datas{gridno, subject, word}{count}.speech_seg-min_v)./(max_v-min_v);
                        end
                    end
                end
            end
        otherwise
    end
end

