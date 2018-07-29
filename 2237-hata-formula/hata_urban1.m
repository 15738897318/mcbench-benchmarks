function saida = hata_urban1(distancia, frequencia, hte, hre)
%
% FUN��O PARA PREVIS�O DE PERDAS USANDO O "MODELO DE HATA"
%
% Fonte bibliogr�fica: Wireless Communications - Principles and Practice
%                      Theodore S. Rappaport
%                      Prentice Hall,1996
%                      P�ginas 119 e 120.
%
% sa�da = hata_urban1(distancia, frequencia, hte, hre)
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
% APLICABILIDADE DO M�TODO: Zona Urbana de pequena ou m�dia dim�ns�es.
%           
%



for k = 1 : length(distancia),
   saida(k) = 0;
   perda = 69.55 + 26.16*log10(frequencia) - 13.82*log10(hte) + (44.9 - 6.55*log10(hte))*log10(distancia(k));
   alfa = 0;
   alfa = (1.1*log10(frequencia) - 0.7)*hre - (1.56*log10(frequencia) - 0.8);
   perda = perda - alfa;
   saida(k) = perda;
end
