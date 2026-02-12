
clear; clc; close all;

filename = 'hotDogdata_corrected.csv';
data = readtable(filename);

data = data((data.division == "M") | data.year < 2011, :);
anni = data.year;
hdm = data.numberDogs;

% Normalizzazione del tempo, migliore condizionamento numerico delle matrici
t = anni - min(anni);  %ogni anno viene trasformato in un numero da 0 a n
n = length(t); %quanti anni considerati

%% Modello 4: Logaritmico
X_log = [ones(n,1),t,log(t+1)]; %matrice del modello logaritmico

% Creazione finestra grafica
figure('Color', 'w', 'Position', [200, 200, 900, 600]);
hold on;

% Plot dei dati 
plot(anni, hdm, 'ko', 'MarkerFaceColor', 'k', 'DisplayName', 'Dati Reali (CSV)');

%Calcolo fittig dati
beta_log = X_log \ hdm;  %risoluzione ai minimi quadratici per trovare il valore dei coefficenti beta 
y_log = X_log * beta_log; %calcolo di quanti hot dog dovrebbero essere mangiati in ogni anni secondo il modello 

residuals_log = hdm - y_log; % residuo (differenza tra dato vero e predetto)
MSE_log = mean(residuals_log.^2); %media dei residui quadratici
R2_log = 1 - sum(residuals_log.^2) / sum((hdm - mean(hdm)).^2); %Coefficiente di determinazione R^2 (quanto bene il modello fitta i dati)

% Generazione curva per il plot
t_grid = linspace(min(t), max(t), 200)'; %griglia di 200 punti equidistanti per plottare il grafico
anni_grid = t_grid + min(anni); %riporta gli anni al formato orignali in millenni
X_log_plot = [ones(200,1),t_grid, log(t_grid+1)]; %crea la griglia per il grafico
y_log_plot = X_log_plot * beta_log; %calcolo dei punti da plottare sugli anni veri con beta calcolata precedentemente

% Plot
plot(anni_grid, y_log_plot, 'b', 'LineWidth', 2, ...
    'DisplayName', sprintf('Logaritmico + Lineare (R^2: %.3f)', R2_log));

% Cosmetica del Grafico
title('Fitting Nathan''s Famous Hot Dog Eating Contest');
xlabel('Anno');
ylabel('Numero di Hot Dog Mangiati (HDM)');
legend('Location', 'northwest');
grid on;
hold off;

