function [ PathRoot,fileNameList,fileNum ] = readFile( ~ )
%READFILE ���ڴ��ļ��ж�ȡ�����ļ�
%   �˴���ʾ��ϸ˵��

PathRoot=uigetdir;

folderAttributesList=dir(fullfile(PathRoot));
folderAttributesList=struct2cell(folderAttributesList)';
Num_folderAttributesList=size(folderAttributesList,1);
fileNameList=folderAttributesList(:,1);
fileNameList=fileNameList(3:Num_folderAttributesList);
fileNameList=sort_nat(fileNameList);

fileNum=size(fileNameList,1);

end

