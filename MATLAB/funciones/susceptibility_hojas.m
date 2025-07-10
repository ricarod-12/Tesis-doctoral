function [X_zz_2_real,X_zz_2_imag,X_tt_2_real,X_tt_2_imag] = susceptibility_hojas(rad,a,t,p,rad_i,x_l)
%susceptibility: Calcula la susceptibilidad.
%rad --> La orientacion aleatoria de las hojas es uniforme en el angulo de
% elevacion en el rango de 0 a 30 grados
%a --> Radio de la hoja
%t --> Grosor de la hoja
%p --> Densidad de hojas por metro cubico
%rad_i --> angulo de incidencia de nuestro rayo en el medio
%x_l --> susceptibilidad de una hoja

I1 = 0.5*(1-(1/rad)*cos(rad)*sin(rad));
I2 = 1 - I1;

% 
% I1 = (1/rad)*((rad/2-sin(2*rad))/4);
% I2 = (1/rad)*((rad/2+sin(2*rad))/4);




%Susceptibilidad horizontal (transversal)
X_tt_2 = pi*x_l*p*t*a.^2*(1-((x_l*I1)/(2*(1+x_l))));
%Susceptibilidad vertical (Eje Z)
X_zz_2 = pi*x_l*p*t*a.^2*(1-(x_l/(2*(1+x_l)))*(((cos(rad_i)).^2)*I1+((sin(rad_i)).^2)*2*I2));

X_zz_2_real = real(X_zz_2);
X_zz_2_imag = -imag(X_zz_2);
X_tt_2_real = real(X_tt_2);
X_tt_2_imag = -imag(X_tt_2);

end

