clc; clear all;

data_path = ['C:/Users/jyshin/Desktop/신진영/대학/대학자료/졸업논문/신진영_졸업논문_구현/데이터/FaceFeature'];

numSubs = 3;
numWords = 10;

datas = cell(numSubs, numWords);
for sub=1:numSubs

    raw_speech_seg_data = load([data_path '/shape_feature_45_' num2str(sub) '.txt']);

    for word=1:numWords

        utterance_data = cell(1,1);
        for count=1:30
            [frameidxes, col] = find(raw_speech_seg_data(:, 1)==word & raw_speech_seg_data(:,2)==count);
            [row, col] = size(frameidxes);
            if row == 0
                continue;
            end
            utterance_data{count} = raw_speech_seg_data(frameidxes, 4:7);
        end
        datas{sub, word}.speech_seg = utterance_data;
    end
end

for subject=1:numSubs
    for word=1:numWords
                
        [aa, cnt] = size(datas{subject, word}.speech_seg);
        diff3 = cell(1,1);
        for count=1:cnt
            [row, col] = size(datas{subject, word}.speech_seg{count});
            temp = [];
            for frame=1:row-1
                temp = [temp; datas{subject, word}.speech_seg{count}(frame, :)-datas{subject, word}.speech_seg{count}(frame+1, :)];
            end
            diff3{count} = temp;
        end
        datas{subject, word}.speech_seg_diff = diff3;
    end
end

% save C:/Users/jyshin/Desktop/신진영/대학/대학자료/졸업논문/신진영_졸업논문_구현/데이터/SHAPE_DATA_45_half.mat datas -v 7.3;
