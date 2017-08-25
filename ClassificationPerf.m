clc
close all
clear all

load CVMdl
load label
[CVLabels8_4,CVScores8_4]=kfoldPredict(CVMdl);
generalError=kfoldLoss(CVMdl);   %�������ʾ���Ƿ������������ĸ��������Ա�����Ϊһ��������Ե㱻�������Ŀ�����

[X,Y,T,AUC,OPTROCPT]=perfcurve(label,CVScores8_4(:,2),1);
threshold=T((X==OPTROCPT(1))&(Y==OPTROCPT(2)));


confusionMat=confusionmat(label,CVLabels8_4);
save('CVScores8_4.mat','CVScores8_4');
figure;
plot(X,Y,'b');
hold on
plot(OPTROCPT(1),OPTROCPT(2),'ro')
xlabel('False positive rate');
ylabel('True positive rate');
title('ROC for classification by SVM');
hold off
