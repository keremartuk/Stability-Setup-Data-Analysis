%% stability data analysis

clear all;
close all;
clc

%CONSTANTS

k = 1.38064852e-23;                     % [(m^2)kg(s^-2)(K^-1)], Boltzmann constant
T = 300;                                % [K], temperature
q = 1.602 * 10^-19;
VT= 25.8e-3; %(k*T)/q;                             % [V], 25.8mV thermal voltage at 300K
h = 6.62607004 * 1e-34 ; 
c = 3 * 10^8 ;                  

T80s = [];

%% Analyse Stability

names = '';
file_names = '';

headerlinesIn = 8;

Folder_name = 'Stability Test';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Folder = dir(strcat(Folder_name,'\','*.txt'));

for i1 = 1:numel(Folder)
    
filename = Folder(i1).name;
names = [names;{filename(1:end-4)}];
delimiterIn = '\t';

data = readtable (strcat(Folder_name,'\',filename),'VariableNamingRule','preserve');
time = table2array(data(:,1));
voltage = table2array(data(:,2));
current_density = table2array(data(:,3));
power = table2array(data(:,4));


kerem = figure(1);

normalized_power = power./max(power);
smoothened_power = smoothdata(normalized_power);

plot (time,power./max(power),'LineWidth',2)

hold all

%plot(time, smoothened_power)

ylim([0,1])
xlabel ('Time (hours)')
ylabel ('Normalized PCE')

saveas(kerem, 'Normalized PCE.png');

% Find T80

index = find((smoothened_power) < 0.8);
T80 = time (index(1,1));

T80s = [T80s; T80];

x = table(names, T80s)

end
