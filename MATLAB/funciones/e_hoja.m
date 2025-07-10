function [e_v] = e_hoja(f0,mg)
% Mg contenido de humedad


    % Modelo Ulaby and El-Rayes
    er   = 1.7 - (0.74*mg) + 6.16 * (mg.^2);
    v_fw = mg .* (0.55 * mg - 0.076);
    v_b  = 4.64*(mg.^2)/(1+7.36*mg.^2);

    s = 8.52847;                %CORN   (EuCAP demostrado que es similar al del limonero)
    ro = 0.16*s-0.0013*s^2;     %CORN


    e_v = er + v_fw*(4.9+(75/(1+(1i*f0/18)))-1i*(18*ro/f0)) + v_b*(2.9+(55/(1+(1i*f0/0.18)^0.5)));


end