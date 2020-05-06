% test AnalysisDTI
br1 = BrainRegion('BR1', 'brain region 1', 1, 11, 111);
br2 = BrainRegion('BR2', 'brain region 2', 2, 22, 222);
br3 = BrainRegion('BR3', 'brain region 3', 3, 33, 333);
br4 = BrainRegion('BR4', 'brain region 4', 4, 44, 444);
br5 = BrainRegion('BR5', 'brain region 5', 5, 55, 555);
atlas = BrainAtlas('brain atlas', {br1, br2, br3, br4, br5});

sub11 = SubjectDTI(atlas, 'SubjectID', '11', 'age', 20, 'DTI', .5 + .5 * rand(atlas.getBrainRegions().length()));
sub12 = SubjectDTI(atlas, 'SubjectID', '12', 'age', 20, 'DTI', .5 + .5 * rand(atlas.getBrainRegions().length()));
sub13 = SubjectDTI(atlas, 'SubjectID', '13', 'age', 20, 'DTI', .5 + .5 * rand(atlas.getBrainRegions().length()));
sub14 = SubjectDTI(atlas, 'SubjectID', '14', 'age', 20, 'DTI', .5 + .5 * rand(atlas.getBrainRegions().length()));
group1 = Group('SubjectDTI', {sub11, sub12, sub13, sub14}, 'GroupName', 'GroupTestDTI1');

sub21 = SubjectDTI(atlas, 'SubjectID', '21', 'age', 20, 'DTI', .5 + .5 * rand(atlas.getBrainRegions().length()));
sub22 = SubjectDTI(atlas, 'SubjectID', '22', 'age', 20, 'DTI', .5 + .5 * rand(atlas.getBrainRegions().length()));
sub23 = SubjectDTI(atlas, 'SubjectID', '23', 'age', 20, 'DTI', .5 + .5 * rand(atlas.getBrainRegions().length()));
group2 = Group('SubjectDTI', {sub21, sub22, sub23}, 'GroupName', 'GroupTestDTI2');

cohort = Cohort('Cohort DTI', 'SubjectDTI', atlas, {sub11, sub12, sub13, sub14, sub21, sub22, sub23});
cohort.getGroups().add(group1.getName(), group1)
cohort.getGroups().add(group2.getName(), group2)

measures = {'Assortativity', 'Degree', 'Distance'};

%% Test 1: Instantiation
analysis = AnalysisDTI(cohort, {}, {}, {}); %#ok<NASGU>

%% Test 2: Create correct ID
analysis = AnalysisDTI(cohort, {}, {}, {});

measurement_id = analysis.getMeasurementID('Degree', group1);
expected_value = [ ...
    tostring(analysis.getMeasurementClass()) ' ' ...
    tostring('Degree') ' ' ...
    tostring(analysis.getCohort().getGroups().getIndex(group1)) ...
    ];

assert(ischar(measurement_id), ...
    ['BRAPH:AnalysisDTI:getMeasurementID'], ...
    ['AnalysisDTI.getMeasurementID() not creating an ID']) %#ok<*NBRAK>
assert(isequal(measurement_id, expected_value), ...
    ['BRAPH:AnalysisDTI:getMeasurementID'], ...
    ['AnalysisDTI.getMeasurementID() not creating correct ID']) %#ok<*NBRAK>

comparison_id = analysis.getComparisonID('Distance', {group1, group2});
expected_value = [ ...
    tostring(analysis.getComparisonClass()) ' ' ...
    tostring('Distance') ' ' ...
    tostring(analysis.getCohort().getGroups().getIndex(group1)) ' ' ...
    tostring(analysis.getCohort().getGroups().getIndex(group2)) ...
    ];
assert(ischar(comparison_id), ...
    ['BRAPH:AnalysisDTI:getComparisonID'], ...
    ['AnalysisDTI.getComparisonID() not creating an ID']) %#ok<*NBRAK>
assert(isequal(comparison_id, expected_value), ...
    ['BRAPH:AnalysisDTI:getComparisonID'], ...
    ['AnalysisDTI.getComparisonID() not creating correct ID']) %#ok<*NBRAK>

randomcomparison_id = analysis.getRandomComparisonID('PathLength', group1);
expected_value = [ ...
    tostring(analysis.getRandomComparisonClass()) ' ' ...
    tostring('PathLength') ' ' ...
    tostring(analysis.getCohort().getGroups().getIndex(group1)) ...
    ];
assert(ischar(randomcomparison_id), ...
    ['BRAPH:AnalysisDTI:getRandomComparisonID'], ...
    ['AnalysisDTI.getRandomComparisonID() not creating an ID']) %#ok<*NBRAK>
assert(isequal(randomcomparison_id, expected_value), ...
    ['BRAPH:AnalysisDTI:getRandomComparisonID'], ...
    ['AnalysisDTI.getRandomComparisonID() not creating correct ID']) %#ok<*NBRAK>

%% Test 3: Calculate Measurement
for i = 1:1:length(measures)
    measure = measures{i};
    analysis = AnalysisDTI(cohort, {}, {}, {});
    calculated_measurement = analysis.calculateMeasurement(measure, group1);
    
    assert(~isempty(calculated_measurement), ...
        ['BRAPH:AnalysisDTI:calculateMeasurement'], ...
        ['AnalysisDTI.calculateMeasurement() not working']) %#ok<*NBRAK>
    
    calculated_measurement = analysis.getMeasurements().getValue(1);
    calculated_value = calculated_measurement.getMeasureValues();
    calculted_average = calculated_measurement.getGroupAverageValue();
    
    if Measure.is_global(measure)
        
        assert(isequal(calculated_measurement.getMeasureCode(), measure), ...
            ['BRAPH:AnalysisDTI:calculateMeasurement'], ...
            ['AnalysisDTI.calculateMeasurement() not working for global']) %#ok<*NBRAK>
        assert(iscell(calculated_value) & ...
            isequal(numel(calculated_value), group1.subjectnumber) & ...
            all(cellfun(@(x) isequal(size(x), [1, 1]), calculated_value)), ...
            ['BRAPH:AnalysisDTI:Instantiation'], ...
            ['AnalysisDTI does not initialize correctly with global measures.']) %#ok<*NBRAK>
        assert(isequal(size(calculted_average), [1 1]), ...
            ['BRAPH:AnalysisDTI:Instantiation'], ...
            ['AnalysisDTI does not initialize correctly with global measures.']) %#ok<*NBRAK>
        
    elseif Measure.is_nodal(measure)
        
        assert(isequal(calculated_measurement.getMeasureCode(), measure), ...
            ['BRAPH:AnalysisDTI:calculateMeasurement'], ...
            ['AnalysisDTI.calculateMeasurement() not working for nodal']) %#ok<*NBRAK>
        assert(iscell(calculated_value) & ...
            isequal(numel(calculated_value), group1.subjectnumber) & ...
            all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), calculated_value)), ...
            ['BRAPH:AnalysisDTI:Instantiation'], ...
            ['AnalysisDTI does not initialize correctly with nodal measures.']) %#ok<*NBRAK>
        assert(isequal(size(calculted_average), [atlas.getBrainRegions().length(), 1]), ...
            ['BRAPH:AnalysisDTI:Instantiation'], ...
            ['AnalysisDTI does not initialize correctly with nodal measures.']) %#ok<*NBRAK>
    
    elseif Measure.is_binodal(measure)
        
        assert(isequal(calculated_measurement.getMeasureCode(), measure), ...
            ['BRAPH:AnalysisDTI:calculateMeasurement'], ...
            ['AnalysisDTI.calculateMeasurement() not working for binodal']) %#ok<*NBRAK>
        assert(iscell(calculated_value) & ...
            isequal(numel(calculated_value), group1.subjectnumber) & ...
            all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), calculated_value)), ...
            ['BRAPH:MeasurementDTI:Instantiation'], ...
            ['MeasurementDTI does not initialize correctly with binodal measures.']) %#ok<*NBRAK>
        assert(isequal(size(calculted_average), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), ...
            ['BRAPH:MeasurementDTI:Instantiation'], ...
            ['MeasurementDTI does not initialize correctly with binodal measures.']) %#ok<*NBRAK>
    end
end

% %% Test 4: Compare
% for i = 1:1:numel(measures)
%     measure = measures{i};
%     analysis = AnalysisDTI(cohort, {}, {}, {});
%     % global-Assortativity nodal-Eccentricity binodal-Distance
%     calculate_comparition = analysis.calculateComparison(measure, {group1, group2}, 'NumerOfPermutations', 10);
%     
%     assert(~isempty(calculate_comparition), ...
%         ['BRAPH:AnalysisDTI:calculateComparison'], ...
%         ['AnalysisDTI.calculateComparison() not working']) %#ok<*NBRAK>
%     
%     assert(analysis.getComparisons().length() == 1, ...
%         ['BRAPH:AnalysisDTI:calculateComparison'], ...
%         ['AnalysisDTI.calculateComparison() not working'])
%     
%     compariton = analysis.getComparisons().getValue(1);
% end
