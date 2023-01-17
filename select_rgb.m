clc;clear;
pnglst = dir('C:\Users\Sun\Desktop\EVA screen\*.png');
for i = 1:length(pnglst)
    png_name = pnglst(i).name;
    pic = imread(['C:\Users\Sun\Desktop\EVA screen\' png_name]);
    pic = imresize(pic,0.2);
    R(i) = sum(sum(pic(:,:,1)));
    G(i) = sum(sum(pic(:,:,2)));
    B(i) = sum(sum(pic(:,:,3)));
    
    lst = [R(i) G(i) B(i)];
    [m1,p] = max(lst);
    rgb_lst(i) = p;
    lst(lst == max(lst)) = -1;
    [m2,p] = max(lst);
    if m1 > 1.5 * m2
        single_lst(i) = 1;
    else
        single_lst(i) = 0;
    end
    lst = [];
end

dir  = 'C:\Users\Sun\Desktop\EVA screen\database4\';
%color_interval = [0 32 64 96 128 160 192 224 255];
%color_interval = [0 64 128 192 255];
%color_interval = [0 85 170 255];
color_interval = [0 128 255];

for i = 1:length(color_interval)
    for j = 1:length(color_interval)
        for  k = 1:length(color_interval)
            dir_folder = [dir num2str(i,'%02d') num2str(j,'%02d') num2str(k,'%02d')];
            [status, msg, msgID] = mkdir(dir_folder);
        end
    end
end

%给照片分组
for i = 1:length(pnglst)
    png_name = pnglst(i).name;
    pic = imread(['C:\Users\Sun\Desktop\EVA screen\' png_name]);
    pic = imresize(pic,0.2);
    pic = pic(1:end-50,:,:);
    r = mean(mean(pic(:,:,1)));
    g = mean(mean(pic(:,:,2)));
    b = mean(mean(pic(:,:,3)));
    

    lst = [r g b];
        for mm =  1:3
            for n = 1:length(color_interval)-1
                if lst(mm) < color_interval(n+1)
                    if abs(lst(mm) - color_interval(n)) < abs(lst(mm) - color_interval(n+1))
                        lst(mm) = n;
                    else
                        lst(mm) = n+1;
                    end
                break 
                end
            end
        end
        imwrite(pic,[dir num2str(lst(1),'%02d') num2str(lst(2),'%02d') num2str(lst(3),'%02d') '\' png_name]);
end

%{
for i = 1:length(rgb_lst)
    png_name = pnglst(i).name;
    pic = imread(['C:\Users\Sun\Desktop\EVA screen\' png_name]);
    pic = imresize(pic,0.2);
    pic = pic(1:end-50,:,:);
    if single_lst(i) == 1
        if   rgb_lst(i) == 1
            imwrite(pic,['C:\Users\Sun\Desktop\EVA screen\R\single\' png_name]);
        elseif rgb_lst(i) == 2
            imwrite(pic,['C:\Users\Sun\Desktop\EVA screen\G\single\' png_name]);
        else
            imwrite(pic,['C:\Users\Sun\Desktop\EVA screen\B\single\' png_name]);
        end
    else
        if   rgb_lst(i) == 1
            imwrite(pic,['C:\Users\Sun\Desktop\EVA screen\R\mul\' png_name]);
        elseif rgb_lst(i) == 2
            imwrite(pic,['C:\Users\Sun\Desktop\EVA screen\G\mul\' png_name]);
        else
            imwrite(pic,['C:\Users\Sun\Desktop\EVA screen\B\mul\' png_name]);
        end
    end
end
%}

% hsv_mean1_lst(var1lst>0.05)=-99999;
% hsv_mean2_lst(var1lst>0.05)=-99999;
% hsv_mean2_lst(var1lst>0.05)=-99999;