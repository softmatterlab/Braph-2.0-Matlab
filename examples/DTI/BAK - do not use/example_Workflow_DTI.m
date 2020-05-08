% Script to simulate DTI Workflow

%% Load DTI BrainAtlas
[file, path, filterindex] = uigetfile('*.xlsx');

if filterindex
    atlas_file = fullfile(path, file);
    atlas = BrainAtlas.load_from_xls('File', atlas_file);
    disp(['Loaded DTI BrainAtlas: ' atlas.getName()])
    disp(['With ' num2str(atlas.getBrainRegions().length()) ' brain regions.']);
else
    disp('Failed to load DTI Atlas.')
    clear file path filterindex;
    return
end

%% Load Subject Data for group 1
cohort = SubjectDTI.load_from_xls('SubjectDTI', atlas);
disp('Loaded Cohort.')
disp(['Cohort has ' num2str(cohort.getSubjects().length()) ' subjects.'])

cohort2 = SubjectDTI.load_from_xls('SubjectDTI', atlas);
disp('Loaded Cohort.')
disp(['Cohort has ' num2str(cohort.getSubjects().length()) ' subjects.'])

% integrating both cohorts
for i = 1:1:cohort2.getSubjects().length()
    sub = cohort2.getSubjects().getValue(i);
    cohort.getSubjects().add(sub.getID(), sub, i);
end

group2 = cohort2.getGroups().getValue(1);
cohort.getGroups().add(group2.getName(), group2);

%% Create Analysis
analysis = AnalysisDTI(cohort, {}, {}, {});
groups = cohort.getGroups().getValues();  % this is a cell array, we will choose first entry.
group = groups{1};
disp('Analysis created.')
disp(['Group choosed: ' group.getName()])

%% Create Measurement
measure = 'Degree';
measurement = analysis.calculateMeasurement(measure, group);
calculated_value = measurement.getMeasureValues();
calculated_average = measurement.getGroupAverageValue();
disp(['Measurement values are for measure: ' measure])
% for i = 1:1:numel(calculated_value)
%     disp(num2str(calculated_value{i}))
% end
% disp(['Measurement average value for measure: ' measure])
% for i = 1:1:size(calculated_average, 1)
%     disp(num2str(calculated_average(i, 1)))
% end

%% Create Comparison
measure = 'Degree';
comparison = analysis.calculateComparison(measure, groups);  % two groups
disp(['Comparison value for group 1 : ' comparison.getGroupValue(1) ' for measure: ' measure])
disp(['Comparison value for group 2 : ' comparison.getGroupValue(2) ' for measure: ' measure])
disp(['Comparison group 1 average : ' comparison.getGroupAverageValue(1) ' for measure: ' measure])
disp(['Comparison group 2 average : ' comparison.getGroupAverageValue(2) ' for measure: ' measure])
disp(['Comparison difference between groups: ' comparison.getDifference() ' for measure: ' measure])
disp(['Comparison all diferecences : ' comparison.getAllDifferences() ' for measure: ' measure])
disp(['Comparison p1 : ' comparison.getP1() ' for measure: ' measure])
disp(['Comparison p2 : ' comparison.getP2() ' for measure: ' measure])
disp(['Comparison confidence interval min : ' comparison.getConfidenceIntervalMin() ' for measure: ' measure])
disp(['Comparison confidence interval max : ' comparison.getConfidenceIntervalMax() ' for measure: ' measure])

%% Create RandomComparison
measure = 'Degree';
randomcomparison =  analysis.calculateRandomComparison(measure, group);  % 1 group
disp(['Comparison value for group 1 : ' comparison.getGroupValue() ' for measure: ' measure])
disp(['Comparison value for random group : ' comparison.getRandomValue() ' for measure: ' measure])
disp(['Comparison group 1 average : ' comparison.getAverageValue() ' for measure: ' measure])
disp(['Comparison random group average : ' comparison.getAverageRandomValue() ' for measure: ' measure])
disp(['Comparison difference between groups: ' comparison.getDifference() ' for measure: ' measure])
disp(['Comparison all diferecences : ' comparison.getAllDifferences() ' for measure: ' measure])
disp(['Comparison p1 : ' comparison.getP1() ' for measure: ' measure])
disp(['Comparison p2 : ' comparison.getP2() ' for measure: ' measure])
disp(['Comparison confidence interval min : ' comparison.getConfidenceIntervalMin() ' for measure: ' measure])
disp(['Comparison confidence interval max : ' comparison.getConfidenceIntervalMax() ' for measure: ' measure])


