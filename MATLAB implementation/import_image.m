function imgcell = import_image(PATH)
% [參數] PATH: 字串型態，為檔案存放路徑
% 將PATH路徑下副檔名為.jpg的圖片讀入，並以Cell Array回傳
lastchar = length(PATH);
if PATH(lastchar) ~= '\'
    PATH(lastchar+1) = '\';
end
file = dir(strcat(PATH, '*.jpg'));
for i = 1:length(file)
    [img, map] = imread(strcat(PATH, file(i).name));
    % 若為索引圖像則需轉換為unit8的RGB圖
    if ~isempty(map)
        imgcell{i} = im2uint8(ind2rgb(img,map));
        continue;
    end
    imgcell{i} = img;
end