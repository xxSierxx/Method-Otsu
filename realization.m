clear all;
clc;
close all;

spath = fileparts(mfilename('fullpath'));
video = VideoReader([spath '\TV-006.mp4']);
Data = data([spath '\TV-006.mat'],2,1,231);
 rect = [419.5100  143.5100   30.9800   32.9800]; %автобуc
%   rect = [ 389.5100  136.5100   21.9800   17.9800]; %машина
% rect = [154.5100   27.5100   26.9800   13.9800];
 noise = 0.3; %значение дисперсии шума
nf = 1;
errorXE = [];
errorYE = [];
errorX = [];
errorY = [];
while nf<51

    im = read (video, nf);
%     im = imnoise(im,'gaussian',noise); %для исследования шума
    im =im(:,:,1);
    im_rect = imcrop(im, rect);
    
    T = otsu (im_rect); %порог, полученный с помощью метода Отсу
    BW = im2bw(im_rect,T); %бинаризация изображения по величен порога Т

    stats = regionprops (BW);
    Area_all=[];
   
    subplot(1,4,[1,2,3]);
    imshow(im);
    
    title(['Выделение объекта (номер кадра: ',num2str(nf),')']);
    subplot(1,4,4);
    imshow(BW);
    title('Результат сегментации')
    Area_max = 0;
    for i = 1:length(stats)

        Area_all = [Area_all stats(i).Area];

        if stats(i).Area > Area_max
            Rect_show = [stats(i).BoundingBox(1) + rect(1) ...
                stats(i).BoundingBox(2) + rect(2) ...
                stats(i).BoundingBox(3) ...
                stats(i).BoundingBox(4)];
        end
        [Area_max idx] = max(Area_all)
    end

    subplot(1,4,[1,2,3]);
    rectangle('Position', Rect_show, 'EdgeColor', 'r');


    %расчёт и вывод для файла трассировки
    Data_new = Data(nf,3:6);
    subplot(1,4,[1,2,3]);
    rectangle('Position', Data_new([2,1,4,3]), 'EdgeColor', 'b');

    %Обновление зоны поиска целеуказания
    rect(1:2)=[Rect_show(1) + Rect_show(3)/2 - rect(3)/2 ...
        Rect_show(2)+Rect_show(4)/2 - rect(4)/2];

    subplot(1,4,[1,2,3]);
    rectangle ('Position', rect, 'EdgeColor', 'g');

errorXE(nf) = Data_new(2);
errorYE(nf) = Data_new(1);


errorX(nf) = rect(1);
errorY(nf) = rect(2);

    nf = nf + 1;
    drawnow;
end


for i = 1:50
dx(i) = (errorXE(i)-errorX(i));
dy(i) = (errorYE(i)-errorY(i));
err(i) = sqrt(dx(i)^2 + dy(i)^2);
end

figure;
plot(err);
title('График ошибки измерения координат');
 xlabel('Номер кадра');
 ylabel('Значение ошибки');





