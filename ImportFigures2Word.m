%%
% This scripts contains utilities to create/open a word document and insert
% various figures either from the current running script or already stored
% Caption for each figure can also be automated.
%
% CODE LIMITATIONS
% ================
% User input is needed for selecting figures in directory
% This code has only being tested with MS Office Standard 2010
% The figures used must be in the same sequence as the parameters
% variations stated.
% Document must be closed BEFORE running the code
%
% Author: P. Kantue
%
% Version Control
%----------------
% 10/14         - Baseline
% 11/14         - Added automated figure caption input based on user title
% 12/14         - Made the default figure import size 85% smaller to allow
%                 a two figures with caption to fit in one page (default
%                 page setup).
% 03/15         - Added functionality to add caption after n-th number of
%                 pictures.
%               - Added option not to save and close and exit script.

%% CREATE WORD DOCUMENT

clear; clc;

disp('Open or create Word Document:');
disp('[1] Create');
disp('[2] Open');
opt = input('Option: ');

if (opt == 2)
    [filename1, pathname1, filterindex] = uigetfile( ...
        {  '*.doc;*.docx','Doc-files (*.doc)'; ...
        '*.*',  'All Files (*.*)'},'Select the Word Doc',...
        'MultiSelect','off');

    % close Word Application and return if no file is selected
    if (filename1 == 0)
        % quit Word Application
        invoke(wordApp,'Quit');
        return;
    end

    % create a Word Application Interface
    wordApp = actxserver('Word.Application');

    % make the Application Interface visible
    wordApp.Visible = 1;

    % create Word Documents Interface within the Application
    wordDoc = wordApp.Documents;

    % open the word document
    newDoc = wordDoc.Open([pathname1 filename1]);
elseif (opt == 1)
    % create a Word Application Interface
    wordApp = actxserver('Word.Application');

    % make the Application Interface visible
    wordApp.Visible = 1;

    % create Word Documents Interface within the Application
    wordDoc = wordApp.Documents;

    % create a new document within the Document interface
    newDoc = wordDoc.Add;
end

% create a Word Selection Interface from the Application
selection = wordApp.Selection;

% create a Word InlineShape Interface from the Application
figure = newDoc.InlineShape;

%% OPEN FIGURE IMPORT IN DOCUMENT

% open specificied figure
% selection.

%disp('Picture display Configuration');
disp('Go to opened Word document and place pointer where figures must be inserted');
disp('Then come back and press any key to continue');
pause;

disp('Inserting Figures...');

[filename, pathname, filterindex] = uigetfile( ...
    { '*.png','PNG-files (*.png)'; ...
    '*.bmp','BMP-files (*.bmp)'; ...
    '*.jpg','JPEG-files (*.jpg)'; ...
    '*.*',  'All Files (*.*)'},'Select Image File',...
    'MultiSelect','on');

if (iscell(filename))
    max_par_length = length(filename);
else
    max_par_length = 1;
end

% initialize figures object
figures = [];

% figure scale factor - 4x pics in landscape view
scale = 0.49;
scale = 1;

% insert caption option
caption = input('Automated figure caption generation yes[1] no[0]: ');
par_values = 0;

if (caption)
    disp(' Parameter values guidelines ');
    disp(' --------------------------- ');
    disp(' ');
    disp(' 1 - Text array is entered as: {"text1" "text2" "text3"}');
    disp(' 2 - Number array is entered as: [1 2 3] or 1:1:3');
    disp('');
    disp(' NB: Parameters will be entered in sequence to their location in the caption title!!!!');
    disp('');
    caption_txt = input('Enter caption with %s indicating location parameter value : ','s');
    % find location of parameters
    par_loc = strfind(caption_txt,'%s');
end

%locate how many times
count = 1;
par_values = 0;

if (caption)
    disp(' ');
    disp(['Max Parameter varation length is : ' num2str(max_par_length)]);
    disp(' ');

    % enter correct
    while( length(par_values) ~= max_par_length)
        disp(' ');
        par_values = input(['Enter Parameter' num2str(count) ' value : ']);
    end

    % divide caption text in parts for parameter variation
    for i=1:1 % Only one parameter variation can be handled currently
        part{i} = caption_txt(1:par_loc(i)-1);
        part{i+1} = caption_txt(par_loc(i)+2:length(caption_txt));
    end
end

if (iscell(filename))
    for i = 1:length(filename)
        % center paragraph text
        selection.Paragraphs.Alignment = 'wdAlignParagraphCenter';
        %add picture
        figures{1,i} = AddPicture(figure,[pathname filename{1,i}]);

        % set size at 85% of original for two figures in a page
        fig_h = get(figures{1,i},'Height');
        fig_w = get(figures{1,i},'Width');
        set(figures{1,i},'Height',scale*fig_h);
        set(figures{1,i},'Width',scale*fig_w);

        % Move to next
        selection.Move;
        % Inserts a new, blank paragraph.
        selection.TypeParagraph;
        if (caption)
            % insert caption
            InsertCaption(selection,'Figure',[' ' part{1} num2str(par_values(i)) part{2}]);
            % center paragraph text
            selection.Paragraphs.Alignment = 'wdAlignParagraphCenter';
            % Inserts a new, blank paragraph
            selection.TypeParagraph;
        end
    end
else
    selection.Paragraphs.Alignment = 'wdAlignParagraphCenter'; % center text
    figures = AddPicture(figure,[pathname filename]);
    fig_h = get(figures,'Height');
    fig_w = get(figures,'Width');
    set(figures,'Height',scale*fig_h);
    set(figures,'Width',scale*fig_w);
    % Inserts a new, blank paragraph.
    selection.TypeParagraph;
end

%% SAVE & CLOSE DOCUMENT
if (opt == 2)
    close_doc = input('Save and Close Document Yes [1] No [0]: ');

    if (close_doc)
        invoke(newDoc,'Save');
        % close document once saved
        invoke(newDoc,'Close');
        % quit Word Application
        invoke(wordApp,'Quit');
    end

elseif (opt == 1)
    close_doc = input('Save and Close Document Yes [1] No [0]: ');

    if (close_doc)
        [filename, pathname, filterindex] = uiputfile( ...
            {  '*.doc','DOC-files (*.doc)'; ...
            '*.docx','DOCX-files (*.docx)'; ...
            '*.*',  'All Files (*.*)'},'Save Word Document');

        % save document
        invoke(newDoc,'SaveAs',[pathname filename]);

        % close document once saved
        invoke(newDoc,'Close');

        % quit Word Application
        invoke(wordApp,'Quit');
    end
end

