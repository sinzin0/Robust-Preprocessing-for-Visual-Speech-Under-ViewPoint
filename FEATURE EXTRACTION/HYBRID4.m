clc; clear all;

load 'C:/Users/jyshin/Desktop/신진영/대학/대학자료/졸업논문/신진영_졸업논문_구현/데이터/ApperanceData2_half_diff.mat'
datas = Normalization(datas, 'ECT', 'MIN-MAX');
gray_data = Normalization(datas, 'UTTERANCE', 'MEAN');
% datas = Normalization(datas, 'ECT', 'MIN-MAX');
% gray_data = Normalization(datas, 'UTTERANCE', 'MEAN');

load 'C:/Users/jyshin/Desktop/신진영/대학/대학자료/졸업논문/신진영_졸업논문_구현/데이터/SHAPE_DATA_45_2_half.mat'
datas = Normalization(datas, 'SHAPE', 'MIN-MAX');
shape_data = ShapeMean(datas, 'UTTERANCE');

numSubs  = 3;
numWords = 10;

hybrid_datas = cell(numSubs, numWords);

for word = 1:numWords
    for sub = 1:numSubs
        worddata = cell(1,1);

        % Han 코드 기준: gridno=6의 gray, gridno=4의 diff_gray 사용
        % (네가 다른 grid를 쓰고 싶으면 이 인덱스만 바꾸면 됨)
        [~, countcnt] = size(gray_data{6, sub, word});

        for count = 1:countcnt
            % 해당 발화가 실제로 존재하는지 체크
            if count > length(shape_data{sub, word}.speech_seg) || ...
               isempty(shape_data{sub, word}.speech_seg{count}) || ...
               isempty(gray_data{6, sub, word}{count}.gray)     || ...
               isempty(gray_data{4, sub, word}{count}.diff_gray)
                continue;
            end

            % frame 길이
            [frame1, ~] = size(shape_data{sub, word}.speech_seg{count});         % shape T1
            [frame2, ~] = size(gray_data{6, sub, word}{count}.gray);            % appearance T2
            [frame3, ~] = size(gray_data{4, sub, word}{count}.diff_gray);       % diff T3

            % Han 코드와 동일한 체크
            if frame2 - frame3 ~= 1
                disp(['error ' num2str(sub) ' ' num2str(word) ' ' num2str(count)]);
            end

            temp1 = 0; 
            temp2 = 0;
            if frame2 - frame1 == 1
                % 이상적 케이스 (T2 = T1+1, T3 = T1)
            elseif frame2 - frame1 > 1
                % appearance가 더 길 때 → diff_gray에서 뒤를 잘라줌
                temp1 = frame2 - frame1 - 1;
            elseif frame2 - frame1 == 0
                % 같은 길이일 때 → shape 하나 줄여서 맞춤
                temp2 = 1;
            else
                % shape가 더 길 때 → shape를 더 줄임
                temp2 = frame1 - frame2 + 1;
            end

            % ---- shape 부분 (4차원) ----
            % 첫 프레임은 0 패딩, 이후엔 shape 시퀀스
            ttt  = zeros(1, 4);   % 기존 5 → 4로 수정
            % frame1 - temp2 만큼만 사용
            shape_seq = shape_data{sub, word}.speech_seg{count}(1:end-temp2, 1:4);
            ttt      = [ttt; shape_seq];

            % ---- appearance diff 부분 (16차원) ----
            ttt1  = zeros(1, 16); % grid 4x4라 가정 (16차원)
            diff_seq = gray_data{4, sub, word}{count}.diff_gray(1:end-temp1, :);
            ttt1     = [ttt1; diff_seq];

            % ---- 두 특징 붙이기 ----
            % 최종 크기: [T' × (4 + 16)] = T' × 20
            temp = [ttt, ttt1];

            worddata{count}.speech_seg = temp;
        end

        hybrid_datas{sub, word} = worddata;
    end
end

% save C:/Users/jyshin/Desktop/신진영/대학/대학자료/졸업논문/신진영_졸업논문_구현/데이터/HYBRID3.mat hybrid_datas;