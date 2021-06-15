function [target_dir, source_dir] = genesis(target_dir, source_dir, run_number)
%GENESIS generates BRAPH2.
%
% [TARGET_DIR, SOURCE_DIR] = GENESIS() generates BRAPH2 from the default
%  SOURCE_DIR (the directory that contains braph2genesis) to the default
%  TARGET_DIR (the directory 'braph2' in the superdirectory of SOURCE_DIR).
%
% GENESIS(TARGET_DIR) generates BRAPH2 in TARGET_DIR from the default
%  SOURCE_DIR.
%
% GENESIS(TARGET_DIR, SOURCE_DIR) generates BRAPH2 in TARGET_DIR from
%  SOURCE_DIR.
%
% GENESIS(TARGET_DIR, SOURCE_DIR, RUN_NUMBER) runs the creation scripts
%  RUN_NUMBER times. RUN_NUMBER = 2 improves the computational efficiency
%  of the code  mainly by hardcoding some intermediate values.
%
% See also braph2genesis, create_Element, create_test_Element.

fp = filesep();

if nargin < 3
    run_number = 1;
end

if nargin < 2 || isempty(source_dir)
    source_dir = fileparts(which('braph2genesis'));
end

if nargin < 1 || isempty(target_dir)
    target_dir = [fileparts(source_dir) fp 'braph2'];
end

disp('¡ BRAPH 2.0 Genesis')
disp(['¡ source dir: ' source_dir])
disp(['¡ target dir: ' target_dir])
disp(' ')

%% CREATE DIR STRUCTURE
% braph2
mkdir(target_dir)

disp('¡! created target dir')

% src
mkdir([target_dir fp 'src' fp 'util'])
mkdir([target_dir fp 'src' fp 'ds'])
mkdir([target_dir fp 'src' fp 'atlas'])
mkdir([target_dir fp 'src' fp 'cohort'])
mkdir([target_dir fp 'src' fp 'gt'])
mkdir([target_dir fp 'src' fp 'analysis'])
mkdir([target_dir fp 'src' fp 'gui'])
mkdir([target_dir fp 'src' fp 'nn'])

disp('¡! created dir structure - SRC')

% brainsurfs
mkdir([target_dir fp 'brainsurfs'])

disp('¡! created dir structure - BRAINGRAPHS')

% graphs
mkdir([target_dir fp 'graphs'])

disp('¡! created dir structure - GRAPHS')

% measures
mkdir([target_dir fp 'measures'])

disp('¡! created dir structure - MEASURES')

% workflows
mkdir([target_dir fp 'workflows'])

disp('¡! created dir structure - WORKFLOWS')

% test
mkdir([target_dir fp 'test'])

disp('¡! created dir structure - TEST')

disp(' ')

%% COPY READY FILES
% braph2.m and license.rtf
copyfile([source_dir fp 'braph2' fp 'braph2.m'], [target_dir fp 'braph2.m'])
copyfile([source_dir fp 'braph2license.rtf'], [target_dir fp 'braph2license.rtf'])
disp('¡! copied ready files - braph2')
disp(' ')

% src
copydir([source_dir fp 'src' fp 'util'], [target_dir fp 'src' fp 'util'])
disp('¡! copied ready files - util')
copydir([source_dir fp 'src' fp 'ds'], [target_dir fp 'src' fp 'ds'])
disp('¡! copied ready files - ds')
copydir([source_dir fp 'src' fp 'gt'], [target_dir fp 'src' fp 'gt'])
disp('¡! copied ready files - gt')
copydir([source_dir fp 'src' fp 'atlas'], [target_dir fp 'src' fp 'atlas'])
disp('¡! copied ready files - atlas')
copydir([source_dir fp 'src' fp 'cohort'], [target_dir fp 'src' fp 'cohort'])
disp('¡! copied ready files - cohort')
copydir([source_dir fp 'src' fp 'analysis'], [target_dir fp 'src' fp 'analysis'])
disp('¡! copied ready files - analysis')
copydir([source_dir fp 'src' fp 'gui'], [target_dir fp 'src' fp 'gui'])
disp('¡! copied ready files - gui')
copydir([source_dir fp 'src' fp 'nn'], [target_dir fp 'src' fp 'nn'])
disp('¡! copied ready files - nn')
disp(' ')

% graphs
copydir([source_dir fp 'graphs'], [target_dir fp 'graphs'], Inf)
disp('¡! copied ready files - graphs')
disp(' ')

% measures
copydir([source_dir fp 'measures'], [target_dir fp 'measures'], Inf)
disp('¡! copied ready files - measures')
disp(' ')

% brainsurfs
copydir([source_dir fp 'brainsurfs'], [target_dir fp 'brainsurfs'], Inf)
disp('¡! copied ready files - brainsurf')
disp(' ')

% workflows
copydir([source_dir fp 'workflows'], [target_dir fp 'workflows'], Inf)
disp('¡! copied ready files - brainsurf')
disp(' ')

% test
copydir([source_dir fp 'test'], [target_dir fp 'test'], Inf)
disp('¡! copied ready files - test')
disp(' ')

%% CREATE ELEMENTS
for run = 1:1:run_number
    
    disp(['¡! started run number ' int2str(run)])
    
    % src
    ds_gen_list = getGenerators([source_dir fp 'src' fp 'ds']);
    for i = 1:1:numel(ds_gen_list)
        create_Element([source_dir fp 'src' fp 'ds' fp ds_gen_list{i}], [target_dir fp 'src' fp 'ds'])
    end

    util_gen_list = getGenerators([source_dir fp 'src' fp 'util']);
    for i = 1:1:numel(util_gen_list)
        create_Element([source_dir fp 'src' fp 'util' fp util_gen_list{i}], [target_dir fp 'src' fp 'util'])
    end

    atlas_gen_list = getGenerators([source_dir fp 'src' fp 'atlas']);
    for i = 1:1:numel(atlas_gen_list)
        create_Element([source_dir fp 'src' fp 'atlas' fp atlas_gen_list{i}], [target_dir fp 'src' fp 'atlas'])
    end
    
    cohort_gen_list = getGenerators([source_dir fp 'src' fp 'cohort']);
    for i = 1:1:numel(cohort_gen_list)
        create_Element([source_dir fp 'src' fp 'cohort' fp cohort_gen_list{i}], [target_dir fp 'src' fp 'cohort'])
    end
    
    gt_gen_list = getGenerators([source_dir fp 'src' fp 'gt']);
    for i = 1:1:numel(gt_gen_list)
        create_Element([source_dir fp 'src' fp 'gt' fp gt_gen_list{i}], [target_dir fp 'src' fp 'gt'])
    end
    
    analysis_gen_list = getGenerators([source_dir fp 'src' fp 'analysis']);
    for i = 1:1:numel(analysis_gen_list)
        create_Element([source_dir fp 'src' fp 'analysis' fp analysis_gen_list{i}], [target_dir fp 'src' fp 'analysis'])
    end
    
    v = matlab.addons.installedAddons;
    result = all(ismember('Deep Learning Toolbox', v.Name) & ismember('Deep Learning Toolbox Converter for ONNX Model Format', v.Name));
    if result
        nn_gen_list = getGenerators([source_dir fp 'src' fp 'nn']);
        for i = 1:1:numel(nn_gen_list)
            create_Element([source_dir fp 'src' fp 'nn' fp nn_gen_list{i}], [target_dir fp 'src' fp 'nn'])
        end    
    else
        warning('Deep Learning Toolbox is not installed. Please refer to <a href="matlab: web(''https://se.mathworks.com/products/deep-learning.html'') ">Deep Learning Toolbox</a> and <a href="matlab: web(''https://se.mathworks.com/matlabcentral/fileexchange/67296-deep-learning-toolbox-converter-for-onnx-model-format'') ">Deep Learning Toolbox Converter for ONNX Model Format</a>');
    end
    
    % graphs
    graphs_gen_list = getGenerators([source_dir fp 'graphs']);
    for i = 1:1:numel(graphs_gen_list)
        create_Element([source_dir fp 'graphs' fp graphs_gen_list{i}], [target_dir fp 'graphs'])
    end
    
    % measures
    measures_gen_list = getGenerators([source_dir fp 'measures']);
    for i = 1:1:numel(measures_gen_list)
        create_Element([source_dir fp 'measures' fp measures_gen_list{i}], [target_dir fp 'measures'])
    end
    
    % gui
    gui_gen_list = getGenerators([source_dir fp 'src' fp 'gui']);
    for i = 1:1:numel(gui_gen_list)
        create_Element([source_dir fp 'src' fp 'gui' fp gui_gen_list{i}], [target_dir fp 'src' fp 'gui'])
    end
    
    % workflows
    workflows_contents = dir([source_dir fp 'workflows']);  % get the folder contents
    workflows_dir_list = workflows_contents([workflows_contents(:).isdir] == 1);  % remove all files (isdir property is 0)
    workflows_dir_list = workflows_dir_list(~ismember({workflows_dir_list(:).name}, {'.', '..'}));  % remove '.' and '..'
    for i = 1:1:length(workflows_dir_list)
        wf_name = workflows_dir_list(i).name;
        wf_gen_list = getGenerators([source_dir fp 'workflows' fp wf_name]);
        for j = 1:1:numel(wf_gen_list)
            create_Element([source_dir fp 'workflows' fp wf_name fp wf_gen_list{j}], [target_dir fp 'workflows' fp wf_name])
        end
    end
    
    % LOAD BRAPH2
    addpath(target_dir)
    braph2

    disp('¡! loaded BRAPH2')
    disp(' ')
    
    disp(['¡! completed run number ' int2str(run)])
    disp(' ')
end

%% CREATE TEST
% src
ds_gen_list = getGenerators([source_dir fp 'src' fp 'ds']);
for i = 1:1:numel(ds_gen_list)
    create_test_Element([source_dir fp 'src' fp 'ds' fp ds_gen_list{i}], [target_dir fp 'src' fp 'ds'])
end

util_gen_list = getGenerators([source_dir fp 'src' fp 'util']);
for i = 1:1:numel(util_gen_list)
    create_test_Element([source_dir fp 'src' fp 'util' fp util_gen_list{i}], [target_dir fp 'src' fp 'util'])
end

atlas_gen_list = getGenerators([source_dir fp 'src' fp 'atlas']);
for i = 1:1:numel(atlas_gen_list)
    create_test_Element([source_dir fp 'src' fp 'atlas' fp atlas_gen_list{i}], [target_dir fp 'src' fp 'atlas'])
end

cohort_gen_list = getGenerators([source_dir fp 'src' fp 'cohort']);
for i = 1:1:numel(cohort_gen_list)
    create_test_Element([source_dir fp 'src' fp 'cohort' fp cohort_gen_list{i}], [target_dir fp 'src' fp 'cohort'])
end

gt_gen_list = getGenerators([source_dir fp 'src' fp 'gt']);
for i = 1:1:numel(gt_gen_list)
    create_test_Element([source_dir fp 'src' fp 'gt' fp gt_gen_list{i}], [target_dir fp 'src' fp 'gt'])
end

analysis_gen_list = getGenerators([source_dir fp 'src' fp 'analysis']);
for i = 1:1:numel(analysis_gen_list)
    create_test_Element([source_dir fp 'src' fp 'analysis' fp analysis_gen_list{i}], [target_dir fp 'src' fp 'analysis'])
end

v = matlab.addons.installedAddons;
result = all(ismember('Deep Learning Toolbox', v.Name) & ismember('Deep Learning Toolbox Converter for ONNX Model Format', v.Name));
if result
    nn_gen_list = getGenerators([source_dir fp 'src' fp 'nn']);
    for i = 1:1:numel(nn_gen_list)
        create_test_Element([source_dir fp 'src' fp 'nn' fp nn_gen_list{i}], [target_dir fp 'src' fp 'nn'])
    end
end

% graphs
graphs_gen_list = getGenerators([source_dir fp 'graphs']);
for i = 1:1:numel(graphs_gen_list)
    create_test_Element([source_dir fp 'graphs' fp graphs_gen_list{i}], [target_dir fp 'graphs'])
end

% measures
measures_gen_list = getGenerators([source_dir fp 'measures']);
for i = 1:1:numel(measures_gen_list)
    create_test_Element([source_dir fp 'measures' fp measures_gen_list{i}], [target_dir fp 'measures'])
end

% gui
gui_gen_list = getGenerators([source_dir fp 'src' fp 'gui']);
for i = 1:1:numel(gui_gen_list)
    create_test_Element([source_dir fp 'src' fp 'gui' fp gui_gen_list{i}], [target_dir fp 'src' fp 'gui'])
end

% workflows
workflows_contents = dir([source_dir fp 'workflows']);  % get the folder contents
workflows_dir_list = workflows_contents([workflows_contents(:).isdir] == 1);  % remove all files (isdir property is 0)
workflows_dir_list = workflows_dir_list(~ismember({workflows_dir_list(:).name}, {'.', '..'}));  % remove '.' and '..'
for i = 1:1:length(workflows_dir_list)
    wf_name = workflows_dir_list(i).name;
    wf_gen_list = getGenerators([source_dir fp 'workflows' fp wf_name]);
    for j = 1:1:numel(wf_gen_list)
        create_test_Element([source_dir fp 'workflows' fp wf_name fp wf_gen_list{j}], [target_dir fp 'workflows' fp wf_name])
    end
end

end