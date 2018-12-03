function imgcell = import_image(PATH)
% [�Ѽ�] PATH: �r�ꫬ�A�A���ɮצs����|
% �NPATH���|�U���ɦW��.jpg���Ϥ�Ū�J�A�åHCell Array�^��
lastchar = length(PATH);
if PATH(lastchar) ~= '\'
    PATH(lastchar+1) = '\';
end
file = dir(strcat(PATH, '*.jpg'));
for i = 1:length(file)
    [img, map] = imread(strcat(PATH, file(i).name));
    % �Y�����޹Ϲ��h���ഫ��unit8��RGB��
    if ~isempty(map)
        imgcell{i} = im2uint8(ind2rgb(img,map));
        continue;
    end
    imgcell{i} = img;
end