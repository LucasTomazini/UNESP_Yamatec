%% Gera��o de dados - sub-rede A do condom�nio 1 - v6
% ATEN��O: esta vers�o usa a fun��o runmodel estendida, com o c�lculo do
% alfa!
close all
clear
clc
rng(10)    % fixa a seed do gerador de n�meros pseudo-aleat�rios
dsct = 0;   % vari�vel para contar quantos datasets foram gerados

%Carregar o modelo EPANET
d = epanet('rede-sub-a-v6.inp'); 
%Este modelo tem consumidores fora do "condom�nio"
%A partir do N2, todas as dist�ncias em metros s�o multiplicadas por 1000
d.solveCompleteHydraulics;

%% Altura dos n�s
%d.setNodeElevations(12,35);  %altera a cota do n� N12

%% Matriz de adjac�ncia (manual)
MCJ = [
    0	10	0	0	0	0	0	0;
    10	0	3	3	0	0	0	0;
    0	3	0	0	0	0	6	6;
    0	3	0	0	6	6	0	0;
    0	0	0	6	0	0	0	0;
    0	0	0	6	0	0	0	0;
    0	0	6	0	0	0	0	0;
    0	0	6	0	0	0	0	0
];

MCJ = MCJ .* 1000;

%% Verificar o n�mero de elementos
nos = d.getNodeCount; %Press�o nos n�s
tre = d.getLinkCount; %Vaz�o nos trechos
tmp = d.getBinComputedLinkFlow;
len = length(tmp);
clear tmp

%% Dados do cen�rio (Configurar manualmente)
num_rnf = 1;                    % N�mero de reservat�rios de n�vel fixo
nos_med = [2 3 4 5 6 7 8 9];    % n�s de medi��o (juntas + pontos de consumo)
tr_med = [1 6 8 11 13 3 9 5];   % trechos de medi��o de vaz�o
nos_vaz = [12 14];              % n�s de vazamento
tot_nos_vaz = length(nos_vaz);  % total de pontos de vazamento

%% Coleta das coordenadas dos n�s
elev = d.getNodeElevations;
for i = 1:(nos-num_rnf)
coord = d.getNodeCoordinates(i); 
coordenadas{i} = [coord(1) coord(2) elev(i)];
end
clear i coord

%% Mapeamento dos pontos de medi��o e vazamento
cpm = node_map(nos_med,coordenadas,len);
cpv = node_map(nos_vaz,coordenadas,len);

%% Cria��o da estampa de tempo
ttime = d.getTimeSimulationDuration;
step = d.getTimeHydraulicStep;
tv = double([0:step:ttime]');
tmin = double(step/60);
tot_horas = double(ttime/3600);
% Para colocar no formato HH:MM:SS
hora = linspace(0,tot_horas,1+(ttime/step));
hora = hours(hora);
hora.Format = 'hh:mm';

%% Cria��o de mais 8 padr�es de consumo para randomizar
hrs = [1 5 8 12 15 18 21 24];
pts = [0.1 0.4 0.8 2 2.2 1.3 1.9 0.5];
[pstr, pv] = pat_interp(d, hrs, pts);
d.addPattern(pstr,pv);

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

%% Padr�es de consumo adicionais para o consumo externo
min = 0;
max = 3.5;

hrs = [1 4 7 10 13 16 19 21 24];
pts = min + (max-min) .* rand(1,9);
[pstr, pv] = pat_interp(d, hrs, pts);
d.addPattern(pstr,pv); %P15

hrs = [1 4 7 10 13 16 19 21 24];
pts = min + (max-min) .* rand(1,9);
[pstr, pv] = pat_interp(d, hrs, pts);
d.addPattern(pstr,pv);

hrs = [1 4 7 10 13 16 19 21 24];
pts = min + (max-min) .* rand(1,9);
[pstr, pv] = pat_interp(d, hrs, pts);
d.addPattern(pstr,pv);

hrs = [1 4 7 10 13 16 19 21 24];
pts = min + (max-min) .* rand(1,9);
[pstr, pv] = pat_interp(d, hrs, pts);
d.addPattern(pstr,pv);

hrs = [1 4 7 10 13 16 19 21 24];
pts = min + (max-min) .* rand(1,9);
[pstr, pv] = pat_interp(d, hrs, pts);
d.addPattern(pstr,pv);

hrs = [1 4 7 10 13 16 19 21 24];
pts = min + (max-min) .* rand(1,9);
[pstr, pv] = pat_interp(d, hrs, pts);
d.addPattern(pstr,pv); %P20

%% Se quiser visualizar os padr�es:
%pat = d.getPattern;
%figure
%plot(pat(3,:))
%hold on
%plot(pat(4,:))
%plot(pat(5,:))
%plot(pat(6,:))
%plot(pat(7,:))
%plot(pat(8,:))
%plot(pat(9,:))
%plot(pat(10,:))
%plot(pat(11,:))
%plot(pat(12,:))
%plot(pat(13,:))
%plot(pat(14,:))

%% Execu��o do modelo SEM VAZAMENTO - 3 dias
% Dados preliminares
wkday = zeros(len,1) + 1;   % dia da semana (1 = dia de semana; 2 = fds)
leak_array = [0 0];         % 5 pontos de vazamento - nenhum vaza
lktype = 'n';               % tipo de vazamento (c=cte.; i=intermitente; n=nenhum)
lktime = 0;                 % hora do vazamento 
%Sortear padr�es de consumo dos n�s externos
d.setNodeDemandPatternIndex(15,randi([15,20]));
d.setNodeDemandPatternIndex(16,randi([15,20]));
% Rodar o modelo original
dsct = dsct +1;             % incrementar o contador de datasets
Data{dsct} = runmodel_ext(d,tv,tmin,cpm,cpv,leak_array,lktype,lktime,nos_med,tot_nos_vaz,tr_med,len,wkday);

%Sortear padr�es para os pontos de consumo
d.setNodeDemandPatternIndex(3,randi([3,14]));
d.setNodeDemandPatternIndex(4,randi([3,14]));
d.setNodeDemandPatternIndex(5,randi([3,14]));
d.setNodeDemandPatternIndex(6,randi([3,14]));
%Sortear padr�es de consumo dos n�s externos
d.setNodeDemandPatternIndex(15,randi([15,20]));
d.setNodeDemandPatternIndex(16,randi([15,20]));
%Rodar o modelo novamente 
dsct = dsct +1;             % incrementar o contador de datasets
Data{dsct} = runmodel_ext(d,tv,tmin,cpm,cpv,leak_array,lktype,lktime,nos_med,tot_nos_vaz,tr_med,len,wkday);
%Sortear padr�es para os pontos de consumo
d.setNodeDemandPatternIndex(3,randi([3,14]));
d.setNodeDemandPatternIndex(4,randi([3,14]));
d.setNodeDemandPatternIndex(5,randi([3,14]));
d.setNodeDemandPatternIndex(6,randi([3,14]));
%Sortear padr�es de consumo dos n�s externos
d.setNodeDemandPatternIndex(15,randi([15,20]));
d.setNodeDemandPatternIndex(16,randi([15,20]));
%Rodar o modelo novamente 
dsct = dsct +1;             % incrementar o contador de datasets
Data{dsct} = runmodel_ext(d,tv,tmin,cpm,cpv,leak_array,lktype,lktime,nos_med,tot_nos_vaz,tr_med,len,wkday);

%% Padr�es de vazamentos j� dispon�veis no modelo 'inp'
% Padr�o 1 = vazamento cte de meio dia
% Padr�o 2 = vazamento cte de dia inteiro

%% Vazamento no n� 12 - dia inteiro
% Dados preliminares
wkday = zeros(len,1) + 1;       % dia da semana
leak_array = [1 0];             % Apenas N12 vaza
lktype = 'c';                   % tipo de vazamento (c=cte.; i=intermitente; n=nenhum)
lktime = 1;                    % hora do vazamento 
% Configurar o vazamento
d.setNodeBaseDemands(12,2);  % consumo-base
d.setNodeDemandPatternIndex(12,2); % para vazar o dia inteiro

%Sortear padr�es para os pontos de consumo
d.setNodeDemandPatternIndex(3,randi([3,14]));
d.setNodeDemandPatternIndex(4,randi([3,14]));
d.setNodeDemandPatternIndex(5,randi([3,14]));
d.setNodeDemandPatternIndex(6,randi([3,14]));
%Sortear padr�es de consumo dos n�s externos
d.setNodeDemandPatternIndex(15,randi([15,20]));
d.setNodeDemandPatternIndex(16,randi([15,20]));
% Rodar o modelo
dsct = dsct +1;                 % incrementar o  contador de datasets
Data{dsct} = runmodel_ext(d,tv,tmin,cpm,cpv,leak_array,lktype,lktime,nos_med,tot_nos_vaz,tr_med,len,wkday);
%Sortear padr�es para os pontos de consumo
d.setNodeDemandPatternIndex(3,randi([3,14]));
d.setNodeDemandPatternIndex(4,randi([3,14]));
d.setNodeDemandPatternIndex(5,randi([3,14]));
d.setNodeDemandPatternIndex(6,randi([3,14]));
%Sortear padr�es de consumo dos n�s externos
d.setNodeDemandPatternIndex(15,randi([15,20]));
d.setNodeDemandPatternIndex(16,randi([15,20]));
%Rodar o modelo novamente 
dsct = dsct +1;             % incrementar o contador de datasets
Data{dsct} = runmodel_ext(d,tv,tmin,cpm,cpv,leak_array,lktype,lktime,nos_med,tot_nos_vaz,tr_med,len,wkday);
%Sortear padr�es para os pontos de consumo
d.setNodeDemandPatternIndex(3,randi([3,14]));
d.setNodeDemandPatternIndex(4,randi([3,14]));
d.setNodeDemandPatternIndex(5,randi([3,14]));
d.setNodeDemandPatternIndex(6,randi([3,14]));
%Sortear padr�es de consumo dos n�s externos
d.setNodeDemandPatternIndex(15,randi([15,20]));
d.setNodeDemandPatternIndex(16,randi([15,20]));
%Rodar o modelo novamente 
dsct = dsct +1;             % incrementar o contador de datasets
Data{dsct} = runmodel_ext(d,tv,tmin,cpm,cpv,leak_array,lktype,lktime,nos_med,tot_nos_vaz,tr_med,len,wkday);
% Desabilitar o vazamento para o pr�ximo exemplo
d.setNodeBaseDemands(12,0);

%% Vazamento no n� 14 - dia inteiro
% Dados preliminares
wkday = zeros(len,1) + 1;       % dia da semana
leak_array = [0 1];             % apenas N14 vaza 
lktype = 'c';                   % tipo de vazamento (c=cte.; i=intermitente; n=nenhum)
lktime = 1;                    % hora do vazamento 
% Configurar o vazamento
d.setNodeBaseDemands(14,2); 
d.setNodeDemandPatternIndex(14,2); % para vazar o dia inteiro

%Sortear padr�es para os pontos de consumo
d.setNodeDemandPatternIndex(3,randi([3,14]));
d.setNodeDemandPatternIndex(4,randi([3,14]));
d.setNodeDemandPatternIndex(5,randi([3,14]));
d.setNodeDemandPatternIndex(6,randi([3,14]));
%Sortear padr�es de consumo dos n�s externos
d.setNodeDemandPatternIndex(15,randi([15,20]));
d.setNodeDemandPatternIndex(16,randi([15,20]));
% Rodar o modelo
dsct = dsct +1;                 % incrementar o  contador de datasets
Data{dsct} = runmodel_ext(d,tv,tmin,cpm,cpv,leak_array,lktype,lktime,nos_med,tot_nos_vaz,tr_med,len,wkday);
%Sortear padr�es para os pontos de consumo
d.setNodeDemandPatternIndex(3,randi([3,14]));
d.setNodeDemandPatternIndex(4,randi([3,14]));
d.setNodeDemandPatternIndex(5,randi([3,14]));
d.setNodeDemandPatternIndex(6,randi([3,14]));
%Sortear padr�es de consumo dos n�s externos
d.setNodeDemandPatternIndex(15,randi([15,20]));
d.setNodeDemandPatternIndex(16,randi([15,20]));
%Rodar o modelo novamente 
dsct = dsct +1;             % incrementar o contador de datasets
Data{dsct} = runmodel_ext(d,tv,tmin,cpm,cpv,leak_array,lktype,lktime,nos_med,tot_nos_vaz,tr_med,len,wkday);
%Sortear padr�es para os pontos de consumo
d.setNodeDemandPatternIndex(3,randi([3,14]));
d.setNodeDemandPatternIndex(4,randi([3,14]));
d.setNodeDemandPatternIndex(5,randi([3,14]));
d.setNodeDemandPatternIndex(6,randi([3,14]));
%Sortear padr�es de consumo dos n�s externos
d.setNodeDemandPatternIndex(15,randi([15,20]));
d.setNodeDemandPatternIndex(16,randi([15,20]));
%Rodar o modelo novamente 
dsct = dsct +1;             % incrementar o contador de datasets
Data{dsct} = runmodel_ext(d,tv,tmin,cpm,cpv,leak_array,lktype,lktime,nos_med,tot_nos_vaz,tr_med,len,wkday);

%Reset das altera��es de coeficiente no n�
d.setNodeBaseDemands(14,0);


%% Exporta��o para CSV
% % Exporta��es das matrizes de adjac�ncia
% csvwrite('Mat-adj-com-junc.csv',MCJ)

% % Exporta��o dos datasets
% for g = 1:dsct
%     nome = sprintf('%s_%d.csv','data',g);
%     csvwrite(nome,Data{g})
% end

disp('Fim')