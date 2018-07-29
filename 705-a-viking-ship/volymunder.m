%
% VOLYMUNDER
%
% Ber�knar volymen av b�ten under ett visst z-v�rde.
% Returnerar dessutom 'spunkter' som �r en vektor av sk�rningspunkter
% med planet zguess. Volymen integreras i x-led �ver snittareorna i
% b�ten. Dessa r�knas ut genom att hitta snittets b�zierkurvas t-v�rde
% f�r d�r fz(t)=z (L�ses med Newton-Raphson.). Sedan kan arean av snittet
% R�knas ut m.h.a. 'areaunder'.

function [spunkter, volym] = volymunder(rpos,botten,nx,ny,zguess)

volym=0; spunkter=[];
for i=1:nx
  Q=rpos(i,:); P=botten(i,:);
  b=Q+[0 0 -1]*0.4*norm(Q-P);
  c=P+[0 1 1]/sqrt(2)*0.6*norm(Q-P);
  
  if P(3)<zguess            % Existerar det n�gon area?
    err=1;
    tguess=0.5;
    while abs(err)>1e-5
      t=tguess-(fz(Q,b,c,P,tguess)-zguess)/dfz(Q,b,c,P,tguess);
      err=t-tguess;
      tguess=t;
    end
    spunkter=[spunkter;[rpos(i,1) fy(Q,b,c,P,tguess)]];
    arean=(fy(Q,b,c,P,tguess)*fz(Q,b,c,P,tguess)+areaunder(Q,b,c,P,tguess));
  else
    arean=0;	
  end
  
  if i>1
    volym=volym+2*(rpos(i,1)-oldx)*(oldarea+arean)/2;
  end
  oldarea=arean;
  oldx=rpos(i,1);
end


