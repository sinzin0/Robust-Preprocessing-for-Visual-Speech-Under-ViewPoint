clc; clear all;

%% 1) 90도용 appearance(diff) 로드 & 정규화
load 'C:/Users/jyshin/Desktop/신진영/대학/대학자료/졸업논문/신진영_졸업논문_구현/데이터/ApperanceData90_diff.mat'
datas = Normalization(datas, 'ECT', 'MIN-MAX');
gray_data = Normalization(datas, 'UTTERANCE', 'MEAN');

% 🔥 여기서 실제 크기대로 받아오기
[numGrid, numSubs, numWords] = size(gray_data);
disp([ "numGrid = " + numGrid, "numSubs = " + numSubs, "numWords = " + numWords ]);

% Han 기준: diff는 grid 4를 사용 (4x4 → 16차원)
grid_diff = 4;
if grid_diff > numGrid
    error('grid_diff(%d)가 gray_data의 grid 개수(%d)를 초과함', grid_diff, numGrid);
end

hybrid_datas = cell(numSubs, numWords);

for word = 1:numWords
    for sub = 1:numSubs
        worddata = cell(1,1);

        % 이 (sub, word)에 해당하는 diff 데이터가 없는 경우
        if isempty(gray_data{grid_diff, sub, word})
            hybrid_datas{sub, word} = worddata;
            continue;
        end

        utts = gray_data{grid_diff, sub, word};
        countcnt = numel(utts);

        for count = 1:countcnt

            % --- 해당 발화가 실제로 존재하는지 체크 ---
            if isempty(utts{count}) || ...
               ~isfield(utts{count}, 'diff_gray') || ...
               isempty(utts{count}.diff_gray)
                continue;
            end

            % ---- appearance diff 부분만 사용 ----
            diff_seq_full = utts{count}.diff_gray;   % [T x D]

            [T, Ddiff] = size(diff_seq_full);
            if T < 2
                continue;   % 너무 짧으면 버림
            end

            % (선택) 가벼운 smoothing (원치 않으면 주석처리)
            % win = 3;
            % diff_seq_full = movmean(diff_seq_full, win, 1);

            % 첫 프레임 0 패딩 (Han 구조와 비슷하게)
            ttt1 = zeros(1, Ddiff);          % [1 x Ddiff]
            ttt1 = [ttt1; diff_seq_full];    % [T+1 x Ddiff]

            % 90도 HYBRID = diff-only 시퀀스
            temp = ttt1;                     % [T' x Ddiff]

            worddata{count}.speech_seg = temp;
        end

        hybrid_datas{sub, word} = worddata;
    end
end

% save 'C:/.../HYBRID4_90_DIFF_ONLY.mat' hybrid_datas -v7.3
