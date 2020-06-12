clc; clear all; close all;
list=dir('*.mat')
N=length(list)


%������ ���ϱ�
load('t_constituents.mat');
list=dir('ADCP*');
N=length(list);

for i=1:N
load(list(i).name);
Ucomp2(:,:,i)=Ucomp*0.01;
Vcomp2(:,:,i)=Vcomp*0.01;
Time2=Time(1,1)
Time3(i,1)=Time2
end
%Time�� ���� �ð��� ����
TT2=sort(Time3);

TT2 = TT2.*24 % �ϴ����� �ð������� �ٲ��ֱ�

tam=Ucomp2(:,:,2:5);
Ucomp2(:,:,2:5)=[];
Ucomp2=cat(3,Ucomp2,tam);
UU2=Ucomp2;

tam=Vcomp2(:,:,2:5);
Vcomp2(:,:,2:5)=[];
Vcomp2=cat(3,Vcomp2,tam);
VV2=Vcomp2;

%lsf ���� 2�������� �ٲ��ֱ�
[a,b,c]=size(UU2);
X=reshape(UU2,a*b,c);

%lsf
for i=1:size(X,1)
[tidestruc1,xout1]=lsf(TT2,X(i,:),['M2'; 'M4']);
zanu(i,:)=X(i,:)-xout1;
end

%lsf ���� 2�������� �ٲ��ֱ�
[a,b,c]=size(VV2);
Y=reshape(VV2,a*b,c);

%lsf 
for i=1:size(Y,1)
[tidestruc2,xout2]=lsf(TT2,Y(i,:),['M2'; 'M4']);
zanv(i,:)=Y(i,:)-xout2;
end

%������ 3�������� ��ȯ
zanuu=reshape(zanu,31,80,13);
zanvv=reshape(zanv,31,80,13);


%�������
for i=1:N
figure(i)
load(list(i).name);
meanU=mean(zanuu(:,:,i),1);
meanV=mean(zanvv(:,:,i),1);
X=LatLon(:,2)';
Y=LatLon(:,1)';
[ggb,cmap,R] = geotiffread('�ϱ���2_�����.tif');
mapshow(ggb,cmap);
xlim([126.59 126.605])
% ylim([37.495 37.5])
hold on
h1 = quiver(X,Y,meanU,meanV,5,'ShowArrowHead','off','color','r')
title(['������� ',num2str(i)])
end
%ǥ�����
for i=1:N
figure(i+13)
load(list(i).name);
meanU=mean(Ucomp(1:10,:),1);
meanV=mean(Vcomp(1:10,:),1);
X=LatLon(:,2)';
Y=LatLon(:,1)';
[ggb,cmap,R] = geotiffread('�ϱ���2_�����.tif');
mapshow(ggb,cmap);
xlim([126.59 126.605])
% ylim([37.495 37.5])
hold on
h1 = quiver(X,Y,meanU,meanV,5,'ShowArrowHead','off','color','r')
title(['ǥ����� ',num2str(i)])
end

%�������
for i=1:N
figure(i+26)
load(list(i).name);
meanU=mean(Ucomp(11:20,:),1);
meanV=mean(Vcomp(11:20,:),1);
X=LatLon(:,2)';
Y=LatLon(:,1)';
[ggb,cmap,R] = geotiffread('�ϱ���2_�����.tif');
mapshow(ggb,cmap);
xlim([126.59 126.605])
% ylim([37.495 37.5])
hold on
h1 = quiver(X,Y,meanU,meanV,5,'ShowArrowHead','off','color','r')
title(['������� ',num2str(i)])
end

%�������
for i=1:N
figure(i+39)
load(list(i).name);
meanU=mean(Ucomp(21:30,:),1);
meanV=mean(Vcomp(21:30,:),1);
X=LatLon(:,2)';
Y=LatLon(:,1)';
[ggb,cmap,R] = geotiffread('�ϱ���2_�����.tif');
mapshow(ggb,cmap);
xlim([126.59 126.605])
% ylim([37.495 37.5])
hold on
h1 = quiver(X,Y,meanU,meanV,5,'ShowArrowHead','off','color','r')
title(['������� ',num2str(i)])
end

