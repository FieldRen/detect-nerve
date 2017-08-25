clear all
close all
load('hogFeatures.mat')
load('label')
CVMdl=fitclinear(hogFeatures,label,'CrossVal','on');

save('CVMdl.mat','CVMdl','-v7.3')
