% 設定圖片的標準尺寸和存放的路徑
standard_height = 300;  standard_width = 300;
PATH = 'C:\Users\Mr-Fish\Desktop\FIDS30\apples\';

imgcell = import_image(PATH);
for i = 1:length(imgcell)
    apple1{i} = size_adjust(imgcell{i}, 'resize', standard_height, standard_width);
    apple2{i} = size_adjust(imgcell{i}, 'padding', standard_height, standard_width);
    apple3{i} = size_adjust(imgcell{i}, 'cutting', standard_height, standard_width);
end

for i = 27:30
    figure();
    subplot(1,4,1);
    imshow(imgcell{i});
    subplot(1,4,2);
    imshow(apple1{i});
    subplot(1,4,3);
    imshow(apple2{i});
    subplot(1,4,4);
    imshow(apple3{i})
end


PATH = 'C:\Users\Mr-Fish\Desktop\FIDS30\apples\';
imgcell = import_image(PATH);
imgpre = ImagePreprocessing(200, 200);
for i = 1:length(imgcell)
    apple1{i} = imgpre.size_adjust(imgcell{i}, 'padding');
end
