%% Carga
load('datos guardados 25-Oct-2022 09-18-47');  %Cargar archivo de datos

%% Configuración plot

escala_plot = 1; % 1 si es en log y 0 si es en lineal
handles.checkbox7 = 1; %1 muestra regresión, 0 no muestra regresión

handles.checkbox1 = 1; %1 Muentra perdidas suelo, 0 no
handles.checkbox2 = 0; %1 Muentra perdidas arboles, 0 no
handles.checkbox3 = 1; %1 Muentra perdidas totales, 0 no

%% Plot
if (escala_plot)
    if handles.checkbox1
        semilogx(distancia_plot,perdidas_suelo,'--m','LineWidth',1.5,'DisplayName','Directo+reflejado suelo')  % directo reflejado suelo
        hold on
        if handles.checkbox7
            semilogx(distancia_plot,regresion_r,':m','LineWidth',1.4,'DisplayName','Directo+reflejado suelo regresión')
        end
    end
    if handles.checkbox2
        semilogx(distancia_plot,perdidas_arboles,'--g','LineWidth',1.5,'DisplayName','Directo+reflejado árboles') % directo reflejados árboles
        hold on
        if handles.checkbox7
            semilogx(distancia_plot,regresion_ra,':g','LineWidth',1.4,'DisplayName','Directo+reflejado árboles regresión')
        end
    end
    if handles.checkbox3
        semilogx(distancia_plot,perdidas_totales,'b','LineWidth',2,'DisplayName','Directo+reflejado totales')    % Perdidas totales
        hold on
        if handles.checkbox7
            semilogx(distancia_plot,regresion_t,':b','LineWidth',1.4,'DisplayName','Directo+reflejado totales regresión')
        end
    end
    hold off
        
else
    if handles.checkbox1
        plot(distancia_plot,perdidas_suelo,'--m','LineWidth',1.5,'DisplayName','Directo+reflejado suelo')  % directo reflejado suelo
        hold on
        if handles.checkbox7
            plot(distancia_plot,regresion_r,':m','LineWidth',1.4,'DisplayName','Directo+reflejado suelo regresión')
        end
    end
    if handles.checkbox2
        plot(distancia_plot,perdidas_arboles,'--g','LineWidth',1.5,'DisplayName','Directo+reflejado árboles') % directo reflejados árboles
        hold on
        if handles.checkbox7
            plot(distancia_plot,regresion_ra,':g','LineWidth',1.4,'DisplayName','Directo+reflejado árboles regresión')
        end
    end
    if handles.checkbox3
        plot(distancia_plot,perdidas_totales,'b','LineWidth',2,'DisplayName','Directo+reflejado totales')    % Perdidas totales
        hold on
        if handles.checkbox7
            plot(distancia_plot,regresion_t,':b','LineWidth',1.4,'DisplayName','Directo+reflejado totales regresión')
        end
    end
    hold off
    
end
title("Path loss " + num2str(plot_f0/1e9) + " GHz")
xlabel('Distancia Tx-Rx (m)')
ylabel('Path loss (dB)')
grid on
xlim([0 max(distancia_plot)])
legend('Location','southeast')