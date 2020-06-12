clc; clear all; close all;
[ggb,cmap,R] = geotiffread('하구역2_변경됨.tif');
list4=dir('*(4조).mat');
N4=length(list4);

list1=dir('*(1조).mat');
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

Y = atand(c);%역탄젠트 이용 쎄타계산(reference line 각도)
D = atan2d(meanV,meanU);%알파(각 좌표의 각도)
r = sqrt(meanV.^2+meanU.^2);%크기

for i=1:80 %축의 회전 -> 회전한 좌표 구하기(회전한후의 수직방향 크기가 원본과 달라지기 때문에 해줘야 하는 과정)
Xk1(i,:) = r(i).*cosd(D(i)-Y);
Yk1(i,:) = r(i).*sind(D(i)-Y);
end
r2=sqrt(Yk1.^2+Xk1.^2);%좌표변환후 크기 같은거 확인(같음)

%변환좌표 reference line 각도만큼 회전, 변환된좌표 vR에 저장
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

Y = atand(c);%역탄젠트 이용 쎄타계산(reference line 각도)
D = atan2d(meanV,meanU);%알파(각 좌표의 각도)
r = sqrt(meanV.^2+meanU.^2);%크기

for i=1:80 %축의 회전 -> 회전한 좌표 구하기(회전한후의 수직방향 크기가 원본과 달라지기 때문에 해줘야 하는 과정)
Xk4(i,:) = r(i).*cosd(D(i)-Y);
Yk4(i,:) = r(i).*sind(D(i)-Y);
end
r2=sqrt(Yk4.^2+Xk4.^2);%좌표변환후 크기 같은거 확인(같음)

%변환좌표 reference line 각도만큼 회전, 변환된좌표 vR에 저장
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