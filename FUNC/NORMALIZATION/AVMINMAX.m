function [datas] = AVMINMAX(datas, type)
    switch(type)
        case 'RAW'
            for sub=1:10
                for word=1:26
                    [col, countcnt] = size(datas{sub, word});
                    for(count=1:countcnt)
                        max_v = max(datas{sub, word}{count});
                        min_v = min(datas{sub, word}{count});
                        a = (datas{sub, word}{count}-min_v)./(max_v-min_v);
                        datas{sub, word}{count} = a;
                        clear a;
                    end
                end
            end
        case 'APPEARANCE'
            for gridno=1:10
                for sub=1:10
                    for word=1:26
                        [col, countcnt] = size(datas{gridno, sub, word});
                        for(count=1:countcnt)
                            max_v = max(datas{gridno, sub, word}{count}.gray);
                            min_v = min(datas{gridno, sub, word}{count}.gray);
                            a = (datas{gridno, sub, word}{count}.gray-min_v)./(max_v-min_v);
                            datas{gridno, sub, word}{count}.gray = a;
                            clear a;
                            
                            max_v = max(datas{gridno, sub, word}{count}.diff_gray);
                            min_v = min(datas{gridno, sub, word}{count}.diff_gray);
                            a = (datas{gridno, sub, word}{count}.diff_gray-min_v)./(max_v-min_v);
                            datas{gridno, sub, word}{count}.diff_gray = a;
                            clear a;
                            
                            max_v = max(datas{gridno, sub, word}{count}.sobel);
                            min_v = min(datas{gridno, sub, word}{count}.sobel);
                            a = (datas{gridno, sub, word}{count}.sobel-min_v)./(max_v-min_v);
                            datas{gridno, sub, word}{count}.sobel = a;
                            clear a;
                            
                            max_v = max(datas{gridno, sub, word}{count}.dct);
                            min_v = min(datas{gridno, sub, word}{count}.dct);
                            a = (datas{gridno, sub, word}{count}.dct-min_v)./(max_v-min_v);
                            datas{gridno, sub, word}{count}.dct = a;
                            clear a;
                            
                            max_v = max(datas{gridno, sub, word}{count}.diff_dct);
                            min_v = min(datas{gridno, sub, word}{count}.diff_dct);
                            a = (datas{gridno, sub, word}{count}.diff_dct-min_v)./(max_v-min_v);
                            datas{gridno, sub, word}{count}.diff_dct = a;
                            clear a;
                        end
                    end
                end
            end
    end
end

