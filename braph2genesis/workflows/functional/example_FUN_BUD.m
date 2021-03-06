%EXAMPLE_FUN_BUD
% Script example workflow FUN BUD

clear variables %#ok<*NASGU>

%% Load BrainAtlas
im_ba = ImporterBrainAtlasXLS('FILE', [fileparts(which('example_FUN_BUD')) filesep 'example data FUN (fMRI)' filesep 'desikan_atlas.xlsx']);

ba = im_ba.get('BA');

%% Load Groups of SubjectFUN
im_gr1 = ImporterGroupSubjectFUNXLS( ...
    'DIRECTORY', [fileparts(which('example_FUN_BUD')) filesep 'example data FUN (fMRI)' filesep 'xls' filesep 'GroupName1'], ...
    'BA', ba ...
    );

gr1 = im_gr1.get('GR');

im_gr2 = ImporterGroupSubjectFUNXLS( ...
    'DIRECTORY', [fileparts(which('example_FUN_BUD')) filesep 'example data FUN (fMRI)' filesep 'xls' filesep 'GroupName2'], ...
    'BA', ba ...
    );

gr2 = im_gr2.get('GR');

%% Analysis FUN BUD
densities = [0 100];
a_BUD1 = AnalyzeEnsemble_FUN_BUD( ...
    'GR', gr1, ...
    'DENSITIES', densities ...
    );

a_BUD2 = AnalyzeEnsemble_FUN_BUD( ...
    'GR', gr2, ...
    'DENSITIES', densities ...
    );

% measure calculation
degree_BUD1 = a_BUD1.getMeasureEnsemble('Degree').get('M');
degree_av_BUD1 = a_BUD1.getMeasureEnsemble('DegreeAv').get('M');
distance_BUD1 = a_BUD1.getMeasureEnsemble('Distance').get('M');

degree_BUD2 = a_BUD2.getMeasureEnsemble('Degree').get('M');
degree_av_BUD2 = a_BUD2.getMeasureEnsemble('DegreeAv').get('M');
distance_BUD2 = a_BUD2.getMeasureEnsemble('Distance').get('M');

% comparison
c_BUD = CompareEnsemble( ...
    'P', 10, ...
    'A1', a_BUD1, ...
    'A2', a_BUD2, ...
    'VERBOSE', true, ...
    'MEMORIZE', true ...
    );

degree_BUD_p1 = c_BUD.getComparison('Degree').get('P1');
degree_BUD_p2 = c_BUD.getComparison('Degree').get('P2');
degree_BUD_cil = c_BUD.getComparison('Degree').get('CIL');
degree_BUD_ciu = c_BUD.getComparison('Degree').get('CIU');

degree_av_BUD_p1 = c_BUD.getComparison('DegreeAv').get('P1');
degree_av_BUD_p2 = c_BUD.getComparison('DegreeAv').get('P2');
degree_av_BUD_cil = c_BUD.getComparison('DegreeAv').get('CIL');
degree_av_BUD_ciu = c_BUD.getComparison('DegreeAv').get('CIU');

distance_BUD_p1 = c_BUD.getComparison('Distance').get('P1');
distance_BUD_p2 = c_BUD.getComparison('Distance').get('P2');
distance_BUD_cil = c_BUD.getComparison('Distance').get('CIL');
distance_BUD_ciu = c_BUD.getComparison('Distance').get('CIU');