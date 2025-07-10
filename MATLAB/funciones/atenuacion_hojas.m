function [alfa_h, alfa_v] = atenuacion_hojas(rad,k,a,t,p,x_l)



I1 = 0.5*(1-(1/rad)*cos(rad)*sin(rad));
I2 = 1 - I1;


alfa_h = (8.656)*k*(p/2)*(pi*t*a^2)*imag(x_l)*(1-k*I1);

alfa_v = (8.656)*k*(p/2)*(pi*t*a^2)*imag(x_l)*(1-I2);


end