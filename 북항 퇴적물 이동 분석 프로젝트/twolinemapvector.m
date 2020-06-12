clc; clear all; close all;
[ggb,cmap,R] = geotiffread('�ϱ���2_�����.tif');
list4=dir('*(4��).mat');
N4=length(list4);

list1=dir('*(1��).mat');
N1=length(list1);

for f=1:13
load(list1(f).name);
lon1=LatLon(:,1);
lat1=LatLon(:,2);
meanU=mean(Ucomp(20:30,:),1);
meanV=mean(Vcomp(20:30,:),1);
[x,y,utmzone] = deg2utm(LatLon(:,1),LatLon(:,2));
maxlat=max(x); minlat=min(x);
maxlon=max(y); minlon=min(y);
a=maxlat-minlat; b=maxlon-minlon; c=b/a;

Y = atand(c);%��ź��Ʈ �̿� ��Ÿ���(reference line ����)
D = atan2d(meanV,meanU);%����(�� ��ǥ�� ����)
r = sqrt(meanV.^2+meanU.^2);%ũ��

for i=1:80 %���� ȸ�� -> ȸ���� ��ǥ ���ϱ�(ȸ�������� �������� ũ�Ⱑ ������ �޶����� ������ ����� �ϴ� ����)
Xk1(i,:) = r(i).*cosd(D(i)-Y);
Yk1(i,:) = r(i).*sind(D(i)-Y);
end
r2=sqrt(Yk1.^2+Xk1.^2);%��ǥ��ȯ�� ũ�� ������ Ȯ��(����)

%��ȯ��ǥ reference line ������ŭ ȸ��, ��ȯ����ǥ vR�� ����
for i=1:80
v = [0 Yk1(i,:)];
theta = -Y;
R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];
vR1(i,:) = v*R;
end

load(list4(f).name);
lon4=LatLon(:,1); lat4=LatLon(:,2);
meanU=mean(Ucomp(20:30,:),1);
meanV=mean(Vcomp(20:30,:),1);
[x,y,utmzone] = deg2utm(LatLon(:,1),LatLon(:,2));
maxlat=max(x); minlat=min(x);
maxlon=max(y); minlon=min(y);
a=maxlat-minlat; b=maxlon-minlon; c=b/a;

Y = atand(c);%��ź��Ʈ �̿� ��Ÿ���(reference line ����)
D = atan2d(meanV,meanU);%����(�� ��ǥ�� ����)
r = sqrt(meanV.^2+meanU.^2);%ũ��

for i=1:80 %���� ȸ�� -> ȸ���� ��ǥ ���ϱ�(ȸ�������� �������� ũ�Ⱑ ������ �޶����� ������ ����� �ϴ� ����)
Xk4(i,:) = r(i).*cosd(D(i)-Y);
Yk4(i,:) = r(i).*sind(D(i)-Y);
end
r2=sqrt(Yk4.^2+Xk4.^2);%��ǥ��ȯ�� ũ�� ������ Ȯ��(����)

%��ȯ��ǥ reference line ������ŭ ȸ��, ��ȯ����ǥ vR�� ����
for i=1:80
v = [0 Yk4(i,:)];
theta = -Y;
R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];
vR4(i,:) = v*R;
end

figure(f)
mapshow(ggb,cmap);
hold on
plot(lat1,lon1,'k')
quiver(lat1,lon1,Xk1,Yk1,5);
quiver(lat1,lon1,vR1(:,1),vR1(:,2))
hold on
plot(lat4,lon4,'k')
quiver(lat4,lon4,Xk4,Yk4,5);
quiver(lat4,lon4,vR4(:,1),vR4(:,2))
text(126.6072,37.487,'0.5 m/s','color',[0.9 0.6 0.1],'fontsize',12);
title_d=datestr(datetime(Time,'convertfrom','datenum'),'yyyy/mm/dd/hh:MM:ss');
title(['Bottom Current speed vector '+string(title_d(40,:))],'fontsize',12);
xlim([126.585 126.61])
ylim([37.485 37.51])
set(gcf,'units','normalized','outerposition',[0 0 1 1]); daspect([1 1 1]);
% get(gca,'dataaspectratio')
end