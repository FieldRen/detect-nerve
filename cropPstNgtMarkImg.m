clc
clear all
close all

BoxSize=127;     %裁剪图片的尺寸
%BoxCenter=zeros(,2);

PathRoot_0=uigetdir;
PathRoot_1=uigetdir;
PathRoot_mark=uigetdir;

% PathRoot_1='MedicalData\07_mengmoumou\BP_L\1';           %读取文件的路径
% PathRoot_mark='MedicalData\07_mengmoumou\BP_L\mark';

index_dir=strfind(PathRoot_1,'\');

SavePathRoot=PathRoot_1(1:index_dir(end)-1);             %保存文件的路径

SavePathRoot_0=[SavePathRoot,'\NegativeImg_0\'];
SavePathRoot_1=[SavePathRoot,'\PositiveImg\'];
SavePathRoot_mark=[SavePathRoot,'\PositiveImg_mark\'];
SavePathRoot_1_neibor=[SavePathRoot,'\negativeImg_neibor\'];
SavePathRoot_1_overlap=[SavePathRoot,'\PositiveImg_overlap\'];

mkdir(SavePathRoot_0);
mkdir(SavePathRoot_1);
%SavePathRoot_1=[cd,[SavePathRoot,'\PositiveImg\']];
mkdir(SavePathRoot_mark);
%SavePathRoot_mark=[cd,[SavePathRoot,'\PositiveImg_mark\']];
mkdir(SavePathRoot_1_neibor);
mkdir(SavePathRoot_1_overlap);



list_0=dir(fullfile(PathRoot_0));
fileNum_0=size(list_0,1);
list_0=struct2cell(list_0)';
list_0=list_0(:,1);
list_0=list_0(3:fileNum_0);

list_1=dir(fullfile(PathRoot_1));
fileNum_1=size(list_1,1);
list_1=struct2cell(list_1)';
list_1=list_1(:,1);
list_1=list_1(3:fileNum_1);

list_mark=dir(fullfile(PathRoot_mark));
fileNum_mark=size(list_mark,1);
list_mark=struct2cell(list_mark)';
list_mark=list_mark(:,1);
list_mark=list_mark(3:fileNum_mark);

fileNum_0=size(list_0,1); %0,1,mark的数量应该基本一致
fileNum_1=size(list_1,1);
fileNum_mark=size(list_mark,1);

list_0=sort_nat(list_0);
list_1=sort_nat(list_1);   %对文件名进行自然序排序
list_mark=sort_nat(list_mark);

objectCenter=zeros(fileNum_1,2);

for i=1:fileNum_1      %fileNum_0,fileNum_1和fileNum_mark应该是相等的
 
    Img_0=imread([PathRoot_0,'\',list_0{i}]);
    Img_1=imread([PathRoot_1,'\',list_1{i}]);   %{}的使用使cell转换成strings
    Img_mark=imread([PathRoot_mark,'\',list_mark{i}]);
 
    difference=Img_mark-Img_1;
    [h,w,channel]=size(difference);
    difference=rgb2gray(difference);
    level=graythresh(difference);
    difference=imbinarize(difference,level);
    %imwrite(difference,[SavePathRoot_mark,'difference_',list_mark{i}]);
    
    Jmin=10000;
    Kmin=10000;
    Jmax=0;
    Kmax=0;
    
    for j=1:h
        for k=1:w
            
            if difference(j,k)>0
                if j>Jmax
                    Jmax=j;
                end
                if j<Jmin
                    Jmin=j;
                end
                if k>Kmax
                    Kmax=k;
                end
                if k<Kmin
                    Kmin=k;
                end
            end   
        end    
    end
    % 获得矩形中心坐标
    center_h=round((Jmin+Jmax)/2);
    center_w=round((Kmin+Kmax)/2);
    
%     s=regionprops(difference,'centroid');
%     centroids=cat(1,s.Centroid);
%     
%     centroidsNum=size(centroids(:,1));
%     
%     for m=1:centroidsNum
%     
%         center_w=centroids(m,1);
%         center_h=centroids(m,2);
%     
%         westnorth_h=round(center_h-BoxSize/2);
%         westnorth_w=round(center_w-BoxSize/2);
%         
%         PositiveImg=imcrop(img_1,[westnorth_w,westnorth_h,BoxSize,BoxSize]);
%         PositiveImg_mark=imcrop(img_mark,[westnorth_w,westnorth_h,BoxSize,BoxSize]);
%         
%         figure
%         imshow(PositiveImg)
%         
%         figure
%         imshow(PositiveImg_mark)
%     
%     end
% 
%     
    objectCenter(i,1)=center_h;
    objectCenter(i,2)=center_w;
    
    westnorth_h=round(center_h-BoxSize/2);
    westnorth_w=round(center_w-BoxSize/2);
    
    NegativeImg_0=imcrop(Img_0,[westnorth_w,westnorth_h,BoxSize,BoxSize]);
    PositiveImg=imcrop(Img_1,[westnorth_w,westnorth_h,BoxSize,BoxSize]);
    PositiveImg_mark=imcrop(Img_mark,[westnorth_w,westnorth_h,BoxSize,BoxSize]);

    
    fprintf(1,'croping original image file %s\n',list_1{i});
    
    %I=int2str(i);
    
    SizeNegativeImg_0=size(NegativeImg_0);
    SizePositiveImg=size(PositiveImg);
    
    if SizeNegativeImg_0(1)==BoxSize+1&&SizeNegativeImg_0(2)==BoxSize+1
        imwrite(NegativeImg_0,[SavePathRoot_0,'\crop_',list_0{i}])  
    end
    
    if SizePositiveImg(1)==BoxSize+1&&SizePositiveImg(2)==BoxSize+1
        imwrite(PositiveImg,[SavePathRoot_1,'\crop_',list_1{i}])  
    end
    
 %   imwrite(PositiveImg,[SavePathRoot_1,'\crop_',list_1{i}])
    imwrite(PositiveImg_mark,[SavePathRoot_mark,'\crop_',list_mark{i}])
    
    
    
    
    
    
    %% 截取目标周围的环境像素作为负样本
    
    neiborWindow=zeros(8,4);
    overlapWindow=zeros(8,4);
    
    neiborWindow(1,:)=[westnorth_w-128,westnorth_h-128,BoxSize,BoxSize];
    neiborWindow(2,:)=[westnorth_w    ,westnorth_h-128,BoxSize,BoxSize];
    neiborWindow(3,:)=[westnorth_w+128,westnorth_h-128,BoxSize,BoxSize];
    neiborWindow(4,:)=[westnorth_w-128,westnorth_h    ,BoxSize,BoxSize];
    neiborWindow(5,:)=[westnorth_w+128,westnorth_h    ,BoxSize,BoxSize];
    neiborWindow(6,:)=[westnorth_w-128,westnorth_h+128,BoxSize,BoxSize];
    neiborWindow(7,:)=[westnorth_w    ,westnorth_h+128,BoxSize,BoxSize];
    neiborWindow(8,:)=[westnorth_w+128,westnorth_h+128,BoxSize,BoxSize];
    
    
    overlapWindow(1,:)=[westnorth_w-5,westnorth_h-5,BoxSize,BoxSize];
    overlapWindow(2,:)=[westnorth_w  ,westnorth_h-5,BoxSize,BoxSize];
    overlapWindow(3,:)=[westnorth_w+5,westnorth_h-5,BoxSize,BoxSize];
    overlapWindow(4,:)=[westnorth_w-5,westnorth_h  ,BoxSize,BoxSize];
    overlapWindow(5,:)=[westnorth_w+5,westnorth_h  ,BoxSize,BoxSize];
    overlapWindow(6,:)=[westnorth_w-5,westnorth_h+5,BoxSize,BoxSize];
    overlapWindow(7,:)=[westnorth_w  ,westnorth_h+5,BoxSize,BoxSize];
    overlapWindow(8,:)=[westnorth_w+5,westnorth_h+5,BoxSize,BoxSize];
    
    
    Str_i=num2str(i);
    
    for k=1:8
        
        Str_k=num2str(k);
        
        NegativeImg_neibor=imcrop(Img_1,neiborWindow(k,:));
        PositiveImg_overlap=imcrop(Img_1,overlapWindow(k,:));

        SizeImg_neibor=size(NegativeImg_neibor);
        SizeImg_overlap=size(PositiveImg_overlap);
        
        if SizeImg_neibor(1)==BoxSize+1&&SizeImg_neibor(2)==BoxSize+1
            imwrite(NegativeImg_neibor,[SavePathRoot_1_neibor,'\Negative_neibor_',Str_i,'_',Str_k,'_',list_1{i}])
        end

        if SizeImg_overlap(1)==BoxSize+1&&SizeImg_overlap(2)==BoxSize+1
            imwrite(PositiveImg_overlap,[SavePathRoot_1_overlap,'\Positive_overlap_',Str_i,'_',Str_k,'_',list_1{i}])
        end

        
    end
    

    
    
    
    
end