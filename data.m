function DataID=data_init(spathdata,IDObject,StartFrame,EndFrame)
load(spathdata);

DataID = Data((Data(:,1)==IDObject & (Data(:,2)>=StartFrame & Data(:,2)<=EndFrame)),1:6); % выбор данных для объекта
% с идентификатором IDObject для диапазона кадров [StartFrame EndFrame]
 [~, idx]=sort(DataID(:,2),'ascend');  % сортировка по возрастанию кадров
 DataID=DataID(idx,1:6);                    % сортировка по возрастанию кадров
 DataID(:,3)=DataID(:,3)-DataID(:,5)/2; %пересчет координаты от КоординатаЦентраY к КоординатаЛевогоВерхнегоУглаY 
 DataID(:,4)=DataID(:,4)-DataID(:,6)/2; %пересчет координаты от КоординатаЦентраX к КоординатаЛевогоВерхнегоУглаX 
% end