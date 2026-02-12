clear; clc; close all;

filename = 'hotDogdata_corrected.csv';
data = readtable(filename);

data = data((data.division == "M") | data.year < 2011, :);
anni = data.year;
hdm = data.numberDogs;

% 2. Normalizzazione del tempo, migliore condizionamento numerico delle matrici
t = anni - min(anni);  %ogni anno viene trasformato in un numero da 0 a n
n = length(t); %quanti anni considerati


%% MODELLO 2: ESPONENZIALE
figure('Color', 'w', 'Position', [150, 150, 900, 600]); % Spostata leggermente per non sovrapporsi
hold on;
% Plot dei dati
plot(anni, hdm, 'ko', 'MarkerFaceColor', 'k', 'DisplayName', 'Dati Reali (CSV)');

% Calcolo fitting dati esponenziale (y = A * e^(B*t))
% Linearizziamo prendendo il logaritmo naturale di hdm
X1 = [ones(n, 1), t]; %matrice del modello lineare: colonna di 1 e colonna con gli anni
beta = X1 \ hdm;  %risoluzione ai minimi quadratici per trovare il valore dei coefficenti beta
beta_exp = X1 \ log(hdm);  % I coefficienti minimizzano i residui del logaritmo

% Calcolo della predizione riportata in scala originale (esponenziale)
y_pred_exp = exp(X1 * beta_exp); 
residuals_exp = hdm - y_pred_exp; % residuo reale (non logaritmico)
MSE_exp = mean(residuals_exp.^2); 
R2_exp = 1 - sum(residuals_exp.^2) / sum((hdm - mean(hdm)).^2); % R^2

% Curva per il plot esponenziale
t_grid = linspace(min(t), max(t), 200)'; %griglia di 200 punti equidistanti per plottare il grafico
anni_grid = t_grid + min(anni); %riporta gli anni al formato orignali in millenni
X1_plot = [ones(200, 1), t_grid]; %crea la griglia per il grafico
y_plot_exp = exp(X1_plot * beta_exp); 
plot(anni_grid, y_plot_exp, 'Color', 'g', 'LineWidth', 2, ...
     'DisplayName', sprintf('%s (R^2: %.3f)', 'Esponenziale', R2_exp));

% Cosmetica del Grafico 2
title('Fitting Esponenziale - Nathan''s Famous Hot Dog Eating Contest');
xlabel('Anno');
ylabel('Numero di Hot Dog Mangiati (HDM)');
legend('Location', 'northwest');
grid on;
hold off;