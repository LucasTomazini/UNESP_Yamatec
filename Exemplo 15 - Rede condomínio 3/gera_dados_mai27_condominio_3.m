%% Geração de dados - rede condomínio 3
close all
clear
clc
rng(10)    % fixa a seed do gerador de números pseudo-aleatórios
dsct = 0;   % variável para contar quantos datasets foram gerados

%Carregar o modelo EPANET
d = epanet('rede-condominio-3.inp'); 
%Inclui as medições nas juntas
%Usa o novo mapeamento de vazamento, só 3 colunas

%Ajuste da bomba
d.setCurve(1,[70,25])   % [vazão,carga hidráulica]
d.solveCompleteHydraulics;
d.runsCompleteSimulation;
d.BinUpdateClass;
%d.getBinCurvesInfo

%% Altura dos nós
%d.setNodeElevations(12,35);  %altera a cota do nó N12

%% Comprimento dos trechos
d.setLinkLength(3,4000);     %original: 40
d.setLinkLength(4,5000);     %original: 50
d.setLinkLength(5,9000);     %original: 90
d.setLinkLength(6,7000);     %original: 70
d.setLinkLength(8,4000);     %original: 40
d.setLinkLength(9,7000);     %original: 70
d.setLinkLength(10,4000);    %original: 40
d.setLinkLength(11,4000);    %original: 40
d.setLinkLength(13,7000);    %original: 70
d.setLinkLength(14,5000);    %original: 50
d.setLinkLength(15,4000);    %original: 40
d.setLinkLength(16,7000);    %original: 70

% check = d.getLinkLength;

%% Matriz de adjacência (manual) 
MCJ = [
    0	0	40	0	0	0	0	0	0	0	0	0;
    0	0	50	0	90	0	40	0	0	0	0	0;
    40	50	0	40	0	0	0	0	0	0	0	0;
    0	0	40	0	0	0	0	0	40	0	90	0;
    0	90	0	0	0	70	0	0	0	0	0	0;
    0	0	0	0	70	0	0	0	0	0	0	0;
    0	40	0	0	0	0	0	70	0	0	0	0;
    0	0	0	0	0	0	70	0	0	0	0	0;
    0	0	0	40	0	0	0	0	0	70	0	0;
    0	0	0	0	0	0	0	0	70	0	0	0;
    0	0	0	90	0	0	0	0	0	0	0	70;
    0	0	0	0	0	0	0	0	0	0	70	0
];

%% Verificar o número de elementos
nos = d.getNodeCount; %Pressão nos nós
tre = d.getLinkCount; %Vazão nos trechos
tmp = d.getBinComputedLinkFlow;
len = length(tmp);
clear tmp

%% Dados do cenário (Configurar manualmente)  
num_rnf = 1;                    % Número de reservatórios de nível fixo
nos_med = [2 3 4 5 6 7 8 9 10 11 12 13];   % nós de medição (juntas + pontos de consumo)
tr_med = [1 5 7 8 9 11 13 15 16 4 3 10];   % trechos de medição de vazão
nos_vaz = [14 15 16 17 11 12 13];          % nós de vazamento
tot_nos_vaz = length(nos_vaz);  % total de pontos de vazamento

%% Coleta das coordenadas dos nós
elev = d.getNodeElevations;
for i = 1:(nos-num_rnf)
coord = d.getNodeCoordinates(i); 
coordenadas{i} = [coord(1) coord(2) elev(i)];
end
clear i coord

%% Mapeamento dos pontos de medição e vazamento
cpm = node_map(nos_med,coordenadas,len);
cpv = node_map(nos_vaz,coordenadas,len);

%% Criação da estampa de tempo
ttime = d.getTimeSimulationDuration;
step = d.getTimeHydraulicStep;
tv = double([0:step:ttime]');
tmin = double(step/60);
tot_horas = double(ttime/3600);
% Para colocar no formato HH:MM:SS
hora = linspace(0,tot_horas,1+(ttime/step));
hora = hours(hora);
hora.Format = 'hh:mm';

%% Criação de mais 8 padrões de consumo para randomizar
hrs = [1 5 8 12 15 18 21 24];
pts = [0.1 0.4 0.8 2 2.2 1.3 1.9 0.5];
[pstr, pv] = pat_interp(d, hrs, pts);
d.addPattern(pstr,pv); %P7

hrs = [1 5 8 12 15 18 21 24];
pts = [0.4 0.1 0.5 1.3 2 1 0.9 0.3];
[pstr, pv] = pat_interp(d, hrs, pts);
d.addPattern(pstr,pv);

hrs = [1 8 15 19 21 24];
pts = [0.2 0.7 3 2 1.1 0.3];
[pstr, pv] = pat_interp(d, hrs, pts);
d.addPattern(pstr,pv);

hrs = [1 8 15 17 19 21 24];
pts = [0.2 1 2 1.3 2 1.6 0.2];
[pstr, pv] = pat_interp(d, hrs, pts);
d.addPattern(pstr,pv);

hrs = [1 3 5 8 12 15 19 21 24];
pts = [0.2 0.5 0.8 2 1.1 0.7 1.5 2 0.2];
[pstr, pv] = pat_interp(d, hrs, pts);
d.addPattern(pstr,pv);

hrs = [1 5 9 12 15 19 21 24];
pts = [0.5 0.3 0.3 2 1.5 2.7 0.8 0.6];
[pstr, pv] = pat_interp(d, hrs, pts);
d.addPattern(pstr,pv);

hrs = [1 5 9 12 15 19 21 24];
pts = [0.5 0.3 0.3 2 1.5 2.7 1 0.6];
[pstr, pv] = pat_interp(d, hrs, pts);
d.addPattern(pstr,pv);

hrs = [1 5 9 12 15 19 21 24];
pts = [0.3 0.5 0.8 1.8 1.5 1.3 0.8 0.6];
[pstr, pv] = pat_interp(d, hrs, pts);
d.addPattern(pstr,pv); %P14

%% Padrões de consumo adicionais para o consumo externo (P15 a P25)
min = 0;
max = 3.5;
hrs = [1 4 7 10 13 16 19 21 24];
for i = 1:11
    pts = min + (max-min) .* rand(1,9);
    [pstr, pv] = pat_interp(d, hrs, pts);
    d.addPattern(pstr,pv);
end

%% Parâmetros para variar o consumo-base nos nós externos
bdmin = 1;
bdmax = 3;

%% Execução do modelo SEM VAZAMENTO - 10 dias
% Dados preliminares
wkday = zeros(len,1) + 1;   % dia da semana (1 = dia de semana; 2 = fds)
leak_array = [0 0 0 0 0 0 0];     
lktype = 'n';               % tipo de vazamento (c=cte.; i=intermitente; n=nenhum)
lktime = 0;                 % hora do vazamento 

%Sortear padrões de consumo dos nós externos
for i = 18:47
    d.setNodeDemandPatternIndex(i,randi([15,20]));
    val = bdmin + (bdmax-bdmin) .* rand;
    d.setNodeBaseDemands(i,val);
end
% Rodar o modelo original
dsct = dsct +1;             % incrementar o contador de datasets
Data{dsct} = runmodel(d,tv,tmin,cpm,cpv,leak_array,lktype,lktime,nos_med,tot_nos_vaz,tr_med,len,wkday);

%Rodar o modelo mais 9 vezes
for c = 1:9
    %Sortear padrões para os pontos de consumo
    for j = 3:10
        d.setNodeDemandPatternIndex(j,randi([3,14]));
    end
    %Sortear padrões de consumo dos nós externos
    for i = 18:47
        d.setNodeDemandPatternIndex(i,randi([15,20]));
        val = bdmin + (bdmax-bdmin) .* rand;
        d.setNodeBaseDemands(i,val);
    end
    %Rodar o modelo
    dsct = dsct +1;             % incrementar o contador de datasets
    Data{dsct} = runmodel(d,tv,tmin,cpm,cpv,leak_array,lktype,lktime,nos_med,tot_nos_vaz,tr_med,len,wkday);
end

%% Vazamento no nó 14 - dia inteiro (5 dias)
% Dados preliminares
wkday = zeros(len,1) + 1;       % dia da semana
leak_array = [1 0 0 0 0 0 0];       
lktype = 'c';                   % tipo de vazamento (c=cte.; i=intermitente; n=nenhum)
lktime = 1;                     % hora do vazamento 
% Configurar o vazamento
d.setNodeBaseDemands(14,2);     % consumo-base
d.setNodeDemandPatternIndex(14,2); % para vazar o dia inteiro

%Rodar o modelo 3 vezes
for c = 1:5
    %Sortear padrões para os pontos de consumo
    for j = 3:10
        d.setNodeDemandPatternIndex(j,randi([3,14]));
    end
    %Sortear padrões de consumo dos nós externos
    for i = 18:47
        d.setNodeDemandPatternIndex(i,randi([15,20]));
        val = bdmin + (bdmax-bdmin) .* rand;
        d.setNodeBaseDemands(i,val);
    end
    %Rodar o modelo novamente 
    dsct = dsct +1;             % incrementar o contador de datasets
    Data{dsct} = runmodel(d,tv,tmin,cpm,cpv,leak_array,lktype,lktime,nos_med,tot_nos_vaz,tr_med,len,wkday);
end

% Desabilitar o vazamento para o próximo exemplo
d.setNodeBaseDemands(14,0);

%% Vazamento no nó 14 - meio dia (5 dias)
% Dados preliminares
wkday = zeros(len,1) + 1;       % dia da semana
leak_array = [1 0 0 0 0 0 0];       
lktype = 'i';                   % tipo de vazamento (c=cte.; i=intermitente; n=nenhum)
lktime = 12;                     % hora do vazamento 
% Configurar o vazamento
d.setNodeBaseDemands(14,2);     % consumo-base
d.setNodeDemandPatternIndex(14,1); % para vazar meio dia

%Rodar o modelo 3 vezes
for c = 1:5
    %Sortear padrões para os pontos de consumo
    for j = 3:10
        d.setNodeDemandPatternIndex(j,randi([3,14]));
    end
    %Sortear padrões de consumo dos nós externos
    for i = 18:47
        d.setNodeDemandPatternIndex(i,randi([15,20]));
        val = bdmin + (bdmax-bdmin) .* rand;
        d.setNodeBaseDemands(i,val);
    end
    %Rodar o modelo novamente 
    dsct = dsct +1;             % incrementar o contador de datasets
    Data{dsct} = runmodel(d,tv,tmin,cpm,cpv,leak_array,lktype,lktime,nos_med,tot_nos_vaz,tr_med,len,wkday);
end

% Desabilitar o vazamento para o próximo exemplo
d.setNodeBaseDemands(14,0);

%% Vazamento no nó 15 - dia inteiro (5 dias)
% Dados preliminares
wkday = zeros(len,1) + 1;       % dia da semana
leak_array = [0 1 0 0 0 0 0];       
lktype = 'c';                   % tipo de vazamento (c=cte.; i=intermitente; n=nenhum)
lktime = 1;                     % hora do vazamento 
% Configurar o vazamento
d.setNodeBaseDemands(15,2);     % consumo-base
d.setNodeDemandPatternIndex(15,2); % para vazar o dia inteiro

%Rodar o modelo 3 vezes
for c = 1:5
    %Sortear padrões para os pontos de consumo
    for j = 3:10
        d.setNodeDemandPatternIndex(j,randi([3,14]));
    end
    %Sortear padrões de consumo dos nós externos
    for i = 18:47
        d.setNodeDemandPatternIndex(i,randi([15,20]));
        val = bdmin + (bdmax-bdmin) .* rand;
        d.setNodeBaseDemands(i,val);
    end
    %Rodar o modelo novamente 
    dsct = dsct +1;             % incrementar o contador de datasets
    Data{dsct} = runmodel(d,tv,tmin,cpm,cpv,leak_array,lktype,lktime,nos_med,tot_nos_vaz,tr_med,len,wkday);
end

% Desabilitar o vazamento para o próximo exemplo
d.setNodeBaseDemands(15,0);

%% Vazamento no nó 15 - meio dia (5 dias)
% Dados preliminares
wkday = zeros(len,1) + 1;       % dia da semana
leak_array = [0 1 0 0 0 0 0];       
lktype = 'i';                   % tipo de vazamento (c=cte.; i=intermitente; n=nenhum)
lktime = 12;                     % hora do vazamento 
% Configurar o vazamento
d.setNodeBaseDemands(15,2);     % consumo-base
d.setNodeDemandPatternIndex(15,1); % para vazar meio dia

%Rodar o modelo 3 vezes
for c = 1:5
    %Sortear padrões para os pontos de consumo
    for j = 3:10
        d.setNodeDemandPatternIndex(j,randi([3,14]));
    end
    %Sortear padrões de consumo dos nós externos
    for i = 18:47
        d.setNodeDemandPatternIndex(i,randi([15,20]));
        val = bdmin + (bdmax-bdmin) .* rand;
        d.setNodeBaseDemands(i,val);
    end
    %Rodar o modelo novamente 
    dsct = dsct +1;             % incrementar o contador de datasets
    Data{dsct} = runmodel(d,tv,tmin,cpm,cpv,leak_array,lktype,lktime,nos_med,tot_nos_vaz,tr_med,len,wkday);
end

% Desabilitar o vazamento para o próximo exemplo
d.setNodeBaseDemands(15,0);

%% Vazamento no nó 16 - dia inteiro (5 dias)
% Dados preliminares
wkday = zeros(len,1) + 1;       % dia da semana
leak_array = [0 0 1 0 0 0 0];       
lktype = 'c';                   % tipo de vazamento (c=cte.; i=intermitente; n=nenhum)
lktime = 1;                     % hora do vazamento 
% Configurar o vazamento
d.setNodeBaseDemands(16,2);     % consumo-base
d.setNodeDemandPatternIndex(16,2); % para vazar o dia inteiro

%Rodar o modelo 3 vezes
for c = 1:5
    %Sortear padrões para os pontos de consumo
    for j = 3:10
        d.setNodeDemandPatternIndex(j,randi([3,14]));
    end
    %Sortear padrões de consumo dos nós externos
    for i = 18:47
        d.setNodeDemandPatternIndex(i,randi([15,20]));
        val = bdmin + (bdmax-bdmin) .* rand;
        d.setNodeBaseDemands(i,val);
    end
    %Rodar o modelo novamente 
    dsct = dsct +1;             % incrementar o contador de datasets
    Data{dsct} = runmodel(d,tv,tmin,cpm,cpv,leak_array,lktype,lktime,nos_med,tot_nos_vaz,tr_med,len,wkday);
end

% Desabilitar o vazamento para o próximo exemplo
d.setNodeBaseDemands(16,0);

%% Vazamento no nó 16 - meio dia (5 dias)
% Dados preliminares
wkday = zeros(len,1) + 1;       % dia da semana
leak_array = [0 0 1 0 0 0 0];       
lktype = 'i';                   % tipo de vazamento (c=cte.; i=intermitente; n=nenhum)
lktime = 12;                     % hora do vazamento 
% Configurar o vazamento
d.setNodeBaseDemands(16,2);     % consumo-base
d.setNodeDemandPatternIndex(16,1); % para vazar meio dia

%Rodar o modelo 3 vezes
for c = 1:5
    %Sortear padrões para os pontos de consumo
    for j = 3:10
        d.setNodeDemandPatternIndex(j,randi([3,14]));
    end
    %Sortear padrões de consumo dos nós externos
    for i = 18:47
        d.setNodeDemandPatternIndex(i,randi([15,20]));
        val = bdmin + (bdmax-bdmin) .* rand;
        d.setNodeBaseDemands(i,val);
    end
    %Rodar o modelo novamente 
    dsct = dsct +1;             % incrementar o contador de datasets
    Data{dsct} = runmodel(d,tv,tmin,cpm,cpv,leak_array,lktype,lktime,nos_med,tot_nos_vaz,tr_med,len,wkday);
end

% Desabilitar o vazamento para o próximo exemplo
d.setNodeBaseDemands(16,0);

%% Vazamento no nó 17 - dia inteiro (5 dias)
% Dados preliminares
wkday = zeros(len,1) + 1;       % dia da semana
leak_array = [0 0 0 1 0 0 0];       
lktype = 'c';                   % tipo de vazamento (c=cte.; i=intermitente; n=nenhum)
lktime = 1;                     % hora do vazamento 
% Configurar o vazamento
d.setNodeBaseDemands(17,2);     % consumo-base
d.setNodeDemandPatternIndex(17,2); % para vazar o dia inteiro

%Rodar o modelo 3 vezes
for c = 1:5
    %Sortear padrões para os pontos de consumo
    for j = 3:10
        d.setNodeDemandPatternIndex(j,randi([3,14]));
    end
    %Sortear padrões de consumo dos nós externos
    for i = 18:47
        d.setNodeDemandPatternIndex(i,randi([15,20]));
        val = bdmin + (bdmax-bdmin) .* rand;
        d.setNodeBaseDemands(i,val);
    end
    %Rodar o modelo novamente 
    dsct = dsct +1;             % incrementar o contador de datasets
    Data{dsct} = runmodel(d,tv,tmin,cpm,cpv,leak_array,lktype,lktime,nos_med,tot_nos_vaz,tr_med,len,wkday);
end

% Desabilitar o vazamento para o próximo exemplo
d.setNodeBaseDemands(17,0);

%% Vazamento no nó 17 - meio dia (5 dias)
% Dados preliminares
wkday = zeros(len,1) + 1;       % dia da semana
leak_array = [0 0 0 1 0 0 0];       
lktype = 'i';                   % tipo de vazamento (c=cte.; i=intermitente; n=nenhum)
lktime = 12;                     % hora do vazamento 
% Configurar o vazamento
d.setNodeBaseDemands(17,2);     % consumo-base
d.setNodeDemandPatternIndex(17,1); % para vazar meio dia

%Rodar o modelo 3 vezes
for c = 1:5
    %Sortear padrões para os pontos de consumo
    for j = 3:10
        d.setNodeDemandPatternIndex(j,randi([3,14]));
    end
    %Sortear padrões de consumo dos nós externos
    for i = 18:47
        d.setNodeDemandPatternIndex(i,randi([15,20]));
        val = bdmin + (bdmax-bdmin) .* rand;
        d.setNodeBaseDemands(i,val);
    end
    %Rodar o modelo novamente 
    dsct = dsct +1;             % incrementar o contador de datasets
    Data{dsct} = runmodel(d,tv,tmin,cpm,cpv,leak_array,lktype,lktime,nos_med,tot_nos_vaz,tr_med,len,wkday);
end

% Desabilitar o vazamento para o próximo exemplo
d.setNodeBaseDemands(17,0);

%% Vazamento nas juntas (N11, N12 e N13)

%% Vazamento na junta N11 - dia inteiro (5 dias)
% Dados preliminares
wkday = zeros(len,1) + 1;       % dia da semana
leak_array = [0 0 0 0 1 0 0];       
lktype = 'c';                   % tipo de vazamento (c=cte.; i=intermitente; n=nenhum)
lktime = 1;                     % hora do vazamento 
% Configurar o vazamento
d.setNodeBaseDemands(11,2);     % consumo-base
d.setNodeDemandPatternIndex(11,2); % para vazar o dia inteiro

%Rodar o modelo 3 vezes
for c = 1:5
    %Sortear padrões para os pontos de consumo
    for j = 3:10
        d.setNodeDemandPatternIndex(j,randi([3,14]));
    end
    %Sortear padrões de consumo dos nós externos
    for i = 18:47
        d.setNodeDemandPatternIndex(i,randi([15,20]));
        val = bdmin + (bdmax-bdmin) .* rand;
        d.setNodeBaseDemands(i,val);
    end
    %Rodar o modelo novamente 
    dsct = dsct +1;             % incrementar o contador de datasets
    Data{dsct} = runmodel(d,tv,tmin,cpm,cpv,leak_array,lktype,lktime,nos_med,tot_nos_vaz,tr_med,len,wkday);
end

% Desabilitar o vazamento para o próximo exemplo
d.setNodeBaseDemands(11,0);

%% Vazamento na junta N11 - meio dia (5 dias)
% Dados preliminares
wkday = zeros(len,1) + 1;       % dia da semana
leak_array = [0 0 0 0 1 0 0];       
lktype = 'i';                   % tipo de vazamento (c=cte.; i=intermitente; n=nenhum)
lktime = 12;                     % hora do vazamento 
% Configurar o vazamento
d.setNodeBaseDemands(11,2);     % consumo-base
d.setNodeDemandPatternIndex(11,1); % para vazar meio dia

%Rodar o modelo 3 vezes
for c = 1:5
    %Sortear padrões para os pontos de consumo
    for j = 3:10
        d.setNodeDemandPatternIndex(j,randi([3,14]));
    end
    %Sortear padrões de consumo dos nós externos
    for i = 18:47
        d.setNodeDemandPatternIndex(i,randi([15,20]));
        val = bdmin + (bdmax-bdmin) .* rand;
        d.setNodeBaseDemands(i,val);
    end
    %Rodar o modelo novamente 
    dsct = dsct +1;             % incrementar o contador de datasets
    Data{dsct} = runmodel(d,tv,tmin,cpm,cpv,leak_array,lktype,lktime,nos_med,tot_nos_vaz,tr_med,len,wkday);
end

% Desabilitar o vazamento para o próximo exemplo
d.setNodeBaseDemands(11,0);

%% Vazamento na junta N12 - dia inteiro (5 dias)
% Dados preliminares
wkday = zeros(len,1) + 1;       % dia da semana
leak_array = [0 0 0 0 0 1 0];       
lktype = 'c';                   % tipo de vazamento (c=cte.; i=intermitente; n=nenhum)
lktime = 1;                     % hora do vazamento 
% Configurar o vazamento
d.setNodeBaseDemands(12,2);     % consumo-base
d.setNodeDemandPatternIndex(12,2); % para vazar o dia inteiro

%Rodar o modelo 3 vezes
for c = 1:5
    %Sortear padrões para os pontos de consumo
    for j = 3:10
        d.setNodeDemandPatternIndex(j,randi([3,14]));
    end
    %Sortear padrões de consumo dos nós externos
    for i = 18:47
        d.setNodeDemandPatternIndex(i,randi([15,20]));
        val = bdmin + (bdmax-bdmin) .* rand;
        d.setNodeBaseDemands(i,val);
    end
    %Rodar o modelo novamente 
    dsct = dsct +1;             % incrementar o contador de datasets
    Data{dsct} = runmodel(d,tv,tmin,cpm,cpv,leak_array,lktype,lktime,nos_med,tot_nos_vaz,tr_med,len,wkday);
end

% Desabilitar o vazamento para o próximo exemplo
d.setNodeBaseDemands(12,0);

%% Vazamento na junta N12 - meio dia (5 dias)
% Dados preliminares
wkday = zeros(len,1) + 1;       % dia da semana
leak_array = [0 0 0 0 0 1 0];       
lktype = 'i';                   % tipo de vazamento (c=cte.; i=intermitente; n=nenhum)
lktime = 12;                     % hora do vazamento 
% Configurar o vazamento
d.setNodeBaseDemands(12,2);     % consumo-base
d.setNodeDemandPatternIndex(12,1); % para vazar meio dia

%Rodar o modelo 3 vezes
for c = 1:5
    %Sortear padrões para os pontos de consumo
    for j = 3:10
        d.setNodeDemandPatternIndex(j,randi([3,14]));
    end
    %Sortear padrões de consumo dos nós externos
    for i = 18:47
        d.setNodeDemandPatternIndex(i,randi([15,20]));
        val = bdmin + (bdmax-bdmin) .* rand;
        d.setNodeBaseDemands(i,val);
    end
    %Rodar o modelo novamente 
    dsct = dsct +1;             % incrementar o contador de datasets
    Data{dsct} = runmodel(d,tv,tmin,cpm,cpv,leak_array,lktype,lktime,nos_med,tot_nos_vaz,tr_med,len,wkday);
end

% Desabilitar o vazamento para o próximo exemplo
d.setNodeBaseDemands(12,0);

%% Vazamento na junta N13 - dia inteiro (5 dias)
% Dados preliminares
wkday = zeros(len,1) + 1;       % dia da semana
leak_array = [0 0 0 0 0 0 1];       
lktype = 'c';                   % tipo de vazamento (c=cte.; i=intermitente; n=nenhum)
lktime = 1;                     % hora do vazamento 
% Configurar o vazamento
d.setNodeBaseDemands(13,2);     % consumo-base
d.setNodeDemandPatternIndex(13,2); % para vazar o dia inteiro

%Rodar o modelo 3 vezes
for c = 1:5
    %Sortear padrões para os pontos de consumo
    for j = 3:10
        d.setNodeDemandPatternIndex(j,randi([3,14]));
    end
    %Sortear padrões de consumo dos nós externos
    for i = 18:47
        d.setNodeDemandPatternIndex(i,randi([15,20]));
        val = bdmin + (bdmax-bdmin) .* rand;
        d.setNodeBaseDemands(i,val);
    end
    %Rodar o modelo novamente 
    dsct = dsct +1;             % incrementar o contador de datasets
    Data{dsct} = runmodel(d,tv,tmin,cpm,cpv,leak_array,lktype,lktime,nos_med,tot_nos_vaz,tr_med,len,wkday);
end

% Desabilitar o vazamento para o próximo exemplo
d.setNodeBaseDemands(13,0);

%% Vazamento na junta N13 - meio dia (5 dias)
% Dados preliminares
wkday = zeros(len,1) + 1;       % dia da semana
leak_array = [0 0 0 0 0 0 1];       
lktype = 'i';                   % tipo de vazamento (c=cte.; i=intermitente; n=nenhum)
lktime = 12;                     % hora do vazamento 
% Configurar o vazamento
d.setNodeBaseDemands(13,2);     % consumo-base
d.setNodeDemandPatternIndex(13,1); % para vazar meio dia

%Rodar o modelo 3 vezes
for c = 1:5
    %Sortear padrões para os pontos de consumo
    for j = 3:10
        d.setNodeDemandPatternIndex(j,randi([3,14]));
    end
    %Sortear padrões de consumo dos nós externos
    for i = 18:47
        d.setNodeDemandPatternIndex(i,randi([15,20]));
        val = bdmin + (bdmax-bdmin) .* rand;
        d.setNodeBaseDemands(i,val);
    end
    %Rodar o modelo novamente 
    dsct = dsct +1;             % incrementar o contador de datasets
    Data{dsct} = runmodel(d,tv,tmin,cpm,cpv,leak_array,lktype,lktime,nos_med,tot_nos_vaz,tr_med,len,wkday);
end

% Desabilitar o vazamento para o próximo exemplo
d.setNodeBaseDemands(13,0);

%% Checagem de pressão negativa
init = length(nos_med)+2;
ending = init + length(nos_med)-1;
for i = 1:length(Data)
    t = Data{i}(:,14:25);
    if any(t<0)
        fprintf('ALERTA: Pressão negativa no dataset %d \n', i)
    end
end

%% Exportação para CSV

% mkdir output
% cd C:\Users\Rodrigo\Documents\MATLAB\output
% csvwrite('Mat-adj-com-junc.csv',MCJ) %matriz de adjacência
% 
% for g = 1:dsct
%     nome = sprintf('%s_%d.csv','data',g);
%     csvwrite(nome,Data{g})
% end
% cd C:\Users\Rodrigo\Documents\MATLAB\

disp('Fim')