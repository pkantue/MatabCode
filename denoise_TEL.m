function [ out_vec ] = denoise_TEL( filename, option)
%   This function used total variance denoising to extract filtered signal
%   for plotting and further processing.
load (filename);
vName = 'Data';
eval(sprintf('%s=%s;',vName,filename));
% length_of_data = length(Data);

% find values of lamdba
lambda = tvdiplmax(Data);

% get lambda max
lambda_vec = linspace(0,lambda,4);

% denoise data
[x, E, s, lambdamax] = tvdip(Data, 0.005*lambda,option,1e-3,150);
% [x, E, s, lambdamax] = tvdip(y, lambda_vec);

out_vec = x;