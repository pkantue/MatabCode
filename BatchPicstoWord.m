% This is script to import pictures into word document
% through using the various directories

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

% Get the figure that are common in each containing folder
%{
[filename, pathname, filterindex] = uigetfile( ...
    { '*.png','PNG-files (*.png)'; ...
    '*.bmp','BMP-files (*.bmp)'; ...
    '*.jpg','JPEG-files (*.jpg)'; ...
    '*.*',  'All Files (*.*)'},'Select Image File(s)',...
    'MultiSelect','on');
%}
% get the master directory
d_ir = cd;
master_dir = uigetdir([d_ir '\']);

% subfolder group
sub_fold1 = {'scenario1' 'scenario2' 'scenario3' 'scenario4' 'scenario5' ...
    'scenario6' 'scenario7'};
par_name1 = {'Scenario 1' 'Scenario 2' 'Scenario 3' 'Scenario 4' 'Scenario 5' ...
    'Scenario 6' 'Scenario 7'};

sub_fold2 = {'1 - 3DR' '2 - FCR' '3 - EOD'};
par_name2 = {'3DR' 'FCR' 'EOD'};

sub_fold3 = {'Azi_0' 'Azi_45' 'Azi_90' 'Azi_135' 'Azi_180' 'Azi_225' ...
    'Azi_270' 'Azi_315'};
par_name3 = {'0' '45' '90' '135' '180' '225' ...
    '270' '315'};

% initialize figures object
figures = [];

% insert caption option
caption = input('Automated figure caption generation yes[1] no[0]: ');
%num_pics = input('Number of figures per page (multiples of 2"s): ');

% figure scale factor
num_pics = 4; %length(filename);

scale = 1;
if(num_pics == 1)scale = 1; end
if(num_pics == 2)scale = 0.75; end
if(num_pics == 4)scale = 0.47; end

% setup pathname
% NOTE:
% THIS IS SPECIFIC TO JAVELIN SYSTEM PERFORMANCE ANALYSIS
for j=1:length(sub_fold1)
    temp_name = sub_fold1{1,j};
    % establish filenames
    if (strcmp(temp_name,'scenario1')) || (strcmp(temp_name,'scenario2')) || (strcmp(temp_name,'scenario6')) || (strcmp(temp_name,'scenario7'))
        filename = {'Flight_time_Range_Profile.png' ...
            'Mach_f_range_Profile.png' ...
            'Phit5m_f_Range_Profile.png' ...
            'Pscan_f_Range_Profile.png'};
    elseif (strcmp(temp_name,'scenario3'))
        filename = {'Phit5m_f_Range_Profile.png' ...
            'Phit5m_Alt_f_Profile.png' ...
            'Pscan_f_Range_Profile.png' ...
            'Pscan_Alt_f_Profile.png'};
    elseif (strcmp(temp_name,'scenario4')) || (strcmp(temp_name,'scenario5'))
        filename = {'Phit10m_f_Range_Profile.png' ...
            'Phit10m_Alt_f_Profile.png' ...
            'Pscan_f_Range_Profile.png' ...
            'Pscan_Alt_f_Profile.png'};
    end
        
    
    for k=1:length(sub_fold2)
        for z=1:length(sub_fold3)
            pathname = [master_dir '\' sub_fold1{1,j} '\' sub_fold2{1,k}...
                '\' sub_fold3{1,z} '\'];

            % setup caption
            fig_desc = [' ' par_name1{1,j} ' vs ' par_name2{1,k} ' Radar ' ...
                'at ' par_name3{1,z} ' deg Azimuth w.r.t. Ship Heading'];
                f_count = length(filename);
            if (iscell(filename))
                for i = 1:length(filename)
                    % center paragraph text
                    selection.Paragraphs.Alignment = 'wdAlignParagraphCenter';
                    %add picture
                    figures{1,i} = AddPicture(figure,[pathname filename{1,f_count}]);
                    % set size at 85% of original for two figures in a page
                    fig_h = get(figures{1,i},'Height');
                    fig_w = get(figures{1,i},'Width');
                    set(figures{1,i},'Height',scale*fig_h);
                    set(figures{1,i},'Width',scale*fig_w);
                    f_count = f_count - 1;                    
                end
                for i=1:length(filename) selection.Move; end

                % Move to next
                selection.Text = ' ';
                % Inserts a new, blank paragraph.
                selection.TypeParagraph;
                if (caption)
                    % insert caption
                    InsertCaption(selection,'Figure',fig_desc);
                    % center paragraph text
                    selection.Paragraphs.Alignment = 'wdAlignParagraphCenter';
                    % Inserts a new, blank paragraph.
                    selection.TypeParagraph;
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
        end
    end
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