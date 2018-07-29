function saida = hata(distancia, frequencia, hte, hre, zona)
%
% FUN��O PARA PREVIS�O DE PERDAS USANDO O "MODELO DE HATA"
%
% Fonte bibliogr�fica: Wireless Communications - Principles and Practice
%                      Theodore S. Rappaport
%                      Prentice Hall,1996
%                      P�ginas 119 e 120.
%
% sa�da = hata(distancia, frequencia, hte, hre, zona)
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
% zona       : Classifica��o da area em analise para o par�metro de correc��o alfa(Hre)
%              1 - Cidade de pequena ou m�dia dim�ns�es
%              2 - Cidade de grandes dim�ns�es
%              3 - Area suburbana
%              4 - Area rural.
%

if zona == 1
  saida = hata_urban1(distancia, frequencia, hte, hre);
elseif zona == 2
  saida = hata_urban2(distancia, frequencia, hte, hre);
elseif zona == 3
  saida = hata_suburban(distancia, frequencia, hte, hre);
else
  saida = hata_rural(distancia, frequencia, hte, hre);
end
