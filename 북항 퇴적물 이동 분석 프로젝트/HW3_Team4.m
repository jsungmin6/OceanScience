clc; clear all; close all;

addpath('function')

cd 18M_W02

load('Step5_Ucomp.mat');
load('Step5_Vcomp.mat');
load('Step5_ZDepth.mat');
load('Step5_ZTime.mat');

%% sigma depth

A = linspace(1,0,16);

for i=1:3973;
a = find(isnan(Step5_Ucomp(:,i))==1);
b = find(isnan(Step5_Vcomp(:,i))==1);
M = nnz(a(:,1));
N = nnz(b(:,1));

if M==16 & N==16
   u(1:16,i)=[0];
   v(1:16,i)=[0];
   m=0; n=0;
else M~=16 & N~=16
    u(1:16,i)=Step5_Ucomp(:,i);
    v(1:16,i)=Step5_Vcomp(:,i);
    m=M; n=N;
end

c = u(:,i);
d = v(:,i);
B1 = c(1:16-m);
B2 = d(1:16-n);
C1 = linspace(1,0,16-m);
C2 = linspace(1,0,16-n);

sigma_U(:,i)=interp1(C1,B1,A);
sigma_V(:,i)=interp1(C2,B2,A);
end

% ³¯Â¥ È®ÀÎ
DDDD=datetime(MX,'ConvertFrom','datenum');

%% Mag, mean( Mag, U, V )

for j=1:3973;
Mag(:,j)= (sigma_U(:,j).^2 + sigma_V(:,j).^2).^ (1/2);

mean_U(j)= mean(sigma_U(:,j));
mean_V(j)= mean(sigma_V(:,j));
mean_Mag(j)=mean(Mag(:,j));
end

%% Ãþ ³ª´©±â

for k=1:3973;

mean_Us(k)=mean(sigma_U(3:5,k)); % us = uº¤ÅÍ surface
mean_Vs(k)=mean(sigma_V(3:5,k));
mean_Ms(k)=mean(Mag(3:5,k));

mean_Um(k)=mean(sigma_U(7:9,k)); % um = uº¤ÅÍ middle
mean_Vm(k)=mean(sigma_V(7:9,k));
mean_Mm(k)=mean(Mag(7:9,k));

mean_Ub(k)=mean(sigma_U(12:14,k)); % ub = uº¤ÅÍ bottom
mean_Vb(k)=mean(sigma_V(12:14,k));
mean_Mb(k)=mean(Mag(12:14,k));
end

%% ¼öÃþº° À¯¼Ó Mag

figure;
subplot(3,1,1);
plot(MX(1,:),mean_Ms,'k');
datetick('x',6,'keepticks')
ylabel('surface');
title('Magnitude')
ylim([0 0.5]); xlim([MX(1,1)-0.28 MX(1,3950)])
grid on;

subplot(3,1,2);
plot(MX(1,:),mean_Mm,'k');
datetick('x',6,'keepticks')
ylabel('middle');
ylim([0 0.5]); xlim([MX(1,1)-0.28 MX(1,3950)])
grid on;

subplot(3,1,3);
plot(MX(1,:),mean_Mb,'k');
datetick('x',6,'keepticks')
ylabel('bottom');
ylim([0 0.5]); xlim([MX(1,1)-0.28 MX(1,3950)])
grid on;
set(gcf,'units','normalized','outerposition',[0 0 1 1]);
saveas(gcf,'figure01.png');
%% ¼öÃþº° À¯¼Ó U

figure
subplot(3,1,1);
plot(horzcat(MX(1,1)-0.28,MX(1,:)),zeros(size(horzcat(MX(1,1)-0.28,MX(1,:)))),'r','LineWidth',1)
hold on
plot(MX(1,:),mean_Us,'k');
datetick('x',6,'keepticks')
ylim([-0.5 0.5]); xlim([MX(1,1)-0.28 MX(1,3950)])
ylabel('surface');
grid on;
title('U')

subplot(3,1,2);
plot(horzcat(MX(1,1)-0.28,MX(1,:)),zeros(size(horzcat(MX(1,1)-0.28,MX(1,:)))),'r','LineWidth',1)
hold on
plot(MX(1,:),mean_Um,'k');
datetick('x',6,'keepticks')
ylim([-0.5 0.5]); xlim([MX(1,1)-0.28 MX(1,3950)])
ylabel('middle');
grid on;

subplot(3,1,3);
plot(horzcat(MX(1,1)-0.28,MX(1,:)),zeros(size(horzcat(MX(1,1)-0.28,MX(1,:)))),'r','LineWidth',1)
hold on
plot(MX(1,:),mean_Ub,'k');
datetick('x',6,'keepticks')
ylim([-0.5 0.5]); xlim([MX(1,1)-0.28 MX(1,3950)])
ylabel('bottom');
grid on;
set(gcf,'units','normalized','outerposition',[0 0 1 1]);
saveas(gcf,'figure02.png');
%% ¼öÃþº° À¯¼Ó V

figure
subplot(3,1,1);
plot(horzcat(MX(1,1)-0.28,MX(1,:)),zeros(size(horzcat(MX(1,1)-0.28,MX(1,:)))),'r','LineWidth',1)
hold on
plot(MX(1,:),mean_Vs,'k');
datetick('x',6,'keepticks')
ylim([-0.5 0.5]); xlim([MX(1,1)-0.28 MX(1,3950)])
ylabel('surface');
grid on;
title('V')

subplot(3,1,2);
plot(horzcat(MX(1,1)-0.28,MX(1,:)),zeros(size(horzcat(MX(1,1)-0.28,MX(1,:)))),'r','LineWidth',1)
hold on
plot(MX(1,:),mean_Vm,'k');
datetick('x',6,'keepticks')
ylim([-0.5 0.5]); xlim([MX(1,1)-0.28 MX(1,3950)])
ylabel('middle');
grid on;

subplot(3,1,3);
plot(horzcat(MX(1,1)-0.28,MX(1,:)),zeros(size(horzcat(MX(1,1)-0.28,MX(1,:)))),'r','LineWidth',1)
hold on
plot(MX(1,:),mean_Vb,'k');
datetick('x',6,'keepticks')
ylim([-0.5 0.5]); xlim([MX(1,1)-0.28 MX(1,3950)])
ylabel('bottom');
set(gcf,'units','normalized','outerposition',[0 0 1 1]);
saveas(gcf,'figure03.png');


cd ../.


%% ÀÜÂ÷·ù ¹æÇâ

% lanczosfilter
Lan1=lanczosfilter(mean_U,1/6,1/48,[300],'low');
Lan2=lanczosfilter(mean_V,1/6,1/48,[300],'low');
Lan3=lanczosfilter(mean_Us,1/6,1/48,[300],'low');
Lan4=lanczosfilter(mean_Vs,1/6,1/48,[300],'low');
Lan5=lanczosfilter(mean_Um,1/6,1/48,[300],'low');
Lan6=lanczosfilter(mean_Vm,1/6,1/48,[300],'low');
Lan7=lanczosfilter(mean_Ub,1/6,1/48,[300],'low');
Lan8=lanczosfilter(mean_Vb,1/6,1/48,[300],'low');

vector=zeros(8,3973);
for i=1:3973
    vector(1,i+1)=vector(1,i)+mean_U(i)*600/1000;
    vector(2,i+1)=vector(2,i)+mean_V(i)*600/1000;
    vector(3,i+1)=vector(3,i)+mean_Us(i)*600/1000;
    vector(4,i+1)=vector(4,i)+mean_Vs(i)*600/1000;
    vector(5,i+1)=vector(5,i)+mean_Um(i)*600/1000;
    vector(6,i+1)=vector(6,i)+mean_Vm(i)*600/1000;
    vector(7,i+1)=vector(7,i)+mean_Ub(i)*600/1000;
    vector(8,i+1)=vector(8,i)+mean_Vb(i)*600/1000;
end

cd 18M_W02

figure;
subplot(1,2,1)
plot(vector(1,:),vector(2,:),'k');
set(gcf,'units','normalized','outerposition',[0 0 1 1]);
axis([-30 10 -50 10]);
xticks([-30 -20 -10 0 10]);
yticks([-50 -40 -30 -20 -10 0 10]);
xlabel('East-West (km)'); ylabel('North-South (km)'); title('progressive vector (mean)','fontsize',18);
grid on;

subplot(1,2,2)
plot(vector(3,:),vector(4,:),'b');
hold on; grid on;
plot(vector(5,:),vector(6,:),'k');
plot(vector(7,:),vector(8,:),'r');
axis([-30 10 -50 10]);
xticks([-30 -20 -10 0 10]);
yticks([-50 -40 -30 -20 -10 0 10]);
xlabel('East-West (km)'); ylabel('North-South (km)');  title('progressive vector (level)','fontsize',18);
set(gcf,'units','normalized','outerposition',[0 0 1 1]); 
legend('surface','middle','bottom');
saveas(gcf,'figure04.png');


%% scatter plot
clear i
[theta_p1,maj_1,min_1,wr_1]=princax(mean_U+i*mean_V);
[theta_p2,maj_2,min_2,wr_2]=princax(mean_Us+i*mean_Vs);
[theta_p3,maj_3,min_3,wr_3]=princax(mean_Um+i*mean_Vm);
[theta_p4,maj_4,min_4,wr_4]=princax(mean_Ub+i*mean_Vb);

figure(14)
subplot(221)
plot(mean_U,mean_V,'.b');
hold on; grid on;
plot([-2 2],[-2*tan(theta_p1) 2*tan(theta_p1)],'k');
plot([2*tan(theta_p1) -2*tan(theta_p1)],[-2 2],'k--');
plot([-2 2],[0 0],'r');
plot([0 0],[-2 2],'r');
axis([-2 2 -2 2]); daspect([1 1 1]);
xticks([-2 -1.5 -1 -0.5 0 0.5 1 1.5 2]);
xlabel('U (m/s)'); ylabel('V (m/s)'); title('Scatter plot (mean)');

subplot(222)
plot(mean_Us,mean_Vs,'.b');
hold on; grid on;
plot([-2 2],[-2*tan(theta_p2) 2*tan(theta_p2)],'k');
plot([2*tan(theta_p2) -2*tan(theta_p2)],[-2 2],'k--');
plot([-2 2],[0 0],'r');
plot([0 0],[-2 2],'r');
axis([-2 2 -2 2]); daspect([1 1 1]);
xticks([-2 -1.5 -1 -0.5 0 0.5 1 1.5 2]);
xlabel('U (m/s)'); ylabel('V (m/s)'); title('Scatter plot (surface)');

subplot(223)
plot(mean_Um,mean_Vm,'.b');
hold on; grid on;
plot([-2 2],[-2*tan(theta_p3) 2*tan(theta_p3)],'k');
plot([2*tan(theta_p3) -2*tan(theta_p3)],[-2 2],'k--');
plot([-2 2],[0 0],'r');
plot([0 0],[-2 2],'r');
axis([-2 2 -2 2]); daspect([1 1 1]);
xticks([-2 -1.5 -1 -0.5 0 0.5 1 1.5 2]);
xlabel('U (m/s)'); ylabel('V (m/s)'); title('Scatter plot (middle)');

subplot(224)
plot(mean_Ub,mean_Vb,'.b');
hold on; grid on;
plot([-2 2],[-2*tan(theta_p4) 2*tan(theta_p4)],'k');
plot([2*tan(theta_p4) -2*tan(theta_p4)],[-2 2],'k--');
plot([-2 2],[0 0],'r');
plot([0 0],[-2 2],'r');
axis([-2 2 -2 2]); daspect([1 1 1]);
xticks([-2 -1.5 -1 -0.5 0 0.5 1 1.5 2]);
xlabel('U (m/s)'); ylabel('V (m/s)'); title('Scatter plot (bottom)');
set(gcf,'units','normalized','outerposition',[0 0 1 1]); daspect([1 1 1]);
saveas(gcf,'figure05.png');

% figure(15)
% subplot(221)
% plot(wr_1,'ok');
% hold on; grid on;
% plot(mean_U,mean_V,'.b');
% plot([-2 2],[0 0],'r');
% plot([0 0],[-2 2],'r');
% axis([-2 2 -2 2]); daspect([1 1 1]);
% xticks([-2 -1.5 -1 -0.5 0 0.5 1 1.5 2]);
% xlabel('U (m/s)'); ylabel('V (m/s)'); title('Fixed scatter plot in all');
% 
% subplot(222)
% plot(wr_2,'ok');
% hold on; grid on;
% plot(mean_Us,mean_Vs,'.b');
% plot([-2 2],[0 0],'r');
% plot([0 0],[-2 2],'r');
% axis([-2 2 -2 2]); daspect([1 1 1]);
% xticks([-2 -1.5 -1 -0.5 0 0.5 1 1.5 2]);
% xlabel('U (m/s)'); ylabel('V (m/s)'); title('Fixed scatter plot in surface');
% 
% subplot(223)
% plot(wr_3,'ok');
% hold on; grid on;
% plot(mean_Um,mean_Vm,'.b');
% plot([-2 2],[0 0],'r');
% plot([0 0],[-2 2],'r');
% axis([-2 2 -2 2]); daspect([1 1 1]);
% xticks([-2 -1.5 -1 -0.5 0 0.5 1 1.5 2]);
% xlabel('U (m/s)'); ylabel('V (m/s)'); title('Fixed scatter plot in middle');
% 
% subplot(224)
% plot(wr_4,'ok');
% hold on; grid on;
% plot(mean_Ub,mean_Vb,'.b');
% plot([-2 2],[0 0],'r');
% plot([0 0],[-2 2],'r');
% axis([-2 2 -2 2]); daspect([1 1 1]);
% xticks([-2 -1.5 -1 -0.5 0 0.5 1 1.5 2]);
% xlabel('U (m/s)'); ylabel('V (m/s)'); title('Fixed scatter plot in bottom');
% set(gcf,'units','normalized','outerposition',[0 0 1 1]); daspect([1 1 1]);

cd ../.

%% 

