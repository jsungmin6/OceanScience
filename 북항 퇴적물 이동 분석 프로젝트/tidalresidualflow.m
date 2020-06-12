clc; clear all; close all;

%ÀÜÂ÷·ù À¯¼Ó º¤ÅÍµµ
load('ADCP_data_1.mat');

vh=mean(Vcomp(1:10,:)*(1000/600),1);
vm=mean(Vcomp(11:20,:)*(1000/600),1);
vl=mean(Vcomp(21:30,:)*(1000/600),1);
% time=diff(flip(Time));
% time=datevec(time)
% time=time(:,6)';
% T=cumsum(time);
% mean=mean(time);
% time=cat(2,mean,time);
% a=time.*vh;
% b=cumsum(a);
% zero2=zeros(1);
% V=cat(2,zero2,b);
% T=cat(2,zero2,T);
% plot(T,V);
zero2=zeros(1);
Vh=cumsum(vh);
Vm=cumsum(vm);
Vl=cumsum(vl);
% Vh=cat(2,zero2,Vh);
Vm=cat(2,zero2,Vm);
Vl=cat(2,zero2,Vl);

plot(Time,Vh,'k','linewidth',1);
datetick('x')
grid on
xlabel('East-West(km)')
ylabel('North-South(km)')
