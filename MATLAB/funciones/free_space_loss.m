function [Losses_free_space, offset] = free_space_loss(dist,f0,Gtx,Grx,P_0)


%Calculo del offset a un metro

offset = P_0 - ((20*log10((f0*4*pi)/(3*10^8)))-Gtx-Grx);


%Calculo del free space loss

    for d = 1:dist
        
        Losses_free_space(d) = (20*log10((f0*4*pi*d)/(3*10^8)))-Gtx-Grx;
        
    end





end