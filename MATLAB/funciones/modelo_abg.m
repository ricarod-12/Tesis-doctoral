function [regresion, alfa, beta, sigma] = modelo_abg(vector_x, vector_y)
%Calcula el modelo ABG o FI

p  = polyfit(10*log10(vector_x),(vector_y),1);
regresion = polyval(p,10*log10(vector_x));

beta = p(1);
alfa = p(2);

sigma = std(fitdist((vector_y-regresion),'Normal')); % Con sigma se saca gamma

end