clc; clear all; close all;

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
T=Turb(:,1+7*(n-1):3+7*(n-1));

figure(n);
subplot(2,2,1);
contourf(C,D,S);
axis ij
colormap jet
colorbar
caxis([29 31]);
ylim([0 20]);
xlabel('Casting Number'); ylabel('Depth (m)'); title('Salinity');

subplot(2,2,2);
contourf(C,D,T);
axis ij
colormap jet
colorbar
caxis([0 10]);
ylim([0 20]);
xlabel('Casting Number'); ylabel('Depth (m)'); title('Turbidity (NTU)');

subplot(2,2,3:4);
fn='인천_관측자료_2019-02-13';
data=readtable(fn);
Ele1=table2array(data(:,2));
M2 = datenum(table2array(data(:,1)));

plot(M2,Ele1);
title('인천 조위 2019년 2월 13일 ')
enddate=max(M2);
startdate=min(M2);
xticks(linspace(startdate,enddate,24));
datetick('x','hh','keepticks')
J=Jday(1,1+7*(n-1):3+7*(n-1));
hold on
plot([J(1) J(1)],[100 700],'r');
plot([J(2) J(2)],[100 700],'r');
plot([J(3) J(3)],[100 700],'r');
grid on
xlabel('Time(hh)')
ylabel('elevation(cm)')
end

