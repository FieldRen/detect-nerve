clc
close all
clear all

load label

load CVScores52
load CVScores62
load CVScores72
load CVScores82
load CVScores92
load CVScores10_2
load CVScores12_2
load CVScores14_2
load CVScores16_2
load CVScores18_2
load CVScores16_4
load CVScores12_4
load CVScores8_4

[X1,Y1,AUC1,OPTROCPT1]=perfcurve(label,CVScores52(:,2),1);
[X2,Y2,AUC2,OPTROCPT2]=perfcurve(label,CVScores62(:,2),1);
[X3,Y3,AUC3,OPTROCPT3]=perfcurve(label,CVScores72(:,2),1);
[X4,Y4,AUC4,OPTROCPT4]=perfcurve(label,CVScores82(:,2),1);
[X5,Y5,AUC5,OPTROCPT5]=perfcurve(label,CVScores92(:,2),1);
[X6,Y6,AUC6,OPTROCPT6]=perfcurve(label,CVScores10_2(:,2),1);
[X7,Y7,AUC7,OPTROCPT7]=perfcurve(label,CVScores12_2(:,2),1);
[X8,Y8,AUC8,OPTROCPT8]=perfcurve(label,CVScores14_2(:,2),1);
[X9,Y9,AUC9,OPTROCPT9]=perfcurve(label,CVScores16_2(:,2),1);
[X10,Y10,AUC10,OPTROCPT10]=perfcurve(label,CVScores18_2(:,2),1);
[X11,Y11,AUC11,OPTROCPT11]=perfcurve(label,CVScores16_4(:,2),1);
[X12,Y12,AUC12,OPTROCPT12]=perfcurve(label,CVScores8_4(:,2),1);
[X13,Y13,AUC13,OPTROCPT13]=perfcurve(label,CVScores12_4(:,2),1);
figure;
plot(X1,Y1,'r')
hold on
plot(X2,Y2,'g')

hold on
plot(X3,Y3,'b')
hold on
plot(X4,Y4,'y')

hold on
plot(X5,Y5,'--r')
hold on
plot(X6,Y6,'--g')
hold on
plot(X7,Y7,'--b')
hold on
plot(X8,Y8,'--y')
hold on
plot(X9,Y9,'-.r')
hold on
plot(X10,Y10,'-.g')
hold on
plot(X11,Y11,'k')
hold on
plot(X12,Y12,'--k')
hold on
plot(X13,Y13,'-.k')
legend('5x2','6x2','7x2','8x2','9x2','10x2','12x2','14x2','16x2','18x2','16x4','8x4','12x4');
xlabel('False positive rate');
ylabel('True positive rate');
title('ROC for classification by SVM');
hold off








