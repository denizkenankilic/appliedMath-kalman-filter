function gennormal(N,mu,sigma)

for i=1:N
   	u=rand; z=sigma*(sqrt(2*log(1/(1-u))));
   	u=rand; 
	x1(i)=mu+z*cos(2*pi*u);
   x2(i)=mu+z*sin(2*pi*u);
end
