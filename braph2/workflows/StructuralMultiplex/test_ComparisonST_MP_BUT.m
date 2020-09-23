% test ComparisonST_MP_BUT

br1 = BrainRegion('BR1', 'brain region 1', 'notes 1', 1, 1.1, 1.11);
br2 = BrainRegion('BR2', 'brain region 2', 'notes 2', 2, 2.2, 2.22);
br3 = BrainRegion('BR3', 'brain region 3', 'notes 3', 3, 3.3, 3.33);
br4 = BrainRegion('BR4', 'brain region 4', 'notes 4', 4, 4.4, 4.44);
br5 = BrainRegion('BR5', 'brain region 5', 'notes 5', 5, 5.5, 5.55);
atlas = BrainAtlas('BA', 'brain atlas', 'notes', 'BrainMesh_ICBM152.nv', {br1, br2, br3, br4, br5});

subject_class = Comparison.getSubjectClass('ComparisonST_MP_BUT');

sub1 = Subject.getSubject(subject_class, 'id1', 'label 1', 'notes 1', atlas);
sub2 = Subject.getSubject(subject_class, 'id2', 'label 2', 'notes 2', atlas);
sub3 = Subject.getSubject(subject_class, 'id3', 'label 3', 'notes 3', atlas);
sub4 = Subject.getSubject(subject_class, 'id4', 'label 4', 'notes 4', atlas);
sub5 = Subject.getSubject(subject_class, 'id5', 'label 5', 'notes 5', atlas);

group = Group(subject_class, 'id', 'label', 'notes', {sub1, sub2, sub3, sub4, sub5});

graph_type = AnalysisST_MP_BUT.getGraphType();
measures = Graph.getCompatibleMeasureList(graph_type);

%% Test 1: Instantiation
for i = 1:1:numel(measures) 
    comparison = ComparisonST_MP_BUT('c1', 'label', 'notes', atlas, measures{i}, group, group);
end

%% Test 2: Correct Size defaults
for i = 1:1:numel(measures)
    number_of_permutations = 10;
            
    B = rand(atlas.getBrainRegions().length());
    A = {B, B; B, B};
    g = Graph.getGraph('MultiplexGraphBU', A);
    m  = Measure.getMeasure(measures{i}, g);
    parameter_values = m.getParameterValues();
    parameter_values_length = max(1, length(parameter_values));
    
    comparison = ComparisonST_MP_BUT('c1', 'label', 'notes', atlas, measures{i}, group, group, 'ComparisonST_MP.PermutationNumber', number_of_permutations, 'ComparisonST_MP.ParameterValuesLength', parameter_values_length);
    
    value_1 = comparison.getGroupValue(1);    
    value_2 = comparison.getGroupValue(2);
    difference = comparison.getDifference();  % difference
    all_differences = comparison.getAllDifferences(); % all differences obtained through the permutation test
    p1 = comparison.getP1(); % p value single tailed
    p2 = comparison.getP2();  % p value double tailed
    confidence_interval_min = comparison.getConfidenceIntervalMin();  % min value of the 95% confidence interval
    confidence_interval_max = comparison.getConfidenceIntervalMax(); % max value of the 95% confidence interval
    comparison_parameter_values = comparison.getMeasureParameterValues();
    comparison_parameter_values_length = max(1, length(comparison_parameter_values));
    
    assert(isequal(parameter_values_length, comparison_parameter_values_length),  ...
    [BRAPH2.STR ':ComparisonST_MP_BUT:' BRAPH2.BUG_FUNC], ...
    'ComparisonST_MP_BUT does not initialize correctly the parameter of the measures')

    if Measure.is_superglobal(measures{i})  % superglobal measure
        num_elements = 1;
    elseif Measure.is_unilayer(measures{i})  % unilayer measure
        num_elements = 2;
    elseif Measure.is_bilayer(measures{i})  % bilayer measure
        num_elements = 4;
    end
            
    if Measure.is_global(measures{i})
        assert(iscell(value_1) && ...
            isequal(numel(value_1), num_elements) && ...
            all(cellfun(@(x) isequal(size(x, 1), 1), value_1)) && ...
            all(cellfun(@(x) isequal(size(x, 2), 1), value_1)), ...
            all(cellfun(@(x) isequal(size(x, 3), parameter_values_length), value_1)), ...
            [BRAPH2.STR ':ComparisonST_MP_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonST_MP_BUT does not initialize correctly with global measures')
        
        assert(iscell(value_2) && ...
            isequal(numel(value_2), num_elements) && ...
            all(cellfun(@(x) isequal(size(x, 1), 1), value_2)) && ...
            all(cellfun(@(x) isequal(size(x, 2), 1), value_2)), ...
            all(cellfun(@(x) isequal(size(x, 3), parameter_values_length), value_2)), ...
            [BRAPH2.STR ':ComparisonST_MP_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonST_MP_BUT does not initialize correctly with global measures')
        
        assert(iscell(difference) && ...
            isequal(numel(difference), num_elements) && ...
            all(cellfun(@(x) isequal(size(x, 1), 1), difference)) && ...
            all(cellfun(@(x) isequal(size(x, 2), 1), difference)), ...
            all(cellfun(@(x) isequal(size(x, 3), parameter_values_length), difference)), ...
            [BRAPH2.STR ':ComparisonST_MP_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonST_MP_BUT does not initialize correctly with global measures')

        assert(iscell(all_differences) && ...
            isequal(numel(all_differences), num_elements*number_of_permutations) && ...
            all(all(cellfun(@(x) isequal(size(x, 1), 1), all_differences))) && ...
            all(all(cellfun(@(x) isequal(size(x, 2), 1), all_differences))), ...
            all(all(cellfun(@(x) isequal(size(x, 3), parameter_values_length), all_differences))), ...
            [BRAPH2.STR ':ComparisonST_MP_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonST_MP_BUT does not initialize correctly with global measures')

        assert(iscell(p1) && ...
            isequal(numel(p1), num_elements) && ...
            all(cellfun(@(x) isequal(size(x, 1), 1), p1)) && ...
            all(cellfun(@(x) isequal(size(x, 2), 1), p1)), ...
            all(cellfun(@(x) isequal(size(x, 3), parameter_values_length), p1)), ...
            [BRAPH2.STR ':ComparisonST_MP_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonST_MP_BUT does not initialize correctly with global measures')
        
        assert(iscell(p2) && ...
            isequal(numel(p2), num_elements) && ...
            all(cellfun(@(x) isequal(size(x, 1), 1), p2)) && ...
            all(cellfun(@(x) isequal(size(x, 2), 1), p2)), ...
            all(cellfun(@(x) isequal(size(x, 3), parameter_values_length), p2)), ...
            [BRAPH2.STR ':ComparisonST_MP_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonST_MP_BUT does not initialize correctly with global measures')
        
        assert(iscell(confidence_interval_min) && ...
            isequal(numel(confidence_interval_min), num_elements) && ...
            all(cellfun(@(x) isequal(size(x, 1), 1), confidence_interval_min)) && ...
            all(cellfun(@(x) isequal(size(x, 2), 1), confidence_interval_min)), ...
            all(cellfun(@(x) isequal(size(x, 3), parameter_values_length), confidence_interval_min)), ...
            [BRAPH2.STR ':ComparisonST_MP_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonST_MP_BUT does not initialize correctly with global measures')

        assert(iscell(confidence_interval_max) && ...
            isequal(numel(confidence_interval_max), num_elements) && ...
            all(cellfun(@(x) isequal(size(x, 1), 1), confidence_interval_max)) && ...
            all(cellfun(@(x) isequal(size(x, 2), 1), confidence_interval_max)), ...
            all(cellfun(@(x) isequal(size(x, 3), parameter_values_length), confidence_interval_max)), ...
            [BRAPH2.STR ':ComparisonST_MP_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonST_MP_BUT does not initialize correctly with global measures')
        
    elseif Measure.is_nodal(measures{i})
        
        assert(iscell(value_1) && ...
            isequal(numel(value_1), num_elements) && ...
            all(cellfun(@(x) isequal(size(x, 1), atlas.getBrainRegions().length()), value_1)) && ...
            all(cellfun(@(x) isequal(size(x, 2), 1), value_1)), ...
            all(cellfun(@(x) isequal(size(x, 3), parameter_values_length), value_1)), ...
            [BRAPH2.STR ':ComparisonST_MP_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonST_MP_BUT does not initialize correctly with nodal measures')
        
        assert(iscell(value_2) && ...
            isequal(numel(value_2), num_elements) && ...
            all(cellfun(@(x) isequal(size(x, 1), atlas.getBrainRegions().length()), value_2)) && ...
            all(cellfun(@(x) isequal(size(x, 2), 1), value_2)), ...
            all(cellfun(@(x) isequal(size(x, 3), parameter_values_length), value_2)), ...
            [BRAPH2.STR ':ComparisonST_MP_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonST_MP_BUT does not initialize correctly with nodal measures')
        
        assert(iscell(difference) && ...
            isequal(numel(difference), num_elements) && ...
            all(cellfun(@(x) isequal(size(x, 1), atlas.getBrainRegions().length()), difference)) && ...
            all(cellfun(@(x) isequal(size(x, 2), 1), difference)), ...
            all(cellfun(@(x) isequal(size(x, 3), parameter_values_length), difference)), ...
            [BRAPH2.STR ':ComparisonST_MP_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonST_MP_BUT does not initialize correctly with nodal measures')

        assert(iscell(all_differences) && ...
            isequal(numel(all_differences), num_elements*number_of_permutations) && ...
            all(all(cellfun(@(x) isequal(size(x, 1), atlas.getBrainRegions().length()), all_differences))) && ...
            all(all(cellfun(@(x) isequal(size(x, 2), 1), all_differences))), ...
            all(all(cellfun(@(x) isequal(size(x, 3), parameter_values_length), all_differences))), ...
            [BRAPH2.STR ':ComparisonST_MP_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonST_MP_BUT does not initialize correctly with nodal measures')

        assert(iscell(p1) && ...
            isequal(numel(p1), num_elements) && ...
            all(cellfun(@(x) isequal(size(x, 1), atlas.getBrainRegions().length()), p1)) && ...
            all(cellfun(@(x) isequal(size(x, 2), 1), p1)), ...
            all(cellfun(@(x) isequal(size(x, 3), parameter_values_length), p1)), ...
            [BRAPH2.STR ':ComparisonST_MP_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonST_MP_BUT does not initialize correctly with nodal measures')
        
        assert(iscell(p2) && ...
            isequal(numel(p2), num_elements) && ...
            all(cellfun(@(x) isequal(size(x, 1), atlas.getBrainRegions().length()), p2)) && ...
            all(cellfun(@(x) isequal(size(x, 2), 1), p2)), ...
            all(cellfun(@(x) isequal(size(x, 3), parameter_values_length), p2)), ...
            [BRAPH2.STR ':ComparisonST_MP_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonST_MP_BUT does not initialize correctly with nodal measures')
        
        assert(iscell(confidence_interval_min) && ...
            isequal(numel(confidence_interval_min), num_elements) && ...
            all(cellfun(@(x) isequal(size(x, 1), atlas.getBrainRegions().length()), confidence_interval_min)) && ...
            all(cellfun(@(x) isequal(size(x, 2), 1), confidence_interval_min)), ...
            all(cellfun(@(x) isequal(size(x, 3), parameter_values_length), confidence_interval_min)), ...
            [BRAPH2.STR ':ComparisonST_MP_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonST_MP_BUT does not initialize correctly with nodal measures')

        assert(iscell(confidence_interval_max) && ...
            isequal(numel(confidence_interval_max), num_elements) && ...
            all(cellfun(@(x) isequal(size(x, 1), atlas.getBrainRegions().length()), confidence_interval_max)) && ...
            all(cellfun(@(x) isequal(size(x, 2), 1), confidence_interval_max)), ...
            all(cellfun(@(x) isequal(size(x, 3), parameter_values_length), confidence_interval_max)), ...
            [BRAPH2.STR ':ComparisonST_MP_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonST_MP_BUT does not initialize correctly with nodal measures')
        
    elseif Measure.is_binodal(measures{i})
        
        assert(iscell(value_1) && ...
            isequal(numel(value_1), num_elements) && ...
            all(cellfun(@(x) isequal(size(x, 1), atlas.getBrainRegions().length()), value_1)) && ...
            all(cellfun(@(x) isequal(size(x, 2), atlas.getBrainRegions().length()), value_1)), ...
            all(cellfun(@(x) isequal(size(x, 3), parameter_values_length), value_1)), ...
            [BRAPH2.STR ':ComparisonST_MP_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonST_MP_BUT does not initialize correctly with binodal measures')
        
        assert(iscell(value_2) && ...
            isequal(numel(value_2), num_elements) && ...
            all(cellfun(@(x) isequal(size(x, 1), atlas.getBrainRegions().length()), value_2)) && ...
            all(cellfun(@(x) isequal(size(x, 2), atlas.getBrainRegions().length()), value_2)), ...
            all(cellfun(@(x) isequal(size(x, 3), parameter_values_length), value_2)), ...
            [BRAPH2.STR ':ComparisonST_MP_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonST_MP_BUT does not initialize correctly with binodal measures')
        
        assert(iscell(difference) && ...
            isequal(numel(difference), num_elements) && ...
            all(cellfun(@(x) isequal(size(x, 1), atlas.getBrainRegions().length()), difference)) && ...
            all(cellfun(@(x) isequal(size(x, 2), atlas.getBrainRegions().length()), difference)), ...
            all(cellfun(@(x) isequal(size(x, 3), parameter_values_length), difference)), ...
            [BRAPH2.STR ':ComparisonST_MP_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonST_MP_BUT does not initialize correctly with binodal measures')

        assert(iscell(all_differences) && ...
            isequal(numel(all_differences), num_elements*number_of_permutations) && ...
            all(all(cellfun(@(x) isequal(size(x, 1), atlas.getBrainRegions().length()), all_differences))) && ...
            all(all(cellfun(@(x) isequal(size(x, 2), atlas.getBrainRegions().length()), all_differences))), ...
            all(all(cellfun(@(x) isequal(size(x, 3), parameter_values_length), all_differences))), ...
            [BRAPH2.STR ':ComparisonST_MP_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonST_MP_BUT does not initialize correctly with binodal measures')

        assert(iscell(p1) && ...
            isequal(numel(p1), num_elements) && ...
            all(cellfun(@(x) isequal(size(x, 1), atlas.getBrainRegions().length()), p1)) && ...
            all(cellfun(@(x) isequal(size(x, 2), atlas.getBrainRegions().length()), p1)), ...
            all(cellfun(@(x) isequal(size(x, 3), parameter_values_length), p1)), ...
            [BRAPH2.STR ':ComparisonST_MP_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonST_MP_BUT does not initialize correctly with binodal measures')
        
        assert(iscell(p2) && ...
            isequal(numel(p2), num_elements) && ...
            all(cellfun(@(x) isequal(size(x, 1), atlas.getBrainRegions().length()), p2)) && ...
            all(cellfun(@(x) isequal(size(x, 2), atlas.getBrainRegions().length()), p2)), ...
            all(cellfun(@(x) isequal(size(x, 3), parameter_values_length), p2)), ...
            [BRAPH2.STR ':ComparisonST_MP_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonST_MP_BUT does not initialize correctly with binodal measures')
        
        assert(iscell(confidence_interval_min) && ...
            isequal(numel(confidence_interval_min), num_elements) && ...
            all(cellfun(@(x) isequal(size(x, 1), atlas.getBrainRegions().length()), confidence_interval_min)) && ...
            all(cellfun(@(x) isequal(size(x, 2), atlas.getBrainRegions().length()), confidence_interval_min)), ...
            all(cellfun(@(x) isequal(size(x, 3), parameter_values_length), confidence_interval_min)), ...
            [BRAPH2.STR ':ComparisonST_MP_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonST_MP_BUT does not initialize correctly with binodal measures')

        assert(iscell(confidence_interval_max) && ...
            isequal(numel(confidence_interval_max), num_elements) && ...
            all(cellfun(@(x) isequal(size(x, 1), atlas.getBrainRegions().length()), confidence_interval_max)) && ...
            all(cellfun(@(x) isequal(size(x, 2), atlas.getBrainRegions().length()), confidence_interval_max)), ...
            all(cellfun(@(x) isequal(size(x, 3), parameter_values_length), confidence_interval_max)), ...
            [BRAPH2.STR ':ComparisonST_MP_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonST_MP_BUT does not initialize correctly with binodal measures')
    end
end

%% Test 3: Initialize with values
for i = 1:1:numel(measures)
    % setup
    number_of_permutations = 10;
    
    B = rand(atlas.getBrainRegions().length());
    A = {B, B; B, B};
    g = Graph.getGraph('MultiplexGraphBU', A);
    m  = Measure.getMeasure(measures{i}, g);
    value = m.getValue();
    parameter_values = m.getParameterValues();
    parameter_values_length = max(1, length(parameter_values));
    
    % the values are not realistic, just the right format
    value_1 = value;
    value_2 = value;
    difference = value;
    all_differences = repmat(value, 1, number_of_permutations);
    p1 = difference;  % all similar
    p2 = difference;
    confidence_interval_min = difference;
    confidence_interval_max = difference;
    
    % act
    comparison = ComparisonST_MP_BUT('c1', ...
        'comparison label', ...
        'comparison notes', ...
        atlas, ...
        measures{i}, ...
        group, ...
        group, ...
        'ComparisonST_MP.PermutationNumber', number_of_permutations, ...
        'ComparisonST_MP.value_1', value_1, ...
        'ComparisonST_MP.value_2', value_2, ...
        'ComparisonST_MP.difference', difference, ...
        'ComparisonST_MP.all_differences', all_differences, ...
        'ComparisonST_MP.p1', p1, ...
        'ComparisonST_MP.p2', p2, ....
        'ComparisonST_MP.confidence_min', confidence_interval_min, ...
        'ComparisonST_MP.confidence_max', confidence_interval_max, ...
        'ComparisonST_MP.ParameterValues', parameter_values ...
        );
    
    comparison_value_1 = comparison.getGroupValue(1);
    comparison_value_2 = comparison.getGroupValue(2);
    comparison_difference = comparison.getDifference();
    comparison_all_differences = comparison.getAllDifferences();
    comparison_p1 = comparison.getP1();
    comparison_p2 = comparison.getP2();
    comparison_confidence_interval_min = comparison.getConfidenceIntervalMin();
    comparison_confidence_interval_max = comparison.getConfidenceIntervalMax();
    comparison_parameter_values = comparison.getMeasureParameterValues();
    
    % assert
    if Measure.is_superglobal(measures{i})  % superglobal measure
        num_elements = 1;
    elseif Measure.is_unilayer(measures{i})  % unilayer measure
        num_elements = 2;
    elseif Measure.is_bilayer(measures{i})  % bilayer measure
        num_elements = 4;
    end
    
    if Measure.is_global(measures{i})
        
        assert(iscell(comparison_value_1) && ...
            isequal(numel(comparison_value_1), num_elements) && ...
            all(cellfun(@(x) isequal(size(x, 1), 1), comparison_value_1)) && ...
            all(cellfun(@(x) isequal(size(x, 2), 1), comparison_value_1)) && ...
            all(cellfun(@(x) isequal(size(x, 3), parameter_values_length), comparison_value_1)), ...   
            [BRAPH2.STR ':ComparisonST_MP_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonST_MP_BUT does not initialize correctly with global measures')
        
        assert(iscell(comparison_value_2) && ...
            isequal(numel(comparison_value_2), num_elements) && ...
            all(cellfun(@(x) isequal(size(x, 1), 1), comparison_value_2)) && ...
            all(cellfun(@(x) isequal(size(x, 2), 1), comparison_value_2)) && ...
            all(cellfun(@(x) isequal(size(x, 3), parameter_values_length), comparison_value_2)), ... 
            [BRAPH2.STR ':ComparisonST_MP_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonST_MP_BUT does not initialize correctly with global measures')
        
        assert(iscell(comparison_difference) && ...
            isequal(numel(comparison_difference), num_elements) && ...
            all(cellfun(@(x) isequal(size(x, 1), 1), comparison_difference)) && ...
            all(cellfun(@(x) isequal(size(x, 2), 1), comparison_difference)) && ...
            all(cellfun(@(x) isequal(size(x, 3), parameter_values_length), comparison_difference)), ...     
            [BRAPH2.STR ':ComparisonST_MP_BUT:' BRAPH2.WRONG_OUTPUT], ...
            'ComparisonST_MP_BUT does not initialize correctly with global measures')
        
        assert(iscell(comparison_all_differences) && ...
            isequal(numel(comparison_all_differences), num_elements*number_of_permutations) && ...
            all(all(cellfun(@(x) isequal(size(x, 1), 1), comparison_all_differences))) && ...
            all(all(cellfun(@(x) isequal(size(x, 2), 1), comparison_all_differences))) && ...
            all(all(cellfun(@(x) isequal(size(x, 3), parameter_values_length), comparison_all_differences))), ...       
            [BRAPH2.STR ':ComparisonST_MP_BUT:' BRAPH2.WRONG_OUTPUT], ...
            'ComparisonST_MP_BUT does not initialize correctly with global measures')
        
        assert(iscell(comparison_p1) && ...
            isequal(numel(comparison_p1), num_elements) && ...
            all(cellfun(@(x) isequal(size(x, 1), 1), comparison_p1)) && ...
            all(cellfun(@(x) isequal(size(x, 2), 1), comparison_p1)) && ...
            all(cellfun(@(x) isequal(size(x, 3), parameter_values_length), comparison_p1)), ...      
            [BRAPH2.STR ':ComparisonST_MP_BUT:' BRAPH2.WRONG_OUTPUT], ...
            'ComparisonST_MP_BUT does not initialize correctly with global measures')

        assert(iscell(comparison_p2) && ...
            isequal(numel(comparison_p2), num_elements) && ...
            all(cellfun(@(x) isequal(size(x, 1), 1), comparison_p2)) && ...
            all(cellfun(@(x) isequal(size(x, 2), 1), comparison_p2)) && ...
            all(cellfun(@(x) isequal(size(x, 3), parameter_values_length), comparison_p2)), ...    
            [BRAPH2.STR ':ComparisonST_MP_BUT:' BRAPH2.WRONG_OUTPUT], ...
            'ComparisonST_MP_BUT does not initialize correctly with global measures')
        
        assert(iscell(comparison_confidence_interval_min) && ...
            isequal(numel(comparison_confidence_interval_min), num_elements) && ...
            all(cellfun(@(x) isequal(size(x, 1), 1), comparison_confidence_interval_min)) && ...
            all(cellfun(@(x) isequal(size(x, 2), 1), comparison_confidence_interval_min)) && ...
            all(cellfun(@(x) isequal(size(x, 3), parameter_values_length), comparison_confidence_interval_min)), ...      
            [BRAPH2.STR ':ComparisonST_MP_BUT:' BRAPH2.WRONG_OUTPUT], ...
            'ComparisonST_MP_BUT does not initialize correctly with global measures')

        assert(iscell(comparison_confidence_interval_max) && ...
            isequal(numel(comparison_confidence_interval_max), num_elements) && ...
            all(cellfun(@(x) isequal(size(x, 1), 1), comparison_confidence_interval_max)) && ...
            all(cellfun(@(x) isequal(size(x, 2), 1), comparison_confidence_interval_max)) && ...
            all(cellfun(@(x) isequal(size(x, 3), parameter_values_length), comparison_confidence_interval_max)), ... 
            [BRAPH2.STR ':ComparisonST_MP_BUT:' BRAPH2.WRONG_OUTPUT], ...
            'ComparisonST_MP_BUT does not initialize correctly with global measures')
        
    elseif Measure.is_nodal(measures{i})
        
        assert(iscell(comparison_value_1) && ...
            isequal(numel(comparison_value_1), num_elements) && ...
            all(cellfun(@(x) isequal(size(x, 1), atlas.getBrainRegions().length()), comparison_value_1)) && ...
            all(cellfun(@(x) isequal(size(x, 2), 1), comparison_value_1)) && ...
            all(cellfun(@(x) isequal(size(x, 3), parameter_values_length), comparison_value_1)), ...
            [BRAPH2.STR ':ComparisonST_MP_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonST_MP_BUT does not initialize correctly with binodal measures')
        
        assert(iscell(comparison_value_2) && ...
            isequal(numel(comparison_value_2), num_elements) && ...
            all(cellfun(@(x) isequal(size(x, 1), atlas.getBrainRegions().length()), comparison_value_2)) && ...
            all(cellfun(@(x) isequal(size(x, 2), 1), comparison_value_2)) && ...
            all(cellfun(@(x) isequal(size(x, 3), parameter_values_length), comparison_value_2)), ...
            [BRAPH2.STR ':ComparisonST_MP_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonST_MP_BUT does not initialize correctly with nodal measures')
        
        assert(iscell(comparison_difference) && ...
            isequal(numel(comparison_difference), num_elements) && ...
            all(cellfun(@(x) isequal(size(x, 1), atlas.getBrainRegions().length()), comparison_difference)) && ...
            all(cellfun(@(x) isequal(size(x, 2), 1), comparison_difference)) && ...
            all(cellfun(@(x) isequal(size(x, 3), parameter_values_length), comparison_difference)), ...       
            [BRAPH2.STR ':ComparisonST_MP_BUT:' BRAPH2.WRONG_OUTPUT], ...
            'ComparisonST_MP_BUT does not initialize correctly with nodal measures')
        
        assert(iscell(comparison_all_differences) && ...
            isequal(numel(comparison_all_differences), num_elements*number_of_permutations) && ...
            all(all(cellfun(@(x) isequal(size(x, 1), atlas.getBrainRegions().length()), comparison_all_differences))) && ...
            all(all(cellfun(@(x) isequal(size(x, 2), 1), comparison_all_differences))) && ...
            all(all(cellfun(@(x) isequal(size(x, 3), parameter_values_length), comparison_all_differences))), ...      
            [BRAPH2.STR ':ComparisonST_MP_BUT:' BRAPH2.WRONG_OUTPUT], ...
            'ComparisonST_MP_BUT does not initialize correctly with nodal measures')
        
        assert(iscell(comparison_p1) && ...
            isequal(numel(comparison_p1), num_elements) && ...
            all(cellfun(@(x) isequal(size(x, 1), atlas.getBrainRegions().length()), comparison_p1)) && ...
            all(cellfun(@(x) isequal(size(x, 2), 1), comparison_p1)) && ...
            all(cellfun(@(x) isequal(size(x, 3), parameter_values_length), comparison_p1)), ...      
            [BRAPH2.STR ':ComparisonST_MP_BUT:' BRAPH2.WRONG_OUTPUT], ...
            'ComparisonST_MP_BUT does not initialize correctly with nodal measures')

        assert(iscell(comparison_p2) && ...
            isequal(numel(comparison_p2), num_elements) && ...
            all(cellfun(@(x) isequal(size(x, 1), atlas.getBrainRegions().length()), comparison_p2)) && ...
            all(cellfun(@(x) isequal(size(x, 2), 1), comparison_p2)) && ...
            all(cellfun(@(x) isequal(size(x, 3), parameter_values_length), comparison_p2)), ...
            [BRAPH2.STR ':ComparisonST_MP_BUT:' BRAPH2.WRONG_OUTPUT], ...
            'ComparisonST_MP_BUT does not initialize correctly with nodal measures')
        
        assert(iscell(comparison_confidence_interval_min) && ...
            isequal(numel(comparison_confidence_interval_min), num_elements) && ...
            all(cellfun(@(x) isequal(size(x, 1), atlas.getBrainRegions().length()), comparison_confidence_interval_min)) && ...
            all(cellfun(@(x) isequal(size(x, 2), 1), comparison_confidence_interval_min)) && ...
            all(cellfun(@(x) isequal(size(x, 3), parameter_values_length), comparison_confidence_interval_min)), ...
            [BRAPH2.STR ':ComparisonST_MP_BUT:' BRAPH2.WRONG_OUTPUT], ...
            'ComparisonST_MP_BUT does not initialize correctly with nodal measures')

        assert(iscell(comparison_confidence_interval_max) && ...
            isequal(numel(comparison_confidence_interval_max), num_elements) && ...
            all(cellfun(@(x) isequal(size(x, 1), atlas.getBrainRegions().length()), comparison_confidence_interval_max)) && ...
            all(cellfun(@(x) isequal(size(x, 2), 1), comparison_confidence_interval_max)) && ...
            all(cellfun(@(x) isequal(size(x, 3), parameter_values_length), comparison_confidence_interval_max)), ...
            [BRAPH2.STR ':ComparisonST_MP_BUT:' BRAPH2.WRONG_OUTPUT], ...
            'ComparisonST_MP_BUT does not initialize correctly with nodal measures')
        
    elseif Measure.is_binodal(measures{i})
        
        assert(iscell(comparison_value_1) && ...
            isequal(numel(comparison_value_1), num_elements) && ...
            all(cellfun(@(x) isequal(size(x, 1), atlas.getBrainRegions().length()), comparison_value_1)) && ...
            all(cellfun(@(x) isequal(size(x, 2), atlas.getBrainRegions().length()), comparison_value_1)) && ...
            all(cellfun(@(x) isequal(size(x, 3), parameter_values_length), comparison_value_1)), ... 
            [BRAPH2.STR ':ComparisonST_MP_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonST_MP_BUT does not initialize correctly with binodal measures')
        
        assert(iscell(comparison_value_2) && ...
            isequal(numel(comparison_value_2), num_elements) && ...
            all(cellfun(@(x) isequal(size(x, 1), atlas.getBrainRegions().length()), comparison_value_2)) && ...
            all(cellfun(@(x) isequal(size(x, 2), atlas.getBrainRegions().length()), comparison_value_2)) && ...
            all(cellfun(@(x) isequal(size(x, 3), parameter_values_length), comparison_value_2)), ... 
            [BRAPH2.STR ':ComparisonST_MP_BUT:' BRAPH2.BUG_FUNC], ...
            'ComparisonST_MP_BUT does not initialize correctly with binodal measures')
        
        assert(iscell(comparison_difference) && ...
            isequal(numel(comparison_difference), num_elements) && ...
            all(cellfun(@(x) isequal(size(x, 1), atlas.getBrainRegions().length()), comparison_difference)) && ...
            all(cellfun(@(x) isequal(size(x, 2), atlas.getBrainRegions().length()), comparison_difference)) && ...
            all(cellfun(@(x) isequal(size(x, 3), parameter_values_length), comparison_difference)), ...   
            [BRAPH2.STR ':ComparisonST_MP_BUT:' BRAPH2.WRONG_OUTPUT], ...
            'ComparisonST_MP_BUT does not initialize correctly with binodal measures')
        
        assert(iscell(comparison_all_differences) && ...
            isequal(numel(comparison_all_differences), num_elements*number_of_permutations) && ...
            all(all(cellfun(@(x) isequal(size(x, 1), atlas.getBrainRegions().length()), comparison_all_differences))) && ...
            all(all(cellfun(@(x) isequal(size(x, 2), atlas.getBrainRegions().length()), comparison_all_differences))) && ...
            all(all(cellfun(@(x) isequal(size(x, 3), parameter_values_length), comparison_all_differences))), ... 
            [BRAPH2.STR ':ComparisonST_MP_BUT:' BRAPH2.WRONG_OUTPUT], ...
            'ComparisonST_MP_BUT does not initialize correctly with binodal measures')
        
        assert(iscell(comparison_p1) && ...
            isequal(numel(comparison_p1), num_elements) && ...
            all(cellfun(@(x) isequal(size(x, 1), atlas.getBrainRegions().length()), comparison_p1)) && ...
            all(cellfun(@(x) isequal(size(x, 2), atlas.getBrainRegions().length()), comparison_p1)) && ...
            all(cellfun(@(x) isequal(size(x, 3), parameter_values_length), comparison_p1)), ...      
            [BRAPH2.STR ':ComparisonST_MP_BUT:' BRAPH2.WRONG_OUTPUT], ...
            'ComparisonST_MP_BUT does not initialize correctly with binodal measures')

        assert(iscell(comparison_p2) && ...
            isequal(numel(comparison_p2), num_elements) && ...
            all(cellfun(@(x) isequal(size(x, 1), atlas.getBrainRegions().length()), comparison_p2)) && ...
            all(cellfun(@(x) isequal(size(x, 2), atlas.getBrainRegions().length()), comparison_p2)) && ...
            all(cellfun(@(x) isequal(size(x, 3), parameter_values_length), comparison_p2)), ... 
            [BRAPH2.STR ':ComparisonST_MP_BUT:' BRAPH2.WRONG_OUTPUT], ...
            'ComparisonST_MP_BUT does not initialize correctly with binodal measures')
        
        assert(iscell(comparison_confidence_interval_min) && ...
            isequal(numel(comparison_confidence_interval_min), num_elements) && ...
            all(cellfun(@(x) isequal(size(x, 1), atlas.getBrainRegions().length()), comparison_confidence_interval_min)) && ...
            all(cellfun(@(x) isequal(size(x, 2), atlas.getBrainRegions().length()), comparison_confidence_interval_min)) && ...
            all(cellfun(@(x) isequal(size(x, 3), parameter_values_length), comparison_confidence_interval_min)), ...
            [BRAPH2.STR ':ComparisonST_MP_BUT:' BRAPH2.WRONG_OUTPUT], ...
            'ComparisonST_MP_BUT does not initialize correctly with binodal measures')

        assert(iscell(comparison_confidence_interval_max) && ...
            isequal(numel(comparison_confidence_interval_max), num_elements) && ...
            all(cellfun(@(x) isequal(size(x, 1), atlas.getBrainRegions().length()), comparison_confidence_interval_max)) && ...
            all(cellfun(@(x) isequal(size(x, 2), atlas.getBrainRegions().length()), comparison_confidence_interval_max)) && ...
            all(cellfun(@(x) isequal(size(x, 3), parameter_values_length), comparison_confidence_interval_max)), ...
            [BRAPH2.STR ':ComparisonST_MP_BUT:' BRAPH2.WRONG_OUTPUT], ...
            'ComparisonST_MP_BUT does not initialize correctly with binodal measures')
    end    
end