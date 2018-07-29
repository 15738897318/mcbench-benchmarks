function saida = hata_urban2(distancia, frequencia, hte, hre)
%
% FUN��O PARA PREVIS�O DE PERDAS USANDO O "MODELO DE HATA"
%
% Fonte bibliogr�fica: Wireless Communications - Principles and Practice
%                      Theodore S. Rappaport
%                      Prentice Hall,1996
%                      P�ginas 119 e 120.
%
% sa�da = hata_urban2(distancia, frequencia, hte, hre)
%
% sa�da      : Vector com estimativas de predas, em fun��o da distancia
%              para um valor fixo da frequencia
% distancia  : Vector com valores da distancia expressa em km
%              Recomenda-se que seja superior a 1 km
% frequencia : Frequencia de trabalho, expressa em MHz,
%              Recomenda-se que se situe na gama [150,1500] MHz
% hte        : Altura efectiva da antena Emissora (em metros)
%              Recomenda-se que esteja na gama [30, 200] (metros)
% hre        : Altura efectiva da antena no terminal mov�l (em metros)
%              Recomenda-se que esteja na gama [1, 10] (metros)
%
% APLICABILIDADE DO M�TODO: Zona Urbana de elevada dim�ns�o.
%           
%



for k = 1 : length(distancia),
   saida(k) = 0;
   perda = 69.55 + 26.16*log10(frequencia) - 13.82*log10(hte) + (44.9 - 6.55*log10(hte))*log10(distancia(k));
   alfa = 0;
   if frequencia >= 400
     alfa = 3.2*(log10(11.75*hre)*log10(11.75*hre)) - 4.97;
   elseif frequencia <= 200
     alfa = 8.29*(log10(1.54*hre)*log10(1.54*hre)) - 1.1;
   end
   perda = perda - alfa;
   saida(k) = perda;
end
