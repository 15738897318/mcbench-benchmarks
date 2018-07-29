function Output = decmax(InputMux)

% algoritmo de decodificacion Log-Map

N = evalin('base','N'); % traigo las variables del workspace
EbNo = evalin('base','EbNo');
trellis = evalin('base','trellis');
Mat = evalin('base','Mat');
decoder = evalin('base','decoder');

Lb = zeros(N,1);
X = zeros(N,1);
Y = zeros(N,1);


% demultiplexo las se�ales de entrada en Lb, X e Y1
for i = 1:N,
    % La informacion a priori de cada bit del dec1 es la extrinseca del
    % dec2, y viceversa
    Lb(i,1) = InputMux(i);
    % bit recibido sistematico afectado por ruido
    X(i,1) = InputMux(i + N);
    % bit de redundancia recibido afectado por ruido
    Y(i,1) = InputMux(i + 2*N); 
end

% EbNo esta en dB, Eb = 1
Sigma = 10^(-EbNo/20); 

Lc = 2/(Sigma^2);

% en el archivo 'trellismat' se define la matriz Mat

% C�lculo de los GAMAS

% Modificacion de Gama por PAB

Gama = zeros(N,trellis.numStates,trellis.numStates);
Gama(:,:,:) = - Inf;
for i = 1:N,
      	for k = 1:trellis.numStates,
         	for j = 1:trellis.numStates,
            	if Mat(j,k,1) ~= 0;
                    % Mat(j,k,1) = bi = x_sist
                    Gama(i,j,k) = Mat(j,k,1).*Lb(i)/2 + ...
                        Lc/2*(X(i).*Mat(j,k,1)+Y(i).*Mat(j,k,2));
            	end
         	end
        end
end


% C�lculo de los ALFAS Log MAP     

Alfa=zeros(N,trellis.numStates);  
Alfa(1,:)=-Inf;
Alfa(1,1)=0;
      
   for i=2:N;
      	for k=1:trellis.numStates;
            for j=1:trellis.numStates;
            	A(j)= Gama(i-1,j,k) + Alfa(i-1,j);
            end
            if A(1)==-Inf & A(2)==-Inf;
               Pru=-Inf;
            else
               Pru= max(A(1),A(2)) + log(1+exp(-1*abs(A(1)-A(2))));            
            end
            
            for j=3:trellis.numStates
               if A(j)~=-Inf;                  
                  Pru= max(Pru,A(j)) + log(1+exp(-1*abs(Pru-A(j))));
               end               
            end
            Alfa(i,k)= Pru;
         end
    end

    % C�lculo de los BETAS
    
   	Beta=zeros(N+1,trellis.numStates);   
    
    if decoder == 1
        % Si es el Primer Decodificador, el �ltimo Beta(1) debe ser 0
        Beta(N+1,:)=-Inf;    
        Beta(N+1,1)=0;    
    else
        % Si es el Segundo Decodificador, todos los �ltimos Betas deben ser
        % 0
        Beta(N+1,:)=0;   
    end
    
    
   	for i=N:-1:2;
      	for j=1:trellis.numStates; % j es el estado actual
         	for k=1:trellis.numStates; % k es el estado proximo
            	B(k)= Beta(i+1,k) + Gama(i,j,k);
            end
            if B(1)==-Inf & B(2)==-Inf;
               Pru=-Inf;
            else
               Pru=max(B(1),B(2)) + log(1+exp(-1*abs(B(1)-B(2))));
            end
            
            for k=3:trellis.numStates
               if B(k)~=-Inf;                  
                  Pru= max(Pru,B(k)) + log(1+exp(-1*abs(Pru-B(k))));
               end               
            end
            Beta(i,j)= Pru;
         end
    end
      
    Lb_y=zeros(N,1);   % C�lculo de los L(b/y)
 
    for i=1:N;
    
        for k=1:trellis.numStates;
         	for j=1:trellis.numStates;
            	if Mat(j,k,1)==1;
                  Numer(k) = Alfa(i,j) + Gama(i,j,k) + Beta(i+1,k);
            	elseif Mat(j,k,1)==-1;
                  Denom(k) = Alfa(i,j) + Gama(i,j,k) + Beta(i+1,k);
            	end
         	end      
        end
         
        % comienzo con los dos primeros elementos de Numer y Denom 
        
         if Numer(1)==-Inf & Numer(2)==-Inf
            NumerAux=-Inf;
         else
            NumerAux=max(Numer(1),Numer(2)) + ...
                log(1+exp(-1*abs(Numer(1)-Numer(2))));
         end
         
         if Denom(1)==-Inf & Denom(2)==-Inf
            DenomAux=-Inf;
         else
            DenomAux=max(Denom(1),Denom(2)) + ...
                log(1+exp(-1*abs(Denom(1)-Denom(2))));
         end
         
         % contin�o con el resto de los elementos
         
         for k=3:trellis.numStates            

             if Numer(k)~=-Inf % PAB - Lo agrego para evitar el NaN
                NumerAux=max(NumerAux,Numer(k)) + ...
                    log(1+exp(-1*abs(NumerAux-Numer(k))));
            end

            if Denom(k)~=-Inf % PAB - Lo agrego para evitar el NaN
                DenomAux=max(DenomAux,Denom(k)) + ...
                    log(1+exp(-1*abs(DenomAux-Denom(k))));
            end

         end
         
      	Lb_y(i)=NumerAux - DenomAux;

    end        
             
   	% Ahora la Informaci�n Extr�nseca es comunicada al otro Decodificador
   	% como parametro de salida

Le = Lb_y - Lc*X - Lb;

Output = [Le Lb_y];