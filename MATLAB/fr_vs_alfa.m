clear all
close all
clc


x_freq = linspace(0.1*1e9,2*1e9,300);

perm_real_suelo   = 6;


a    = 5*(1e-2);
t    = 1*(1e-3);
p    = 200;
teta = (30*pi)/180;

polarizacion = 1;

% Añadimo la ruta de las funciones
addpath(genpath('funciones'))

for f = 1:length(x_freq)

    lambda         = 3e8/x_freq(f);
    k              = (2*pi)/lambda;
    perm_img_suelo = 60*0.005*lambda;       %"Measurements and Characterization at 2.1 GHz While Entering in a Small Tunnel"???

    mg = 0.86;
    
    alpha_hojas = (90*pi)/180;


    % Permitividad dieléctrica Hojas
    perm_leaf = e_hoja(x_freq(f),mg);
    % Susceptibilidad de una hoja
    x_l = perm_leaf - 1;    



    % Ez y Et para reflexion simple)
    [X_z_real,X_z_imag,X_t_real,X_t_imag] = susceptibility_hojas(teta,a,t,p,alpha_hojas,x_l);

    % Susceptibilidad y permitividad eje Z
    X_z(f)     = X_z_real - X_z_imag*1i;
    e_z     = 1 + X_z(f);

    % Susceptibilidad y permitividad transversal
    X_t(f)     = X_t_real - X_t_imag*1i;
    e_t     = 1 + X_t(f); 


    R_hojas_Horizontal = coeff_refl_anisotropo(polarizacion,alpha_hojas,e_t,e_z);


    Losses_reflejadas_Horizontal_hojas = R_hojas_Horizontal.*(exp(-1i.*k.*1)./1);
    
    % Funciones de transferencia
    H_t(f)    = (lambda/(4*pi))*Losses_reflejadas_Horizontal_hojas;
    H2_t(f)   = abs(H_t(f)).^2;
    
    
    % Atenuacion hojas
    [alfa_h(f), alfa_v(f)] = atenuacion_hojas(teta,k,a,t,p,x_l);

     
end

figure
loglog(x_freq/1e6,real(X_z),'b','LineWidth',1.5,'DisplayName','Directo')  
hold on
loglog(x_freq/1e6,imag(X_z),'--b','LineWidth',1.5,'DisplayName','Directo')
loglog(x_freq/1e6,real(X_t),'r','LineWidth',1.5,'DisplayName','Directo') 
loglog(x_freq/1e6,imag(X_t),'--r','LineWidth',1.5,'DisplayName','Directo')
hold off
grid on
% ylim([0.00001 0])
xlabel('Frecuencia (MHz)')


figure
hold on
plot(x_freq/1e9,-10*log10(abs(alfa_v)),'b','LineWidth',1.5,'DisplayName','Perdidas hojas')  

title("Path loss")
xlabel('Frecuencia (GHz)')
ylabel('Path loss (dB/m)')
grid on
legend('Location','southeast')
