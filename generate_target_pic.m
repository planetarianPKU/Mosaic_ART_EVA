clear
%pic = imread("C:\Users\Sun\Desktop\EVA screen\target\2023-01-16-15-08-22.png");
% pic = imread("C:\Users\Sun\Desktop\EVA screen\target\2023-01-16-16-18-10.png");
% pic = imread("C:\Users\Sun\Desktop\EVA screen\target\2023-01-16-18-12-01.png");
% pic = imread("C:\Users\Sun\Desktop\EVA screen\target\2023-01-16-15-18-39.png");
pic = imread("C:\Users\Sun\Desktop\EVA screen\target\2023-01-16-18-10-17.png");
pic = pic(1:end-50,:,:);
zoom_factor = 0.2;
ele_sz = ceil(zoom_factor*[246,383]);
%ele_sz = [74   115];
pic_sz = 10*size(pic);
pic_use_sz = [round(ele_sz(1)/ele_sz(2)*pic_sz(2)) pic_sz(2)];
cut_part = round(0.5*(pic_sz(1)-pic_use_sz(1)));
pic = imresize(pic,10);
pic = pic(cut_part+1:end-cut_part,:,:);
pic = imresize(pic,0.1);

pic_small = imresize(pic,0.1);
szpic = size(pic_small);
pic_small = double(pic_small);
pic_recolor = pic_small;
pic_recolor_ind = pic_recolor;
color_interval = [0 64 128 192 255];
%color_interval = [0 32 64 96 128 160 192 224 255];
%color_interval = [0 85 170 255];

for i = 1:szpic(1)
    for j = 1:szpic(2)
        for k = 1:szpic(3)
            for n = 1:length(color_interval)-1
                if pic_small(i,j,k) < color_interval(n+1)
                    if abs(pic_small(i,j,k) - color_interval(n)) < abs(pic_small(i,j,k) - color_interval(n+1))
                        pic_recolor(i,j,k) = color_interval(n);
                        pic_recolor_ind(i,j,k) = n;
                    else
                        pic_recolor(i,j,k) = color_interval(n+1);
                        pic_recolor_ind(i,j,k) = n+1;
                    end
                    break
                end
            end
        end
    end
end


pic_mosaic(:,:,1) = zeros(size(pic_small,1)*ele_sz(1),size(pic_small,2)*ele_sz(2)) ;
pic_mosaic(:,:,2) = zeros(size(pic_small,1)*ele_sz(1),size(pic_small,2)*ele_sz(2)) ;
pic_mosaic(:,:,3) = zeros(size(pic_small,1)*ele_sz(1),size(pic_small,2)*ele_sz(2)) ;


for i = 1:szpic(1)
    for j = 1:szpic(2)
        vec = [pic_recolor_ind(i,j,1) pic_recolor_ind(i,j,2) pic_recolor_ind(i,j,3)];
        pnglst = dir(['C:\Users\Sun\Desktop\EVA screen\database2\' num2str(vec(1),'%02d') ...
            num2str(vec(2),'%02d') num2str(vec(3),'%02d') '\*.png']);
        if isempty(pnglst)
            block(:,:,1) = pic_recolor(1)*zeros(ele_sz);
            block(:,:,2) = pic_recolor(2)*zeros(ele_sz);
            block(:,:,3) = pic_recolor(3)*zeros(ele_sz);
            pic_mosaic(1+(i-1)*ele_sz(1):(i)*ele_sz(1),1+(j-1)*ele_sz(2):(j)*ele_sz(2),:) = block;
        else
            rand_ind = randi([1 length(pnglst)],1);
            block_name = pnglst(rand_ind).name;
            block = imread(['C:\Users\Sun\Desktop\EVA screen\database2\' ...
                num2str(vec(1),'%02d') num2str(vec(2),'%02d') num2str(vec(3),'%02d') '\' block_name]);
            block = imresize(block,zoom_factor);
            pic_mosaic(1+(i-1)*ele_sz(1):(i)*ele_sz(1),1+(j-1)*ele_sz(2):(j)*ele_sz(2),:) = block;
            
        end
        
    end
end

imwrite(pic_mosaic/256,'C:\Users\Sun\Desktop\EVA screen\result\result.png');
