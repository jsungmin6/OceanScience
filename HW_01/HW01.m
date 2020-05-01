clc; clear all; close all;

%dataset 이라는 폴더에서 txt 이름이 붙은 파일을 불러들임
filelist = dir(['dataset/*.txt']);
%불어들인 txt파일의 수를 filenumber 변수에 저장
filenumber=length(filelist);

%txt파일을 1개씩 꺼내서 읽기
for i=1:filenumber
    %파일의 경로를 tide_name에 저장
    tide_name=[filelist(i).folder,'\',filelist(i).name];
    %파일경로를 fopen을 통해 열고 파일을 fileid에 저장
    fileid = fopen(tide_name);
    %textscan을 통해 fileid를 읽어들임
    A = textscan(fileid,'%d %d %d %d %*d %d','headerlines',5);
    %파일 내용을 한 열씩 읽어 분할해 저장
    year = A{:,1};  month = A{:,2}; day = A{:,3}; hour = A{:,4}; tide = A{:,5};
    %datetime을 생성
    mydatetime = datetime(year,month,day,hour,00,00);
    %datetime sort를 위해 DateNumber 로 변환
    DateNumber=datenum(mydatetime);
    %DateNumber와 tide를 한 matrix로 만듬. 한꺼번에 sort하기 위함.
    %두개의 자료형이 다르면 DateNumber가 자동으로 int로 변환되기에 tide를 미리 double형으로 바꿔줌
    DateNumber_tide_matrix=cat(2, DateNumber,double(tide));
    %sortrows 를 통해 datetime 기준으로 행렬을 sorting함
    sort_datetime_tide_matrix = sortrows(DateNumber_tide_matrix);
    %tide와 datenum을 다시 쪼개고 datenum을 datetime으로 변환
    sort_datetime = datetime(sort_datetime_tide_matrix(:,1),'ConvertFrom','datenum');
    sort_tide=sort_datetime_tide_matrix(:,2);
    %plot
    figure(i);
    plot(sort_datetime,sort_tide)
    hold on
    %제목을 filelist(i).name을 이용해 자동생성
    %erase : string 내 불필요한 문자 제거
    %extractBefore : 기준문자 앞만 출력 txt는 불필요 하기에 제거햇다.
    title(extractBefore(erase(filelist(i).name,"_"),".txt"))
    
    %피크 데이터 찾기
    [pks,locs,w,p] = findpeaks(sort_tide);
    TF = islocalmin(sort_tide);
    %치솟은 지점
    Top_Peak_Tide=pks;
    %낮은 지점
    Low_Peak_Tide=sort_tide(TF);

    Alldiff=Top_Peak_Tide-Low_Peak_Tide;
    
    %최소 최대 평균 저장
    maximum_tide_range=max(Alldiff);
    minimum_tide_range=min(Alldiff);
    mean_tide_range=mean(Alldiff);
    
    %textbox 생성
    dim = [0.15 0.15 0.175 0.165];
    str = {['Max : ',num2str(maximum_tide_range)],['Min : ',num2str(minimum_tide_range)],['Mean : ',num2str(mean_tide_range)]};
    annotation('textbox',dim,'String',str,'FitBoxToText','on','Color','red');
    
    
    %for문을 통해 같은 변수를 사용하면 index error가 날 수 있으므로 다시 reset 해준다.
    clear 'year' 'month' 'day' 'hour' 'A' 'filed' 'tidename' 'mydatetime' 'DateNumber' 'DateNumber_tide_matrix' 'sort_datetime_tide_matrix' 'sort_datetime' 'sort_tide'
end


