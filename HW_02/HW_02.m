%% 
%%%%%%% This Code used compare Verification make data with %%%%%%%
%%%%%%% Model River in  date WAMIS                         %%%%%%%
%%%%%%% and Meteoric Compare Data KMA           
%%%%%%% Running at Windows Environment                     %%%%%%%
%%%%%%% Made by Jae Yoon Choi INHA.UN                      %%%%%%%
%%%%%%% starchaseryooni@gmail.com                          %%%%%%%
clc; clear all; close all;

%% File Open Declaration _ River in
filelist = dir(['datasat/02_Riverin/*.xls']);
Riv_name=[filelist.folder,'\',filelist.name];
Riverin = xlsread(Riv_name); disp('Import Riv Data')
Riverin(:,1) = [];
Rsdate=datetime(2019,01,01); Redate=datetime(2019,12,31);
Rivdate=linspace(Rsdate,Redate,365)'; clear Rsdate Redate;
lineRiverin=reshape(Riverin,numel(Riverin),1);delnan_lineRiverin = rmmissing(lineRiverin); clear lineRiverin Riverin
bar(Rivdate,delnan_lineRiverin)
startDate=Rivdate(1,1);
endDate=Rivdate(end,1);
xticks(linspace(startDate,endDate,30));
yticks(0:50:max(delnan_lineRiverin))
datetick('x','mm/dd','keepticks')
title('Han Rivar discharge(m^{3}/s)','Fontsize',15,'Fontname','Arial')
xlabel('time in 2019(mm/dd)','fontsize',15,'Fontname','Arial')
ylabel('Rivar discharge(m^{3}/s)','fontsize',15,'Fontname','Arial')
grid on


%% File Open Declaration _ Meteoric
clc; clear all; close all;
Year = [2019];
Meteorlist = dir(['datasat/03_Meteoric/*.csv']);
Met_name = [Meteorlist(1).folder,'\',Meteorlist(1).name];
data=readtable(Met_name);
time=data(:,2);
time=table2array(time);
datenum=datenum(time);
speed=data(:,3);
speed=table2array(speed);
deg=data(:,4);
deg=table2array(deg);
deg=270*ones(size(deg))-deg;
a=find(deg<0);
deg(a)=-deg(a);


subplot(3,1,1)
plot(datenum,deg,'.','markersize',3)
startDate=datenum(1,1);
endDate=datenum(end,1);
xticks(linspace(startDate,endDate,30))
yticks(0:50:max(deg))
datetick('x','mm/dd','keepticks')
title('2019 East Sea Bouy year wind degree','Fontsize',15,'fontname','Arial')
xlabel('time in 2019(mm/dd)','fontsize',15)
ylabel('wind direction(degree)','fontsize',15)
grid on

subplot(3,1,2)
plot(datenum,speed,'k','linewidth',1)
xticks(linspace(startDate,endDate,30))
yticks(0:2:max(speed))
datetick('x','mm/dd','keepticks')
title('2019 East Sea Bouy year wind speed(m/s)','fontsize',15,'fontname','Arial')
xlabel('time in 2019(mm/dd)','fontsize',15,'Fontname','Arial')
ylabel('wind speed(m/s)','fontsize',15,'Fontname','Arial')
grid on

subplot(3,1,3)
Y = zeros(size(datenum));
U = speed.*cosd(deg);
V = speed.*sind(deg);
h1 = quiver(datenum,Y,U,V,'autoscale','on','ShowArrowHead','off','color','r')
xticks(linspace(startDate,endDate,30))
datetick('x','mm/dd','keepticks')
title('2019 East Sea Bouy year wind vector','Fontsize',15,'Fontname','Arial')
xlabel('time in 2019(mm/dd)','fontsize',15,'Fontname','Arial')
grid on