function RMS_DS=delay_spread(t_medi,H_T,Margen)

pdp_medi=abs(H_T);
Margen=10.^(Margen/10);
limite=max(pdp_medi);
pdp_medi_2=[];
t_medi_2=[];
for l=0:(length(pdp_medi)-1)
   if (pdp_medi(l+1)>limite/Margen)
       pdp_medi_2=[pdp_medi_2;pdp_medi(l+1)]; 
       t_medi_2=[t_medi_2;t_medi(l+1)];                       
   end   
end,
RMS_DS=sqrt((sum(pdp_medi_2.*(t_medi_2.^2))/sum(pdp_medi_2))-(sum(pdp_medi_2.*t_medi_2)/sum(pdp_medi_2)).^2);

%hold on
%plot(t_medi,10*log10(abs(H_T)))
%plot(t_medi_2,10*log10(pdp_medi_2))