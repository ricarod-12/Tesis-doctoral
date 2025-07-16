function [r_dir,r_ref,r_ref_hojas_der,r_ref_hojas_izq] = caminos_recorridos(h_tx,h_rx,distancia,d_tx_der,d_tx_izq,d_rx_der,d_rx_izq)
%Calcula la distancia que recorre el rayo por el camino directo, el
%reflejado con el suelo, y el reflejado con cada lado.

	r_dir = sqrt((h_tx-h_rx).^2+distancia^2); 
    r_ref = sqrt((h_tx+h_rx).^2+distancia^2); 
        
    r_ref_hojas_der = sqrt((d_tx_der+d_rx_der).^2+distancia^2); 
    r_ref_hojas_izq = sqrt((d_tx_izq+d_rx_izq).^2+distancia^2);

end