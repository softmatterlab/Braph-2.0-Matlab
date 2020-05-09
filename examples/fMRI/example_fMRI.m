% Example fMRI Workflow

%% Load Atlas
atlas = BrainAtlas.load_from_xls('File','dosenbach_atlas.xlsx');

%% Load Subject Data
cohort_group1 = SubjectfMRI.load_from_xls('SubjectfMRI', atlas);
cohort_group2 = SubjectfMRI.load_from_xls('SubjectfMRI', atlas);
cohort = Cohort('Cohort Name', 'SubjectfMRI', atlas, {});

% integrating both cohorts
for i = 1:1:cohort_group1.getSubjects().length()
    subject = cohort_group1.getSubjects().getValue(i);
    cohort.getSubjects().add(subject.getID(), subject);
end
group1 = cohort_group1.getGroups().getValue(1);
cohort.getGroups().add(group1.getName(), group1)

for i = 1:1:cohort_group2.getSubjects().length()
    subject = cohort_group2.getSubjects().getValue(i);
    cohort.getSubjects().add(subject.getID(), subject);
end
group2 = cohort_group2.getGroups().getValue(1);
cohort.getGroups().add(group2.getName(), group2)

%% Show groups data
groups = cohort.getGroups().getValues();
group = groups{1}
group = groups{2}

%% Create Analysis
analysis = AnalysisfMRI(cohort, {}, {}, {}, ...
    'AnalysisMRI.Longitudinal', 1, ...
    'DirectedTrianglesRule', 'middleman');

analysis.getSettings()

%% Create Measurement
measurement = analysis.calculateMeasurement('Degree', group1);
calculated_value = measurement.getMeasureValues()
calculated_average = measurement.getGroupAverageValue()

measurement2 = analysis.calculateMeasurement('DegreeAv', group1);
calculated_value2 = measurement2.getMeasureValues()
calculated_average2 = measurement2.getGroupAverageValue();

%% Create Group Comparison
group_comparison = analysis.calculateComparison('Degree', {group1 group2});
group_comparison.getDifference()
group_comparison.getAllDifferences()
group_comparison.getP1()
group_comparison.getP2()

%% Create Random Comparison
random_comparison = analysis.calculateRandomComparison('Degree', group1, 'NumberOfPermutations', 10);
random_comparison.getDifference()
random_comparison2 = analysis.calculateRandomComparison('Degree', group2, 'NumberOfPermutations', 10);
random_comparison2.getDifference()

