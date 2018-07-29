function perda = cost231wi(distancia, frequencia, hte, hre, ws, wb, hb, fi, los, zona)
%
% FUN��O PARA PREVIS�O DE PERDAS USANDO O MODELO "COST231-WI".
%
% Fonte bibliogr�fica: Principles and Applications of GSM
%                      Vijay K. Garg, Joseph E. Wilkes
%                      Prentice Hall,1999
%                      P�ginas 270 e 273.
%
% sa�da = cost231wi(distancia, frequencia, hte, hre, ws, wb, hb, fi, los, zona)
%
% sa�da      : Vector com estimativas de predas, em fun��o da distancia
%              para um valor fixo da frequencia
% distancia  : Vector com valores da distancia expressa em km,
% frequencia : Valor da frequ�ncia de trabalho, expressa em MHz,
% hte        : Altura da antena Emissora (em metros)
%	       Recomenda-se que esteja na gama [4,50] metros,
% hre        : Altura efectiva da antena no terminal mov�l (em metros)
%              Recomenda-se que esteja na gama [1,3] metros,
% ws	     : Largura da rua (expressa em metros), onde o terminal m�vel
%	       se encontra; admite-se que este se localiza no centro da via,
% wb	     : Distancia m�dia entre edificios, marcada entre os pontos
%	       centrais dos mesmos, para efeitos do calculo da m�dia,
% hb	     : Altura m�dia dos edificios; neste parametros, inclui-se a
%	       contribui��o dos telhados,
% fi       : Orienta��o da via relativamente � uni�o entre terminais (Graus);
% los      : condi��o de linha de vista
%            1- LOS
%            0 - NLOS;
% zona	  : Tipo de ambiente urbano em causa:
%	          1 - Grandes Centros Urbanos
%	          0 - Cidades de dimens�es razo�veis ou areas Sub-urbanas.
%       

if los == 1
   perda = 42.6+26*log10(distancia)+20*log10(frequencia);
else
   perda = mscost231(distancia, frequencia, hte, hre, ws, wb, hb, zona);
   parcial = rtscost231(frequencia, hre, ws, hb, fi);
   perda = perda + parcial - freespaceloss(frequencia,distancia);
end   