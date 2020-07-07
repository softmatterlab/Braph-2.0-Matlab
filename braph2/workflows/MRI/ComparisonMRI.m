classdef ComparisonMRI < Comparison
    properties
        value_1  % array with the value_1 of the measure for each subject of group 1
        value_2  % array with the value_1 of the measure for each subject of group 1
        difference  % difference
        all_differences  % all differences obtained through the permutation test
        p1  % p value single tailed
        p2  % p value double tailed
        confidence_interval_min  % min value of the 95% confidence interval
        confidence_interval_max  % max value of the 95% confidence interval
    end
    methods  % Constructor
        function c =  ComparisonMRI(id, label, notes, atlas, measure_code, group_1, group_2, varargin)

% TODO: Add assert that the measure_code is in the measure list.

            c = c@Comparison(id, label, notes, atlas, measure_code, group_1, group_2, varargin{:});
        end
    end
    methods  % Get functions
        function [value_1, value_2] = getGroupValues(c)
            value_1 = c.value_1;
            value_2 = c.value_2;
        end
        function value = getGroupValue(c, group_index)
            if group_index == 1
                value = c.value_1;
            else
                value = c.value_2;
            end
        end
        function difference = getDifference(c)
            difference = c.difference;
        end
        function all_differences = getAllDifferences(c)
            all_differences = c.all_differences;
        end
        function p1 = getP1(c)
            p1 = c.p1;
        end
        function p2 = getP2(c)
            p2 = c.p2;
        end
        function confidence_interval_min = getConfidenceIntervalMin(c)
            confidence_interval_min = c.confidence_interval_min;
        end
        function confidence_interval_max = getConfidenceIntervalMax(c)
            confidence_interval_max = c.confidence_interval_max;
        end
    end
    methods (Access=protected)  % Initialize data
        function initialize_data(c, varargin)
            atlases = c.getBrainAtlases();
            atlas = atlases{1};       
            
            measure_code = c.getMeasureCode();
            
            number_of_permutations = c.getSettings('ComparisonMRI.PermutationNumber');
            
            if Measure.is_global(measure_code)  % global measure
                % values
                c.value_1 = get_from_varargin( ...
                    repmat({0}, 1, 1), ...
                    'ComparisonMRI.value_1', ...
                    varargin{:});
                c.value_2 = get_from_varargin( ...
                    repmat({0}, 1, 1), ...
                    'ComparisonMRI.value_2', ...
                    varargin{:});
                assert(iscell(c.getGroupValue(1)) & ...
                    isequal(size(c.getGroupValue(1)), [1, 1]) & ...
                    all(cellfun(@(x) isequal(size(x), [1, 1]), c.getGroupValue(1))), ...
                    [BRAPH2.STR ':ComparisonMRI:' BRAPH2.WRONG_INPUT], ...
                    'Data not compatible with ComparisonMRI')
                assert(iscell(c.getGroupValue(2)) & ...
                    isequal(size(c.getGroupValue(2)), [1, 1]) & ...
                    all(cellfun(@(x) isequal(size(x), [1, 1]), c.getGroupValue(2))), ...
                    [BRAPH2.STR ':ComparisonMRI:' BRAPH2.WRONG_INPUT], ...
                    'Data not compatible with ComparisonMRI')
                
                % permutation measures
                 c.difference = get_from_varargin( ...
                    0, ...
                    'ComparisonMRI.difference', ...
                    varargin{:});
                c.all_differences = get_from_varargin( ...
                    repmat({0}, 1, number_of_permutations), ...
                    'ComparisonMRI.all_differences', ...
                    varargin{:});
                c.p1 = get_from_varargin( ...
                    0, ...
                    'ComparisonMRI.p1', ...
                    varargin{:});
                c.p2 = get_from_varargin( ...
                    0, ...
                    'ComparisonMRI.p2', ...
                    varargin{:});
                c.confidence_interval_min = get_from_varargin( ...
                    0, ...
                    'ComparisonMRI.confidence_interval_min', ...
                    varargin{:});
                c.confidence_interval_max = get_from_varargin( ...
                    0, ...
                    'ComparisonMRI.confidence_interval_max', ...
                    varargin{:});
                
                assert(isequal(size(c.getDifference()), [1, 1]), ...
                    [BRAPH2.STR ':ComparisonMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonMRI')
                assert(isequal(size(c.getAllDifferences()), [1, number_of_permutations]), ...
                    [BRAPH2.STR ':ComparisonMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonMRI')
                assert(isequal(size(c.getP1()), [1, 1]), ...
                    [BRAPH2.STR ':ComparisonMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonMRI')
                assert(isequal(size(c.getP2()), [1, 1]), ...
                    [BRAPH2.STR ':ComparisonMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonMRI')
                
            elseif Measure.is_nodal(measure_code)  % nodal measure
                % values
                c.value_1 = get_from_varargin( ...
                    repmat({zeros(atlas.getBrainRegions().length(), 1)}, 1, 1), ...
                    'ComparisonMRI.value_1', ...
                    varargin{:});
                c.value_2 = get_from_varargin( ...
                    repmat({zeros(atlas.getBrainRegions().length(), 1)}, 1, 1), ...
                    'ComparisonMRI.value_2', ...
                    varargin{:});
                assert(iscell(c.getGroupValue(1)) & ...
                    isequal(size(c.getGroupValue(1)), [1, 1]) & ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), c.getGroupValue(1))), ...
                    [BRAPH2.STR ':ComparisonMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonMRI')
                assert(iscell(c.getGroupValue(2)) & ...
                    isequal(size(c.getGroupValue(2)), [1, 1]) & ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), c.getGroupValue(2))), ...
                    [BRAPH2.STR ':ComparisonMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonMRI')
                
                % statistic values
               c.difference = get_from_varargin( ...
                    zeros(atlas.getBrainRegions().length(), 1), ...
                    'ComparisonMRI.difference', ...
                    varargin{:});
                c.all_differences = get_from_varargin( ...
                    repmat({zeros(atlas.getBrainRegions().length(), 1)}, 1, number_of_permutations), ...
                    'ComparisonMRI.all_differences', ...
                    varargin{:});
                c.p1 = get_from_varargin( ...
                    zeros(atlas.getBrainRegions().length(), 1), ...
                    'ComparisonMRI.p1', ...
                    varargin{:});
                c.p2 = get_from_varargin( ...
                    zeros(atlas.getBrainRegions().length(), 1), ...
                    'ComparisonMRI.p2', ...
                    varargin{:});
                c.confidence_interval_min = get_from_varargin( ...
                    zeros(atlas.getBrainRegions().length(), 1), ...
                    'ComparisonMRI.confidence_interval_min', ...
                    varargin{:});
                c.confidence_interval_max = get_from_varargin( ...
                    zeros(atlas.getBrainRegions().length(), 1), ...
                    'ComparisonMRI.confidence_interval_max', ...
                    varargin{:});
                
                assert(isequal(size(c.getDifference()), [atlas.getBrainRegions().length(), 1]), ...
                    [BRAPH2.STR ':ComparisonMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonMRI')
                assert(isequal(size(c.getAllDifferences()), [1, number_of_permutations]), ...  % it should be like this currently the second dimension is expanding depending on modality.
                    [BRAPH2.STR ':ComparisonMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonMRI')
                assert(isequal(size(c.getP1()), [atlas.getBrainRegions().length(), 1]), ...
                    [BRAPH2.STR ':ComparisonMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonMRI')
                assert(isequal(size(c.getP2()), [atlas.getBrainRegions().length(), 1]), ...
                    [BRAPH2.STR ':ComparisonMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonMRI')
                assert(isequal(size(c.getConfidenceIntervalMin()), [atlas.getBrainRegions().length(), 1]), ...
                    [BRAPH2.STR ':ComparisonMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonMRI')
                assert(isequal(size(c.getConfidenceIntervalMax()), [atlas.getBrainRegions().length(), 1]), ...
                    [BRAPH2.STR ':ComparisonMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonMRI')
                
            elseif Measure.is_binodal(measure_code)  % binodal measure
                % values
                c.value_1 = get_from_varargin( ...
                    repmat({zeros(atlas.getBrainRegions().length())}, 1, 1), ...
                    'ComparisonMRI.value_1', ...
                    varargin{:});
                c.value_2 = get_from_varargin( ...
                    repmat({zeros(atlas.getBrainRegions().length())}, 1, 1), ...
                    'ComparisonMRI.value_2', ...
                    varargin{:});
                assert(iscell(c.getGroupValue(1)) & ...
                    isequal(size(c.getGroupValue(1)), [1, 1]) & ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), c.getGroupValue(1))), ...
                    [BRAPH2.STR ':ComparisonMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonMRI')
                assert(iscell(c.getGroupValue(2)) & ...
                    isequal(size(c.getGroupValue(2)), [1, 1]) & ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), c.getGroupValue(2))), ...
                    [BRAPH2.STR ':ComparisonMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonMRI')
                
                % statistic values
                 c.difference = get_from_varargin( ...
                    zeros(atlas.getBrainRegions().length()), ...
                    'ComparisonMRI.difference', ...
                    varargin{:});
                c.all_differences = get_from_varargin( ...
                    repmat({zeros(atlas.getBrainRegions().length())}, 1, number_of_permutations), ...
                    'ComparisonMRI.all_differences', ...
                    varargin{:});
                c.p1 = get_from_varargin( ...
                    zeros(atlas.getBrainRegions().length()), ...
                    'ComparisonMRI.p1', ...
                    varargin{:});
                c.p2 = get_from_varargin( ...
                    zeros(atlas.getBrainRegions().length()), ...
                    'ComparisonMRI.p2', ...
                    varargin{:});
                c.confidence_interval_min = get_from_varargin( ...
                    zeros(atlas.getBrainRegions().length()), ...
                    'ComparisonMRI.confidence_interval_min', ...
                    varargin{:});
                c.confidence_interval_max = get_from_varargin( ...
                    zeros(atlas.getBrainRegions().length()), ...
                    'ComparisonMRI.confidence_interval_max', ...
                    varargin{:});
                
                assert(isequal(size(c.getDifference()), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), ...
                    [BRAPH2.STR ':ComparisonMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonMRI')
                assert(isequal(size(c.getAllDifferences()), [1, number_of_permutations]), ...  % it should be like this currently the second dimension is expanding depending on modality.
                    [BRAPH2.STR ':ComparisonMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonMRI')
                assert(isequal(size(c.getP1()), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), ...
                    [BRAPH2.STR ':ComparisonMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonMRI')
                assert(isequal(size(c.getP2()), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), ...
                    [BRAPH2.STR ':ComparisonMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonMRI')
                assert(isequal(size(c.getConfidenceIntervalMin()), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), ...
                    [BRAPH2.STR ':ComparisonMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonMRI')
                assert(isequal(size(c.getConfidenceIntervalMax()), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), ...
                    [BRAPH2.STR ':ComparisonMRI:' BRAPH2. WRONG_INPUT], ...
                    'Data not compatible with ComparisonMRI')
            end
        end
    end
    methods (Static)  % Descriptive functions
        function class = getClass()
            class = 'ComparisonMRI';
        end
        function name = getName()
            name = 'Comparison MRI';
        end
        function description = getDescription()
            description = 'MRI comparison.';
        end
        function atlas_number = getBrainAtlasNumber()
            atlas_number =  1;
        end
        function analysis_class = getAnalysisClass()
            analysis_class = 'AnalysisMRI';
        end
        function subject_class = getSubjectClass()
            subject_class = 'SubjectMRI';
        end
        function available_settings = getAvailableSettings()
            available_settings = {
                'ComparisonMRI.PermutationNumber', BRAPH2.NUMERIC, 1000, {};
                };
        end
        function sub = getComparison(comparisonClass, id, label, notes, atlas, group_1, group_2, varargin) %#ok<INUSD>
            sub = eval([comparisonClass '(id, label, notes, atlas, group_1, group_2, varargin{:})']);
        end
    end
end