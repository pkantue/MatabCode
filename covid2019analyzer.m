% This script is to retrieve, analyze and plot data from around the world
% for public awareness
% This script also has prediction logic just for analysis purposes and not
% to be used in public social platforms. The Author accepts no
% responsibility in the usage or distribution of this script.
%
% This focus is on South Africa 
% 
% Sources:
% https://www.worldometers.info/coronavirus/
% 
 
% Author: Paulin Kantue
% Date: April 2020

% clearvars;

%% retrieve data (automatic)
% 1 - get Gauteng data from 
% data = retrieveData(1);

%% retrieve data (manual)
load('Covid2019_Archived_Data/covid19SA.mat');
n = size(data,1);

% update
% n = n + 1;

% data structure

data{n,1,1}.level = 'Province';
data{n,1,1}.RowTag = {'Unidentified',...
    'Northern Cape',...
    'North West',...
    'Mpumalanga',...
    'Limpopo',...
    'Eastern Cape',...
    'Free State',...
    'KwaZulu- Natal',...
    'Western Cape',...
    'Gauteng'};

data{n,1,1}.ColumnTag = {'Accumulated Cases',...
    'Daliy Death'};
data{n,1,1}.date = '27-Mar-2020';
data{n,1,1}.testTag = {'Accumulated','Daily'};
data{n,1,1}.testing = [161004 8614];

% user input 
data{n,1,1}.date = input('Date of Dataset [dd-mmm-yyyy]: ','s');

% collect table data
data{n,1,1}.table = zeros(length(data{n,1,1}.RowTag),...
    length(data{n,1,1}.ColumnTag));

for i = 1:length(data{n,1,1}.RowTag)
    for j = 1:length(data{n,1,1}.ColumnTag)
    data{n,1,1}.table(i,j) = input([data{n,1,1}.ColumnTag{1,j} ' - '...
        data{n,1,1}.RowTag{1,i} ': ']);
    end
end

data{n,1,1}.testing(1) = input('Dataset of testing - Accumulated]: ');
data{n,1,1}.testing(2) = input('Dataset of testing - Daily: ');

%% save data 
save('Covid2019_Archived_Data/covid19SA.mat','data');