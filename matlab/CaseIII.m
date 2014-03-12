close all;clear all;clc;



X = @(t) (r-s)*t + X0;
Y = @(t) ((s*r-s^2)/(2*k))*t^2 + (s/k)*X0*t + Y0;
% Case we are not hiring
r = 0;
s = 0;
k = 30;
l = 10;
m = 14;
X0 = 0;
Y0 = 3;

f = figure;
tspan = 0:0.1:20;
ode1 = @(t,y) [(r-s); (s/k)*y(1); y(2)-(m/k)*y(3)-(l/k)*y(1)];
[tout,yout] = ode45(ode1,tspan,[X0,Y0,0]);
plot(tout,yout(:,3),'k-');
hold on;

% Case we are hiring, half of the junior staff turn seniors.
r = 10;
s = 5;
k = 30;
l = 10;
m = 14;
X0 = 0;
Y0 = 3;


ode1 = @(t,y) [(r-s); (s/k)*y(1); y(2)-(m/k)*y(3)-(l/k)*y(1)];
[tout,yout] = ode45(ode1,tspan,[X0,Y0,0]);
plot(tout,yout(:,3),'r-');

% Case when m is really big
r = 10;
s = 5;
k = 30;
l = 10;
X0 = 0;
Y0 = 3;
m = 300;

ode1 = @(t,y) [(r-s); (s/k)*y(1); y(2)-(m/k)*y(3)-(l/k)*y(1)];
[tout,yout] = ode45(ode1,tspan,[X0,Y0,0]);
axis([0 tspan(end) 0 14]);
plot(tout,yout(:,3),'g-');

title('Nondimensionalized Progress vs Time','Fontsize',25);
ylabel('P','Fontsize',20);
xlabel('\tau','Fontsize',20);
legend('Case not hiring people','Case we are hiring people','Case m=300');

mkdir('..','images');
saveas(f, '../images/caseIII.png');