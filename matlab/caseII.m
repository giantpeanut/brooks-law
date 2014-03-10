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
betas = [0.5 1 2];
gammas = [0 -0.5 -1 -1.25];

% Curves
tspan = t0:0.01:td; % 30 days
curves = length(betas) * length(gammas);

% Figure f
f = figure;
for p = 1:4
  sp(p) = subplot(2,2,p);
  fontsize = 14;
  title('Nondimensionalized Progress vs Time', 'FontSize', fontsize+5);
  ylabel('\Psi ',  'FontSize', fontsize+10, 'rot', 0);
  xlabel('T', 'FontSize', fontsize+10);
  colors = hsv(curves);
  black = [0 0 0];
  set(gca, 'ColorOrder', [ black; colors((1:3)+(p-1)*3,:)], 'FontSize', fontsize);
  axis([t0 td -2 td], 'square');
  hold all;
end

% plot no-hiring case on all plots
for p = 1:4
  PsiDoublePrime0 = 0;
  ic = [PsiDoublePrime0 PsiPrime0 Psi0];
  ode = @(t, Psi) [ 
    0; % (Psi'')' = beta
    Psi(1); % (Psi')' = Psi''
    Psi(2); % (Psi)' = Psi'
  ];
  [t, Psi] = ode45(ode, tspan, ic);

  subplot(sp(p));
  plot(t, Psi(:,3), 'LineSmoothing', 'on');
end

% plot hiring cases
for p = 1:length(gammas)
  PsiDoublePrime0 = gammas(p);
  subplot(sp(p));
  labels = cell(length(betas), 1);
  for q = 1:length(betas)
    ic = [PsiDoublePrime0 PsiPrime0 Psi0];
    ode = @(t, Psi) [ 
      betas(q); % (Psi'')' = beta
      Psi(1); % (Psi')' = Psi''
      Psi(2); % (Psi)' = Psi'
    ];
    [t, Psi] = ode45(ode, tspan, ic);

    
    plot(t, Psi(:,3), 'LineSmoothing', 'on');

    labels{q} = sprintf('\\gamma = %.2f, \\beta = %.2f', ...
    gammas(p),betas(q));
  end
  legend(labels, 'FontSize', fontsize, 'Location', ...
  'SouthEast');
  legend boxoff
end

% Legend
set(0,'CurrentFigure',f)
set(gcf,'PaperPositionMode','auto')
set(f, 'Position', [0 0 900 900])

mkdir('..','images');
saveas(f, '../images/caseII.png');
