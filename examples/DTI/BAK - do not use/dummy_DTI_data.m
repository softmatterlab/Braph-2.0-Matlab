% script to create DTI Subjects

% create 100 brain regions
for i = 1:1:100
    br = BrainRegion(['BR' num2str(i)], ['brain region ' num2str(i)], i, 10+i, 100+i);
    brs{i} = br;  %#ok<SAGROW>
end

% create a atlas
atlas = BrainAtlas('brain atlas dti', brs);

% create 100 subjects
for i = 1:1:100
    input_data = rand(atlas.getBrainRegions().length(), atlas.getBrainRegions().length());
    sub = Subject.getSubject('SubjectDTI', atlas, 'SubjectID', num2str(i), 'DTI', input_data);
    subs{i} = sub; %#ok<SAGROW>
end

% create 2 groups
group = Group('SubjectDTI', subs(1:50), 'GroupName', 'TestGroupDTI_1');
group2 = Group('SubjectDTI', subs(51:100), 'GroupName', 'TestGroupDTI_2');

% create a cohort & add groups to the cohort
cohort = Cohort('CohortTestDTI', 'SubjectDTI', atlas, subs);
cohort.getGroups().add(group.getName(), group);
cohort.getGroups().add(group.getName(), group2);

% save the subjects & and the atlas in the test folder
save_dir_rule = 'RootDirectory';
save_dir_path = [fileparts(which('test_braph2')) filesep 'Dummy DTI'];
SubjectDTI.save_to_xls(cohort, save_dir_rule, save_dir_path);
atlas_file = [fileparts(which('test_braph2')) filesep 'Dummy DTI' filesep 'AtlasDTI.xlsx'];
BrainAtlas.save_to_xls(atlas, 'File', atlas_file);