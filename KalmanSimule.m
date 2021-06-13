%%% Matlab script to simulate data and process usiung Kalman filter
delT = 1;
F = [ 1 delT
0 1 ];
H = [ 1 0 ];
x = [ 0
10];
P = [ 10 0
0 10 ];
Q = [ 1 1
1 1 ];
R = [ 1 ];
z = [2.5 1 4 2.5 5.5 ];
for i=1:5
[xpred, Ppred] = predict(x, P, F, Q);
[nu, S] = innovation(xpred, Ppred, z(i), H, R);
[x, P] = innovation_update(xpred, Ppred, nu, S, H);
end