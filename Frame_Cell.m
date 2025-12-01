clc; clear all;

numSpeakers = 3;

datas = cell(numSpeakers, 10);

path = "C:/Users/jyshin/Desktop/신진영/대학/대학자료/졸업논문/신진영_졸업논문_구현/데이터/match image/90/match_";
f_path = "D:/python/RoIDetection/Result/45/";

for s = 1:numSpeakers
    i = s;

    path_i = path + i + ".txt";
    match = readcell(path_i);
    table_height = size(match, 1);

    j = 1;
    utt_cnt = 1;
    for hgt = 1:table_height
        if match{hgt, 2} ~= utt_cnt
            utt_cnt = match{hgt, 2};
            j = 1;
        end
        if match{hgt, 5} == 1
            f_path_match = f_path + i + "/" + match{hgt, 1} + "/" + match{hgt, 6};
                img = imread(f_path_match);
                img = rgb2gray(img);
                img = histeq(img);
                datas{i, match{hgt, 1}}{match{hgt, 2}}{j} = img;
                j = j + 1;
            %                 break
        else
            j = 1;
        end
        %             break
    end
    %         break
end



% save('C:/Users/jyshin/Desktop/신진영/대학/대학자료/졸업논문/신진영_졸업논문_구현/데이터/Frame_Data_Pre_1.mat', 'datas' , '-v7.3');