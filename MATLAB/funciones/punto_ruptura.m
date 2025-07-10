f_0 = 3.5e9;

htx = 1.5;

hrx = linspace(100,1200,1000);

lambda         = 3e8/f_0;

for altura = 1:length(hrx)

breakpoint(altura)  = (4*htx*hrx(altura))/lambda;

end
(4*htx*2)/lambda

plot(hrx,breakpoint/1000,'LineWidth',2)
title("Punto de ruptura con la altura de RX")
xlabel('Altura RX (m)')
ylabel('Punto de ruptura (km)')