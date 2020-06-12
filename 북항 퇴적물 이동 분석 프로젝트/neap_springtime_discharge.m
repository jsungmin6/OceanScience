clc; clear all; close all;
clc; clear all; close all;
format short

% reference line 수직방향 discharge

list=dir('*(4조).mat')
N=length(list)
for w=1:N
load(list(w).name);
lon=LatLon(:,1);
lat=LatLon(:,2);
Timetitle=datestr(datetime(Time,'convertfrom','datenum'),'yy-mm-dd-hh');
[x,y,utmzone] = deg2utm(LatLon(:,1),LatLon(:,2));
maxlat=max(x);
minlat=min(x);
maxlon=max(y);
minlon=min(y);

a=maxlat-minlat
b=maxlon-minlon
c=b/a
Y = atand(c)%역탄젠트 이용 쎄타계산(reference line 각도)

for k=1:31
U=Ucomp(k,:);
V=Vcomp(k,:);

D = atan2d(U,V);%알파
r=sqrt(U.^2+V.^2);%크기

for i=1:80%축 변환
Xk(i,:)=r(i).*cosd(D(i)-Y);
Yk(i,:)=r(i).*sind(D(i)-Y);
end

for i=1:80;
v = [0 Yk(i,:)];
theta = -Y;
R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];
vR(i,:) = v*R;
end
index=find(vR(:,2)<0)';%-방향 음수처리
Speed(k,:)=sqrt(vR(:,1).^2+vR(:,2).^2);
Speed(k,index)=-Speed(k,index);
end

g=(sqrt((maxlat-minlat).^2+(maxlon-minlon).^2))/80;%line 길이 80등분
h=mean(diff(depth));%31등분깊이 평균간격
in=g*h;%1개크기분의 discharge
grid1=in.*ones(31,80);% Speed와 크기 맞춰주기
Discharge=grid1.*Speed;% 속력x크기 ->Discharge
Alldischarge=sum(Discharge,'omitnan');%nan값 제외하고 합 계산
dischargesave(1,w)=sum(Alldischarge);
end
last=sum(dischargesave);
for w=1:N
load(list(w).name);
Discharge_Time(w)=datenum(Time(:,40));
end
tam=Discharge_Time(1,2:5);
Discharge_Time(2:5)=[]
Discharge_Time=horzcat(Discharge_Time,tam);

tam=dischargesave(1,2:5);
dischargesave(2:5)=[]
dischargesave=horzcat(dischargesave,tam);

timecheck=datevec(Discharge_Time);

a=find(dischargesave<0);
b=find(dischargesave>0);
subplot(2,1,1)
c=bar(Discharge_Time,dischargesave,'FaceColor','flat');
enddate=max(Discharge_Time);
startdate=min(Discharge_Time);
xticks(linspace(startdate,enddate,13));
datetick('x','hh','keepticks')
grid on

%시간별
for i=1:size(a,2)
c.CData(a(i),:) = [0 0 1];
end
for i=1:size(b,2)
c.CData(b(i),:) = [1 0 0];
end
xlabel('Time(hh)')
ylabel('Discharge(m^3/s)')
title('Discharge and elevation in spring tide 2019/2/13','fontsize',12)

for i=1:size(a,2)
c.CData(a(i),:) = [0 0 1];
end
for i=1:size(b,2)
c.CData(b(i),:) = [1 0 0];
end


data=readtable('인천_관측자료_2019-02-13.txt');
time=datenum(table2array(data(:,1)));
Ele=0.01.*table2array(data(:,2));
datevec(time);
start=datenum([2019,2,13,7,0,0])
finish=datenum([2019,2,13,18,0,0])
subplot(2,1,2)
plot(time,Ele);
xlim([start finish]);
xticks(linspace(start,finish,12));
datetick('x','hh','keepticks')
grid on
xlabel('Time(hh)')
ylabel('elevation(m)')