%% MDS_HYBRID4_1_ISOMAP.m
% - 입력: HYBRID.mat 안의 hybrid_datas (numSubs x numWords cell)
%         각 cell: {count}.speech_seg = (T x dim) 하이브리드 특징 시퀀스
% - 출력:
%   confu         : 10x10 혼동행렬
%   recog_result  : 10x3 [정답수, 전체수, 인식률]
%   word_acc      : 10x1 단어별 인식률
%   mean_acc      : 전체 평균 인식률
%   template      : [word, sub, count] 템플릿 인덱스
%   datass        : ISOMAP 임베딩된 시퀀스

clear; close all; clc;

%% 0. HYBRID 데이터 로드
% ★ 여기 경로만 네 환경에 맞게 수정해줘 ★
load('C:/Users/jyshin/Desktop/신진영/대학/대학자료/졸업논문/신진영_졸업논문_구현/데이터/HYBRID90.mat', ...
     'hybrid_datas');

datas = hybrid_datas;                 % 이후 코드는 datas 기준으로 사용
[numSubs, numWords] = size(datas);    % 예: numSubs=5, numWords=10


%% 1. tempdata, label1 구성 (프레임 단위 펼치기)
% tempdata : [전체 프레임 수 x feature_dim]
% label1   : [word, sub, count] (프레임마다 하나씩)

tempdata = [];
label1   = [];

for word = 1:numWords
    for sub = 1:numSubs
        block = datas{sub, word};
        if isempty(block)
            continue;
        end

        % block 타입에 따라 utterance 개수(countcnt) 계산
        if iscell(block)
            countcnt = numel(block);
        elseif isstruct(block)
            countcnt = numel(block);
        else
            countcnt = 1;      % 단일 행렬이라고 가정
        end

        for count = 1:countcnt

            % 1-1) block에서 sample 하나 꺼내기
            if iscell(block)
                sample = block{count};
            elseif isstruct(block)
                sample = block(count);
            else
                if count > 1
                    continue;   % 행렬 하나뿐인데 count>1면 스킵
                end
                sample = block;
            end

            if isempty(sample)
                continue;
            end

            % 1-2) sample 구조에 따라 실제 시퀀스 seq 추출
            if isstruct(sample)
                if isfield(sample, 'speech_seg')
                    seq = sample.speech_seg;     % HYBRID 코드에서 만든 필드
                elseif isfield(sample, 'full')
                    seq = sample.full;
                else
                    continue;
                end
            else
                % 이미 (T x dim) 행렬이면 그대로 사용
                seq = sample;
            end

            if isempty(seq)
                continue;
            end

            [fno, ~] = size(seq);
            for frame = 1:fno
                tempdata = [tempdata; seq(frame, :)];
                label1   = [label1; word, sub, count];
            end
        end
    end
end


%% 2. 단어별 ISOMAP 차원 축소
% 각 단어마다 tempdata 중 해당 단어 프레임만 뽑아서 ISOMAP 수행
% c_data: 모든 프레임에 대한 임베딩 결과 (label1 순서와 일치)

K       = 10;   % ISOMAP 이웃 수
MAX_DIM = 57;   % 원래 코드에서 사용하던 최대 차원
c_data  = [];

for word = 1:numWords
    idx = find(label1(:, 1) == word);
    if isempty(idx)
        continue;
    end

    X = tempdata(idx, :)';         % (feature_dim x N)
    Yiso = ISOMAP(X, K);           % (embed_dim x N)

    dim_keep = min(MAX_DIM, size(Yiso, 1));
    % (#samples x dim_keep) 로 transpose 해서 이어붙임
    c_data = [c_data; Yiso(1:dim_keep, :)'];
end


%% 3. 발화 단위 datass{sub, word}{count} 로 복원
datass = cell(numSubs, numWords);

for word = 1:numWords
    for sub = 1:numSubs
        block = datas{sub, word};
        if isempty(block)
            continue;
        end

        if iscell(block)
            countcnt = numel(block);
        elseif isstruct(block)
            countcnt = numel(block);
        else
            countcnt = 1;
        end

        if countcnt == 0
            continue;
        end

        countdata = cell(1, countcnt);

        for count = 1:countcnt
            idx = find(label1(:, 1) == word & ...
                       label1(:, 2) == sub  & ...
                       label1(:, 3) == count);
            if isempty(idx)
                continue;
            end
            % 이 발화의 모든 프레임 (프레임 수 x dim_keep)
            countdata{count} = c_data(idx, :);
        end

        datass{sub, word} = countdata;
    end
end

% 필요하면 ISOMAP 결과도 저장할 수 있음
% save('.../HYBRID4_ISOMAP_DATAS_45.mat','datass','-v7.3');

%% 4. DTW + MDS(cmdscale) + 템플릿 선택 + 인식률 계산

% 여러 DIM을 시험할 수도 있으니 루프 구조는 유지
DIM_list = [3:20];   % 지금은 7만 사용 (원하면 [3:20] 같은 벡터로 바꿔도 됨)
results_all = struct([]);

idxDIM = 1;
for DIM = DIM_list   % 논문에서 7차원이 best라서 7만 사용

    % 4-1) 각 발화 시퀀스를 DIM 차원으로 자른 후 inputdata, label 구성
    label     = [];
    inputdata = {};
    idx_all   = 1;

    for word = 1:numWords
        for sub = 1:numSubs
            utts = datass{sub, word};
            if isempty(utts)
                continue;
            end

            countcnt = numel(utts);
            for count = 1:countcnt
                seq = utts{count};
                if isempty(seq)
                    continue;
                end

                % (frames x DIM) 으로 차원 자르기
                dim_use = min(DIM, size(seq, 2));
                seq_dim = seq(:, 1:dim_use);

                inputdata{idx_all} = seq_dim;
                label = [label; word, sub, count];
                idx_all = idx_all + 1;
            end
        end
    end

    cnt = numel(inputdata);
    if cnt < 2
        warning('시퀀스 개수가 너무 적어서 DTW/MDS 수행 불가 (DIM=%d)', DIM);
        continue;
    end

    % 4-2) DTW 거리 행렬(벡터 형태) 계산
    D = zeros(1, cnt*(cnt-1)/2);
    k = 1;
    for i = 1:cnt-1
        Xi = inputdata{i}';   % (DIM x T1)
        for j = i+1:cnt
            Xj = inputdata{j}';  % (DIM x T2)
            D(k) = dtw(Xi, Xj);  % 여기서 dtw는 ToolBox / 직접 구현 둘 다 가능
            k = k + 1;
        end
    end

    % 4-3) MDS(cmdscale)로 2차원 임베딩
    [Y, eigvals] = cmdscale(D);   % Y: (cnt x 2) 기본

    % (옵션) 단어별 분포 시각화
    figure(3); clf; hold on;
    opt1 = {'o','x','+','*','.'};
    opt2 = {'b','g','r','c','m','k'};
    for word = 1:numWords
        opt = [opt1{mod(word,5)+1} opt2{mod(word,6)+1}];
        idxw = find(label(:, 1) == word);
        plot(Y(idxw, 1), Y(idxw, 2), opt);
    end
    grid on; title(sprintf('Word-wise MDS distribution (DIM=%d)', DIM));

    % (옵션) 화자별 분포 시각화
    figure(4); clf; hold on;
    for sub = 1:numSubs
        opt = [opt1{mod(sub,5)+1} opt2{mod(sub,6)+1}];
        idxs = find(label(:, 2) == sub);
        plot(Y(idxs, 1), Y(idxs, 2), opt);
    end
    grid on; title(sprintf('Speaker-wise MDS distribution (DIM=%d)', DIM));


    %% 5. 템플릿 선택 (단어별 중심에 가장 가까운 발화)

    template = zeros(numWords, 3);   % [word, sub, count]

    for word = 1:numWords
        idxw = find(label(:, 1) == word);
        if isempty(idxw)
            template(word, :) = [word, 0, 0];
            continue;
        end

        c = mean(Y(idxw, 1:2), 1);        % (1 x 2) 중심점
        diff = Y(idxw, 1:2) - c;          % (N x 2)
        d = sqrt(sum(diff.^2, 2));        % (N x 1) 거리
        [~, minidx] = min(d);

        template(word, :) = label(idxw(minidx), :);  % [word, sub, count]
    end


    %% 6. 단어별 inputdata / 템플릿 시퀀스 정리

    inputdata_words = cell(numWords, 1);
    labels_words    = cell(numWords, 1);
    referClass      = cell(numWords, 1);

    for word = 1:numWords
        word_seqs   = {};
        word_labels = [];
        idx_w       = 1;

        for sub = 1:numSubs
            utts = datass{sub, word};
            if isempty(utts)
                continue;
            end

            countcnt = numel(utts);
            for count = 1:countcnt
                seq = utts{count};
                if isempty(seq)
                    continue;
                end

                dim_use = min(DIM, size(seq, 2));
                seq_dim = seq(:, 1:dim_use);

                word_seqs{idx_w} = seq_dim;
                word_labels = [word_labels; sub, count];

                % 템플릿으로 선택된 발화라면 referClass에 저장
                if template(word, 2) == sub && template(word, 3) == count
                    referClass{word} = seq_dim;
                end

                idx_w = idx_w + 1;
            end
        end

        inputdata_words{word} = word_seqs;
        labels_words{word}    = word_labels;
    end


    %% 7. 템플릿과 DTW 비교로 인식률 계산

    result       = zeros(numWords, numWords);   % 혼동 행렬
    recog_result = [];                          % [정답수, 전체수, 인식률]
    sub_results  = cell(numSubs, 1);
    for sub = 1:numSubs
        sub_results{sub} = zeros(numWords, numWords);
    end

    for word = 1:numWords
        word_seqs   = inputdata_words{word};
        word_labels = labels_words{word};
        countcnt    = numel(word_seqs);

        total_cnt = 0;

        for n = 1:countcnt
            seq = word_seqs{n};
            if isempty(seq)
                continue;
            end

            total_cnt = total_cnt + 1;

            % 모든 단어 템플릿과 DTW 거리 계산
            compDtw = inf(1, numWords);
            for w2 = 1:numWords
                if ~isempty(referClass{w2})
                    compDtw(w2) = dtw(referClass{w2}', seq');   % (DIM x T) 형태
                end
            end

            [~, recResult] = min(compDtw);   % 최소 DTW 거리의 단어

            result(word, recResult) = result(word, recResult) + 1;

            lbl = word_labels(n, :);  % [sub, count]
            sub_results{lbl(1)}(word, recResult) = ...
                sub_results{lbl(1)}(word, recResult) + 1;
        end

        if total_cnt == 0
            recog_result = [recog_result; 0, 0, 0];
        else
            recog_result = [recog_result; ...
                result(word, word), ...
                total_cnt, ...
                result(word, word) / total_cnt];
        end
    end

    % === 여기서 DIM별 결과 정리 ===
    word_acc    = recog_result(:,3);          % 각 단어 인식률
    overall_acc = mean(word_acc);             % 전체 평균 인식률

    fprintf('DIM = %d, 평균 인식률 = %.3f\n', DIM, overall_acc);

    results_all(idxDIM).DIM          = DIM;
    results_all(idxDIM).confu_mat    = result;
    results_all(idxDIM).recog_table  = recog_result;   % [정답, 총발화, 인식률]
    results_all(idxDIM).word_acc     = word_acc;
    results_all(idxDIM).overall_acc  = overall_acc;
    results_all(idxDIM).template     = template;
    results_all(idxDIM).label        = label;
    results_all(idxDIM).sub_results  = sub_results;

    idxDIM = idxDIM + 1;
end

%% 8. 결과 .mat로 저장

out_path = 'C:/Users/jyshin/Desktop/신진영/대학/대학자료/졸업논문/신진영_졸업논문_구현/데이터/HYBRID4_ISOMAP_45_DIM7.mat';
save(out_path, 'results_all', 'datass', 'label1', '-v7.3');
