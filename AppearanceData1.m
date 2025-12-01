% clc; clear all;

datass = datas;
[numSubs,numWords] = size(datass);
numGrid = 10;

datas = cell(numGrid, numSubs, numWords);
for gridno=1:numGrid
    for sub=1:numSubs
        for word=1:numWords
            [gridno sub word]
            cnt = length(datass{sub, word});
            utterance_data = cell(1,cnt);

            for count=1:cnt
                frame = length(datass{sub, word}{count});
                grayfeature = [];
                
                for frameno=1:frame
                    image=datass{sub, word}{count}{frameno};

                    image=im2gray(im2double(image));

                    image=imresize(image, [100, 130],'bilinear');

                    image=histeq(image);

                    [row, col] = size(image);
                    gridimg = cell(gridno, gridno);
                    x_criterion = floor(col/gridno);
                    y_criterion = floor(row/gridno);
                    for y=1:gridno
                        for x=1:gridno
                            gridimg{y,x} = [];
                        end
                    end

                    for y=1:row
                        yidx = ceil(y/y_criterion);
                        if yidx > gridno
                            yidx = gridno;
                        end
                        for x=1:col
                            xidx = ceil(x/x_criterion);
                            if xidx > gridno
                                xidx = gridno;
                            end
                            gridimg{yidx, xidx} = [gridimg{yidx, xidx}; image(y, x)];
                        end
                    end

                    img = [];
                    for y=1:gridno
                        for x=1:gridno
                            img = [img,mean(gridimg{y,x})];
                        end
                    end
                    grayfeature = [grayfeature;img];
                end
                utterance_data{count}.gray = grayfeature;
            end
            datas{gridno, sub, word} = utterance_data;
        end
    end
end

% save C:/Users/jyshin/Desktop/신진영/대학/대학자료/졸업논문/신진영_졸업논문_구현/데이터/AppearanceData_1.mat datas;

