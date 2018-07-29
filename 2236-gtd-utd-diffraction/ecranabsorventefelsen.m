function saida = ecranabsorventefelsen( frequencia, angulo)
%
%  Fun��o que para um determinado valor da frequ�ncia de trabalho,
%  e para uma ampla gama de angulos, retorna o valor do
%  coeficiente de difra��o Df=D(teta), usando a formula��o de FELSEN..
%
%
%
%  Fonte bibliogr�fica: Radiowave propagation for modern communications
%			Henry L. Bertoni
%			Prentice-Hall, 2000
%			[Bertoni 2000]
%
%  saida = ecranabsorventefelsen( frequencia, angulo)
%  saida	       : Vector com valore do coeficiente de difusao, para
%		            uma gama de angulos dada pelo array 'angulo';
%  frequencia   : Valor da frequencia de trabalho expressa em MHz;
%  angulo	    : Vector de entrada contendo valores do �ngulo de
%                 em rela��o � direc��o de incid�ncia, em RADIANOS;
%
%

k = 0;

s = 0;

lambda = 300/frequencia;

beta = 2*pi/lambda;

saida = 0*angulo;

aux = 0;

for k = 1 : length(angulo),
   fi = angulo(k);
   aux = -1/sqrt(2*pi*beta)*(1/fi+1/(2*pi-fi));  
   saida(k) = abs(aux);
end
