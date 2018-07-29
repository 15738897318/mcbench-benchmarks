function y=keyexpansion(x)
%------------------------------------------------------------------------------------------
%  KEYEXPANSION
%  The program transforms an alphabetical key into a key of 57 or 115 bits.
%
%  This key is a number or a vector of dimension two; smaller than one of 16 digits.
%
%  The syntax is y=keyexpansion(x); donde x=dalfa('keyword'); 
%
%  Author: Francisco Echegorri  
%  E-mail: fdefac@montevideo.com.uy  
%  Created in September of 2002.  
%
%------------------------------------------------------------------------------------------  
% 
%  El programa convierte una clave alfab�tica en una clave de 57 o 115 bits.
%
%  Dicha clave es un n�mero o un vector de dimensi�n dos; menor que uno de 16 d�gitos.
%
%  La sintaxis es y=keyexpansion(x);donde x=dalfa('clavealfab�tica');
%
%  Author: Francisco Echegorri  
%  E-mail: fdefac@montevideo.com.uy  
%  Created in September of 2002.  
%
%------------------------------------------------------------------------------------------

if length(x)==2
   x=num2str(x,17);
   y=find(x~=' ');x=x(y);x1=x(1:16);x2=x(17:length(x));x1=['0','.',x1];x2=['0','.',x2];
   x=[x1,x2];y=str2num(x);
else
   x=num2str(x,17);
   if length(x)<=16
      x=x(1:length(x));x=['0','.',x];y=str2num(x);
   else
      x=x(1:16);x=['0','.',x];y=str2num(x);
   end
end

