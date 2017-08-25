
load hogFeatures
load label
finalMdl=fitclinear(hogFeatures,label);
save('finalMdl.mat','finalMdl','-v7.3');