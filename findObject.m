% clc
% clear all
% close all
load finalMdl

scoreThreshold=1.8;%初步过滤阈值
overlap=0.3;       %非极大值抑制阈值

%% find nerve
windowSize=127;
stepLength=10;
cellSize=8;
blockSize=4;

[PathRoot_Find,imgNameList_Find,imgNum_Find]=readFile;
index_dir=strfind(PathRoot_Find,'\');

SavePathRoot=PathRoot_Find(1:index_dir(end)-1);
SavePathRoot_Find=[SavePathRoot,'\nmsfindResult_',PathRoot_Find(index_dir(end)+1:end),'\'];

mkdir(SavePathRoot_Find);


for Num=1:imgNum_Find
    imgName_Find=[PathRoot_Find,'\',imgNameList_Find{Num}];
    img_Find=imread(imgName_Find);
    img_Find=rgb2gray(img_Find);
    [Height,Width]=size(img_Find);
    
    window=zeros(100,4);
    score=zeros(100);
    count=0;
    
    for h=1:stepLength:(Height-windowSize)
        
        for w=1:stepLength:(Width-windowSize)
            
            img_Find_Win=imcrop(img_Find,[w,h,windowSize,windowSize]);
            hogFeatures_Find_Win=extractHOGFeatures(img_Find_Win,'CellSize',[cellSize,cellSize],'BlockSize',[blockSize,blockSize]);
            [class_Find,score_Find]=predict(finalMdl,hogFeatures_Find_Win);
            
            if class_Find==1&&score_Find(2)>scoreThreshold
                count=count+1;
                window(count,:)=[w,h,windowSize,windowSize];
                score(count)=score_Find(2);
                %img_Find_Win=insertShape(img_Find,'Rectangle',window);
            end
                
        end
        
    end
    %% 非极大值抑制
    %winSize=size(window(:,1));
    boxes=zeros(count,5);
    boxes(:,1)=window(1:count,1);
    boxes(:,2)=window(1:count,2);
    boxes(:,3)=window(1:count,1)+window(1:count,3);
    boxes(:,4)=window(1:count,2)+window(1:count,4);
    boxes(:,5)=score(1:count);
    
%     overlap=0.3;% 重叠阈值
    selected=nms(boxes,overlap);
    selectedboxes=boxes(selected,:);
    selectedboxesNum=length(selectedboxes(:,1));
    selectedwindow=zeros(selectedboxesNum,4);
    
    selectedwindow(:,1)=selectedboxes(:,1);
    selectedwindow(:,2)=selectedboxes(:,2);
    selectedwindow(:,3)=selectedboxes(:,3)-selectedboxes(:,1);
    selectedwindow(:,4)=selectedboxes(:,4)-selectedboxes(:,2);
    
    
    
    
    
    %CenterWindow=round((sum(window))/count);
    %img_Find=insertShape(img_Find,'Rectangle',window);
    
    img_Find=insertShape(img_Find,'Rectangle',selectedwindow,'Color','red');
    position=selectedwindow(:,1:2);
    text='Nerve!!!!!!!!!!!!!!!^o^';
    img_Find=insertText(img_Find,position,text);
    
    %img_Find=insertShape(img_Find,'Rectangle',CenterWindow,'Color','red');
%     figure
%     imshow(img_Find);
    imwrite(img_Find,[SavePathRoot_Find,'\Find_',imgNameList_Find{Num}])
    
    
    
    
end