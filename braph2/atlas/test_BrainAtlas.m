% test BrainAtlas

br1 = BrainRegion('BR1', 'brain region 1', 'brain region notes 1', 1, 11, 111);
br2 = BrainRegion('BR2', 'brain region 2', 'brain region notes 2', 2, 22, 222);
br3 = BrainRegion('BR3', 'brain region 3', 'brain region notes 3', 3, 33, 333);
br4 = BrainRegion('BR4', 'brain region 4', 'brain region notes 4', 4, 44, 444);
br5 = BrainRegion('BR5', 'brain region 5', 'brain region notes 5', 5, 55, 555);
br6 = BrainRegion('BR6', 'brain region 6', 'brain region notes 6', 6, 66, 666);
br7 = BrainRegion('BR7', 'brain region 7', 'brain region notes 7', 7, 77, 777);
br8 = BrainRegion('BR8', 'brain region 8', 'brain region notes 8', 8, 88, 888);
br9 = BrainRegion('BR9', 'brain region 9', 'brain region notes 9', 9, 99, 999);

%% Test 1: Basic functions
atlas = BrainAtlas('TRIAL', 'Brain Atlas', 'Brain atlas notes', {br1, br2, br3, br4, br5});

assert(ischar(atlas.tostring()), ...
	[BRAPH2.STR ':' class(atlas) ':' BRAPH2.WRONG_OUTPUT], ...
    'BrainAtlas.tostring() must return a string.')

%% Test 2: Get methods
id = 'TRIAL';
label = 'Brain Atlas';
notes = 'Brain atlas notes';
brain_regions = {br1, br2, br3, br4, br5};
atlas = BrainAtlas(id, label, notes, brain_regions);

assert(isequal(atlas.getID(), id), ...
	[BRAPH2.STR ':' class(atlas) ':' BRAPH2.WRONG_OUTPUT], ...
    'BrainAtlas.getID() does not work.')
assert(isequal(atlas.getLabel(), label), ...
	[BRAPH2.STR ':' class(atlas) ':' BRAPH2.WRONG_OUTPUT], ...
    'BrainAtlas.getLabel() does not work.')
assert(isequal(atlas.getNotes(), notes), ...
	[BRAPH2.STR ':' class(atlas) ':' BRAPH2.WRONG_OUTPUT], ...
    'BrainAtlas.getNotes() does not work.')
assert(isequal(atlas.getBrainRegions().getValues(), brain_regions), ...
	[BRAPH2.STR ':' class(atlas) ':' BRAPH2.WRONG_OUTPUT], ...
    'BrainAtlas.getBrainregions() does not work.')

%% Test 3: Set methods
atlas = BrainAtlas('TRIAL', 'Brain Atlas', 'Brain atlas notes', {br1, br2, br3, br4, br5});

id = 'TRIAL UPDATED';
atlas.setID(id)
assert(isequal(atlas.getID(), id), ...
	[BRAPH2.STR ':' class(atlas) ':' BRAPH2.BUG_FUNC], ...
    'BrainAtlas.setID() does not work.')

label = 'Brain Atlas UPDATED';
atlas.setLabel(label)
assert(isequal(atlas.getLabel(), label), ...
	[BRAPH2.STR ':' class(atlas) ':' BRAPH2.BUG_FUNC], ...
    'BrainAtlas.setLabel() does not work.')

notes = 'Brain atlas notes UPDATED';
atlas.setNotes(notes)
assert(isequal(atlas.getNotes(), notes), ...
	[BRAPH2.STR ':' class(atlas) ':' BRAPH2.BUG_FUNC], ...
    'BrainAtlas.setNotes() does not work.')

%% Test 4: Deep copy

%% Test 5: Save and load to XLS
% br1 = BrainRegion('ISF', 'superiorfrontal', -12.6, 22.9, 42.4);
% br2 = BrainRegion('lFP', 'frontalpole', -8.6,61.7,-8.7);
% br3 = BrainRegion('lRMF', 'rostralmiddlefrontal', -31.3,41.2,16.5);
% br4 = BrainRegion('lCMF', 'caudalmiddlefrontal', -34.6, 10.2, 42.8);
% br5 = BrainRegion('lPOB', 'parsorbitalis', -41,38.8,-11.1);
% atlas  = BrainAtlas('TestToSaveCoolName1', {br1, br2, br3, br4, br5});
% 
% file = [fileparts(which('test_braph2')) filesep 'trial_atlas_to_be_erased.xlsx'];
% 
% BrainAtlas.save_to_xls(atlas, 'File', file);
% 
% atlas_loaded = BrainAtlas.load_from_xls('File', file);
% 
% assert(isequal(atlas.getName(), atlas_loaded.getName()), ...
% 	'BRAPH:BrainAtlas:SaveLoadXLS', ...
%     'Problems saving or loading a brain atlas.')
% assert(isequal(atlas.getBrainRegions().length(), atlas_loaded.getBrainRegions().length()), ...
% 	'BRAPH:BrainAtlas:SaveLoadXLS', ...
%     'Problems saving or loading a brain atlas.')
% for i = 1:1:max(atlas.getBrainRegions().length(), atlas_loaded.getBrainRegions().length())
%     br = atlas.getBrainRegions().getValue(i);
%     br_loaded = atlas_loaded.getBrainRegions().getValue(i);    
%     assert( ...
%         isequal(br.getLabel(), br_loaded.getLabel()) & ...
%         isequal(br.getName(), br_loaded.getName()) & ...
%         isequal(br.getX(), br_loaded.getX()) & ...
%         isequal(br.getY(), br_loaded.getY()) & ...
%         isequal(br.getZ(), br_loaded.getZ()), ...
%         'BRAPH:BrainAtlas:SaveLoadXLS', ...
%         'Problems saving or loading a brain atlas.')    
% end
% 
% delete(file)

%% Test 6: Save and load to TXT
% br1 = BrainRegion('ISF', 'superiorfrontal', -12.6, 22.9, 42.4);
% br2 = BrainRegion('lFP', 'frontalpole', -8.6,61.7,-8.7);
% br3 = BrainRegion('lRMF', 'rostralmiddlefrontal', -31.3,41.2,16.5);
% br4 = BrainRegion('lCMF', 'caudalmiddlefrontal', -34.6, 10.2, 42.8);
% br5 = BrainRegion('lPOB', 'parsorbitalis', -41,38.8,-11.1);
% atlas  = BrainAtlas('TestToSaveCoolName1', {br1, br2, br3, br4, br5});
% 
% file = [fileparts(which('test_braph2')) filesep 'trial_atlas_to_be_erased.txt'];
% 
% BrainAtlas.save_to_txt(atlas, 'File', file);
% 
% atlas_loaded = BrainAtlas.load_from_txt('File', file);
% 
% assert(isequal(atlas.getName(), atlas_loaded.getName()), ...
% 	'BRAPH:BrainAtlas:SaveLoadTXT', ...
%     'Problems saving or loading a brain atlas.')
% assert(isequal(atlas.getBrainRegions().length(), atlas_loaded.getBrainRegions().length()), ...
% 	'BRAPH:BrainAtlas:SaveLoadTXT', ...
%     'Problems saving or loading a brain atlas.')
% for i = 1:1:max(atlas.getBrainRegions().length(), atlas_loaded.getBrainRegions().length())
%     br = atlas.getBrainRegions().getValue(i);
%     br_loaded = atlas_loaded.getBrainRegions().getValue(i);    
%     assert( ...
%         isequal(br.getLabel(), br_loaded.getLabel()) & ...
%         isequal(br.getName(), br_loaded.getName()) & ...
%         isequal(br.getX(), br_loaded.getX()) & ...
%         isequal(br.getY(), br_loaded.getY()) & ...
%         isequal(br.getZ(), br_loaded.getZ()), ...
%         'BRAPH:BrainAtlas:SaveLoadTXT', ...
%         'Problems saving or loading a brain atlas.')    
% end
% 
% delete(file)

%% Test 7: Save and load to JSON
% br1 = BrainRegion('ISF', 'superiorfrontal', -12.6, 22.9, 42.4);
% br2 = BrainRegion('lFP', 'frontalpole', -8.6,61.7,-8.7);
% br3 = BrainRegion('lRMF', 'rostralmiddlefrontal', -31.3,41.2,16.5);
% br4 = BrainRegion('lCMF', 'caudalmiddlefrontal', -34.6, 10.2, 42.8);
% br5 = BrainRegion('lPOB', 'parsorbitalis', -41,38.8,-11.1);
% atlas  = BrainAtlas('TestToSaveCoolName1', {br1, br2, br3, br4, br5});
% 
% file = [fileparts(which('test_braph2')) filesep 'trial_atlas_to_be_erased.json'];
% 
% BrainAtlas.save_to_json(atlas, 'File', file);
% 
% atlas_loaded = BrainAtlas.load_from_json('File', file);
% 
% assert(isequal(atlas.getName(), atlas_loaded.getName()), ...
% 	'BRAPH:BrainAtlas:SaveLoadJSON', ...
%     'Problems saving or loading a brain atlas.')
% assert(isequal(atlas.getBrainRegions().length(), atlas_loaded.getBrainRegions().length()), ...
% 	'BRAPH:BrainAtlas:SaveLoadJSON', ...
%     'Problems saving or loading a brain atlas.')
% for i = 1:1:max(atlas.getBrainRegions().length(), atlas_loaded.getBrainRegions().length())
%     br = atlas.getBrainRegions().getValue(i);
%     br_loaded = atlas_loaded.getBrainRegions().getValue(i);    
%     assert( ...
%         isequal(br.getLabel(), br_loaded.getLabel()) & ...
%         isequal(br.getName(), br_loaded.getName()) & ...
%         isequal(br.getX(), br_loaded.getX()) & ...
%         isequal(br.getY(), br_loaded.getY()) & ...
%         isequal(br.getZ(), br_loaded.getZ()), ...
%         'BRAPH:BrainAtlas:SaveLoadJSON', ...
%         'Problems saving or loading a brain atlas.')    
% end
% 
% delete(file)