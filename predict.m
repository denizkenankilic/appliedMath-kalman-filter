function [xpred, Ppred] = predict(x, P, F, QQ)

xpred = F * x;
Ppred = F * P * F' + QQ;
