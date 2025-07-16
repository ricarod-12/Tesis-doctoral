function [Losses_wide_band_d_r, Losses_wide_band_d_ra, Losses_wide_band_t] = pathloss(f_0,BW,N,dist,e_hoja_real,e_hoja_img,perm_real_suelo,a,t,p,teta,hrx,drx_der,drx_izq,htx,dtx_der,dtx_izq,Gto,Gro,offset,polarizacion)

% Modelo de dos rayos banda ancha
frecuencias = linspace(f_0-(BW/2),f_0+(BW/2),N);

% Cálculos
for d = 1:length(dist)      % Recorremos todos los valores de distancia
    for f = 1:N             % Recorremos todos los valores del ancho de banda
        
        % Calculamos para cada frecuencia
        lambda         = 3e8/frecuencias(f);
        k              = (2*pi)/lambda;
        perm_img_suelo = 60*0.005*lambda;       %"Measurements and Characterization at 2.1 GHz While Entering in a Small Tunnel"???
        
        
        % Distancia caminos recorridos
        [r_dir(d),r_ref(d),r_ref_hojas_der(d),r_ref_hojas_izq(d)] = caminos_recorridos(htx,hrx,dist(d),dtx_der,dtx_izq,drx_der,drx_izq);

        
        % Angulos de incidencia
        alpha_suelo     = atan((htx+hrx)./dist(d));
        alpha_hojas_der = atan((dtx_der+drx_der)./dist(d));
        alpha_hojas_izq = atan((dtx_izq+drx_izq)./dist(d));
        
        
        % Permitividad dieléctrica Hojas
        perm_leaf = e_hoja_real - 1i*e_hoja_img;
        % Susceptibilidad de una hoja
        x_l = perm_leaf - 1;        
        
        
        % Ez y Et para reflexion simple)
        [X_z_real,X_z_imag,X_t_real,X_t_imag] = susceptibility_hojas(teta,a,t,p,alpha_hojas_der,x_l);
        
        % Susceptibilidad y permitividad eje Z
        X_z     = X_z_real - X_z_imag*1i;
        e_z     = 1 + X_z;
        
        % Susceptibilidad y permitividad transversal
        X_t     = X_t_real - X_t_imag*1i;
        e_t     = 1 + X_t; 
        
        
        %Reflexiones
        R_suelo                = coefreflx(0,polarizacion,alpha_suelo,perm_real_suelo,perm_img_suelo); %1 polarizacion vertical, 0 polarizacion horizontal
        R_hojas_Horizontal_der = coeff_refl_anisotropo(polarizacion,alpha_hojas_der,e_t,e_z);
        R_hojas_Horizontal_izq = coeff_refl_anisotropo(polarizacion,alpha_hojas_izq,e_t,e_z);
        
        
        %Perdidas  
        Losses_directas   = (exp(-1i.*k.*r_dir(d)))./r_dir(d);
        Losses_reflejadas = R_suelo.*(exp(-1i.*k.*r_ref(d))./r_ref(d));
       
        Losses_reflejadas_Horizontal_hojas_der = R_hojas_Horizontal_der.*(exp(-1i.*k.*r_ref_hojas_der(d))./r_ref_hojas_der(d));
        Losses_reflejadas_Horizontal_hojas_izq = R_hojas_Horizontal_izq.*(exp(-1i.*k.*r_ref_hojas_izq(d))./r_ref_hojas_izq(d));
       
        
        % Haremos uso de las perdidas de polarizacion vertical para rayo reflejado en el suelo y la de los arboles en horizontal
        Losses_lineal_t     = [Losses_directas Losses_reflejadas Losses_reflejadas_Horizontal_hojas_der Losses_reflejadas_Horizontal_hojas_izq];
        Losses_lineal_d_r   = [Losses_directas Losses_reflejadas];
        Losses_lineal_d_ra  = [Losses_directas Losses_reflejadas_Horizontal_hojas_der Losses_reflejadas_Horizontal_hojas_izq];                
        
        % Funciones de transferencia
        H_t(d,f)    = (lambda/(4*pi))*sum(Losses_lineal_t);
        H2_t(d,f)   = abs(H_t(d,f)).^2;
                 
        H_d_r(d,f)  = (lambda/(4*pi))*sum(Losses_lineal_d_r);
        H2_d_r(d,f) = abs(H_d_r(d,f)).^2;
          
        H_d_ra(d,f) = (lambda/(4*pi))*sum(Losses_lineal_d_ra);
        H2_d_ra(d,f)= abs(H_d_ra(d,f)).^2;
    end
end


% Pérdidas totales
for d_2 = 1:length(dist)
    Losses_wide_band_t(d_2)=-10*log10(sum(H2_t(d_2,:))/N)-Gto-Gro;
    Losses_wide_band_d_r(d_2)=-10*log10(sum(H2_d_r(d_2,:))/N)-Gto-Gro;
    Losses_wide_band_d_ra(d_2)=-10*log10(sum(H2_d_ra(d_2,:))/N)-Gto-Gro;
end


end