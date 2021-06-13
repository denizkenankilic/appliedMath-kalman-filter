%%% Matlab script to generate some "true" data for later assessment
%%% Generates:
%%% x: the state history which evolves according to
%%% x(k+1) = Fx(k) + w(k)
%%% w: the process noise history (randomly generated)
%%% z: a set of observations on the state corrupted by noise
%%% v: the noise on each observation (randomly generated)
N = 100;
delT = 1;
F = [ 1 delT
0 1 ];
H = [ 1 0 ];
sigma2Q = 0.01;
sigma2R = 0.1;
Q = sigma2Q * [ delT^3/3 delT^2/2
delT^2/2 delT ];
P = 10*Q;
R = sigma2R * [ 1 ];
x = zeros(2,N);
w = zeros(2,N);
z = zeros(1,N);
v = zeros(1,N);
for i=2:N
w(:,i) = gennormal([0;0], Q); % generate process noise
x(:,i) = F*x(:,i-1) + w(:,i); % update state
v(:,i) = gennormal([0], R); % generate measurement noise
z(:,i) = H * x(:,i) + v(:,i); % get "true" measurement
end
plot(x(1,:));

%%% Matlab script to assess Kalman filter performance
%%% The script assumes the existence of a vector z of
%%% noise corrupted observations
N = length(z); % number of Klamn filter iterations
Qfactor = 1; % process noise mult factor
Rfactor = 10; % measurement noise mult factor
delT = 1; % time step
F = [ 1 delT % update matrix
    0 1 ];
H = [ 1 0 ]; % measurement matrix
sigmaQ = Qfactor*sqrt(0.01);
sigmaR = Rfactor*sqrt(0.1);
Q = sigmaQ^2 * [ 1/3 1/2 % process noise covariance matrix
1/2 1 ];
P = 10*Q;
R = sigmaR^2 * [ 1 ]; % measurement noise covariance
xhat = zeros(2,N); % state estimate
nu = zeros(1,N); % innovation
S = zeros(1,N); % innovation (co)variance
q = zeros(1,N); % normalised innovation squared
for i=2:N
[xpred, Ppred] = predict(xhat(:,i-1), P, F, Q);
[nu(:,i), S(:,i)] = innovation(xpred, Ppred, z(i), H, R);
[xhat(:,i), P] = innovation_update(xpred, Ppred, nu, S, R);
q(:,i) = nu(:,i)'*inv(S(:,i))*nu(:,i);
end
sumQ = sum(q) % determine Sum q which is Chiˆ2 on N d.o.f.
r = xcorr(nu); % get autocorrealtion of innovation
plot(xhat(1,:)); % plot state estimate
pause;
plot(nu) % plot innovation and 2sigma confidence interval
hold on;
plot(2*sqrt(S),'r');
plot(-2*sqrt(S),'r');
hold off;
pause;
plot(q); % plot normalised innovation squared
pause;
plot(r(N:2*N-1)/r(N)); % plot autocorr of innovation (normalised)

