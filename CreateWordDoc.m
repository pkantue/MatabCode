%% 
% This scripts contains utilities to create/open a word document and insert
% various objects either from the current running script or already stored
% Caption for each figure can also be automated.
%
% CODE LIMITATIONS
% ================
% User input is needed for creating 
%
% Author: P. Kantu
%
% Version Control
%----------------
% 08/14         - Baseline

%% CREATE WORD DOCUMENT
% create a Word Application Interface
wordApp = actxserver('Word.Application');

% make the Application Interface visible
wordApp.Visible = 1;

% create Word Documents Interface within the Application
wordDoc = wordApp.Documents;

% Add an empty document collection within Documents interface
newDoc = wordDoc.Add;

% create a Word Selection Interface from the Application
selection = wordApp.Selection;

% create a Word InlineShape Interface from the Application
figure = newDoc.InlineShape;

%% ADD A CUSTOM TABLE FOR DATA

%Specfify number of rows and columns
numRows = 3;
numCols = 5;

% Invoke the 'Add' method to create a table object with the following
% specficications:
table = newDoc.Tables.Add(selection.Range, numRows, numCols);

% modify the style of the table object AFTER being created 
table.Style = 'Table Grid';

% set properties of the selection
selection.Text = 'EnterText'; % inputs text into the selection
selection.Font.Bold = 1; % Adds bold font type
%selection.Paragraphs.Alignment = 'wdAlignParagraphCenter'; % center text

% select the entire table to effect 'whole' changes
table.Select;

% set properties of the selection
selection.Paragraphs.Alignment = 'wdAlignParagraphCenter'; % center text

%}

%% OPEN FIGURE IMPORT IN DOCUMENT

% open specificied figure 
% NB: currently only .fig works!
%{
%open('surf_test.fig');
[X,Y,Z] = peaks(30);
surfc(X,Y,Z)
colormap hsv
axis([-3 3 -3 3 -10 5])

% copy figure to clipboard
print -dmeta

% insert figure in document
selection.Paste;

% Inserts a new, blank paragraph.
selection.TypeParagraph;

% Inserts a caption immediately preceding or following the specified
% selection.
InsertCaption(selection,'Figure',' Surf script from MATLAB repository');

selection.Paragraphs.Alignment = 'wdAlignParagraphCenter'; % center text

% Inserts a new, blank paragraph.
selection.TypeParagraph;
selection.Paragraphs.Alignment = 'wdAlignParagraphCenter'; % center tex

%}

%% ADD CUSTOM EQUATION

% enter text equation first in the selection
selection.Text = 'R =  ( "5+6.5"/"9" )^"( "2"/"10" )" ';
selection.Text = 'R = sin (\sigma) [ 5^"2" +6.5/9 ]^"(2/10)" ';

% convert the selection text to equation
Equ1 = selection.OMaths.Add(selection.Range);

% BuildUp equation - convert it to professional format
Equ1.OMaths(1).BuildUp;

%% SAVE & CLOSE DOCUMENT

%{
% save document
invoke(newDoc,'SaveAs','C:\Users\kntp\Desktop\try1.doc');

% close document once saved
invoke(newDoc,'Close');

% quit Word Application
invoke(wordApp,'Quit');

%}