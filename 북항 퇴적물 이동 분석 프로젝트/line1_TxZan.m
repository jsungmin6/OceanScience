clc; close all; clear all;

clc; close all; clear all;
%소조기 turbidity x 잔차류수직벡터 x 면적 컨투어
%CTD turbidity 구하기
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
% T 31x80 형태 만들기
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



%잔차류 수정 -> 잔차류 x 면적 discharge
%잔차류 구하기
load('t_constituents.mat');
list=dir('*(4조).mat');
N=length(list);

for i=1:N
load(list(i).name);
Ucomp2(:,:,i)=Ucomp*0.01;
Vcomp2(:,:,i)=Vcomp*0.01;
Time2=Time(1,1)
Time3(i,1)=Time2
end
%Time과 유속 시간순 정렬
TT2=sort(Time3);

TT2 = TT2.*24 % 일단위를 시간단위로 바꿔주기

tam=Ucomp2(:,:,2:5);
Ucomp2(:,:,2:5)=[];
Ucomp2=cat(3,Ucomp2,tam);
UU2=Ucomp2;

tam=Vcomp2(:,:,2:5);
Vcomp2(:,:,2:5)=[];
Vcomp2=cat(3,Vcomp2,tam);
VV2=Vcomp2;

%lsf 위해 2차원으로 바꿔주기
[a,b,c]=size(UU2);
X=reshape(UU2,a*b,c);
fnan=find(isnan(X)==1);
X(fnan)=0;

%lsf
for i=1:size(X,1)
[tidestruc1,xout1]=lsf(TT2,X(i,:),['M2'; 'M4']);
zanu(i,:)=X(i,:)-xout1;
end

zanu(fnan)=NaN

%lsf 위해 2차원으로 바꿔주기
[a,b,c]=size(VV2);
Y=reshape(VV2,a*b,c);

fnan2=find(isnan(Y)==1);
Y(fnan2)=0;

%lsf 
for i=1:size(Y,1)
[tidestruc2,xout2]=lsf(TT2,Y(i,:),['M2'; 'M4']);
zanv(i,:)=Y(i,:)-xout2;
end

zanv(fnan2)=NaN

%잔차류 3차원으로 변환
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
Y = atand(c)%역탄젠트 이용 쎄타계산(reference line 각도)

%유속 정선에 직각으로 만들어주기
for w=1:13
    zanuu2=zanuu(:,:,w);
    zanvv2=zanvv(:,:,w);
for k=1:31
U=zanuu2(k,:);
V=zanvv2(k,:);

D = atan2d(U,V);%알파
r=sqrt(U.^2+V.^2);%크기

for i=1:80 %축 변환
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
Discharge=grid.*Speed.*T6(:,:,w);% 속력x크기xTurbinity ->부유물 Discharge
surface(1,w)=sum(sum(sum(Discharge(1:10,:,:),'omitnan')));
middle(1,w)=sum(sum(sum(Discharge(11:20,:,:),'omitnan')));
bottom(1,w)=sum(sum(sum(Discharge(21:30,:,:),'omitnan')));
Alldischarge=sum(sum(sum(Discharge,'omitnan')));%nan값 제외하고 합 계산
dischargesave(1,w)=sum(Alldischarge)
end
surf=sum(surface);
md=sum(middle);
bot=sum(bottom);
last=sum(dischargesave);

mdischarge=nanmean(Discharge,3);

h=pcolor(dist,depth,mdischarge);
axis ij
set(h, 'EdgeColor', 'none');
set ( gca, 'xdir', 'reverse' )
colormap([0 0 1;0.03125 0.03125 1;0.0625 0.0625 1;0.09375 0.09375 1;0.125 0.125 1;0.15625 0.15625 1;0.1875 0.1875 1;0.21875 0.21875 1;0.25 0.25 1;0.28125 0.28125 1;0.3125 0.3125 1;0.34375 0.34375 1;0.375 0.375 1;0.40625 0.40625 1;0.4375 0.4375 1;0.46875 0.46875 1;0.5 0.5 1;0.53125 0.53125 1;0.5625 0.5625 1;0.59375 0.59375 1;0.625 0.625 1;0.65625 0.65625 1;0.6875 0.6875 1;0.71875 0.71875 1;0.75 0.75 1;0.78125 0.78125 1;0.8125 0.8125 1;0.84375 0.84375 1;0.875 0.875 1;0.90625 0.90625 1;0.9375 0.9375 1;0.96875 0.96875 1;1 1 1;1 0.967741906642914 0.967741906642914;1 0.935483872890472 0.935483872890472;1 0.903225779533386 0.903225779533386;1 0.870967745780945 0.870967745780945;1 0.838709652423859 0.838709652423859;1 0.806451618671417 0.806451618671417;1 0.774193525314331 0.774193525314331;1 0.74193549156189 0.74193549156189;1 0.709677398204803 0.709677398204803;1 0.677419364452362 0.677419364452362;1 0.645161271095276 0.645161271095276;1 0.612903237342834 0.612903237342834;1 0.580645143985748 0.580645143985748;1 0.548387110233307 0.548387110233307;1 0.516129016876221 0.516129016876221;1 0.483870953321457 0.483870953321457;1 0.451612889766693 0.451612889766693;1 0.419354826211929 0.419354826211929;1 0.387096762657166 0.387096762657166;1 0.354838699102402 0.354838699102402;1 0.322580635547638 0.322580635547638;1 0.290322571992874 0.290322571992874;1 0.25806450843811 0.25806450843811;1 0.225806444883347 0.225806444883347;1 0.193548381328583 0.193548381328583;1 0.161290317773819 0.161290317773819;1 0.129032254219055 0.129032254219055;1 0.0967741906642914 0.0967741906642914;1 0.0645161271095276 0.0645161271095276;1 0.0322580635547638 0.0322580635547638;1 0 0]);

colorbar
caxis([-10 10])
hold on
plot(dist(1,:),depth(end,:),'k','linewidth',2)



