function [ Ref_coeff ] = coeff_refl_anisotropo(pol,ang,et,ez)
 
% pol ---> 1 polarizacion vertical (paralela), 0 polarizacion horizontal
% (perpendicular)
% ang ---> angulo de incidencia
% et ---> permitividad electrica transversal
% ez ---> permitividad electrica longitudinal
% f ---> frecuencia de trabajo

    if pol == 1
        Ref_coeff = (sqrt(et).*sin(ang)-sqrt(1-(1./ez).*(cos(ang)).^2))./(sqrt(et).*sin(ang)+sqrt(1-(1./ez).*(cos(ang)).^2));
    else
       Ref_coeff = (1./(sqrt(et)).*sin(ang)-sqrt(1-(1./ez).*(cos(ang)).^2))./(1./(sqrt(et)).*sin(ang)+sqrt(1-(1./ez).*(cos(ang)).^2));
    end
end

