clc; close all; clear all;

%CTD turbidity ���ϱ�
for n=1:13
for i=1+7*(n-1):3+7*(n-1);
[YEAR{i} MONTH{i} DAY{i} HOUR{i} MIN{i} SEC{i} DEPTH{i} SALT{i} TURB{i}]=textread(['CAST0',num2str(i),'_CUT.dat'],'%f %f %f %f %f %f %f %*f %f %f','headerlines',1,'delimiter','\b');
N{i}=datenum(YEAR{i},MONTH{i},DAY{i},HOUR{i},MIN{i},SEC{i});
L(i)=length(N{i});
l=max(L);
end

for j=1+7*(n-1):3+7*(n-1);
if L(1,j)~=70
    Jday(L(1,j)+1:70,j)=nan;
    Jday(1:L(1,j),j)=N{j};
    Depth(L(1,j)+1:70,j)=nan;
    Depth(1:L(1,j),j)=DEPTH{j};
    Salt(L(1,j)+1:70,j)=nan;
    Salt(1:L(1,j),j)=SALT{j};
    Turb(L(1,j)+1:70,j)=nan;
    Turb(1:L(1,j),j)=TURB{j};

else L(1,j)==70
    Depth(:,j)=DEPTH{j};
    Salt(:,j)=SALT{j};
    Turb(:,j)=TURB{j};
    end
end

for o=1:70
    c=linspace(1,3,3);
    C(o,:)=c;
end
D=Depth(:,1+7*(n-1):3+7*(n-1));
S=Salt(:,1+7*(n-1):3+7*(n-1));
T(:,:,n)=Turb(:,1+7*(n-1):3+7*(n-1));
end
% T 31x80 ���� �����
for z=1:13
    T2=T(:,:,z)
for i=1:size(T2,2)
    t=T2(:,i);
    a=find(isnan(t)==1);
    t(a)=[];
    interpT(:,i) =interp1(linspace(1,length(t),length(t)),t,linspace(1,length(t),31));
end
T3(:,:,z)=interpT
end

for z=1:13
    T4=T3(:,:,z)
for i=1:size(T4,1)
    t2=T4(i,:);
    T5(i,:) =interp1(linspace(1,length(t2),length(t2)),t2,linspace(1,length(t2),80));
end
T6(:,:,z)=T5
end


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

%Discharge
lon=LatLon(:,1);
lat=LatLon(:,2);
Timetitle=datestr(datetime(Time,'convertfrom','datenum'),'yy-mm-dd-hh');
[x,y,utmzone] = deg2utm(LatLon(:,1),LatLon(:,2));
maxlat=max(x);
minlat=min(x);
maxlon=max(y);
minlon=min(y);

a=maxlat-minlat;
b=maxlon-minlon;
c=b/a
Y = atand(c)%��ź��Ʈ �̿� ��Ÿ���(reference line ����)

%���� ������ �������� ������ֱ�
for w=1:13
    zanuu2=zanuu(:,:,w);
    zanvv2=zanvv(:,:,w);
for k=1:31
U=zanuu2(k,:);
V=zanvv2(k,:);

D = atan2d(U,V);%����
r=sqrt(U.^2+V.^2);%ũ��

for i=1:80%�� ��ȯ
Xk(i,:)=r(i).*cosd(D(i)-Y);
Yk(i,:)=r(i).*sind(D(i)-Y);
end

for i=1:80;
v = [0 Yk(i,:)];
theta = -Y;
R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];
vR(i,:) = v*R;
end
index=find(vR(:,2)<0)';%-���� ����ó��
Speed(k,:)=sqrt(vR(:,1).^2+vR(:,2).^2);
Speed(k,index)=-Speed(k,index);
end

g=(sqrt((maxlat-minlat).^2+(maxlon-minlon).^2))/80;%line ���� 80���
h=mean(diff(depth));%31��б��� ��հ���
in=g*h;%1��ũ����� discharge
grid=in.*ones(31,80);% Speed�� ũ�� �����ֱ�
Discharge=grid.*Speed.*T6(:,:,w);% �ӷ�xũ��xTurbinity ->������ Discharge
Alldischarge=sum(Discharge,'omitnan');%nan�� �����ϰ� �� ���
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
% enddate=datenum([2019 2 13 19 0 0]);
startdate=min(Discharge_Time);
xticks(linspace(startdate,enddate,13));
datetick('x','hh','keepticks')

%�ð���
for i=1:size(a,2)
c.CData(a(i),:) = [0 0 1];
end
for i=1:size(b,2)
c.CData(b(i),:) = [1 0 0];
end
xlabel('Time(hour)')
ylabel('Discharge(m^3/s)')
title('Turbidity discharge in spring tide')

for i=1:size(a,2)
c.CData(a(i),:) = [0 0 1];
end
for i=1:size(b,2)
c.CData(b(i),:) = [1 0 0];
end



