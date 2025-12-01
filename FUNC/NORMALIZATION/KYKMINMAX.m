function [datas] = KYKMINMAX(datas)
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
%                 max_v = max(datas{sub, word}{count});
%                 min_v = min(datas{sub, word}{count});
%                 a = (datas{sub, word}{count}-min_v)./(max_v-min_v);
%                 datas{sub, word}{count} = a;
%                 clear a;
            end
        end
    end
end

