function [ result ] = Normalization( datas, range, type )
    disp('Start Normalization...');
    switch(type)
        case 'MEAN'
            result = Mean(datas, range);
        case 'MIN-MAX'
            result = MinMax(datas, range);
        otherwise
            result = Mean(datas, range);
    end
    disp('End Normalization...');
end

