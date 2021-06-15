%EXAMPLE_CON_WU_NN_CLASSIFICATION
% Script example workflow CON WU

clear variables %#ok<*NASGU>

%% Load BrainAtlas
im_ba = ImporterBrainAtlasXLS('FILE', [fileparts(which('example_CON_WU')) filesep 'example data CON (DTI)' filesep 'desikan_atlas.xlsx']);

ba = im_ba.get('BA');

%% Load Groups of SubjectCON
im_gr1 = ImporterGroupSubjectCONXLS( ...
    'DIRECTORY', [fileparts(which('example_CON_WU')) filesep 'example data CON (DTI)' filesep 'xls' filesep 'GroupName1'], ...
    'BA', ba ...
    );

gr1 = im_gr1.get('GR');

im_gr2 = ImporterGroupSubjectCONXLS( ...
    'DIRECTORY', [fileparts(which('example_CON_WU')) filesep 'example data CON (DTI)' filesep 'xls' filesep 'GroupName2'], ...
    'BA', ba ...
    );

gr2 = im_gr2.get('GR');

%% Neural networls CON WU
nn_CON_WU = ClassifierNN_CON_WU( ...
    'GR1', gr1, ...
    'GR2', gr2 ...
    );

% nn result calculation
trained_net = nn_CON_WU.get('NEURAL_NETWORK');
trained_net_obj = nn_CON_WU.net_obj_transformer();
acc_training = nn_CON_WU.getTrainingAccuracy();
acc_test = nn_CON_WU.getTestAccuracy();
confusion_matrix_training = nn_CON_WU.getTrainingConfusionMatrix();
confusion_matrix_test = nn_CON_WU.getTestConfusionMatrix();

