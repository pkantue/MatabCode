% This script is to clean-up the data set such that it has consistant data
% and data fields.
%
% Author: Paulin Kantue
% Date: April 2020
% Ver: 0.1

clearvars;

UPDATE_COLUMNS = 0;
LIST_UNIDENT_DEATH = 0;
LIST_RECOVER = 0;
SAVE_DATA = 0;

%%
load('Covid2019_Archived_Data/covid19SA.mat');

%% update the columns with latest fields
if UPDATE_COLUMNS
    for i = 1:size(data,1)
        len = size(data{i,1,1}.table,2);
        
        % update the Column tags with the latest one
        data{i,1,1}.ColumnTag = data{30,1,1}.ColumnTag;
        
        % update the table with zeros based on additional column tags
        if len < size(data{30,1,1}.ColumnTag,2)
            data{i,1,1}.table(:,(len+1 : size(data{30,1,1}.ColumnTag,2))) = 0;
        end
    end
end

%% find death tally under 'Unidentified'
if LIST_UNIDENT_DEATH
    for i = 1:size(data,1)
        ind(i) = data{i,1,1}.table(1,2) > 0;
        if ind(i) > 0 display(data{i,1,1}.date); end
    end
    
    % list table death summation up to user-defined date
    user_date = '25-Apr-2020';
    
    table = [];
    for i = 1:size(data,1)
        
        % collect table data
        table = [table data{i,1,1}.table(:,2)];
        if strfind(data{i,1,1}.date,user_date)
            break;
        end
    end
end

%% confirm the recoveries
if LIST_RECOVER
    table = [];
    for i = 1:size(data,1)
        table = [table data{i,1,1}.table(:,3)];
    end
end

%% save data
if SAVE_DATA
    save('Covid2019_Archived_Data/covid19SA.mat','data');
end