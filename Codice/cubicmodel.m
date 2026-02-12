
clear; clc; close all;

filename = 'hotDogdata_corrected.csv';
data = readtable(filename);

data = data((data.division == "M") | data.year < 2011, :);
anni = data.year;
hdm = data.numberDogs;

% 2. Normalizzazione del tempo, migliore condizionamento numerico delle matrici
t = anni - min(anni);  %ogni anno viene trasformato in un numero da 0 a n
n = length(t); %quanti anni considerati

% Modello 1: Lineare
X1 = [ones(n, 1), t, t.^2, t.^3]; %matrice del modello lineare: colonna di 1 e colonna con gli anni

figure('Color', 'w', 'Position', [100, 100, 900, 600]);
hold on;

% Plot dei dati 
plot(anni, hdm, 'ko', 'MarkerFaceColor', 'k', 'DisplayName', 'Dati Reali (CSV)');

%Calcolo fittig dati
beta = X1 \ hdm;  %risoluzione ai minimi quadratici per trovare il valore dei coefficenti beta 
y_pred = X1 * beta; %calcolo di quanti hot dog dovrebbero essere mangiati in ogni anni secondo il modello 

residuals = hdm - y_pred; %residuo (differenza tra dato vero e predetto)
MSE = mean(residuals.^2); %media dei residui quadratici
R2 = 1 - sum(residuals.^2) / sum((hdm - mean(hdm)).^2); %Coefficiente di determinazione R^2 (quanto bene il modello fitta i dati)

% Generazione curva per il plot
t_grid = linspace(min(t), max(t), 200)'; %griglia di 200 punti equidistanti per plottare il grafico
anni_grid = t_grid + min(anni); %riporta gli anni al formato orignali in millenni
X1_plot = [ones(200, 1), t_grid, t_grid.^2, t_grid.^3]; %crea la griglia per il grafico
y_plot = X1_plot * beta; %calcolo dei punti da plottare sugli anni veri con beta calcolata precedentemente

plot(anni_grid, y_plot, 'Color', 'r', 'LineWidth', 2, ...
     'DisplayName', sprintf('%s (R^2: %.3f)', 'Lineare', R2));


% Cosmetica del Grafico
title('Fitting Nathan''s Famous Hot Dog Eating Contest');
xlabel('Anno');
ylabel('Numero di Hot Dog Mangiati (HDM)');
legend('Location', 'northwest');
grid on;
hold off;

