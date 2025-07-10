clear all
close all
clc

% Medidas
%            Peso,Parte real,Parte imaginaria, modulo, tang, MC,
resultados = [3.5   23.26   7.263   24.3675762  0.31225  0.628571429;
              3.3   21.88   7.17523 23.0264701  0.32794  0.606060606;
              3.0   19.82   6.0823  20.7322641  0.30688  0.566666667;
              2.8   19.82   6.37504 20.8200273  0.32165  0.535714286;
              2.6   18.94   5.73792 19.7900815  0.30295  0.5;
              2.4   18.24   5.39353 19.0207194  0.295698 0.458333333];

          
f0 = 2.1;        % (GHz)
mg = resultados(:,6)';        %Lemon leaf

mg = linspace(0,0.90);

% Modelo Ulaby and El-Rayes

er   = 1.7 - (0.74*mg) + 6.16 * (mg.^2);
v_fw = mg .* (0.55 * mg - 0.076);
v_b  = 4.64*(mg.^2)/(1+7.36*mg.^2);

s = 8.52847;                %CORN   (EuCAP demostrado que es similar al del limonero)
ro = 0.16*s-0.0013*s^2;     %CORN


e_v = er + v_fw*(4.9+(75/(1+(1i*f0/18)))-1i*(18*ro/f0)) + v_b*(2.9+(55/(1+(1i*f0/0.18)^0.5)));



% PLOT

modelo = [real(e_v)' -1*imag(e_v)'];
      
      
figure('Position',[100,100,800,500])
plot(mg'*100,modelo(:,1),'-b','linewidth',2.5)
hold on
% plot(resultados(:,6)*100,resultados(:,2),'*b','linewidth',2.5)
% plot(resultados(:,6)*100,resultados(:,3),'*m','linewidth',2.5)

plot(mg'*100,modelo(:,2),'-m','linewidth',2.5)
hold off

set(gca,'fontsize',18);
% title('Dielectric constant with respect to moisture content');
xlabel('Moisture content (%)')
ylabel('Dielectric constant')
axis tight

grid on

xlim([30 90])
ylim([0 45])
set(gca,'xtick',[30:5:90]);
set(gca,'ytick',[0:5:45]);
% 
% set(gca,'xtick',[0:2:60]);

legend({'Real part (CALC) ($\varepsilon^{\prime}$)','Imaginary part (CALC) ($\varepsilon^{  \prime\prime}$)', 'Real part (CALC) ($\varepsilon^{\prime}$)','Imaginary part (CALC) ($\varepsilon^{  \prime\prime}$)'},'FontSize',15,'Location','east','Interpreter','latex')


print(gcf,'modelo_vs_medidas_hoja_2100.png','-dpng','-r500'); 

%% RMS
real_corr = [16 17.6 19.22 20.53 22.5 23.88];
img_corr  = [5.4 5.78 6.14 6.44 6.9 7.2];

RMS_real = sqrt(mean((real_corr - fliplr(resultados(:,2)')).^2))
RMS_imag = sqrt(mean((img_corr - fliplr(resultados(:,3)')).^2))