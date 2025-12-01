load 'C:/Users/jyshin/Desktop/신진영/대학/대학자료/졸업논문/신진영_졸업논문_구현/데이터/HYBRID4_ISOMAP_45_DIM7.mat';
R = results_all(10);          % 지금은 DIM 하나라 1번만 있음
R.DIM                        % 사용한 차원 (7)
R.confu_mat                  % 10x10 혼동행렬
R.recog_table                % [정답개수, 총발화수, 인식률]
R.word_acc                   % (10x1) 각 단어 인식률
R.overall_acc                % 전체 평균 인식률