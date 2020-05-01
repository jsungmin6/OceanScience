clc; clear all; close all;

%dataset �̶�� �������� txt �̸��� ���� ������ �ҷ�����
filelist = dir(['dataset/*.txt']);
%�Ҿ���� txt������ ���� filenumber ������ ����
filenumber=length(filelist);

%txt������ 1���� ������ �б�
for i=1:filenumber
    %������ ��θ� tide_name�� ����
    tide_name=[filelist(i).folder,'\',filelist(i).name];
    %���ϰ�θ� fopen�� ���� ���� ������ fileid�� ����
    fileid = fopen(tide_name);
    %textscan�� ���� fileid�� �о����
    A = textscan(fileid,'%d %d %d %d %*d %d','headerlines',5);
    %���� ������ �� ���� �о� ������ ����
    year = A{:,1};  month = A{:,2}; day = A{:,3}; hour = A{:,4}; tide = A{:,5};
    %datetime�� ����
    mydatetime = datetime(year,month,day,hour,00,00);
    %datetime sort�� ���� DateNumber �� ��ȯ
    DateNumber=datenum(mydatetime);
    %DateNumber�� tide�� �� matrix�� ����. �Ѳ����� sort�ϱ� ����.
    %�ΰ��� �ڷ����� �ٸ��� DateNumber�� �ڵ����� int�� ��ȯ�Ǳ⿡ tide�� �̸� double������ �ٲ���
    DateNumber_tide_matrix=cat(2, DateNumber,double(tide));
    %sortrows �� ���� datetime �������� ����� sorting��
    sort_datetime_tide_matrix = sortrows(DateNumber_tide_matrix);
    %tide�� datenum�� �ٽ� �ɰ��� datenum�� datetime���� ��ȯ
    sort_datetime = datetime(sort_datetime_tide_matrix(:,1),'ConvertFrom','datenum');
    sort_tide=sort_datetime_tide_matrix(:,2);
    %plot
    figure(i);
    plot(sort_datetime,sort_tide)
    hold on
    %������ filelist(i).name�� �̿��� �ڵ�����
    %erase : string �� ���ʿ��� ���� ����
    %extractBefore : ���ع��� �ո� ��� txt�� ���ʿ� �ϱ⿡ �����޴�.
    title(extractBefore(erase(filelist(i).name,"_"),".txt"))
    
    %��ũ ������ ã��
    [pks,locs,w,p] = findpeaks(sort_tide);
    TF = islocalmin(sort_tide);
    %ġ���� ����
    Top_Peak_Tide=pks;
    %���� ����
    Low_Peak_Tide=sort_tide(TF);

    Alldiff=Top_Peak_Tide-Low_Peak_Tide;
    
    %�ּ� �ִ� ��� ����
    maximum_tide_range=max(Alldiff);
    minimum_tide_range=min(Alldiff);
    mean_tide_range=mean(Alldiff);
    
    %textbox ����
    dim = [0.15 0.15 0.175 0.165];
    str = {['Max : ',num2str(maximum_tide_range)],['Min : ',num2str(minimum_tide_range)],['Mean : ',num2str(mean_tide_range)]};
    annotation('textbox',dim,'String',str,'FitBoxToText','on','Color','red');
    
    
    %for���� ���� ���� ������ ����ϸ� index error�� �� �� �����Ƿ� �ٽ� reset ���ش�.
    clear 'year' 'month' 'day' 'hour' 'A' 'filed' 'tidename' 'mydatetime' 'DateNumber' 'DateNumber_tide_matrix' 'sort_datetime_tide_matrix' 'sort_datetime' 'sort_tide'
end


