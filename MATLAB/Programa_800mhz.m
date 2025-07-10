clear all
close all
clc

load MedidasLimon.mat

f_0 = 2.1*1e9;
BW  = 0.5*1e9;
N   = 2001;
P_0 = 0;

tau=0:1/BW:(N-1)/BW;
tau_micro=tau/1e-6;
x = tau.*3e8;

distancia = 60;
dist = [1:0.25:60];
Distancias = [1 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34 36 38 40 42 44 46 48 50];
% dist = Distancias;

mg = 0.68;
perm_real_suelo   = 15;


a    = 5*(1e-2);
t    = 1*(1e-3);
p    = 200;
teta = (30*pi)/180;


hrx         = 1.5;
drx_der     = 1.3;
drx_izq     = 1.3;
htx         = 1.5;
dtx_der     = 1.3;
dtx_izq     = 1.3;


Gto         = 1.75; 
Gro         = 1.75;

polarizacion = 1;

% Añadimo la ruta de las funciones
addpath(genpath('funciones'))


% Se realiza los calculos de pathloss
[perdidas_free_space, offset] = free_space_loss(distancia,f_0,Gto,Gro,P_0);

[H_t, H_d_r, H_d_ra, Losses_LOS, Losses_suelo, Losses_arbol, perdidas_suelo, perdidas_arboles, perdidas_totales] = pathloss(f_0,BW,N,dist,perm_real_suelo,a,t,p,teta,hrx,drx_der,drx_izq,htx,dtx_der,dtx_izq,Gto,Gro,offset,polarizacion,mg);

% % Se realizan las PDP
% load PDP_medidas.mat
% for d = 1:length(dist)
%     PDP_d_r(d,:)= (abs(ifft(H_d_r(d,:) ))).^2;
%     PDP_d_a(d,:)= (abs(ifft(H_d_ra(d,:)))).^2;
%     PDP_t(d,:)  = (abs(ifft(H_t(d,:)   ))).^2;
%     
% 
%     PDP_d_r_log(d,:) = 10*log10(PDP_d_r(d,:));
%     PDP_d_a_log(d,:) = 10*log10(PDP_d_a(d,:));
%     PDP_t_log(d,:)   = 10*log10(PDP_t(d,:));
% end

%Se realiza las regresiones

[regresion_r,  alfa_r,  beta_r,  sigma_r]  = modelo_abg(dist', perdidas_suelo');
[regresion_ra, alfa_ra, beta_ra, sigma_ra] = modelo_abg(dist', perdidas_arboles');
[regresion_t,  alfa_t, beta_t,   sigma_t]  = modelo_abg(dist', perdidas_totales');







% Plot puntos
H_Luis= hBic(:,:,52:552,:);
dimensionesMatrizH=size(H_Luis);

D_log = 10*log10(Distancias);
X=dimensionesMatrizH(1);
Y=dimensionesMatrizH(2);
T=dimensionesMatrizH(3);
Dist=dimensionesMatrizH(4);
realizaciones = X*Y;

for Dist = 1:1: length(H_Luis(1,1,1,:))
        matrizh_d =squeeze(H_Luis(:,:,:,Dist));
        H=reshape(matrizh_d(:,:),X*Y,T);
                    
 for jj=1:realizaciones
        H_temp=squeeze(H(jj,:));
        matrizj(jj,:)=abs(H_temp).^2;
 end
 
 Loc(Dist)=Gto+Gro-10*log10(mean(matrizj));
end





Margen = 20;
% Path loss and RMS de las Medidas
for Dist = 1:1: length(H_Luis(1,1,1,:))
    matrizh_d =squeeze(H_Luis(:,:,:,Dist));
    H=reshape(matrizh_d(:,:),X*Y,T);        
     for jj=1:realizaciones
            H_temp=squeeze(H(jj,:));
            matrizj(jj,:)=abs(H_temp).^2;
            h_temp=(ifft(H_temp));
            matrizh(jj,:)=abs(h_temp).^2;
     end
 mediamatrizh=matrizh;
 % RMS DELAY SPREAD
 Loc(Dist)=Gto+Gro-10*log10(mean(matrizj));
 RMS_PDP_20_O35m(Dist)= delay_spread(tau,mediamatrizh,Margen); 
end 

mean_RMS_meas=mean(RMS_PDP_20_O35m)*1e9;




%% RMS teorico vs real

%valores medida
medida_corregida = [34.4580908900891,39.7304614755793,45.8035635254250,48.7200145157167,52.9164287569495,53.1578012898908,54.9336907895215,54.4523728996789,56.8633074178877,59.3312831342417,61.5573414552644,63.8798208388675,63.0021726474889,64.0613386800302,62.3143980283184,60.7595158334134,60.4335978868204,60.5267747671489,60.5087295800777,60.3389825460184,60.6330752031549,60.6811158707476,61.2627744827388,60.4428540553509,61.1451322989848];
Distancias_corregida = [1,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48];
plot(Distancias_corregida,medida_corregida)



    predecido_free(1)   = Losses_LOS(1);
    predecido_vp(1)     = perdidas_suelo(1);
    predecido_hp(1)     = perdidas_arboles(1);
    predecido_modelo(1) = perdidas_totales(1);

for i = 0:length(Distancias_corregida)-2
    predecido_free(i+2)   = Losses_LOS(5+i*8);
    predecido_vp(i+2)     = perdidas_suelo(5+i*8);
    predecido_hp(i+2)     = perdidas_arboles(5+i*8);
    predecido_modelo(i+2) = perdidas_totales(5+i*8);
end

%RMS freespace
RMS_free = sqrt(mean((medida_corregida(1:end) - predecido_free(1:end)).^2))
%RMS VP
RMS_vp   = sqrt(mean((medida_corregida(1:end) - predecido_vp(1:end)).^2))
%RMS HP
RMS_hp   = sqrt(mean((medida_corregida(1:end) - predecido_hp(1:end)).^2))
%RMS model
RMS_model= sqrt(mean((medida_corregida(1:end) - predecido_modelo(1:end)).^2))



%% Path loss
figure('Position',[200,200,1200,800])
plot(Distancias,Loc-4.14,'ro','MarkerSize',7,'LineWidth',1.5,'DisplayName','Measurements');

hold on
plot(dist,Losses_LOS,'b','LineWidth',1.5,'DisplayName','Free space')
plot(dist,perdidas_suelo,'y','LineWidth',2,'DisplayName','Direct+refl. soil (VP)')
plot(dist,perdidas_arboles,'g','LineWidth',2,'DisplayName','Direct+refl. trees (HP)')
plot(dist,perdidas_totales,'k','LineWidth',2,'DisplayName','Direct+refl. soil+refl. trees')
hold off

% Línea LOS a NLOS
hold on
p7 = plot([10 10],[30 70],'-r','linewidth',1.5);
text(2,68,'\bf Region I','FontSize',18)
text(12,68,'\bf Region II','FontSize',18)
hold off

set(gca,'fontsize',18);
title("Path loss " + num2str(f_0/1e9) + " GHz")
xlabel('Distance Tx-Rx (m)')
ylabel('Path loss (dB)')
grid on
xlim([0 55])
set(gca,'xtick',[0:5:55]);
legend('Location','southeast')

print(gcf,'modelo_vs_medidas_800mhz.png','-dpng','-r500'); 


%% Plot PDP
plot(x-0.3,PDP_medidas(7,:),'g','LineWidth',2)
hold on
plot(x,PDP_t_log(7,:),'b','LineWidth',3)
hold off

set(gca,'fontsize',16);
title(['PDP 3.5 GHz (Vertical Polarization)']);
xlabel('delay distance (m)')
ylabel('PDP')
xlim([0 60])
grid on
set(gca,'xtick',[0:2:60]);

%% RMS

figure('Position',[347,300,1000,376])
plot(Distancias,(RMS_PDP_20_O35m)*1e9,'g-o','LineWidth',2);
ylabel('Mean Rms Delay Spread (ns)');
xlabel('Distancia (m)');
title(['RMS Delay Spread por metro (Margen = ', num2str(Margen),')']);
axis tight