format long

src_dir = [fileparts(which('braph2')) filesep 'src'];
addpath(src_dir)
addpath([src_dir filesep 'util'])
addpath([src_dir filesep 'ds'])
% addpath([src_dir filesep 'atlas'])
% addpath([src_dir filesep 'cohort'])
% addpath([src_dir filesep 'analysis'])
% addpath([src_dir filesep 'gt'])

% graphs_dir = [fileparts(which('braph2')) filesep 'graphs'];
% addpath(graphs_dir)

% measures_dir = [fileparts(which('braph2')) filesep 'measures'];
% addpath(measures_dir)

test_dir = [fileparts(which('braph2')) filesep 'test'];
addpath(test_dir)

% workflows_dir = [fileparts(which('braph2')) filesep 'workflows'];
% addpath(workflows_dir)
% workflows_dir_list = dir(workflows_dir);   % get the folder contents
% workflows_dir_list = workflows_dir_list([workflows_dir_list(:).isdir] == 1);  % remove all files (isdir property is 0)
% workflows_dir_list = workflows_dir_list(~ismember({workflows_dir_list(:).name}, {'.', '..'}));  % remove '.' and '..'
% for i = 1:1:length(workflows_dir_list)
%     addpath([workflows_dir filesep workflows_dir_list(i).name])
% end

clear src_dir graphs_dir measures_dir test_dir workflows_dir workflows_dir_list i