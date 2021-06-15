%% ¡header!
ImporterGroupSubjectFUNTXT < Importer (im, importer of FUN subject group from TXT) imports a group of subjects with connectivity data from a series of TXT file.

%%% ¡description!
ImporterGroupSubjectFUNTXT imports a group of subjects with connectivity data from a series of TXT file and their covariates (optional) from another TXT file.
All these files must be in the same folder; also, no other files should be in the folder.
Each file contains a table with each row correspoding to a time serie and each column to a brain region.
The TXT file containing the covariates must be inside another folder in the same group directory 
and consists of the following columns:
Subject ID (column 1), Subject AGE (column 2), and Subject SEX (column 3).
The first row contains the headers and each subsequent row the values for each subject.

%%% ¡seealso!
Element, Importer, ExporterGroupSubjectFUNTXT

%% ¡props!

%%% ¡prop!
DIRECTORY (data, string) is the directory containing the FUN subject group files from which to load the subject group.

%%% ¡prop!
BA (data, item) is a brain atlas.
%%%% ¡settings!
'BrainAtlas'

%%% ¡prop!
GR (result, item) is a group of subjects with functional data.
%%%% ¡settings!
'Group'
%%%% ¡check_value!
check = any(strcmp(value.get(Group.SUB_CLASS_TAG), subclasses('SubjectFUN', [], [], true))); % Format.checkFormat(Format.ITEM, value, 'Group') already checked
%%%% ¡default!
Group('SUB_CLASS', 'SubjectFUN', 'SUB_DICT', IndexedDictionary('IT_CLASS', 'SubjectFUN'))
%%%% ¡calculate!
% creates empty Group
gr = Group( ...
    'SUB_CLASS', 'SubjectFUN', ...
    'SUB_DICT', IndexedDictionary('IT_CLASS', 'SubjectFUN') ...
    );

directory = im.get('DIRECTORY');

if isfolder(directory)
    % sets group props
    f = waitbar(0, 'Reading Directory ...', 'Name', BRAPH2.NAME);
    set_icon(f)
    [~, name] = fileparts(directory);
    gr.set( ...
        'ID', name, ...
        'LABEL', name, ...
        'NOTES', ['Group loaded from ' directory] ...
        );
    
    % analyzes file
    files = dir(fullfile(directory, '*.txt'));
    
    % Check if there are covariates to add (age and sex)
    cov_folder = dir(directory);
    cov_folder = cov_folder([cov_folder(:).isdir] == 1);
    cov_folder = cov_folder(~ismember({cov_folder(:).name}, {'.', '..'}));
    if ~isempty(cov_folder)
        file_cov = dir(fullfile([directory filesep() cov_folder.name], '*.txt'));
        raw_covariates = readtable([directory filesep() cov_folder.name filesep() file_cov.name], 'Delimiter', '	');
        age = raw_covariates{:, 2};
        sex = raw_covariates{:, 3};
    else
        age = ones(length(files), 1);
        unassigned =  {'unassigned'};
        sex = unassigned(ones(length(files), 1));
    end
    
    waitbar(.15, f, 'Loading your data ...');
    if length(files) > 0        
        % brain atlas
        ba = im.get('BA');
        br_number = ba.get('BR_DICT').length;
        subdict = gr.get('SUB_DICT');
        
        % adds subjects
        n = length(files);
        for i = 1:1:n
            progress = (.65 * i ) / n;
            waitbar(.3 + progress, f, ['Loading Brain region: ' num2str(i) ' ...'])
            % read file
            FUN = table2array(readtable(fullfile(directory, files(i).name), 'Delimiter', '	'));
            
            % brain atlas
            ba = im.get('BA');
            br_number = size(FUN, 2);   
            if ba.get('BR_DICT').length ~= br_number
                ba = BrainAtlas();
                idict = ba.get('BR_DICT');
                for j = 1:1:br_number
                    br_id = ['br' int2str(j)];
                    br = BrainRegion('ID', br_id);
                    idict.add(br)
                end
                ba.set('br_dict', idict);
            end
            subdict = gr.get('SUB_DICT');
            
            [~, sub_id] = fileparts(files(i).name);
            sub = SubjectFUN( ...
                'ID', sub_id, ...
                'BA', ba, ...
                'age', age(i), ...
                'sex', sex{i} ...
                );
            
            sub.set('FUN', FUN);
            subdict.add(sub);
        end
        gr.set('sub_dict', subdict);
    end
end
if exist('f', 'var')
    waitbar(1, f, 'Finishing')
    pause(.5)
    close(f)
end
value = gr;

%% ¡methods!
function uigetdir(im)
    % UIGETDIR opens a dialog box to set the directory from where to load the TXT files of the FUN subject group.

    directory = uigetdir('Select directory');
    if isfolder(directory)
        im.set('DIRECTORY', directory);
    end
end