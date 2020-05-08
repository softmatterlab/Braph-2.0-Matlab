% example DTI

% Load Brain Atlas
atlas = BrainAtlas.load_from_xls();

% Load Cohort and Subject Data
cohort_group1 = SubjectDTI.load_from_xls('SubjectDTI', atlas)
cohort_group2 = SubjectDTI.load_from_xls('SubjectDTI', atlas)

cohort = Cohort('Cohort Name', 'SubjectDTI', atlas, {});

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

% Create Analysis
analysis = AnalysisDTI(cohort, {}, {}, {}, ...
    'AnalysisDTI.Longitudinal', 1, ...
    'DirectedTrianglesRule', 'middleman');

% Measurement
m1 = analysis.calculateMeasurement('Degree', group1)
m1.getGroupAverageValue()

m2 = analysis.calculateMeasurement('Strength', group1)
m2.getGroupAverageValue()

m3 = analysis.calculateMeasurement('DegreeAv', group1)
m3.getGroupAverageValue()

m4 = analysis.calculateMeasurement('Distance', group1)
m4.getGroupAverageValue()

% Comparison
c1 = analysis.calculateComparison('Degree', {group1 group2})
c1.getDifference()
c1.getP1()
c1.getP2()

% RandomComparison
c1 = analysis.calculateRandomComparison('Degree', group1, 'NumberOfPermutations', 10)
c1.getDifference()

