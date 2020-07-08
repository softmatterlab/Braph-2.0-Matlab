% test ComparisionMRI

br1 = BrainRegion('BR1', 'brain region 1', 'notes 1', 1, 1.1, 1.11);
br2 = BrainRegion('BR2', 'brain region 2', 'notes 2', 2, 2.2, 2.22);
br3 = BrainRegion('BR3', 'brain region 3', 'notes 3', 3, 3.3, 3.33);
br4 = BrainRegion('BR4', 'brain region 4', 'notes 4', 4, 4.4, 4.44);
br5 = BrainRegion('BR5', 'brain region 5', 'notes 5', 5, 5.5, 5.55);
atlas = BrainAtlas('BA', 'brain atlas', 'notes', 'BrainMesh_ICBM152.nv', {br1, br2, br3, br4, br5});

subject_class = Comparison.getSubjectClass('ComparisonMRI');

sub1 = Subject.getSubject(subject_class, 'id1', 'label 1', 'notes 1', atlas);
sub2 = Subject.getSubject(subject_class, 'id2', 'label 2', 'notes 2', atlas);
sub3 = Subject.getSubject(subject_class, 'id3', 'label 3', 'notes 3', atlas);
sub4 = Subject.getSubject(subject_class, 'id4', 'label 4', 'notes 4', atlas);
sub5 = Subject.getSubject(subject_class, 'id5', 'label 5', 'notes 5', atlas);

group = Group(subject_class, 'id', 'label', 'notes', {sub1, sub2, sub3, sub4, sub5});

graph_type = AnalysisMRI.getGraphType();
measures = Graph.getCompatibleMeasureList(graph_type);

%% Test 1: Instantiation
for i = 1:1:numel(measures)
    comparison = ComparisonMRI('c1', 'label', 'notes', atlas, measures{i}, group, group);
end

%% Test 2: Correct Size defaults
for i = 1:1:numel(measures)
    number_of_permutations = 10;
    
    comparison = ComparisonMRI('c1', 'label', 'notes', atlas, measures{i}, group, group, 'ComparisonMRI.PermutationNumber', number_of_permutations);
    
    value_1 = comparison.getGroupValue(1);    
    value_2 = comparison.getGroupValue(2);
    difference = comparison.getDifference();  % difference
    all_differences = comparison.getAllDifferences(); % all differences obtained through the permutation test
    p1 = comparison.getP1(); % p value single tailed
    p2 = comparison.getP2();  % p value double tailed
    confidence_interval_min = comparison.getConfidenceIntervalMin();  % min value of the 95% confidence interval
    confidence_interval_max = comparison.getConfidenceIntervalMax(); % max value of the 95% confidence interval

% TODO: Separate tests and adapt tests to cell data (revise data formats as well)    
%     if Measure.is_global(measures{i})
%         assert(iscell(value_1) & ...
%             isequal(numel(value_1), 1) & ...
%             all(cellfun(@(x) isequal(size(x), [1, 1]), value_1)) & ...
%             iscell(value_2) & ...
%             isequal(numel(value_2), 1) & ...
%             all(cellfun(@(x) isequal(size(x), [1, 1]), value_2)), ...
%             [BRAPH2.STR ':ComparisonMRI:' BRAPH2.BUG_FUNC], ...
%             'ComparisonMRI does not initialize correctly with global measures')
%          assert(isequal(numel(difference), 1) & ...
%             isequal(numel(all_differences), number_of_permutations) & ...
%             isequal(numel(p1), 1) & ...
%             isequal(numel(p2), 1) & ...
%             isequal(numel(confidence_interval_min), 1) & ...
%             isequal(numel(confidence_interval_max), 1), ...
%             [BRAPH2.STR ':ComparisonMRI:' BRAPH2.BUG_FUNC], ...
%             'ComparisonMRI does not initialize correctly with global measures')
%     elseif Measure.is_nodal(measures{i})
%         assert(iscell(value_1) & ...
%             isequal(numel(value_1), 1) & ...
%             all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), value_1)) & ...
%             iscell(value_2) & ...
%             isequal(numel(value_2), 1) & ...
%             all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), value_2)) , ...
%             [BRAPH2.STR ':ComparisonMRI:' BRAPH2.BUG_FUNC], ...
%             'ComparisonMRI does not initialize correctly with nodal measures')
%         assert(isequal(size(difference), [atlas.getBrainRegions().length(), 1]) & ...
%             isequal(size(all_differences), [1, number_of_permutations]) & ...
%             isequal(size(p1), [atlas.getBrainRegions().length(), 1]) & ...
%             isequal(size(p2), [atlas.getBrainRegions().length(), 1]) & ...
%             isequal(size(confidence_interval_min), [atlas.getBrainRegions().length(), 1]) & ...
%             isequal(size(confidence_interval_max), [atlas.getBrainRegions().length(), 1]), ...
%             [BRAPH2.STR ':ComparisonMRI:' BRAPH2.BUG_FUNC], ...
%             'ComparisonMRI does not initialize correctly with nodal measures')
%     elseif Measure.is_binodal(measures{i})
%         assert(iscell(value_1) & ...
%             isequal(numel(value_1), 1) & ...
%             all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), value_1)) & ...
%             iscell(value_2) & ...
%             isequal(numel(value_2), 1) & ...
%             all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), value_2)), ...
%             [BRAPH2.STR ':ComparisonMRI:' BRAPH2.BUG_FUNC], ...
%             'ComparisonMRI does not initialize correctly with binodal measures')
%         assert(isequal(size(difference), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]) & ...
%             isequal(size(all_differences), [1, number_of_permutations]) & ...
%             isequal(size(p1), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]) & ...
%             isequal(size(p2), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]) & ...
%             isequal(size(confidence_interval_min), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]) & ...
%             isequal(size(confidence_interval_max), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), ...
%             [BRAPH2.STR ':ComparisonMRI:' BRAPH2.BUG_FUNC], ...
%             'ComparisonMRI does not initialize correctly with binodal measures')
%     end
end

% %% Test 3: Initialize with values
% for i = 1:1:numel(measures)
%     % setup
%     number_of_permutations = 10;
%     
%     A_1 = rand(atlas.getBrainRegions().length());
%     A_2 = rand(atlas.getBrainRegions().length());
%     g_1 = Graph.getGraph('GraphWU', A_1);
%     g_2 = Graph.getGraph('GraphWU', A_2);
%     m_1  = Measure.getMeasure(measures{i}, g_1);
%     m_2 = Measure.getMeasure(measures{i}, g_2);
%     value_1 = m_1.getValue(); %#ok<*SAGROW>
%     value_2 = m_2.getValue();
%     
%     % for the dimensions 
%     difference  = value_2{1} - value_1{1};
%     
%     for j = 1:1:number_of_permutations
%         all_differences{j} =  value_2{1} - value_1{1};  % similar
%     end
%     p1 = difference;  % all similar
%     p2 = difference;
%     confidence_interval_min = difference;
%     confidence_interval_max = difference;
%     
%     % act
%     comparison = ComparisonMRI('c1', ...
%         'comparison label', ...
%         'comparison notes', ...
%         atlas, ...
%         measures{i}, ...
%         group, ...
%         group, ...
%         'ComparisonMRI.PermutationNumber', number_of_permutations, ...
%         'ComparisonMRI.value_1', value_1, ...
%         'ComparisonMRI.value_2', value_2, ...
%         'ComparisonMRI.difference', difference, ...
%         'ComparisonMRI.all_differences', all_differences, ...
%         'ComparisonMRI.p1', p1, ...
%         'ComparisonMRI.p2', p2, ....
%         'ComparisonMRI.confidence_min', confidence_interval_min, ...
%         'ComparisonMRI.confidence_max', confidence_interval_max ...
%         );
%     
%     comparison_value_1 = comparison.getGroupValue(1);
%     comparison_value_2 = comparison.getGroupValue(2);
%     comparison_difference = comparison.getDifference();
%     comparison_all_differences = comparison.getAllDifferences();
%     comparison_p1 = comparison.getP1();
%     comparison_p2 = comparison.getP2();
%     comparison_confidence_interval_min = comparison.getConfidenceIntervalMin();
%     comparison_confidence_interval_max = comparison.getConfidenceIntervalMax();
% 
% % TODO: Separate tests and adapt tests to cell data  (revise data formats as well)       
% %     % assert
% %     if Measure.is_global(measures{i})
% %         assert(iscell(comparison_value_1) & ...
% %             isequal(numel(comparison_value_1), 1) & ...
% %             all(cellfun(@(x) isequal(size(x), [1, 1]), comparison_value_1)) & ...
% %             iscell(comparison_value_2) & ...
% %             isequal(numel(comparison_value_2), 1) & ...
% %             all(cellfun(@(x) isequal(size(x), [1, 1]), comparison_value_2)), ...
% %             [BRAPH2.STR ':ComparisonMRI:' BRAPH2.BUG_FUNC], ...
% %             'ComparisonMRI does not initialize correctly with global measures')
% %         assert(isequal(numel(comparison_difference), 1) & ...
% %             isequal(numel(comparison_all_differences), number_of_permutations) & ...
% %             isequal(numel(comparison_p1), 1) & ...
% %             isequal(numel(comparison_p2), 1) & ...
% %             isequal(numel(comparison_confidence_interval_min), 1) & ...
% %             isequal(numel(comparison_confidence_interval_max), 1), ...
% %             [BRAPH2.STR ':ComparisonMRI:' BRAPH2.BUG_FUNC], ...
% %             'ComparisonMRI does not initialize correctly with global measures')
% %     elseif Measure.is_nodal(measures{i})
% %         assert(iscell(comparison_value_1) & ...
% %             isequal(numel(comparison_value_1), 1) & ...
% %             all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), comparison_value_1)) & ...
% %             iscell(comparison_value_2) & ...
% %             isequal(numel(comparison_value_2), 1) & ...
% %             all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), comparison_value_2)) , ...
% %             [BRAPH2.STR ':ComparisonMRI:' BRAPH2.BUG_FUNC], ...
% %             'ComparisonMRI does not initialize correctly with nodal measures')
% %         assert(isequal(size(comparison_difference), [atlas.getBrainRegions().length(), 1]) & ...
% %             isequal(size(comparison_all_differences), [1, number_of_permutations]) & ...
% %             isequal(size(comparison_p1), [atlas.getBrainRegions().length(), 1]) & ...
% %             isequal(size(comparison_p2), [atlas.getBrainRegions().length(), 1]) & ...
% %             isequal(size(comparison_confidence_interval_min), [atlas.getBrainRegions().length(), 1]) & ...
% %             isequal(size(comparison_confidence_interval_max), [atlas.getBrainRegions().length(), 1]), ...
% %             [BRAPH2.STR ':ComparisonMRI:' BRAPH2.BUG_FUNC], ...
% %             'ComparisonMRI does not initialize correctly with nodal measures')
% %     elseif Measure.is_binodal(measures{i})
% %         assert(iscell(comparison_value_1) & ...
% %             isequal(numel(comparison_value_1), 1) & ...
% %             all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), comparison_value_1)) & ...
% %             iscell(comparison_value_2) & ...
% %             isequal(numel(comparison_value_2), 1) & ...
% %             all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), comparison_value_2)), ...
% %             [BRAPH2.STR ':ComparisonMRI:' BRAPH2.BUG_FUNC], ...
% %             'ComparisonMRI does not initialize correctly with binodal measures')
% %         assert(isequal(size(comparison_difference), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]) & ...
% %             isequal(size(comparison_all_differences), [1, number_of_permutations]) & ...
% %             isequal(size(comparison_p1), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]) & ...
% %             isequal(size(comparison_p2), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]) & ...
% %             isequal(size(comparison_confidence_interval_min), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]) & ...
% %             isequal(size(comparison_confidence_interval_max), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), ...
% %             [BRAPH2.STR ':ComparisonMRI:' BRAPH2.BUG_FUNC], ...
% %             'ComparisonMRI does not initialize correctly with binodal measures')
% %     end    
% end