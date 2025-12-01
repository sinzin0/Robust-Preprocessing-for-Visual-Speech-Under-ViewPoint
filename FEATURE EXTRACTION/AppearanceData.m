% clc; clear all;
% load D:/CBNU/FRAMES/Frame_Data_1.mat
% % labels = {'ABOUT','BILLION','CALLED', 'DAVID', 'EARLY', 'FACING', 'GENERAL', 'HIGHER', 'INTEREST', 'KILLED'};
% % raw_data_path=['/Volumes/SAMSUNG/WILD_DATASET/DATAS/IMG/'];
% % raw_data_path=['E:/WILD_DATASET/DATAS/IMG/'];
% 
datass = datas;
datas = cell(10, 16, 10);
for gridno=1:10
    for sub=1:16
        for word=1:10
            [gridno sub word]
            cnt = length(datass{sub, word});
            utterance_data = cell(1,cnt);
            %         path = [raw_data_path labels{1, word} '/'];
            for count=1:cnt
                %             ImageFileList = dir([path num2str(count) '_*.jpg']);
                %             [frame, col] = size(ImageFileList);
%                 if frame == 0
%                     continue;
%                 end
                frame = length(datass{sub, word}{count});
                grayfeature = [];
                for frameno=1:frame
%                     name = [num2str(count) '_' num2str(frameno) '.jpg'];
                    image=datass{sub, word}{count}{frameno};
                    
                    image=rgb2gray(im2double(image));
                    %                 figure(1);
                    %                 imshow(image);
                    
                    
                    image=imresize(image, [100, 130]);
                    
                    image=histeq(image);
                    %                 figure(2)
                    %                 imshow(image);                 
                    
                    
%                     image = lightNormalize(image);
                    %                 figure(3)
                    %                 imshow(image);
                    
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
%     gridno
end

save D:/CBNU/AppearanceData/AppearanceData1_ROI1_bicubic.mat datas;
% load D:/CBNU/AppearanceData/AppearanceData1_ROI_4.mat datas;

% % datas_f = cell(10, 16, 10);
% % 
% % for gridno=1:10
% %     for sub=1:16  
% %         for word=1:10
% %             datas_f{gridno, sub, word} = datas{gridno, word, sub};
% %         end
% %     end
% % endbilinear
% % 
% % datas = cell(10, 16, 10);
% % datas = datas_f;

for gridno=1:10
    for sub=1:16
        for word=1:10
            cnt = length(datass{sub, word});
            for count=1:cnt
                [row, col] = size(datas{gridno, sub, word}{count}.gray);
                temp = [];
                for frame=1:row-1
                    temp = [temp; datas{gridno, sub, word}{count}.gray(frame, :)-datas{gridno, sub, word}{count}.gray(frame+1, :)];
                end
                datas{gridno, sub, word}{count}.diff_gray = temp;
            end
        end
    end
end

save D:/CBNU/AppearanceData/AppearanceData1_Dif_ROI1_bicubic.mat datas

% save D:/AppearanceData/APPEARANCE_LN_ROI_4.mat datas -v7.3
% save E:/WILD_DATASET/MATLAB_DATAS/APPEARANCE.mat datas -v7.3