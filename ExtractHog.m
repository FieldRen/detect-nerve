clc
clear all
close all

cellSize=8;
blockSize=4;

[PathRoot_pstive,imgNameList_pstive,imgNum_pstive]=readFile;
[PathRoot_ngtive,imgNameList_ngtive,imgNum_ngtive]=readFile;

label_pstive=ones(imgNum_pstive,1);   %正样本标签
label_ngtive=zeros(imgNum_ngtive,1);  %负样本标签

label=[label_pstive',label_ngtive']'; %标签汇总
labelNum=length(label);

%测试hogFeatures的尺寸大小
imgName_testSize=[PathRoot_ngtive,'\',imgNameList_ngtive{140}];
img_testSize=imread(imgName_testSize);
img_testSize=imresize(img_testSize,[128,128]);
img_testSize=rgb2gray(img_testSize);
[hog,visualization]=extractHOGFeatures(img_testSize,'CellSize',[cellSize,cellSize],'BlockSize',[blockSize,blockSize]);
hogVectorsLength=length(hog);
figure;
imshow(imgName_testSize);
hold on
plot(visualization);

hogFeatures=zeros(labelNum,hogVectorsLength);

for i=1:imgNum_pstive
    
    imgName_pstive=[PathRoot_pstive,'\',imgNameList_pstive{i}];
    img_pstive=imread(imgName_pstive);   %读取正样本图像
    img_pstive=imresize(img_pstive,[128,128]);
    img_pstive=rgb2gray(img_pstive);
    
    hog=extractHOGFeatures(img_pstive,'CellSize',[cellSize,cellSize],'BlockSize',[blockSize,blockSize]);
    hogFeatures(i,:)=hog;
    
    fprintf(1,'Extracting HOG features of positive image %s\n',imgName_pstive);
end

for j=1:imgNum_ngtive
    
    imgName_ngtive=[PathRoot_ngtive,'\',imgNameList_ngtive{j}];
    img_ngtive=imread(imgName_ngtive);   %读取负样本图像
    img_ngtive=imresize(img_ngtive,[128,128]);
    img_ngtive=rgb2gray(img_ngtive);
    
    hog=extractHOGFeatures(img_ngtive,'CellSize',[cellSize,cellSize],'BlockSize',[blockSize,blockSize]);
    hogFeatures(imgNum_pstive+j,:)=hog;
    
    fprintf(1,'Extracting HOG features of negative image %s\n',imgName_ngtive);
end

%% 整理训练集
save('hogFeatures.mat','hogFeatures','-v7.3')
save('label.mat','label')
save hogVectorsLength

% svmMdl_kfold=fitclinear(hogFeatures,label,'kFold',10);
% label_kfold=kfoldPredict(svmMdl_kfold);
% ConfusionTrain=confusionmat(label,label_kfold);







