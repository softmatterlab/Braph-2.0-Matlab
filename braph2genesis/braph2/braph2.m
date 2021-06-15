%BRAPH2 - BRrain Analysis using graPH theory version 2.0
% This script loads all packages necessary to use BRAPH2.
%
% BRAPH2 packages:
%  <a href="matlab:help src         ">src</a>           - software core
%  <a href="matlab:help brainsurfs  ">brainsurfs</a>    - brainsurfs
%  <a href="matlab:help graphs      ">graphs</a>        - graphs
%  <a href="matlab:help measures    ">measures</a>      - measures
%  <a href="matlab:help workflows   ">workflows</a>     - workflows
%  <a href="matlab:help test        ">test</a>          - unit test

format long

src_dir = [fileparts(which('braph2')) filesep 'src'];
addpath(src_dir)
addpath([src_dir filesep 'util'])
addpath([src_dir filesep 'ds'])
addpath([src_dir filesep 'atlas'])
addpath([src_dir filesep 'cohort'])
addpath([src_dir filesep 'gt'])
addpath([src_dir filesep 'analysis'])
addpath([src_dir filesep 'gui'])
addpath([src_dir filesep 'nn'])

brainsurfs_dir = [fileparts(which('braph2')) filesep 'brainsurfs'];
addpath(brainsurfs_dir)

graphs_dir = [fileparts(which('braph2')) filesep 'graphs'];
addpath(graphs_dir)

measures_dir = [fileparts(which('braph2')) filesep 'measures'];
addpath(measures_dir)

test_dir = [fileparts(which('braph2')) filesep 'test'];
addpath(test_dir)

workflows_dir = [fileparts(which('braph2')) filesep 'workflows'];
addpath(workflows_dir)
workflows_dir_list = dir(workflows_dir); % get the folder contents
workflows_dir_list = workflows_dir_list([workflows_dir_list(:).isdir] == 1); % remove all files (isdir property is 0)
workflows_dir_list = workflows_dir_list(~ismember({workflows_dir_list(:).name}, {'.', '..'})); % remove '.' and '..'
for i = 1:1:length(workflows_dir_list)
    addpath([workflows_dir filesep workflows_dir_list(i).name])
end

clear src_dir brainsurfs_dir graphs_dir measures_dir test_dir workflows_dir workflows_dir_list i