%
% VLINJEFUNC
%
% Hittar ,givet ett x v�rde, y v�rdet d�r vikingaskeppet sk�r
% vattenytan. Utnyttjar 'spunkter' som �r k�nda sk�rningar.

function stop=vlinjefunc(x,spunkter,search)
	if search>size(spunkter,1) | x<spunkter(1,1)
		stop=0;
	else
		if x>spunkter(search,1)
			stop=vlinjefunc(x,spunkter,search+1);
		else
			stop=spunkter(search,2);
		end
	end
