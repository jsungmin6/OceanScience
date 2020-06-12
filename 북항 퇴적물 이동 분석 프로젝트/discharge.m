clc; clear all; close all;
format short

% reference line 수직방향 discharge

list=dir('ADCP*')
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
U=Ucomp(k,:)*0.01;
V=Vcomp(k,:)*0.01;

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
grid=in.*ones(31,80);% Speed와 크기 맞춰주기
Discharge=grid.*Speed;% 속력x크기 ->Discharge
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
c=bar(Discharge_Time,dischargesave,'FaceColor','flat');
enddate=max(Discharge_Time);
startdate=min(Discharge_Time);
xticks(linspace(startdate,enddate,13));
datetick('x','hh','keepticks')

%시간별
for i=1:size(a,2)
c.CData(a(i),:) = [0 0 1];
end
for i=1:size(b,2)
c.CData(b(i),:) = [1 0 0];
end
xlabel('Time(hh)')
ylabel('Discharge')

for i=1:size(a,2)
c.CData(a(i),:) = [0 0 1];
end
for i=1:size(b,2)
c.CData(b(i),:) = [1 0 0];
end