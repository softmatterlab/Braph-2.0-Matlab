% test SubjectST_MP

br1 = BrainRegion('BR1', 'brain region 1', 'notes 1', 1, 1.1, 1.11);
br2 = BrainRegion('BR2', 'brain region 2', 'notes 2', 2, 2.2, 2.22);
br3 = BrainRegion('BR3', 'brain region 3', 'notes 3', 3, 3.3, 3.33);
br4 = BrainRegion('BR4', 'brain region 4', 'notes 4', 4, 4.4, 4.44);
br5 = BrainRegion('BR5', 'brain region 5', 'notes 5', 5, 5.5, 5.55);
atlas = BrainAtlas('BA', 'brain atlas', 'notes', 'BrainMesh_ICBM152.nv', {br1, br2, br3, br4, br5});

%% Test 1: Instantiation
sub = SubjectST_MP('id', 'label', 'notes', atlas);

%% Test 2.1: Save and Load Cohort XLS
% setup
sub_class = 'SubjectST_MP';
input_rule1 = 'ST_MP1';
input_rule2 = 'ST_MP2';
input_data1 = rand(atlas.getBrainRegions().length(), 1);
input_data2 = rand(atlas.getBrainRegions().length(), 1);
save_dir_rule1 = 'File1';
save_dir_rule2 = 'File2';
save_dir_path1 = [fileparts(which('test_braph2')) filesep 'trial_cohort_to_be_erased.xlsx'];
save_dir_path2 = [fileparts(which('test_braph2')) filesep 'trial_cohort_to_be_erased2.xlsx'];
sub1 = Subject.getSubject(sub_class, 'SubjectID1', 'label1', 'notes1', atlas, input_rule1, input_data1, input_rule2, input_data2);
sub2 = Subject.getSubject(sub_class, 'SubjectID2', 'label2', 'notes2', atlas, input_rule1, input_data1, input_rule2, input_data2);
sub3 = Subject.getSubject(sub_class, 'SubjectID3', 'label3', 'notes3', atlas, input_rule1, input_data1, input_rule2, input_data2);
group = Group(sub_class, 'GroupName1', 'TestGroup1', 'notes1', {sub1, sub2, sub3});

cohort = Cohort('cohorttest', 'label1', 'notes1', sub_class, atlas, {sub1, sub2, sub3});
cohort.getGroups().add(group.getID(), group);

% act
SubjectST_MP.save_to_xls(cohort, save_dir_rule1, save_dir_path1, save_dir_rule2, save_dir_path2);

load_cohort = SubjectST_MP.load_from_xls(atlas, sub_class, save_dir_rule1, save_dir_path1, save_dir_rule2, save_dir_path2);

% assert
assert(isequal(cohort.getSubjects().length(), load_cohort.getSubjects().length()), ...
    [BRAPH2.STR ':SubjectST_MP:SaveLoadXLS'], ...
    'Problems saving or loading a cohort.')
assert(isequal(cohort.getGroups().length(), load_cohort.getGroups().length()), ...
    [BRAPH2.STR ':SubjectST_MP:SaveLoadXLS'], ...
    'Problems saving or loading a cohort.')
for i = 1:1:max(cohort.getSubjects().length(), load_cohort.getSubjects().length())
    sub = cohort.getSubjects().getValue(i);
    sub_loaded = load_cohort.getSubjects().getValue(i);
    data1 = sub.getData(input_rule1);
    data_loaded1 = sub_loaded.getData(input_rule1);
    data2 = sub.getData(input_rule2);
    data_loaded2 = sub_loaded.getData(input_rule2);
    assert( ...
        isequal(sub.getID(), sub_loaded.getID()) & ...
        isequal(data1.getValue(), data_loaded1.getValue()) & ...
        isequal(data2.getValue(), data_loaded2.getValue()), ...
        [BRAPH2.STR ':SubjectST_MP:SaveLoadXLS'], ...
        'Problems saving or loading a cohort.')
end

delete(save_dir_path1)
delete(save_dir_path2)

%% Test 2.2: Save and load to same cohort from XLS
% setup
sub_class = 'SubjectST_MP';
input_rule1 = 'ST_MP1';
input_rule2 = 'ST_MP2';
input_data1 = rand(atlas.getBrainRegions().length(), 1);
input_data2 = rand(atlas.getBrainRegions().length(), 1);
save_dir_rule1 = 'File1';
save_dir_rule2 = 'File2';
save_dir_path1 = [fileparts(which('test_braph2')) filesep 'trial_cohort_to_be_erased.xlsx'];
save_dir_path2 = [fileparts(which('test_braph2')) filesep 'trial_cohort_to_be_erased2.xlsx'];
save_dir_path3 = [fileparts(which('test_braph2')) filesep 'trial_cohort_to_be_erased3.xlsx'];
save_dir_path4 = [fileparts(which('test_braph2')) filesep 'trial_cohort_to_be_erased4.xlsx'];

sub1 = Subject.getSubject(sub_class, 'SubjectID1', 'label1', 'notes1', atlas, input_rule1, input_data1, input_rule2, input_data2);
sub2 = Subject.getSubject(sub_class, 'SubjectID2', 'label2', 'notes2', atlas, input_rule1, input_data1, input_rule2, input_data2);
sub3 = Subject.getSubject(sub_class, 'SubjectID3', 'label3', 'notes3', atlas, input_rule1, input_data1, input_rule2, input_data2);
group = Group(sub_class, 'GroupName1', 'TestGroup1', 'notes1', {sub1, sub2, sub3});
cohort = Cohort('cohorttest', 'label1', 'notes1', sub_class, atlas, {sub1, sub2, sub3});
cohort.getGroups().add(group.getID(), group);

sub4 = Subject.getSubject(sub_class, 'SubjectID4', 'label4', 'notes4', atlas, input_rule1, input_data1, input_rule2, input_data2);
sub5 = Subject.getSubject(sub_class, 'SubjectID5', 'label5', 'notes5', atlas, input_rule1, input_data1, input_rule2, input_data2);
sub6 = Subject.getSubject(sub_class, 'SubjectID6', 'label6', 'notes6', atlas, input_rule1, input_data1, input_rule2, input_data2);
group2 = Group(sub_class, 'GroupName2', 'TestGroup2', 'notes2', {sub4, sub5, sub6});
cohort_2 = Cohort('cohorttest2', 'label2', 'notes2', sub_class, atlas, {sub4, sub5, sub6});
cohort_2.getGroups().add(group2.getID(), group2);

% act
SubjectST_MP.save_to_xls(cohort, save_dir_rule1, save_dir_path1, save_dir_rule2, save_dir_path2);
SubjectST_MP.save_to_xls(cohort_2, save_dir_rule1, save_dir_path3, save_dir_rule2, save_dir_path4);
load_cohort = SubjectST_MP.load_from_xls(atlas, sub_class, save_dir_rule1, save_dir_path1, save_dir_rule2, save_dir_path2);

% load
load_cohort_2 = SubjectST_MP.load_from_xls(load_cohort, sub_class, save_dir_rule1, save_dir_path3, save_dir_rule2, save_dir_path4);

% assert
assert(isequal(cohort.getSubjects().length() + cohort_2.getSubjects().length(), load_cohort_2.getSubjects().length()), ...
    [BRAPH2.STR ':SubjectST_MP:SaveLoadXLS'], ...
    'Problems saving or loading a cohort.')
assert(isequal(cohort.getGroups().length() + cohort_2.getGroups().length(), load_cohort_2.getGroups().length()), ...
    [BRAPH2.STR ':SubjectST_MP:SaveLoadXLS'], ...
    'Problems saving or loading a cohort.')
for i = 1:1:min(cohort.getSubjects().length(), load_cohort_2.getSubjects().length())
    sub = cohort.getSubjects().getValue(i);
    sub2 = cohort_2.getSubjects().getValue(i);
    subs_loaded = load_cohort_2.getSubjects();
    for j = 1:1:subs_loaded.length()
        s = subs_loaded.getValue(j);
        ids_loaded{j} = s.getID(); %#ok<SAGROW>
    end
    
    assert(ismember(sub.getID(), ids_loaded),  ...
        [BRAPH2.STR ':SubjectST_MP:SaveLoadXLS'], ...
        'Problems saving or loading a cohort.')
    
    assert(ismember(sub2.getID(), ids_loaded),  ...
        [BRAPH2.STR ':SubjectST_MP:SaveLoadXLS'], ...
        'Problems saving or loading a cohort.')
end

delete(save_dir_path1)
delete(save_dir_path2)
delete(save_dir_path3)
delete(save_dir_path4)

%% Test 2.3 Save and load cohort to same cohort from XLS with repeating subjects in diff groups.
% setup
sub_class = 'SubjectST_MP';
input_rule1 = 'ST_MP1';
input_rule2 = 'ST_MP2';
input_data1 = rand(atlas.getBrainRegions().length(), 1);
input_data2 = rand(atlas.getBrainRegions().length(), 1);
save_dir_rule1 = 'File1';
save_dir_rule2 = 'File2';
save_dir_path1 = [fileparts(which('test_braph2')) filesep 'trial_cohort_to_be_erased.xlsx'];
save_dir_path2 = [fileparts(which('test_braph2')) filesep 'trial_cohort_to_be_erased2.xlsx'];
save_dir_path3 = [fileparts(which('test_braph2')) filesep 'trial_cohort_to_be_erased3.xlsx'];
save_dir_path4 = [fileparts(which('test_braph2')) filesep 'trial_cohort_to_be_erased4.xlsx'];

sub1 = Subject.getSubject(sub_class, 'SubjectID1', 'label1', 'notes1', atlas, input_rule1, input_data1, input_rule2, input_data2);
sub2 = Subject.getSubject(sub_class, 'SubjectID2', 'label2', 'notes2', atlas, input_rule1, input_data1, input_rule2, input_data2);
sub3 = Subject.getSubject(sub_class, 'SubjectID3', 'label3', 'notes3', atlas, input_rule1, input_data1, input_rule2, input_data2);
group = Group(sub_class, 'GroupName1', 'TestGroup1', 'notes1', {sub1, sub2, sub3});
cohort = Cohort('cohorttest', 'label1', 'notes1', sub_class, atlas, {sub1, sub2, sub3});
cohort.getGroups().add(group.getID(), group);

sub6 = Subject.getSubject(sub_class, 'SubjectID6', 'label6', 'notes6', atlas, input_rule1, input_data1, input_rule2, input_data2);
group2 = Group(sub_class, 'GroupName2', 'TestGroup2', 'notes2', {sub1, sub2, sub6});
cohort_2 = Cohort('cohorttest2', 'label2', 'notes2', sub_class, atlas, {sub1, sub2, sub6});
cohort_2.getGroups().add(group2.getID(), group2);

% act
SubjectST_MP.save_to_xls(cohort, save_dir_rule1, save_dir_path1, save_dir_rule2, save_dir_path2);
SubjectST_MP.save_to_xls(cohort_2, save_dir_rule1, save_dir_path3, save_dir_rule2, save_dir_path4);
load_cohort = SubjectST_MP.load_from_xls(atlas, sub_class, save_dir_rule1, save_dir_path1, save_dir_rule2, save_dir_path2);

% load
load_cohort_2 = SubjectST_MP.load_from_xls(load_cohort, sub_class, save_dir_rule1, save_dir_path3, save_dir_rule2, save_dir_path4);

% assert
assert(isequal(4, load_cohort_2.getSubjects().length()), ...
    [BRAPH2.STR ':SubjectST_MP:SaveLoadXLS'], ...
    'Problems saving or loading a cohort.')
assert(isequal(cohort.getGroups().length() + cohort_2.getGroups().length(), load_cohort_2.getGroups().length()), ...
    [BRAPH2.STR ':SubjectST_MP:SaveLoadXLS'], ...
    'Problems saving or loading a cohort.')
for i = 1:1:min(cohort.getSubjects().length(), load_cohort_2.getSubjects().length())
    sub = cohort.getSubjects().getValue(i);
    sub2 = cohort_2.getSubjects().getValue(i);
    subs_loaded = load_cohort_2.getSubjects();
    for j = 1:1:subs_loaded.length()
        s = subs_loaded.getValue(j);
        ids_loaded{j} = s.getID();
    end
    
    assert(ismember(sub.getID(), ids_loaded),  ...
        [BRAPH2.STR ':SubjectST_MP:SaveLoadXLS'], ...
        'Problems saving or loading a cohort.')
    
    assert(ismember(sub2.getID(), ids_loaded),  ...
        [BRAPH2.STR ':SubjectST_MP:SaveLoadXLS'], ...
        'Problems saving or loading a cohort.')
end

delete(save_dir_path1)
delete(save_dir_path2)
delete(save_dir_path3)
delete(save_dir_path4)

%% Test 3.1: Save and Load cohort from TXT
% setup
sub_class = 'SubjectST_MP';
input_rule1 = 'ST_MP1';
input_rule2 = 'ST_MP2';
input_data1 = rand(atlas.getBrainRegions().length(), 1);
input_data2 = rand(atlas.getBrainRegions().length(), 1);
save_dir_rule1 = 'File1';
save_dir_rule2 = 'File2';
save_dir_path1 = [fileparts(which('test_braph2')) filesep 'trial_cohort_to_be_erased.txt'];
save_dir_path2 = [fileparts(which('test_braph2')) filesep 'trial_cohort_to_be_erased2.txt'];
sub1 = Subject.getSubject(sub_class, 'SubjectID1', 'label1', 'notes1', atlas, input_rule1, input_data1, input_rule2, input_data2);
sub2 = Subject.getSubject(sub_class, 'SubjectID2', 'label2', 'notes2', atlas, input_rule1, input_data1, input_rule2, input_data2);
sub3 = Subject.getSubject(sub_class, 'SubjectID3', 'label3', 'notes3', atlas, input_rule1, input_data1, input_rule2, input_data2);
group = Group(sub_class, 'GroupName1', 'TestGroup1', 'notes1', {sub1, sub2, sub3});

cohort = Cohort('cohorttest', 'label1', 'notes1', sub_class, atlas, {sub1, sub2, sub3});
cohort.getGroups().add(group.getID(), group);

% act
SubjectST_MP.save_to_txt(cohort, save_dir_rule1, save_dir_path1, save_dir_rule2, save_dir_path2);

load_cohort = SubjectST_MP.load_from_txt(atlas, save_dir_rule1, save_dir_path1, save_dir_rule2, save_dir_path2);

% assert
assert(isequal(cohort.getSubjects().length(), load_cohort.getSubjects().length()), ...
    [BRAPH2.STR ':SubjectST_MP:SaveLoadTXT'], ...
    'Problems saving or loading a cohort.')
assert(isequal(cohort.getGroups().length(), load_cohort.getGroups().length()), ...
    [BRAPH2.STR ':SubjectST_MP:SaveLoadTXT'], ...
    'Problems saving or loading a cohort.')
for i = 1:1:max(cohort.getSubjects().length(), load_cohort.getSubjects().length())
    sub = cohort.getSubjects().getValue(i);
    sub_loaded = load_cohort.getSubjects().getValue(i);
    data1 = sub.getData(input_rule1);
    data_loaded1 = sub_loaded.getData(input_rule1);
    data2 = sub.getData(input_rule1);
    data_loaded2 = sub_loaded.getData(input_rule1);
    assert( ...
        isequal(sub.getID(), sub_loaded.getID()) & ...
        isequal(round(data1.getValue(), 3), round(data_loaded1.getValue(), 3)) & ...
        isequal(round(data2.getValue(), 3), round(data_loaded2.getValue(), 3 )), ...
        [BRAPH2.STR ':SubjectST_MP:SaveLoadTXT'], ...
        'Problems saving or loading a cohort.')
end

delete(save_dir_path1)
delete(save_dir_path2)

%% Test 3.2 Save and load to same cohort from TXT
% setup
sub_class = 'SubjectST_MP';
input_rule1 = 'ST_MP1';
input_rule2 = 'ST_MP2';
input_data1 = rand(atlas.getBrainRegions().length(), 1);
input_data2 = rand(atlas.getBrainRegions().length(), 1);
save_dir_rule1 = 'File1';
save_dir_rule2 = 'File2';
save_dir_path1 = [fileparts(which('test_braph2')) filesep 'trial_cohort_to_be_erased.txt'];
save_dir_path2 = [fileparts(which('test_braph2')) filesep 'trial_cohort_to_be_erased2.txt'];
save_dir_path3 = [fileparts(which('test_braph2')) filesep 'trial_cohort_to_be_erased3.txt'];
save_dir_path4 = [fileparts(which('test_braph2')) filesep 'trial_cohort_to_be_erased4.txt'];
sub1 = Subject.getSubject(sub_class, 'SubjectID1', 'label1', 'notes1', atlas, input_rule1, input_data1, input_rule2, input_data2);
sub2 = Subject.getSubject(sub_class, 'SubjectID2', 'label2', 'notes2', atlas, input_rule1, input_data1, input_rule2, input_data2);
sub3 = Subject.getSubject(sub_class, 'SubjectID3', 'label3', 'notes3', atlas, input_rule1, input_data1, input_rule2, input_data2);
group = Group(sub_class, 'GroupName1', 'TestGroup1', 'notes1', {sub1, sub2, sub3});
cohort = Cohort('cohorttest', 'label1', 'notes1', sub_class, atlas, {sub1, sub2, sub3});
cohort.getGroups().add(group.getID(), group);

sub4 = Subject.getSubject(sub_class, 'SubjectID4', 'label4', 'notes4', atlas, input_rule1, input_data1, input_rule2, input_data2);
sub5 = Subject.getSubject(sub_class, 'SubjectID5', 'label5', 'notes5', atlas, input_rule1, input_data1, input_rule2, input_data2);
sub6 = Subject.getSubject(sub_class, 'SubjectID6', 'label6', 'notes6', atlas, input_rule1, input_data1, input_rule2, input_data2);
group2 = Group(sub_class, 'GroupName2', 'TestGroup2', 'notes2', {sub4, sub5, sub6});
cohort_2 = Cohort('cohorttest2', 'label2', 'notes2', sub_class, atlas, {sub4, sub5, sub6});
cohort_2.getGroups().add(group2.getID(), group2);

% act
SubjectST_MP.save_to_txt(cohort, save_dir_rule1, save_dir_path1, save_dir_rule2, save_dir_path2);
SubjectST_MP.save_to_txt(cohort_2, save_dir_rule1, save_dir_path3, save_dir_rule2, save_dir_path4);
load_cohort = SubjectST_MP.load_from_txt(atlas, sub_class, save_dir_rule1, save_dir_path1, save_dir_rule2, save_dir_path2);

% load
load_cohort_2 = SubjectST_MP.load_from_txt(load_cohort, sub_class, save_dir_rule1, save_dir_path3, save_dir_rule2, save_dir_path4);

% assert
assert(isequal(cohort.getSubjects().length() + cohort_2.getSubjects().length(), load_cohort_2.getSubjects().length()), ...
    [BRAPH2.STR ':SubjectST_MP:SaveLoadTXT'], ...
    'Problems saving or loading a cohort.')
assert(isequal(cohort.getGroups().length() + cohort_2.getGroups().length(), load_cohort_2.getGroups().length()), ...
    [BRAPH2.STR ':SubjectST_MP:SaveLoadTXT'], ...
    'Problems saving or loading a cohort.')
for i = 1:1:min(cohort.getSubjects().length(), load_cohort_2.getSubjects().length())
    sub = cohort.getSubjects().getValue(i);
    sub2 = cohort_2.getSubjects().getValue(i);
    subs_loaded = load_cohort_2.getSubjects();
    for j = 1:1:subs_loaded.length()
        s = subs_loaded.getValue(j);
        ids_loaded{j} = s.getID();
    end
    
    assert(ismember(sub.getID(), ids_loaded),  ...
        [BRAPH2.STR ':SubjectST_MP:SaveLoadTXT'], ...
        'Problems saving or loading a cohort.')
    
    assert(ismember(sub2.getID(), ids_loaded),  ...
        [BRAPH2.STR ':SubjectST_MP:SaveLoadTXT'], ...
        'Problems saving or loading a cohort.')
end

delete(save_dir_path1)
delete(save_dir_path2)
delete(save_dir_path3)
delete(save_dir_path4)

%% Test 3.3 Save and load to same cohort from TXT repeating subjects
% setup
sub_class = 'SubjectST_MP';
input_rule1 = 'ST_MP1';
input_rule2 = 'ST_MP2';
input_data1 = rand(atlas.getBrainRegions().length(), 1);
input_data2 = rand(atlas.getBrainRegions().length(), 1);
save_dir_rule1 = 'File1';
save_dir_rule2 = 'File2';
save_dir_path1 = [fileparts(which('test_braph2')) filesep 'trial_cohort_to_be_erased.txt'];
save_dir_path2 = [fileparts(which('test_braph2')) filesep 'trial_cohort_to_be_erased2.txt'];
save_dir_path3 = [fileparts(which('test_braph2')) filesep 'trial_cohort_to_be_erased3.txt'];
save_dir_path4 = [fileparts(which('test_braph2')) filesep 'trial_cohort_to_be_erased4.txt'];
sub1 = Subject.getSubject(sub_class, 'SubjectID1', 'label1', 'notes1', atlas, input_rule1, input_data1, input_rule2, input_data2);
sub2 = Subject.getSubject(sub_class, 'SubjectID2', 'label2', 'notes2', atlas, input_rule1, input_data1, input_rule2, input_data2);
sub3 = Subject.getSubject(sub_class, 'SubjectID3', 'label3', 'notes3', atlas, input_rule1, input_data1, input_rule2, input_data2);
group = Group(sub_class, 'GroupName1', 'TestGroup1', 'notes1', {sub1, sub2, sub3});
cohort = Cohort('cohorttest', 'label1', 'notes1', sub_class, atlas, {sub1, sub2, sub3});
cohort.getGroups().add(group.getID(), group);

sub6 = Subject.getSubject(sub_class, 'SubjectID6', 'label6', 'notes6', atlas, input_rule1, input_data1, input_rule2, input_data2);
group2 = Group(sub_class, 'GroupName2', 'TestGroup2', 'notes2', {sub1, sub2, sub6});
cohort_2 = Cohort('cohorttest2', 'label2', 'notes2', sub_class, atlas, {sub1, sub2, sub6});
cohort_2.getGroups().add(group2.getID(), group2);

% act
SubjectST_MP.save_to_txt(cohort, save_dir_rule1, save_dir_path1, save_dir_rule2, save_dir_path2);
SubjectST_MP.save_to_txt(cohort_2, save_dir_rule1, save_dir_path3, save_dir_rule2, save_dir_path4);
load_cohort = SubjectST_MP.load_from_txt(atlas, sub_class, save_dir_rule1, save_dir_path1, save_dir_rule2, save_dir_path2);

% load
load_cohort_2 = SubjectST_MP.load_from_txt(load_cohort, sub_class, save_dir_rule1, save_dir_path3, save_dir_rule2, save_dir_path4);

% assert
assert(isequal(4, load_cohort_2.getSubjects().length()), ...
    [BRAPH2.STR ':SubjectST_MP:SaveLoadTXT'], ...
    'Problems saving or loading a cohort.')
assert(isequal(cohort.getGroups().length() + cohort_2.getGroups().length(), load_cohort_2.getGroups().length()), ...
    [BRAPH2.STR ':SubjectST_MP:SaveLoadTXT'], ...
    'Problems saving or loading a cohort.')
for i = 1:1:min(cohort.getSubjects().length(), load_cohort_2.getSubjects().length())
    sub = cohort.getSubjects().getValue(i);
    sub2 = cohort_2.getSubjects().getValue(i);
    subs_loaded = load_cohort_2.getSubjects();
    for j = 1:1:subs_loaded.length()
        s = subs_loaded.getValue(j);
        ids_loaded{j} = s.getID();
    end
    
    assert(ismember(sub.getID(), ids_loaded),  ...
        [BRAPH2.STR ':SubjectST_MP:SaveLoadTXT'], ...
        'Problems saving or loading a cohort.')
    
    assert(ismember(sub2.getID(), ids_loaded),  ...
        [BRAPH2.STR ':SubjectST_MP:SaveLoadTXT'], ...
        'Problems saving or loading a cohort.')
end

delete(save_dir_path1)
delete(save_dir_path2)
delete(save_dir_path3)
delete(save_dir_path4)

%% Test 4.1: Save and Load cohort from JSON
% setup
sub_class = 'SubjectST_MP';
input_rule1 = 'ST_MP1';
input_rule2 = 'ST_MP2';
input_data1 = rand(atlas.getBrainRegions().length(), 1);
input_data2 = rand(atlas.getBrainRegions().length(), 1);
save_dir_rule1 = 'File1';
save_dir_rule2 = 'File2';
save_dir_path1 = [fileparts(which('test_braph2')) filesep 'trial_cohort_to_be_erased.json'];
save_dir_path2 = [fileparts(which('test_braph2')) filesep 'trial_cohort_to_be_erased2.json'];
sub1 = Subject.getSubject(sub_class, 'SubjectID1', 'label1', 'notes1', atlas, input_rule1, input_data1, input_rule2, input_data2);
sub2 = Subject.getSubject(sub_class, 'SubjectID2', 'label2', 'notes2', atlas, input_rule1, input_data1, input_rule2, input_data2);
sub3 = Subject.getSubject(sub_class, 'SubjectID3', 'label3', 'notes3', atlas, input_rule1, input_data1, input_rule2, input_data2);
group = Group(sub_class, 'GroupName1', 'TestGroup1', 'notes1', {sub1, sub2, sub3});

cohort = Cohort('cohorttest', 'label1', 'notes1', sub_class, atlas, {sub1, sub2, sub3});
cohort.getGroups().add(group.getID(), group);

% act

[a, b] = SubjectST_MP.save_to_json(cohort); 
JSON.Serialize(a, 'File', save_dir_path1);
JSON.Serialize(b, 'File', save_dir_path2);


load_cohort = SubjectST_MP.load_from_json(atlas, save_dir_rule1, save_dir_path1, save_dir_rule2, save_dir_path2);

% assert
assert(isequal(cohort.getSubjects().length(), load_cohort.getSubjects().length()), ...
    [BRAPH2.STR ':SubjectST_MP:SaveLoadJSON'], ...
    'Problems saving or loading a cohort.')
assert(isequal(cohort.getGroups().length(), load_cohort.getGroups().length()), ...
    [BRAPH2.STR ':SubjectST_MP:SaveLoadJSON'], ...
    'Problems saving or loading a cohort.')
for i = 1:1:max(cohort.getSubjects().length(), load_cohort.getSubjects().length())
    sub = cohort.getSubjects().getValue(i);
    sub_loaded = load_cohort.getSubjects().getValue(i);
    data1 = sub.getData(input_rule1);
    data_loaded1 = sub_loaded.getData(input_rule1);
    data2 = sub.getData(input_rule1);
    data_loaded2 = sub_loaded.getData(input_rule1);
    assert( ...
        isequal(sub.getID(), sub_loaded.getID()) & ...
        isequal(round(data1.getValue(), 3), round(data_loaded1.getValue(), 3)) & ...
        isequal(round(data2.getValue(), 3), round(data_loaded2.getValue(), 3 )), ...
        [BRAPH2.STR ':SubjectST_MP:SaveLoadJSON'], ...
        'Problems saving or loading a cohort.')
end

delete(save_dir_path1)
delete(save_dir_path2)

%% Test 4.2: Save and Load to the same cohort from JSON
% setup
sub_class = 'SubjectST_MP';
input_rule1 = 'ST_MP1';
input_rule2 = 'ST_MP2';
input_data1 = rand(atlas.getBrainRegions().length(), 1);
input_data2 = rand(atlas.getBrainRegions().length(), 1);
save_dir_rule1 = 'File1';
save_dir_rule2 = 'File2';
save_dir_path1 = [fileparts(which('test_braph2')) filesep 'trial_cohort_to_be_erased.json'];
save_dir_path2 = [fileparts(which('test_braph2')) filesep 'trial_cohort_to_be_erased2.json'];
save_dir_path3 = [fileparts(which('test_braph2')) filesep 'trial_cohort_to_be_erased3.json'];
save_dir_path4 = [fileparts(which('test_braph2')) filesep 'trial_cohort_to_be_erased4.json'];
sub1 = Subject.getSubject(sub_class, 'SubjectID1', 'label1', 'notes1', atlas, input_rule1, input_data1, input_rule2, input_data2);
sub2 = Subject.getSubject(sub_class, 'SubjectID2', 'label2', 'notes2', atlas, input_rule1, input_data1, input_rule2, input_data2);
sub3 = Subject.getSubject(sub_class, 'SubjectID3', 'label3', 'notes3', atlas, input_rule1, input_data1, input_rule2, input_data2);
group = Group(sub_class, 'GroupName1', 'TestGroup1', 'notes1', {sub1, sub2, sub3});

cohort = Cohort('cohorttest', 'label1', 'notes1', sub_class, atlas, {sub1, sub2, sub3});
cohort.getGroups().add(group.getID(), group);

sub4 = Subject.getSubject(sub_class, 'SubjectID4', 'label4', 'notes4', atlas, input_rule1, input_data1, input_rule2, input_data2);
sub5= Subject.getSubject(sub_class, 'SubjectID5', 'label5', 'notes5', atlas, input_rule1, input_data1, input_rule2, input_data2);
sub6 = Subject.getSubject(sub_class, 'SubjectID6', 'label6', 'notes6', atlas, input_rule1, input_data1, input_rule2, input_data2);
group2 = Group(sub_class, 'GroupName2', 'TestGroup2', 'notes2', {sub4, sub5, sub6});

cohort2 = Cohort('cohorttest2', 'label2', 'notes2', sub_class, atlas, {sub4, sub5, sub6});
cohort2.getGroups().add(group2.getID(), group2);

% act
SubjectST_MP.save_to_json(cohort, save_dir_rule1, save_dir_path1, save_dir_rule2, save_dir_path2);
SubjectST_MP.save_to_json(cohort2, save_dir_rule1, save_dir_path3, save_dir_rule2, save_dir_path4);
load_cohort = SubjectST_MP.load_from_json(atlas, save_dir_rule1, save_dir_path1, save_dir_rule2, save_dir_path2);

load_cohort_2 = SubjectST_MP.load_from_json(load_cohort, save_dir_rule1, save_dir_path3, save_dir_rule2, save_dir_path4);

% assert
assert(isequal(cohort.getSubjects().length() + cohort2.getSubjects().length(), load_cohort_2.getSubjects().length()), ...
    [BRAPH2.STR ':SubjectST_MP:SaveLoadJSON'], ...
    'Problems saving or loading a cohort.')
assert(isequal(cohort.getGroups().length() + cohort2.getGroups().length(), load_cohort_2.getGroups().length()), ...
    [BRAPH2.STR ':SubjectST_MP:SaveLoadJSON'], ...
    'Problems saving or loading a cohort.')
for i = 1:1:min(cohort.getSubjects().length(), load_cohort_2.getSubjects().length())
    sub = cohort.getSubjects().getValue(i);
    sub2 = cohort2.getSubjects().getValue(i);
    subs_loaded = load_cohort.getSubjects();
    for j = 1:1:subs_loaded.length()
        s = subs_loaded.getValue(j);
        ids_loaded{j} = s.getID();
    end
    
    assert(ismember(sub.getID(), ids_loaded),  ...
        [BRAPH2.STR ':SubjectST_MP:SaveLoadJSON'], ...
        'Problems saving or loading a cohort.')
    
    assert(ismember(sub2.getID(), ids_loaded),  ...
        [BRAPH2.STR ':SubjectST_MP:SaveLoadJSON'], ...
        'Problems saving or loading a cohort.')
end

delete(save_dir_path1)
delete(save_dir_path2)
delete(save_dir_path3)
delete(save_dir_path4)

%% Test 4.3: Save and Load to the same cohort from JSON
% setup
sub_class = 'SubjectST_MP';
input_rule1 = 'ST_MP1';
input_rule2 = 'ST_MP2';
input_data1 = rand(atlas.getBrainRegions().length(), 1);
input_data2 = rand(atlas.getBrainRegions().length(), 1);
save_dir_rule1 = 'File1';
save_dir_rule2 = 'File2';
save_dir_path1 = [fileparts(which('test_braph2')) filesep 'trial_cohort_to_be_erased.json'];
save_dir_path2 = [fileparts(which('test_braph2')) filesep 'trial_cohort_to_be_erased2.json'];
save_dir_path3 = [fileparts(which('test_braph2')) filesep 'trial_cohort_to_be_erased3.json'];
save_dir_path4 = [fileparts(which('test_braph2')) filesep 'trial_cohort_to_be_erased4.json'];
sub1 = Subject.getSubject(sub_class, 'SubjectID1', 'label1', 'notes1', atlas, input_rule1, input_data1, input_rule2, input_data2);
sub2 = Subject.getSubject(sub_class, 'SubjectID2', 'label2', 'notes2', atlas, input_rule1, input_data1, input_rule2, input_data2);
sub3 = Subject.getSubject(sub_class, 'SubjectID3', 'label3', 'notes3', atlas, input_rule1, input_data1, input_rule2, input_data2);
group = Group(sub_class, 'GroupName1', 'TestGroup1', 'notes1', {sub1, sub2, sub3});

cohort = Cohort('cohorttest', 'label1', 'notes1', sub_class, atlas, {sub1, sub2, sub3});
cohort.getGroups().add(group.getID(), group);

sub6 = Subject.getSubject(sub_class, 'SubjectID6', 'label6', 'notes6', atlas, input_rule1, input_data1, input_rule2, input_data2);
group2 = Group(sub_class, 'GroupName2', 'TestGroup2', 'notes2', {sub1, sub2, sub6});

cohort2 = Cohort('cohorttest2', 'label2', 'notes2', sub_class, atlas, {sub1, sub2, sub6});
cohort2.getGroups().add(group2.getID(), group2);

% act
JSON.Serialize(SubjectST_MP.save_to_json(cohort), save_dir_rule1, save_dir_path1, save_dir_rule2, save_dir_path2);
JSON.Serialize(SubjectST_MP.save_to_json(cohort2), save_dir_rule1, save_dir_path3, save_dir_rule2, save_dir_path4);
load_cohort = SubjectST_MP.load_from_json(atlas, save_dir_rule1, save_dir_path1, save_dir_rule2, save_dir_path2);

load_cohort_2 = SubjectST_MP.load_from_json(load_cohort, save_dir_rule1, save_dir_path3, save_dir_rule2, save_dir_path4);

% assert
assert(isequal(4, load_cohort_2.getSubjects().length()), ...
    [BRAPH2.STR ':SubjectST_MP:SaveLoadJSON'], ...
    'Problems saving or loading a cohort.')
assert(isequal(cohort.getGroups().length() + cohort2.getGroups().length(), load_cohort_2.getGroups().length()), ...
    [BRAPH2.STR ':SubjectST_MP:SaveLoadJSON'], ...
    'Problems saving or loading a cohort.')
for i = 1:1:min(cohort.getSubjects().length(), load_cohort_2.getSubjects().length())
    sub = cohort.getSubjects().getValue(i);
    sub2 = cohort2.getSubjects().getValue(i);
    subs_loaded = load_cohort.getSubjects();
    for j = 1:1:subs_loaded.length()
        s = subs_loaded.getValue(j);
        ids_loaded{j} = s.getID();
    end
    
    assert(ismember(sub.getID(), ids_loaded),  ...
        [BRAPH2.STR ':SubjectST_MP:SaveLoadJSON'], ...
        'Problems saving or loading a cohort.')
    
    assert(ismember(sub2.getID(), ids_loaded),  ...
        [BRAPH2.STR ':SubjectST_MP:SaveLoadJSON'], ...
        'Problems saving or loading a cohort.')
end

delete(save_dir_path1)
delete(save_dir_path2)
delete(save_dir_path3)
delete(save_dir_path4)
