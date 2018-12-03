classdef ImagePreprocessing
    % 在影像送進網路前的預處理工作
    properties
        standard_height;
        standard_width;
    end
    
    methods
        function obj = ImagePreprocessing(height, width)
            % 建構子，設定圖片的標準尺寸
            if nargin > 0
                obj.standard_height = height;
                obj.standard_width = width;
            end
        end
        
        function img_new = zoom_adjust(obj, img, axis)
            % 縮放調整圖片的副程式：等比例將圖片寬、高其中一邊調成標準大小
            % [參數] img:原始圖片，型態為三維陣列,  axis:用來選擇做為基準的邊(軸)
            %     axis == 1 將圖片的高調整成 standard_height
            %     axis == 2 將圖片的寬調整成 standard_width
            %     axis 若為 1,2以外的值就直接將圖片resize成標準尺寸
            shape = size(img);
            if axis == 1
                zoom_ratio = obj.standard_height / shape(1);
                img_new = imresize(img, [obj.standard_height,floor(shape(2)*zoom_ratio)], 'bilinear');
            elseif axis == 2
                zoom_ratio = obj.standard_width / shape(2);
                img_new = imresize(img, [floor(shape(1)*zoom_ratio),obj.standard_width], 'bilinear');
            else
                img_new = imresize(img, [obj.standard_height,obj.standard_width], 'bilinear');
            end
        end
        
        function img_new = padding(obj, img, axis)
            % 將調整過的圖片擴展成標準size(針對不足的區塊全部填充 0)
            % [參數] img:調整後的圖片 ,  axis:小於標準寬高的軸(短邊)
            % 先創建一個標準size的空圖片img_new，再將img複製到img_new的中間
            shape = size(img);
            img_new = zeros(obj.standard_height, obj.standard_width, 3, 'uint8');
            if axis == 1
                bottom = floor((obj.standard_height - shape(1)) / 2);
                top = bottom + shape(1);
                img_new(bottom+1:top,:,:) = img;
            elseif axis == 2
                left = floor((obj.standard_width - shape(2)) / 2);
                right = left + shape(2);
                img_new(:,left+1:right,:) = img;
            else
                error('Argument "axis" not allowed');
            end
        end
        
        function img_new = cropping(obj, img, axis)
            % 等比例將圖片寬、高中較短的邊調成標準大小，再切除長邊多餘的部分
            % [參數] img:原始圖片 ,  axis:用來選擇作為基準的軸(短邊)
            img_new = obj.zoom_adjust(img, axis);
            shape = size(img_new);
            if axis == 1
                left = floor((shape(2) - obj.standard_width) / 2);
              	right = left + obj.standard_width;
                img_new = img_new(:,left+1:right,:);
            elseif axis == 2
                bottom = floor((shape(1) - obj.standard_height) / 2);
                top = bottom + obj.standard_height;
                img_new = img_new(bottom+1:top,:,:);
            else
                error('Argument "axis" not allowed');
            end
        end
        
        function img_new = size_adjust(obj, img, method)
            % 將圖片調整成標準size，提供三種方法
            %     method == "warping": 直接透過resize轉換成標準尺寸
            %     method == "padding": 將圖片等比縮放至長邊等於標準大小，再填滿剩餘區域
            %     method == "cropping": 將圖片等比縮放至短邊等於標準大小，再將多餘區域切除
            shape = size(img);
            aspect_ratio = shape(2) / shape(1);
            standard_aspect_ratio = obj.standard_width / obj.standard_height;
            if strcmp(method, 'warping')
                img_new = obj.zoom_adjust(img, 0);
            elseif strcmp(method, 'padding')
                if aspect_ratio < standard_aspect_ratio
                    img_ = obj.zoom_adjust(img, 1);
                    img_new = obj.padding(img_, 2);
                elseif aspect_ratio > standard_aspect_ratio
                    img_ = obj.zoom_adjust(img, 2);
                    img_new = obj.padding(img_, 1);
                else
                    img_new = obj.zoom_adjust(img, 0);
                end
            elseif strcmp(method, 'cropping')
                if aspect_ratio < standard_aspect_ratio
                    img_new = obj.cropping(img, 2);
                elseif aspect_ratio > standard_aspect_ratio
                    img_new = obj.cropping(img, 1);
                else
                    img_new = obj.zoom_adjust(img, 0);
                end
            else
                error('Argument "method" not allowed');
            end
        end
        
    end
end