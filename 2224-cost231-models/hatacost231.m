function saida = hatacost231(distancia, frequencia, hte, hre, zona)
%
% FUN��O PARA PREVIS�O DE PERDAS USANDO UMA EXTENS�O DO "MODELO DE HATA"
%             SEGUNDO UMA RECOMENDA��O DO COMIT� CIENTIFICO COST-231, 
%             COM VISTA A EXT�NDER A GAMA DE FREQU�NCIAS DE 1.5 A 2 GHz.
%
% Fonte bibliogr�fica: Wireless Communications - Principles and Practice
%                      Theodore S. Rappaport
%                      Prentice Hall,1996
%                      P�ginas 120.
%
% sa�da = hatacost231(distancia, frequencia, hte, hre, zona)
%
% sa�da      : Vector com estimativas de predas, em fun��o da distancia
%              para um valor fixo da frequencia
% distancia  : Vector com valores da distancia expressa em km
%              Recomenda-se que seja superior a 1 km
% frequencia : Frequencia de trabalho, expressa em MHz,
%              Recomenda-se que se situe na gama [150,2000] MHz
% hte        : Altura efectiva da antena Emissora (em metros)
%              Recomenda-se que esteja na gama [30, 200] (metros)
% hre        : Altura efectiva da antena no terminal mov�l (em metros)
%              Recomenda-se que esteja na gama [1, 10] (metros)
% zona       : Classifica��o da area em analise para o par�metro de correc��o alfa(Hre)
%              1 - Cidades com pouco e mediano grau de urbaniza��o
%              2 - Grandes metr�poles
%	            3 - Areas suburbanas
%              4 - N�O EST� PREVISTA A SITUA��O PARA ZONAS RURAIS.
%


if frequencia > 1500
   for k = 1 : length(distancia),
      perda = 46.30 + 33.90*log10(frequencia) - 13.82*log10(hte) + (44.9 - 6.55*log10(hte))*log10(distancia(k));
      perda = perda -(1.1*log10(frequencia)-0.7)*hre + (1.56*log10(frequencia)-0.8);
      if zona ~= 2
         perda = perda + 3;
      end  
      saida(k) = perda;
   end 
else
   for k = 1 : length(distancia),
      perda = 69.55 + 26.16*log10(frequencia) - 13.82*log10(hte) + (44.9 - 6.55*log10(hte))*log10(distancia(k));
      saida(k) = perda -(1.1*log10(frequencia)-0.7)*hre + (1.56*log10(frequencia)-0.8);
   end    
end