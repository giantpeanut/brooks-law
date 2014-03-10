close all
clear all
clc

% Parameters
t0 = 0;
td = 20;
Xi0 = 0;
Phi0 = 1;
Psi0 = 0;
alphas = 0:0.25:2;

% Curves
tspan = t0:0.01:td; % 30 days
ic = [Xi0 Phi0 Psi0];
curves = length(alphas);

% Figure
f = figure;
fontsize = 14;
title('Nondimensionalized Progress vs Time', 'FontSize', fontsize+5);
ylabel('\Psi ',  'FontSize', fontsize+10, 'rot', 0);
xlabel('T', 'FontSize', fontsize+10);
set(gca, 'ColorOrder', hsv(curves), 'FontSize', fontsize);
axis([t0 td t0 td], 'square');
hold all;
labels = cell(curves, 1);

% Plot Curves
for p = 1:curves;
	ode = @(t, Psi) [ 
		alphas(p);
		Psi(1);
		Psi(2);
	];
	[t, Psi] = ode45(ode, tspan, ic);
	plot(t, Psi(:,3), 'LineSmoothing', 'on');
	labels{p} = sprintf('\\alpha = %.2f', alphas(p));
end

% Legend
legend(labels, 'FontSize', fontsize, 'Location', ...
'SouthEast');
legend boxoff

mkdir('..','images');
saveas(f, '../images/caseI.png');
