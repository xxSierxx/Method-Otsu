 function T = otsu (im)
% J = imnoise(im,'gaussian',0.1, 0.35);
% im = imread ('C:\Users\dendo\Desktop\tex_zren\znak.jpg');

im = im2gray(im); %преобразуем в полутон
h = imhist (im);  %гистограмма изображения
% histogram(im);
% title('Гистограмма яркости');
% xlabel('Яркость пикселя');
% ylabel('Количество пикселей');

var = zeros(1,256);
numPixel = sum (h);    %Общее количество всех пикселей гистограммы
p = h / numPixel;      %Средний уровень яркости исходного изображения

L = 256;

porog = graythresh(im);
for t = 1:L

    wBack =  sum(p(1 : t));        %распределение вероятностей для фона
    wObject = sum(p(t + 1 : L));     %распределение вероятностей для объекта

    % математическое ожидание для фона и объекта
    mBack = dot(1 : t, p(1 : t)) / wBack;
    mObject = dot(t + 1 : L, p(t + 1  : L)) / wObject;

 
    var(t) = wObject * wBack * (mBack - mObject).^2;    %дисперсия
    %     varBack = (1 : t - mBack).^2 / wObject;
    %     varObject = (t + 1: - mObject).^2/wObject;


    %   var(t) = varBack.^2 * wBack + wObject * varObject.^2;

    % var(t) = wBack * mBack + wObject * wObject;

end



[maxVar idx] = max(var);  %Максимальная дисперсия
F = find (var == maxVar);
% Threshold = F/255;
Threshold = idx/256;
T = Threshold;
% BW = im2bw(im,Threshold);
% imshow(BW);
% [porog Threshold]
% imshow ([im (im > F)*255]);


% figure;
% imshow(im2bw(im,porog));