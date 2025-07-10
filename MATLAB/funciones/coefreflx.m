function [Ref_coeff] = coefreflx(cond,pol,ang,perm_real,perm_imag)
% Cond--> Conductor(Si la onda incide sobre conductor cond = 1, si no, cond= 0).
% Pol-->Polarizacion, 1 paralela (vertical), 0 perpendicular (horizontal).
% ang--> Angulo de incidencia.
% perm_real--> Permitividad Real.
% perm_imag--> Permitividad imaginaria (si la permitividad fuera un numero
% complejo).

e_r = perm_real-1i.*perm_imag;

    if cond == 1
        if pol == 1
            Ref_coeff = 1;
        elseif pol == 0
            Ref_coeff = -1;
        end
    elseif cond == 0
        if pol == 1
            Ref_coeff = ((e_r).*sin(ang)-sqrt((e_r)-(cos(ang)).^2))./((e_r).*sin(ang)+sqrt((e_r)-(cos(ang)).^2));
        elseif pol == 0
            Ref_coeff = (sin(ang)-sqrt((e_r)-(cos(ang)).^2))./(sin(ang)+sqrt((e_r)-(cos(ang)).^2));    
        end
    end
end