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
    target_dir = [fileparts(source_dir) fp 'braph2tmp'];
end

disp('¡ BRAPH 2.0 Genesis')
disp(['¡ source dir: ' source_dir])
disp(['¡ target dir: ' target_dir])
disp(' ')

%% CREATE DIR STRUCTURE
% braph2
mkdir(target_dir)

disp('¡¡¡! created target dir')

% src
mkdir([target_dir fp 'src' fp 'util'])
mkdir([target_dir fp 'src' fp 'ds'])
% mkdir([target_dir fp 'src' fp 'atlas'])
% mkdir([target_dir fp 'src' fp 'cohort'])
% mkdir([target_dir fp 'src' fp 'analysis'])
% mkdir([target_dir fp 'src' fp 'gt'])

disp('¡! created dir structure - SRC')

% % graphs
% mkdir([target_dir fp 'graphs'])
% 
% disp('¡! created dir structure - GRAPHS')
% 
% % measures
% mkdir([target_dir fp 'measures'])
% 
% disp('¡! created dir structure - MEASURES')
% 
% % workflows
% mkdir([target_dir fp 'workflows'])
% mkdir([target_dir fp 'workflows' fp 'structural'])
% mkdir([target_dir fp 'workflows' fp 'functional'])
% mkdir([target_dir fp 'workflows' fp 'connectivity'])
% 
% disp('¡! created dir structure - WORKFLOWS')

% test
mkdir([target_dir fp 'test'])

disp('¡! created dir structure - TEST')

disp(' ')

%% COPY READY FILES
% braph2.m and license.rtf
copyfile([source_dir fp 'braph2' fp 'braph2.m'], [target_dir fp 'braph2.m'])
copyfile([source_dir fp 'license.rtf'], [target_dir fp 'license.rtf'])
disp('¡! copied ready files - braph2')

% src
copyfile([source_dir fp 'src' fp 'util' fp 'BRAPH2.m'], [target_dir fp 'src' fp 'util' fp 'BRAPH2.m'])
copyfile([source_dir fp 'src' fp 'util' fp 'tostring.m'], [target_dir fp 'src' fp 'util' fp 'tostring.m'])
copyfile([source_dir fp 'src' fp 'util' fp 'subclasses.m'], [target_dir fp 'src' fp 'util' fp 'subclasses.m'])
% copyfile([source_dir fp 'src' fp 'util' fp 'clean_varargin.m'], [target_dir fp 'src' fp 'util' fp 'clean_varargin.m'])
% copyfile([source_dir fp 'src' fp 'util' fp 'test_clean_varargin.m'], [target_dir fp 'src' fp 'util' fp 'test_clean_varargin.m'])
% copyfile([source_dir fp 'src' fp 'util' fp 'copy_varargin.m'], [target_dir fp 'src' fp 'util' fp 'copy_varargin.m'])
% copyfile([source_dir fp 'src' fp 'util' fp 'test_copy_varargin.m'], [target_dir fp 'src' fp 'util' fp 'test_copy_varargin.m'])
% copyfile([source_dir fp 'src' fp 'util' fp 'get_from_varargin.m'], [target_dir fp 'src' fp 'util' fp 'get_from_varargin.m'])
% copyfile([source_dir fp 'src' fp 'util' fp 'test_get_from_varargin.m'], [target_dir fp 'src' fp 'util' fp 'test_get_from_varargin.m'])
disp('¡! copied ready files - util')

copyfile([source_dir fp 'src' fp 'ds' fp 'Category.m'], [target_dir fp 'src' fp 'ds' fp 'Category.m'])
copyfile([source_dir fp 'src' fp 'ds' fp 'test_Category.m'], [target_dir fp 'src' fp 'ds' fp 'test_Category.m'])
copyfile([source_dir fp 'src' fp 'ds' fp 'Format.m'], [target_dir fp 'src' fp 'ds' fp 'Format.m'])
copyfile([source_dir fp 'src' fp 'ds' fp 'test_Format.m'], [target_dir fp 'src' fp 'ds' fp 'test_Format.m'])
copyfile([source_dir fp 'src' fp 'ds' fp 'Element.m'], [target_dir fp 'src' fp 'ds' fp 'Element.m'])
copyfile([source_dir fp 'src' fp 'ds' fp 'test_Element.m'], [target_dir fp 'src' fp 'ds' fp 'test_Element.m'])
disp('¡! copied ready files - ds')

% copyfile([source_dir fp 'src' fp 'gt' fp 'histogram.m'], [target_dir fp 'src' fp 'gt' fp 'histogram.m'])
% copyfile([source_dir fp 'src' fp 'gt' fp 'binarize.m'], [target_dir fp 'src' fp 'gt' fp 'binarize.m'])
% copyfile([source_dir fp 'src' fp 'gt' fp 'test_binarize.m'], [target_dir fp 'src' fp 'gt' fp 'test_binarize.m'])
% copyfile([source_dir fp 'src' fp 'gt' fp 'dediagonalize.m'], [target_dir fp 'src' fp 'gt' fp 'dediagonalize.m'])
% copyfile([source_dir fp 'src' fp 'gt' fp 'test_dediagonalize.m'], [target_dir fp 'src' fp 'gt' fp 'test_dediagonalize.m'])
% copyfile([source_dir fp 'src' fp 'gt' fp 'diagonalize.m'], [target_dir fp 'src' fp 'gt' fp 'diagonalize.m'])
% copyfile([source_dir fp 'src' fp 'gt' fp 'test_diagonalize.m'], [target_dir fp 'src' fp 'gt' fp 'test_diagonalize.m'])
% copyfile([source_dir fp 'src' fp 'gt' fp 'semipositivize.m'], [target_dir fp 'src' fp 'gt' fp 'semipositivize.m'])
% copyfile([source_dir fp 'src' fp 'gt' fp 'test_semipositivize.m'], [target_dir fp 'src' fp 'gt' fp 'test_semipositivize.m'])
% copyfile([source_dir fp 'src' fp 'gt' fp 'standardize.m'], [target_dir fp 'src' fp 'gt' fp 'standardize.m'])
% copyfile([source_dir fp 'src' fp 'gt' fp 'test_standardize.m'], [target_dir fp 'src' fp 'gt' fp 'test_standardize.m'])
% copyfile([source_dir fp 'src' fp 'gt' fp 'symmetrize.m'], [target_dir fp 'src' fp 'gt' fp 'symmetrize.m'])
% copyfile([source_dir fp 'src' fp 'gt' fp 'test_symmetrize.m'], [target_dir fp 'src' fp 'gt' fp 'test_symmetrize.m'])
% disp('¡! copied ready files - gt')
% 
% copyfile([source_dir fp 'src' fp 'analysis' fp 'Correlation.m'], [target_dir fp 'src' fp 'analysis' fp 'Correlation.m'])
% copyfile([source_dir fp 'src' fp 'analysis' fp 'test_Correlation.m'], [target_dir fp 'src' fp 'analysis' fp 'test_Correlation.m'])
% copyfile([source_dir fp 'src' fp 'analysis' fp 'permutation.m'], [target_dir fp 'src' fp 'analysis' fp 'permutation.m'])
% copyfile([source_dir fp 'src' fp 'analysis' fp 'test_permutation.m'], [target_dir fp 'src' fp 'analysis' fp 'test_permutation.m'])
% copyfile([source_dir fp 'src' fp 'analysis' fp 'pvalue1.m'], [target_dir fp 'src' fp 'analysis' fp 'pvalue1.m'])
% copyfile([source_dir fp 'src' fp 'analysis' fp 'test_pvalue1.m'], [target_dir fp 'src' fp 'analysis' fp 'test_pvalue1.m'])
% copyfile([source_dir fp 'src' fp 'analysis' fp 'pvalue2.m'], [target_dir fp 'src' fp 'analysis' fp 'pvalue2.m'])
% copyfile([source_dir fp 'src' fp 'analysis' fp 'test_pvalue2.m'], [target_dir fp 'src' fp 'analysis' fp 'test_pvalue2.m'])
% copyfile([source_dir fp 'src' fp 'analysis' fp 'bonferroni.m'], [target_dir fp 'src' fp 'analysis' fp 'bonferroni.m'])
% copyfile([source_dir fp 'src' fp 'analysis' fp 'test_bonferroni.m'], [target_dir fp 'src' fp 'analysis' fp 'test_bonferroni.m'])
% copyfile([source_dir fp 'src' fp 'analysis' fp 'fdr.m'], [target_dir fp 'src' fp 'analysis' fp 'fdr.m'])
% copyfile([source_dir fp 'src' fp 'analysis' fp 'test_fdr.m'], [target_dir fp 'src' fp 'analysis' fp 'test_fdr.m'])
% copyfile([source_dir fp 'src' fp 'analysis' fp 'quantiles.m'], [target_dir fp 'src' fp 'analysis' fp 'quantiles.m'])
% copyfile([source_dir fp 'src' fp 'analysis' fp 'test_quantiles.m'], [target_dir fp 'src' fp 'analysis' fp 'test_quantiles.m'])
% disp('¡! copied ready files - analysis')
% 
% disp(' ')
% 
% % workflows
% copyfile([source_dir fp 'workflows' fp 'structural' fp 'example_ST.m'], [target_dir fp 'workflows' fp 'structural' fp 'example_ST.m'])
% mkdir([target_dir fp 'workflows' fp 'structural' fp 'example data ST (MRI)'])
% copyfile([source_dir fp 'workflows' fp 'structural' fp 'example data ST (MRI)' fp 'desikan_atlas.xlsx'], [target_dir fp 'workflows' fp 'structural' fp 'example data ST (MRI)' fp 'desikan_atlas.xlsx'])
% mkdir([target_dir fp 'workflows' fp 'structural' fp 'example data ST (MRI)' fp 'xls'])
% copyfile([source_dir fp 'workflows' fp 'structural' fp 'example data ST (MRI)' fp 'xls' fp 'ST_group1.xlsx'], [target_dir fp 'workflows' fp 'structural' fp 'example data ST (MRI)' fp 'xls' fp 'ST_group1.xlsx'])
% copyfile([source_dir fp 'workflows' fp 'structural' fp 'example data ST (MRI)' fp 'xls' fp 'ST_group2.xlsx'], [target_dir fp 'workflows' fp 'structural' fp 'example data ST (MRI)' fp 'xls' fp 'ST_group2.xlsx'])
% disp('¡! copied ready files - workflow structural')
% 
% copyfile([source_dir fp 'workflows' fp 'functional' fp 'example_FUN.m'], [target_dir fp 'workflows' fp 'functional' fp 'example_FUN.m'])
% mkdir([target_dir fp 'workflows' fp 'functional' fp 'example data FUN (fMRI)'])
% copyfile([source_dir fp 'workflows' fp 'functional' fp 'example data FUN (fMRI)' fp 'desikan_atlas.xlsx'], [target_dir fp 'workflows' fp 'functional' fp 'example data FUN (fMRI)' fp 'desikan_atlas.xlsx'])
% mkdir([target_dir fp 'workflows' fp 'functional' fp 'example data FUN (fMRI)' fp 'xls'])
% mkdir([target_dir fp 'workflows' fp 'functional' fp 'example data FUN (fMRI)' fp 'xls' fp 'GroupName1'])
% for i = 1:1:10
%     copyfile([source_dir fp 'workflows' fp 'functional' fp 'example data FUN (fMRI)' fp 'xls' fp 'GroupName1' fp 'subject' int2str(i) '.xlsx'], [target_dir fp 'workflows' fp 'functional' fp 'example data FUN (fMRI)' fp 'xls' fp 'GroupName1' fp 'subject' int2str(i) '.xlsx'])
% end
% mkdir([target_dir fp 'workflows' fp 'functional' fp 'example data FUN (fMRI)' fp 'xls' fp 'GroupName2'])
% for i = 11:1:20
%     copyfile([source_dir fp 'workflows' fp 'functional' fp 'example data FUN (fMRI)' fp 'xls' fp 'GroupName2' fp 'subject' int2str(i) '.xlsx'], [target_dir fp 'workflows' fp 'functional' fp 'example data FUN (fMRI)' fp 'xls' fp 'GroupName2' fp 'subject' int2str(i) '.xlsx'])
% end
% disp('¡! copied ready files - workflow functional')
% 
% copyfile([source_dir fp 'workflows' fp 'connectivity' fp 'example_CON.m'], [target_dir fp 'workflows' fp 'connectivity' fp 'example_CON.m'])
% mkdir([target_dir fp 'workflows' fp 'connectivity' fp 'example data CON (DTI)'])
% copyfile([source_dir fp 'workflows' fp 'connectivity' fp 'example data CON (DTI)' fp 'desikan_atlas.xlsx'], [target_dir fp 'workflows' fp 'connectivity' fp 'example data CON (DTI)' fp 'desikan_atlas.xlsx'])
% mkdir([target_dir fp 'workflows' fp 'connectivity' fp 'example data CON (DTI)' fp 'xls'])
% mkdir([target_dir fp 'workflows' fp 'connectivity' fp 'example data CON (DTI)' fp 'xls' fp 'GroupName1'])
% for i = 1:1:5
%     copyfile([source_dir fp 'workflows' fp 'connectivity' fp 'example data CON (DTI)' fp 'xls' fp 'GroupName1' fp 'SubjectID' int2str(i) '.xlsx'], [target_dir fp 'workflows' fp 'connectivity' fp 'example data CON (DTI)' fp 'xls' fp 'GroupName1' fp 'SubjectID' int2str(i) '.xlsx'])
% end
% mkdir([target_dir fp 'workflows' fp 'connectivity' fp 'example data CON (DTI)' fp 'xls' fp 'GroupName2'])
% for i = 1:1:5
%     copyfile([source_dir fp 'workflows' fp 'connectivity' fp 'example data CON (DTI)' fp 'xls' fp 'GroupName2' fp 'subject_' int2str(i) '.xlsx'], [target_dir fp 'workflows' fp 'connectivity' fp 'example data CON (DTI)' fp 'xls' fp 'GroupName2' fp 'subject_' int2str(i) '.xlsx'])
% end
% disp('¡! copied ready files - workflow connectivity')
% 
% disp(' ')

% test
copyfile([source_dir fp 'test' fp 'test_braph2.m'], [target_dir fp 'test' fp 'test_braph2.m'])
copyfile([source_dir fp 'test' fp 'assert_with_error.m'], [target_dir fp 'test' fp 'assert_with_error.m'])
% copyfile([source_dir fp 'test' fp 'DummyObject.m'], [target_dir fp 'test' fp 'DummyObject.m'])
% copyfile([source_dir fp 'test' fp 'DummyCopiableObject.m'], [target_dir fp 'test' fp 'DummyCopiableObject.m'])
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

    % atlas_gen_list = getGenerators([source_dir fp 'src' fp 'atlas']);
    % for i = 1:1:numel(atlas_gen_list)
    %     create_Element([source_dir fp 'src' fp 'atlas' fp atlas_gen_list{i}], [target_dir fp 'src' fp 'atlas'])
    % end
    % 
    % cohort_gen_list = getGenerators([source_dir fp 'src' fp 'cohort']);
    % for i = 1:1:numel(cohort_gen_list)
    %     create_Element([source_dir fp 'src' fp 'cohort' fp cohort_gen_list{i}], [target_dir fp 'src' fp 'cohort'])
    % end
    % 
    % gt_gen_list = getGenerators([source_dir fp 'src' fp 'gt']);
    % for i = 1:1:numel(gt_gen_list)
    %     create_Element([source_dir fp 'src' fp 'gt' fp gt_gen_list{i}], [target_dir fp 'src' fp 'gt'])
    % end
    % 
    % analysis_gen_list = getGenerators([source_dir fp 'src' fp 'analysis']);
    % for i = 1:1:numel(analysis_gen_list)
    %     create_Element([source_dir fp 'src' fp 'analysis' fp analysis_gen_list{i}], [target_dir fp 'src' fp 'analysis'])
    % end
    % 
    % % graphs
    % graphs_gen_list = getGenerators([source_dir fp 'graphs']);
    % for i = 1:1:numel(graphs_gen_list)
    %     create_Element([source_dir fp 'graphs' fp graphs_gen_list{i}], [target_dir fp 'graphs'])
    % end
    % 
    % % measures
    % measures_gen_list = getGenerators([source_dir fp 'measures']);
    % for i = 1:1:numel(measures_gen_list)
    %     create_Element([source_dir fp 'measures' fp measures_gen_list{i}], [target_dir fp 'measures'])
    % end
    % 
    % % worksflows
    % wf_structural_gen_list = getGenerators([source_dir fp 'workflows' fp 'structural']);
    % for i = 1:1:numel(wf_structural_gen_list)
    %     create_Element([source_dir fp 'workflows' fp 'structural' fp wf_structural_gen_list{i}], [target_dir fp 'workflows' fp 'structural'])
    % end
    % 
    % wf_functional_gen_list = getGenerators([source_dir fp 'workflows' fp 'functional']);
    % for i = 1:1:numel(wf_functional_gen_list)
    %     create_Element([source_dir fp 'workflows' fp 'functional' fp wf_functional_gen_list{i}], [target_dir fp 'workflows' fp 'functional'])
    % end
    % 
    % wf_connectivity_gen_list = getGenerators([source_dir fp 'workflows' fp 'connectivity']);
    % for i = 1:1:numel(wf_connectivity_gen_list)
    %     create_Element([source_dir fp 'workflows' fp 'connectivity' fp wf_connectivity_gen_list{i}], [target_dir fp 'workflows' fp 'connectivity'])
    % end
    
    disp(['¡! completed run number ' int2str(run)])
    disp(' ')
end

%% LOAD BRAPH2
addpath(target_dir)
braph2

disp('¡! loaded BRAPH2')
disp(' ')

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

% atlas_gen_list = getGenerators([source_dir fp 'src' fp 'atlas']);
% for i = 1:1:numel(atlas_gen_list)
%     create_test_Element([source_dir fp 'src' fp 'atlas' fp atlas_gen_list{i}], [target_dir fp 'src' fp 'atlas'])
% end
% 
% cohort_gen_list = getGenerators([source_dir fp 'src' fp 'cohort']);
% for i = 1:1:numel(cohort_gen_list)
%     create_test_Element([source_dir fp 'src' fp 'cohort' fp cohort_gen_list{i}], [target_dir fp 'src' fp 'cohort'])
% end
% 
% gt_gen_list = getGenerators([source_dir fp 'src' fp 'gt']);
% for i = 1:1:numel(gt_gen_list)
%     create_test_Element([source_dir fp 'src' fp 'gt' fp gt_gen_list{i}], [target_dir fp 'src' fp 'gt'])
% end
% 
% analysis_gen_list = getGenerators([source_dir fp 'src' fp 'analysis']);
% for i = 1:1:numel(analysis_gen_list)
%     create_test_Element([source_dir fp 'src' fp 'analysis' fp analysis_gen_list{i}], [target_dir fp 'src' fp 'analysis'])
% end
% 
% % graphs
% graphs_gen_list = getGenerators([source_dir fp 'graphs']);
% for i = 1:1:numel(graphs_gen_list)
%     create_test_Element([source_dir fp 'graphs' fp graphs_gen_list{i}], [target_dir fp 'graphs'])
% end
% 
% % measures
% measures_gen_list = getGenerators([source_dir fp 'measures']);
% for i = 1:1:numel(measures_gen_list)
%     create_test_Element([source_dir fp 'measures' fp measures_gen_list{i}], [target_dir fp 'measures'])
% end
% 
% % workflows
% wf_structural_gen_list = getGenerators([source_dir fp 'workflows' fp 'structural']);
% for i = 1:1:numel(wf_structural_gen_list)
%     create_test_Element([source_dir fp 'workflows' fp 'structural' fp wf_structural_gen_list{i}], [target_dir fp 'workflows' fp 'structural'])
% end
% 
% wf_functional_gen_list = getGenerators([source_dir fp 'workflows' fp 'functional']);
% for i = 1:1:numel(wf_functional_gen_list)
%     create_test_Element([source_dir fp 'workflows' fp 'functional' fp wf_functional_gen_list{i}], [target_dir fp 'workflows' fp 'functional'])
% end
% 
% wf_connectivity_gen_list = getGenerators([source_dir fp 'workflows' fp 'connectivity']);
% for i = 1:1:numel(wf_connectivity_gen_list)
%     create_test_Element([source_dir fp 'workflows' fp 'connectivity' fp wf_connectivity_gen_list{i}], [target_dir fp 'workflows' fp 'connectivity'])
% end

end