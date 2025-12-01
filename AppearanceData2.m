clc; clear all;
load C:/Users/jyshin/Desktop/신진영/대학/대학자료/졸업논문/신진영_졸업논문_구현/데이터/Frame_Data_Pre_90.mat


datass = datas;                         % 1단계 결과: datass{sub, word}{utt}{frame}
[numSubs, numWords] = size(datass);
numGrid = 10;

datas = cell(numGrid, numSubs, numWords);

% 어느 쪽 반을 쓸지 선택: "left" 또는 "right"
use_side = "left";   % 45도에서 카메라 쪽이 오른쪽이면 "right", 왼쪽이면 "left"

for gridno = 1:numGrid
    for sub = 1:numSubs
        for word = 1:numWords
            [gridno sub word]   % 진행 상황 출력

            cnt = length(datass{sub, word});        % 이 단어의 발화 수
            utterance_data = cell(1, cnt);

            for count = 1:cnt                       % 각 발화
                frame = length(datass{sub, word}{count});  % 프레임 수
                grayfeature = [];

                for frameno = 1:frame               % 각 프레임
                    image = datass{sub, word}{count}{frameno};  
                    image=im2gray(im2double(image));

                    % --- (2) 잘 보이는 반쪽만 사용 ---
                    [h, w] = size(image);
                    left_ratio = 0.6;                % 왼쪽 60%, 오른쪽 40%
                    cut = round(w * left_ratio);     % 기준선: 전체 폭의 60% 위치

                    if use_side == "right"
                        % 오른쪽 절반만 사용
                        image = image(:, cut+1:end);
                    else
                        % 왼쪽 절반만 사용
                        image = image(:, 1:cut);
                    end

                    % --- (3) 논문 설정대로 100x130, bilinear 리사이즈 ---
                    image = imresize(image, [100, 130], 'bilinear');
                    image=histeq(image);

                    % --- (4) 아래부터는 기존 grid 나누기 코드 그대로 ---
                    [row, col] = size(image);
                    gridimg = cell(gridno, gridno);
                    x_criterion = floor(col/gridno);
                    y_criterion = floor(row/gridno);

                    for y = 1:gridno
                        for x = 1:gridno
                            gridimg{y,x} = [];
                        end
                    end

                    for y = 1:row
                        yidx = ceil(y / y_criterion);
                        if yidx > gridno
                            yidx = gridno;
                        end
                        for x = 1:col
                            xidx = ceil(x / x_criterion);
                            if xidx > gridno
                                xidx = gridno;
                            end
                            gridimg{yidx, xidx} = [gridimg{yidx, xidx}; image(y, x)];
                        end
                    end

                    img = [];
                    for y = 1:gridno
                        for x = 1:gridno
                            img = [img, mean(gridimg{y,x})];
                        end
                    end

                    grayfeature = [grayfeature; img];
                end

                utterance_data{count}.gray = grayfeature;
            end

            datas{gridno, sub, word} = utterance_data;
        end
    end
end

% save C:/Users/jyshin/Desktop/신진영/대학/대학자료/졸업논문/신진영_졸업논문_구현/데이터/AppearanceData_half.mat datas