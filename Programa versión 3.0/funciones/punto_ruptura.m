f_0 = 11e9;

htx = 110;

hrx = linspace(100,1200,1000);

lambda         = 3e8/f_0;

for altura = 1:length(hrx)

breakpoint(altura)  = (4*htx*hrx(altura))/lambda;

end


plot(hrx,breakpoint/1000,'LineWidth',2)
title("Punto de ruptura con la altura de RX")
xlabel('Altura RX (m)')
ylabel('Punto de ruptura (km)')