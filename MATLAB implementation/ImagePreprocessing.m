classdef ImagePreprocessing
    % �b�v���e�i�����e���w�B�z�u�@
    properties
        standard_height;
        standard_width;
    end
    
    methods
        function obj = ImagePreprocessing(height, width)
            % �غc�l�A�]�w�Ϥ����зǤؤo
            if nargin > 0
                obj.standard_height = height;
                obj.standard_width = width;
            end
        end
        
        function img_new = zoom_adjust(obj, img, axis)
            % �Y��վ�Ϥ����Ƶ{���G����ұN�Ϥ��e�B���䤤�@��զ��зǤj�p
            % [�Ѽ�] img:��l�Ϥ��A���A���T���}�C,  axis:�Ψӿ�ܰ�����Ǫ���(�b)
            %     axis == 1 �N�Ϥ������վ㦨 standard_height
            %     axis == 2 �N�Ϥ����e�վ㦨 standard_width
            %     axis �Y�� 1,2�H�~���ȴN�����N�Ϥ�resize���зǤؤo
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
            % �N�վ�L���Ϥ��X�i���з�size(�w�藍�����϶�������R 0)
            % [�Ѽ�] img:�վ�᪺�Ϥ� ,  axis:�p��зǼe�����b(�u��)
            % ���Ыؤ@�Ӽз�size���ŹϤ�img_new�A�A�Nimg�ƻs��img_new������
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
            % ����ұN�Ϥ��e�B�������u����զ��зǤj�p�A�A��������h�l������
            % [�Ѽ�] img:��l�Ϥ� ,  axis:�Ψӿ�ܧ@����Ǫ��b(�u��)
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
            % �N�Ϥ��վ㦨�з�size�A���ѤT�ؤ�k
            %     method == "warping": �����z�Lresize�ഫ���зǤؤo
            %     method == "padding": �N�Ϥ������Y��ܪ��䵥��зǤj�p�A�A�񺡳Ѿl�ϰ�
            %     method == "cropping": �N�Ϥ������Y��ܵu�䵥��зǤj�p�A�A�N�h�l�ϰ����
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