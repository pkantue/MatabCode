%%  
%{
This is script to communicate with the arduino and allow the device to
change behaviour.
%}

%% 
clear all
close all

%% select serial com
com_no = 'COM6';

% define COM object
s = serial(com_no);

% open connect object to device
fopen(s);
%fclose(s);
