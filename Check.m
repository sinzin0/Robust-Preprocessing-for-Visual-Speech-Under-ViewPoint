% CheckFeatureDims.m 같은 이름으로 만들어도 됨
clear; clc;
load 'C:/Users/jyshin/Desktop/신진영/대학/대학자료/졸업논문/신진영_졸업논문_구현/데이터/HYBRID_half.mat';
datas = hybrid_datas

[numSubs, numWords] = size(datas);

allDims = [];   % [sub, word, count, frames, dim]

for sub = 1:numSubs
    for word = 1:numWords

        block = datas{sub, word};
        if isempty(block)
            continue;
        end

        % block 타입별로 utterance 개수 파악
        if iscell(block)
            countcnt = numel(block);
        elseif isstruct(block)
            countcnt = numel(block);
        else
            countcnt = 1;
        end

        for count = 1:countcnt

            % ----- sample 하나 꺼내기 -----
            if iscell(block)
                sample = block{count};
            elseif isstruct(block)
                sample = block(count);
            else
                if count > 1
                    continue;
                end
                sample = block;
            end

            if isempty(sample)
                continue;
            end

            % ----- sample 구조에 따라 seq 꺼내기 -----
            if isstruct(sample)
                if isfield(sample, 'speech_seg')
                    seq = sample.speech_seg;
                elseif isfield(sample, 'full')
                    seq = sample.full;
                else
                    continue;
                end
            else
                seq = sample;
            end

            if isempty(seq)
                continue;
            end

            [fno, dim] = size(seq);
            allDims = [allDims; sub, word, count, fno, dim];
        end
    end
end

fprintf('★ 발견된 feature 차원 종류들 (dim):\n');
disp(unique(allDims(:,5)));

% 가장 많이 나오는(정상으로 추정되는) 차원 찾기
dims = allDims(:,5);
[uniqDims, ~, idxu] = unique(dims);
counts = accumarray(idxu, 1);
[~, maxIdx] = max(counts);
majorDim = uniqDims(maxIdx);

fprintf('★ 가장 많이 등장하는 dim = %d (정상 후보)\n', majorDim);

% 튀는 애들만 골라보기
abnormal = allDims(dims ~= majorDim, :);
fprintf('★ 다른 차원을 가진 샘플 수 = %d\n', size(abnormal,1));
if ~isempty(abnormal)
    disp('  [sub, word, count, frames, dim] 예시 (앞 20개만):');
    disp(abnormal(1:min(20,end), :));
end
