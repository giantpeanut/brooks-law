close all
clear all
clc

% Parameters
t0 = 0;
td = 8;
Psi0 = 0;
PsiPrime0 = 1;
PsiDoublePrime0 = 0;

% Parameters
nohiring = [0; 0];
betas = 1:0.5:2;
gammas = fliplr(-2:0.5:0);
hiring = zeros(2, length(betas)*length(gammas));
hiringCount = 1;
% for p = 1:length(betas)
%   for q = 1:length(gammas)
%     hiring(1, hiringCount) = betas(p);
%     hiring(2, hiringCount) = gammas(q);
%     hiringCount = hiringCount + 1;
%   end
% end

for p = 1:length(gammas)
  for q = 1:length(betas)
    hiring(1, hiringCount) = betas(q);
    hiring(2, hiringCount) = gammas(p);
    hiringCount = hiringCount + 1;
  end
end

parameters = [nohiring, hiring];

% Curves
tspan = t0:0.01:td; % 30 days
curves = length(parameters);

% Figure f
f = figure;
fontsize = 14;
title('Nondimensionalized Progress vs Time', 'FontSize', fontsize+5);
ylabel('\Psi ',  'FontSize', fontsize+10, 'rot', 0);
xlabel('T', 'FontSize', fontsize+10);
set(gca, 'ColorOrder', hsv(curves), 'FontSize', fontsize);
axis([t0 td -2 td], 'square');
hold all;

% Figure g
g = figure;
fontsize = 14;
title('Nondimensionalized Progress vs Time', 'FontSize', fontsize+5);
ylabel('\Psi^{\prime}',  'FontSize', fontsize+10, 'rot', 0);
xlabel('\Psi', 'FontSize', fontsize+10);
set(gca, 'ColorOrder', hsv(curves), 'FontSize', fontsize);
axis([-2 5 -2 5], 'square');
hold all;

labels = cell(curves, 1);
labelCount = 1;

% Plot Curves
for p = 1:length(parameters)
  PsiDoublePrime0 = parameters(2,p);
  ic = [PsiDoublePrime0 PsiPrime0 Psi0];
	ode = @(t, Psi) [ 
		parameters(1, p); % (Psi'')' = beta
		Psi(1); % (Psi')' = Psi''
		Psi(2); % (Psi)' = Psi'
	];
	[t, Psi] = ode45(ode, tspan, ic);
  set(0,'CurrentFigure',f)
	plot(t, Psi(:,3), 'LineSmoothing', 'on');
  set(0,'CurrentFigure',g)
  plot(Psi(:,3), Psi(:,2), 'LineSmoothing', 'on');
	labels{p} = sprintf('\\beta = %.2f, \\gamma = %.2f', ...
    parameters(1, p),parameters(2, p));
  labelCount = labelCount + 1;
end

% Legend
set(0,'CurrentFigure',f)
legend(labels, 'FontSize', fontsize, 'Location', ...
'SouthEast');
legend boxoff

set(0,'CurrentFigure',g)
legend(labels, 'FontSize', fontsize, 'Location', ...
'SouthEast');
legend boxoff

mkdir('..','images');
saveas(f, '../images/caseII.png');
