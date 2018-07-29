%% Parallel Computing  example / Obliczenia r�wnolegle
nc=2 % number of cores or processors, nc = 1,2,3,...
     % ilosc rdzeni lub procesor�w    nc = 1,2,3...
matlabpool(nc)  % opening parallel session for nc cores
                % otwarcie sesji r�wnoleglej dla nc rdzeni
NumberOfWorkers=matlabpool('size') %  
tic        % timer start
%% Start of parallel for loop / Petla for dla obliczen r�wnoleglych
parfor tt=10:20 
[~,~]=ode23('ode1000',[0,tt],[1,-1]); % solving ode from ode1000.m
          % rozwi�zywanie r�wnania r�zniczkowego z pliku ode1000.m
% [~,~] zrezygnowano z zapamietania wynik�w obliczen
end
toc
%% Closing parallel session / Zamyka sesje r�wnolegla dla nc rdzeni
matlabpool close force
NumberOfWorkers=matlabpool('size')