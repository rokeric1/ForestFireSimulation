
% Parametri
gridSize = 150; % Veličina šume
grid = zeros(gridSize); % Svaka ćelija šume je u stanju 0
burnTime = 3; % Broj koraka gorenja ćelije
fuelDensity = 0.7; % Gustina goriva
temperature = 7; % Temperatura
humidity = 0.2; % Vlažnost
b = 0.2; % Koeficijent vegetacije


grid(75, 75) = 1; % Izvor požara
burnTimer = zeros(gridSize); % Vrijeme gorenja ćelije


windDirections = [1, 0; -1, 0; 0, 1; 0, -1]; % Smjerovi puhanja vjetra
windWeight = 5; % Indeks težine vjetra
windSpeed = 0; % Brzina vjetra
currentWindDirection = [-1, 0];

steps = 250; % Broj koraka simulacije
sigurno=0;


figure;
colormap([0.565 0.761 0.149; 1 0 0; 0.5 0.5 0.5]); 

for t = 1:steps
    newGrid = grid; 
    
    for i = 2:gridSize-1
        for j = 2:gridSize-1
            if grid(i, j) == 0 
                
                neighbors = grid(i-1:i+1, j-1:j+1) == 1;% Kreiranje mreže susjeda 3x3
              if (windSpeed>0)  
                
                if currentWindDirection(1) == 1 %  Vjetar puše južno
                    neighbors(3, 2) = neighbors(3, 2) * windWeight;
                    neighbors(3, 1) = neighbors(3, 1) * windWeight*0.5;
                    neighbors(3, 3) = neighbors(3, 3) * windWeight*0.5;
                    
                elseif currentWindDirection(1) == -1 % Vjetar puše sjeverno
                    neighbors(1, 2) = neighbors(1, 2) * windWeight;
                    neighbors(1, 1) = neighbors(1, 1) * windWeight*0.5;
                    neighbors(1, 3) = neighbors(1, 3) * windWeight*0.5;
                    
                end
                if currentWindDirection(2) == 1 % Vjetar puše istočno
                    neighbors(2, 3) = neighbors(2, 3) * windWeight;
                    neighbors(3, 3) = neighbors(3, 3) * windWeight*0.5;
                    neighbors(1, 3) = neighbors(1, 3) * windWeight*0.5;

                elseif currentWindDirection(2) == -1 % Vjetar puše zapadno
                    neighbors(2, 1) = neighbors(2, 1) * windWeight;
                    neighbors(1, 1) = neighbors(1, 1) * windWeight*0.5;
                    neighbors(1, 3) = neighbors(1, 3) * windWeight*0.5;
                end
              end
                
                
                windSpeedIndex = min(1 + windSpeed / 10, 3); % Indeks brzine vjetra
                
                if(steps <= 5)
                    fireProbability=1
                else
                
                
                fireProbability = b * fuelDensity * sum(neighbors(:)) *(1 - humidity) * exp(temperature / 100) * windSpeedIndex; % Računanje vjerovatnoće
                end
                if rand < fireProbability
                    newGrid(i, j) = 1; % Prelazak ćelije u stanje 1
                    burnTimer(i, j) = burnTime;
                end
            elseif grid(i, j) == 1 
                burnTimer(i, j) = burnTimer(i, j) - 1; 
                if burnTimer(i, j) <= 0
                    newGrid(i, j) = 2; % Prelazak ćelije u stanje 2
                end
            end
        end
    end
    
    grid = newGrid; 
    
        
    
    
    imagesc(grid);
    %title(['Korak: ', num2str(t), ', Gustina goriva: [', num2str(fuelDensity),'], Brzina vjetra: ', num2str(windSpeed), ' m/s']);
    
    pause(0.1); 
end

for i=2:gridSize-1
        for j = 2:gridSize-1
             if grid(i, j) == 0
                 sigurno=sigurno+1;
             end
        end
end
 disp([num2str(sigurno) ])