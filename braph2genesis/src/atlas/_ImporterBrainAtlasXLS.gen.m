%% ¡header!
ImporterBrainAtlasXLS < Importer (im, importer of brain atlas from XLS/XLSX) imports a brain atlas from an XLS/XLSX file.

%%% ¡description!
ImporterBrainAtlasXLS imports a brain atlas from an XLS/XLSX file.
The TXT file consists of 6 columns. It reads as follows: 
BrainAtlas ID (column 1), BrainAtlas LABEL (column 2),
BrainRegions (column 3-5; coordinates x, y, z, one per column) and 
BrainAtlas NOTES (column 6).

%%% ¡seealso!
Element, Importer, ExporterBrainAtlasXLS.

%% ¡props!

%%% ¡prop!
FILE (data, string) is the XLS/XLSX file from where to load the brain atlas.

%%% ¡prop!
BA (result, item) is a brain atlas.
%%%% ¡settings!
'BrainAtlas'
%%%% ¡default!
BrainAtlas()
%%%% ¡calculate!
% creates empty BrainAtlas
ba = BrainAtlas();

% analyzes file
file = im.memorize('FILE');
if isfile(file)
    f = waitbar(0, 'Reading File ...', 'Name', BRAPH2.NAME);
    set_icon(f)
    [~, ~, raw] = xlsread(file);

    % adds props
    waitbar(.15, f, 'Loading your data ...');
    ba.set( ...
        'ID', raw{1, 1}, ...
        'LABEL', raw{2, 1}, ...
        'NOTES', raw{3, 1} ...
        );
    
     idict = ba.get('BR_DICT');

    % adds brain regions
    waitbar(.3, f, 'Processing your data ...')
    n = size(raw, 1);
    for i = 5:1:n
        progress = (.65 * i ) / n;
        waitbar(.3 + progress, f, ['Loading Brain region: ' num2str(i) ' ...'])
        
        br = BrainRegion( ...
            'ID', raw{i, 1}, ...
            'LABEL', raw{i, 2}, ...
            'X', raw{i, 3}, ...
            'Y', raw{i, 4}, ...
            'Z', raw{i, 5}, ...
            'NOTES', raw{i, 6} ...
        );
       idict.add(br);
    end
    ba.set('br_dict', idict);
end
if exist('f', 'var')
    waitbar(1, f, 'Finishing')
    pause(.5)
    close(f)
end
value = ba;

%% ¡methods!
function uigetfile(im)
    % UIGETFILE opens a dialog box to set the XLS/XLSX file where to save the brain atlas.
    
    [filename, filepath, filterindex] = uigetfile({'*.xlsx';'*.xls'}, 'Select Excel file');
    if filterindex
        file = [filepath filename];
        im.set('FILE', file);
    end
end