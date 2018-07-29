
%**************************************************************************
%     Programme Algorithme G�n�tique pour maximiser une fonction � n
%           variables pour notre cas nombre de variable =2
%**************************************************************************
%                   D�velopp� par :MEKHMOUKH Abdenour
%                     1 Ann�e Post Graduation ATS 
%           D�partement d'Electronique Universit� de Bejaia                                                                     
%                                2005/2006
%**************************************************************************





%**************************************************************************
%                         Programme Principal :
%**************************************************************************
clear all;
load parametres;
clc;
%**************************************************************************
%                  Initialisation des parametres :
%**************************************************************************
nbregeneration = ng;	% Nombre de g�n�rations
taillepopulation = ni;		% Tailee de la population
probdecroisement = pc;	% Probabilite de croisement
probdemutation = pm;	% Probabilit� de mutation
nbredebits = nb;		    % Nombre de bits pour chaque variable
%**************************************************************************
disp('*************************************************************');
disp('            Param�tres de l''Algorithme G�n�tique            ');
disp('*************************************************************');

disp([' Nombre de G�n�rations     =',num2str(ng)]);
disp([' Nombre d''individus       =',num2str(ni)]);
disp([' Probabilite de croisement =',num2str(pc)]);
disp([' Probabilit� de mutation   =',num2str(pm)]);
disp([' Nombre de bits (Codage)   =',num2str(nb)]);
disp('*************************************************************');




%**************************************************************************
%                    Le trac� de la fonction � maximiser
%**************************************************************************
figure;
blackbg;
obj_fcn = 'mafonc';	
nbredevariable = 2;		% Nombre de variables
intervalle = [-5, 5; -5, 5];	% intervalle pour les variables

fonction;%appel de la fonction pour la tracer

	
%**************************************************************************


%**************************************************************************
%                      G�n�ration de population al�atoirement
%*************************************************************************
popu = rand(taillepopulation, nbredebits*nbredevariable) > 0.5; 

haut = zeros(nbregeneration, 1);
moyen = zeros(nbregeneration, 1);
bas = zeros(nbregeneration, 1);
%**************************************************************************


%**************************************************************************
% Evaluation de la fonction objective ( � maximiser) pour chaque individu
%**************************************************************************

disp('*************************************************************');
disp(['         Evaluation de f(x,y) pour ',num2str(nbregeneration),' G�n�rations']);
disp('*************************************************************');
for i = 1:nbregeneration;
  

	fcn_evaluation = evalpopu(popu, nbredebits, intervalle, obj_fcn);


	
	haut(i) = max(fcn_evaluation );
	moyen(i) = mean(fcn_evaluation );
	bas(i) = min(fcn_evaluation );
%**************************************************************************
	
%**************************************************************************   
%                        Affiche � l'ecran
%**************************************************************************
	[meilleur, index] = max(fcn_evaluation );
	fprintf('G�n�ration %i: ', i);
	fprintf('f(%f, %f)=%f\n', ...
			bit2num(popu(index, 1:nbredebits), intervalle(1,:)), ...
			bit2num(popu(index, nbredebits+1:2*nbredebits), intervalle(2,:)), ...
			meilleur);
     
	%----------------------------------------------------------------------
	% G�n�ration de la nouvelle population  par selection, croisement et mutation
    %----------------------------------------------------------------------
	popu = nextpopu(popu, fcn_evaluation , probdecroisement, probdemutation);

   xopt=bit2num(popu(index, 1:nbredebits), intervalle(1,:));%x optimal
   yopt=bit2num(popu(index, nbredebits+1:2*nbredebits), intervalle(2,:));%y optimal
  
  xopts(i)=xopt ;
  yopts(i)=yopt ;
   savefile = 'resultats.mat';

save(savefile,'xopt','yopt','meilleur')
   
end
disp('*************************************************************');
disp(['       Fin d''�valuation de f(x,y) pour les ',num2str(nbregeneration),' G�n�rations']);
disp('*************************************************************');
disp( '       R�sultats :  ');
disp(['                       x =',num2str(xopt)]);
disp(['                       y =',num2str(yopt)]);
disp(['                       f(',num2str(xopt),',',num2str(yopt),') =',num2str(meilleur)]);
disp('*************************************************************');

%**************************************************************************
%                        Evolution de x et y  
%**************************************************************************
xevolution =xopts ;
yevolution = yopts;
grid on
subplot(2,1,1); plot(xevolution);xlabel('G�n�rations'); ylabel('x');
subplot(2,1,2); plot(yevolution);xlabel('G�n�rations'); ylabel('y');
%**************************************************************************


figure;
blackbg;
x = (1:nbregeneration)';
plot(x, haut, 'o', x, moyen, 'x', x, bas, '*');
hold on;
plot(x, [haut moyen bas]);
hold off;
legend('Meilleur', 'Moyenne', 'Faible');
xlabel('G�n�rations'); 
ylabel('F(x,y)');
%**************************************************************************
