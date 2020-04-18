% Configuration Control Preamble------------------------------------------%
% Project           : None                                                %
% File Name         : create_3D_array                                     %
% Classification    : Autopilot Design                                    %
% Purpose           : Generate a 3D array for embedded code               %
% Program Language  : Matlab m-file                                       %
% Issue             : 1                                                   %
% Version           : 1.0                                                 %
% Programmers       : P. Kantu                                            %
% External Functions:                                                     %
% Restrictions      :                                                     %
% Important Remarks :                                                     %
%                                                                         %
% Updates           : Reasons                            Date        By   %
%-------------------------------------------------------------------------%

function [str] = create_3D_array(no_tables,no_rows,no_cols,data,format)

% string container
str = '';

for k = 1:no_tables
    
    % 2D array
    if (k == 1)
        % start data/next table
        if (no_tables > 1)
            str = [str '{{ \n'];
        elseif (no_rows > 1)
            str = [str '{ \n'];
        else
            str = [str ' {'];
        end
    else
        str = [str '{ \n'];
    end
    
    for j = 1:no_rows
        
        for i = 1:no_cols
            
            % row start
            if(i == 1) && no_rows > 1
                str = [str '\t {'];           
            end
            
            str = [str sprintf([' ' format],data(j,i,k))];
            
            if (i < no_cols)
                str = [str ','];
            else
                str = [str '}'];
            end
            
        end
        
        % end table
        if (j < no_rows)
            str = [str ',\n'];
        elseif (k < no_tables)
            str = [str '},\n'];
        elseif (no_rows > 1) % for 2D array
            str = [str '}\n'];
        end
        
        % 2D array
        if (no_rows == 1)
            str = [str ';'];
        end
        
    end
    
    % end table
    if (k == no_tables && no_tables > 1)
        str = [str '};\n'];
    elseif (k == no_tables && no_rows > 1)
        str = [str ';\n'];
    end
    
end