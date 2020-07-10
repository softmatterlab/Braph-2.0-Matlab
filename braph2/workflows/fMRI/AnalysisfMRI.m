classdef AnalysisfMRI < Analysis
    methods  % Constructor
        function analysis = AnalysisfMRI(id, label, notes, cohort, measurements, randomcomparisons, comparisons, varargin)
            
            analysis = analysis@Analysis(id, label, notes, cohort, measurements, randomcomparisons, comparisons, varargin{:});
        end
    end
    methods  % ID functions
        function measurement_id = getMeasurementID(analysis, measure_code, group, varargin)
            measurement_id = [ ...
                tostring(analysis.getMeasurementClass()) ' ' ...
                tostring(measure_code) ' ' ...
                tostring(analysis.cohort.getGroups().getIndex(group)) ...
                ];
        end
%         function randomcomparison_id = getRandomComparisonID(analysis, measure_code, group, varargin)
%             randomcomparison_id = [ ...
%                 tostring(analysis.getRandomComparisonClass()) ' ' ...
%                 tostring(measure_code) ' ' ...
%                 tostring(analysis.cohort.getGroups().getIndex(group)) ...
%                 ];
%         end
        function comparison_id = getComparisonID(analysis, measure_code, group1, group2, varargin)
            comparison_id = [ ...
                tostring(analysis.getComparisonClass()) ' ' ...
                tostring(measure_code) ' ' ...
                tostring(analysis.cohort.getGroups().getIndex(group1)) ' ' ...
                tostring(analysis.cohort.getGroups().getIndex(group2)) ...
                ];
        end
    end
    methods (Access = protected)  % Calculation functions
        function graphs = get_graph_for_subjects(analysis, subjects)
            % will return an array of graphs
            subject_number = numel(subjects);             
            graphs = cell(1, subject_number);
  
            for i = 1:1:subject_number
                subject = subjects{i};
                data = subject.getData('fMRI').getValue();
                
                % filter data
                fmin = 0;  % values from braph 1
                fmax = Inf;
                T = 1;
                fs = 1 / T;
                if fmax > fmin && T > 0
                    NFFT = 2 * ceil(size(data, 1) / 2);
                    ft = fft(data, NFFT);  % Fourier transform
                    f = fftshift(fs * abs(-NFFT / 2:NFFT / 2 - 1) / NFFT);  % absolute frequency
                    ft(f < fmin | f > fmax, :) = 0;
                    data = ifft(ft, NFFT);
                end
                
                correlation_rule = analysis.getSettings('AnalysisfMRI.CorrelationRule');
                negative_weight_rule = analysis.getSettings('AnalysisfMRI.NegativeWeightRule');
                A = Correlation.getAdjacencyMatrix(data, correlation_rule, negative_weight_rule);
                
                graph_type = analysis.getGraphType();
                g = Graph.getGraph(graph_type, A);
                graphs{i} = g;
            end
        end
        function measurement = calculate_measurement(analysis, measure_code, group, varargin)
            measures = cell(1, group.subjectnumber());
            subjects = group.getSubjects();
            % refactor graphs with get_graph_for_subjects
            graphs = analysis.get_graph_for_subjects(subjects);
            
            for i = 1:1:group.subjectnumber()
                measure = Measure.getMeasure(measure_code, graphs{i}, varargin{:});                
                measures{1, i} = cell2mat(measure.getValue());
            end
            
            measurement_average = mean(reshape(cell2mat(measures), [size(measures{1}, 1), size(measures{1}, 2), group.subjectnumber()]), 3);

            measurement = Measurement.getMeasurement('MeasurementfMRI', ...
                analysis.getMeasurementID(measure_code, group, varargin{:}), ...
                '', ...  % meaurement label
                '', ...  % meaurement notes
                analysis.getCohort().getBrainAtlases(), ...
                measure_code, ...
                group,  ...
                'MeasurementfMRI.value', measures, ...
                'MeasurementfMRI.average_value', measurement_average ...
                );
        end
%         function randomcomparison = calculate_random_comparison(analysis, measure_code, group, varargin)
%             % rules
%             attemptsPerEdge = analysis.getSettings('AnalysisMRI.AttemptsPerEdge');
%             numerOfWeights = analysis.getSettings('AnalysisMRI.NumberOfWeights');
%             graph_type = analysis.getSettings('AnalysisMRI.GraphType');
%             verbose = analysis.getSettings('AnalysisMRI.ComparisonVerbose');
%             interruptible = analysis.getSettings('AnalysisMRI.ComparionInterruptible');
%             correlation_rule = analysis.getSettings('AnalysisMRI.CorrelationRule');
%             negative_weight_rule = analysis.getSettings('AnalysisMRI.NegativeWeightRule');
%             is_longitudinal = analysis.getSettings('AnalysisMRI.Longitudinal');
%             M = get_from_varargin(1e+3, 'NumerOfPermutations', varargin{:});
%             
%             % get info from subjects
%             subjects = group.getSubjects();
%             subject_class = group.getSubjectClass();
%             atlases = analysis.getCohort().getBrainAtlases();
%             A = zeros(atlases{1}.getBrainRegions().length());
%             for i = 1:1:numel(subjects)
%                 subject = subjects{i};
%                 A(i, :) = subject.getData('MRI').getValue();
%             end
%             
%             % get randomize graphs of subjects
%             g = Graph.getGraph(graph_type, A);
%             [permuted_A, ~] = g.randomize_graph('AttemptsPerEdge', attemptsPerEdge, 'NumberOfWeights', numerOfWeights);
%             
%             % create subjects with new data
%             for i = 1:1:numel(subjects)
%                 info_subject =  permuted_A(i, :);
%                 permuted_subjects{i} = Subject.getSubject(subject_class, atlases{1}, 'MRI', info_subject'); %#ok<AGROW>
%             end
%             
% 
%             permuted_group = Group(subject_class, permuted_subjects, 'GroupName', ['RandomGroup_' group.getName()]);
%             
%             % create Measurements
%             measurement_group = analysis.calculate_measurement(measure_code, group, varargin{:});
%             measurement_random = analysis.calculate_measurement(measure_code, permuted_group, 'is_randomMRI', 1, varargin{:});
%             
%             value_group = measurement_group.getMeasureValue();
%             value_random = measurement_random.getMeasureValue();
%             
%                         
%             for i = 1:1:group.subjectnumber()
%                 subject = subjects{i};
%                 subjects_data_1(:, i) = subject.getData('MRI').getValue();  %#ok<AGROW> % MRI data % here we swaps dimensions to be compatible with permutation
%             end
%             
%             for i = 1:1:permuted_group.subjectnumber()
%                 subject = permuted_subjects{i};
%                 subjects_data_2(:, i) = subject.getData('MRI').getValue(); %#ok<AGROW>
%             end
%             
%             % compare
%             all_permutations_1 = cell(1, M);
%             all_permutations_2 = cell(1, M);
%             
%             start = tic;
%             for i = 1:1:M
%                 if verbose
%                     disp(['** PERMUTATION TEST - sampling #' int2str(i) '/' int2str(M) ' - ' int2str(toc(start)) '.' int2str(mod(toc(start),1)*10) 's'])
%                 end
%                 
%                 if is_longitudinal
%                     [permutation_1, permutation_2] = Permutation.permute(subjects_1, subjects_2, is_longitudinal);
%                 else
%                     [permutation_1, permutation_2] = Permutation.permute(subjects_data_1, subjects_data_2, is_longitudinal);
%                 end
%                 
%                 A_permutated_1 = Correlation.getAdjacencyMatrix(permutation_1', correlation_rule, negative_weight_rule);  % swap dimensions again
%                 graph_permutated_1 = Graph.getGraph(graph_type, A_permutated_1, varargin{:});
%                 measure_permutated_1 = Measure.getMeasure(measure_code, graph_permutated_1, varargin{:});
%                 measure_permutated_value_1 = measure_permutated_1.getValue();
%                 
%                 A_permutated_2 = Correlation.getAdjacencyMatrix(permutation_2', correlation_rule, negative_weight_rule);
%                 graph_permutated_2 = Graph.getGraph(graph_type, A_permutated_2, varargin{:});
%                 measure_permutated_2 = Measure.getMeasure(measure_code, graph_permutated_2, varargin{:});
%                 measure_permutated_value_2 = measure_permutated_2.getValue();
%                 
%                 
%                 all_permutations_1(1, i) = {measure_permutated_value_1};
%                 all_permutations_2(1, i) = {measure_permutated_value_2};
%                 
%                 difference_all_permutations{1, i} = measure_permutated_value_2 - measure_permutated_value_1; %#ok<AGROW>
%                 if interruptible
%                     pause(interruptible)
%                 end
%             end
%             
%             difference_mean = cell2mat(value_random) - cell2mat(value_group);  % difference of the mean values of non permuted random group minus the non permuted group 
%             difference_all_permutations = cellfun(@(x) [x], difference_all_permutations, 'UniformOutput', false);  %#ok<NBRAK> % permutated group 1 - permutated group 2
%             
%             p1 = pvalue1(difference_mean, difference_all_permutations);  % singe tail,
%             p2 = pvalue2(difference_mean, difference_all_permutations);  % double tail
%             percentiles = quantiles(difference_all_permutations, 100);
%             if size(percentiles) == [1 1] %#ok<BDSCA>
%                 ci_lower = percentiles{1}(2);
%                 ci_upper = percentiles{1}(40); % 95 percent
%             elseif size(percentiles) == [size(difference_mean, 1) 1] %#ok<BDSCA>
%                 for i = 1:1:length(percentiles)
%                     percentil = percentiles{i};
%                     ci_lower{i, 1} = percentil(2);  %#ok<AGROW>
%                     ci_upper{i, 1} = percentil(40); %#ok<AGROW>
%                 end
%             else
%                 for i = 1:1:size(percentiles, 1)
%                     for j = 1:1:size(percentiles, 2)
%                         percentil = percentiles{i, j};
%                         ci_lower{i, j} = percentil(2); %#ok<AGROW>
%                         ci_upper{i, j} = percentil(40); %#ok<AGROW>
%                     end
%                 end
%             end
%             
%             % create randomComparisonClass
%             randomcomparison = RandomComparison.getRandomComparison('RandomComparisonMRI', ...
%                 analysis.getRandomComparisonID(measure_code, group, varargin{:}), ...
%                 analysis.getCohort().getBrainAtlases(), group, ...
%                 'RandomComparisonMRI.measure_code', measure_code, ...
%                 'RandomComparisonMRI.values_group', value_group, ...
%                 'RandomComparisonMRI.values_random', value_random, ...
%                 'RandomComparisonMRI.difference', difference_mean, ...
%                 'RandomComparisonMRI.all_differences', difference_all_permutations, ...
%                 'RandomComparisonMRI.p1', p1, ...
%                 'RandomComparisonMRI.p2', p2, ....
%                 'RandomComparisonMRI.confidence_min', ci_lower, ...
%                 'RandomComparisonMRI.confidence_max', ci_upper, ...
%                 'RandomComparisonMRI.number_of_permutations', M ...
%                 );
%         end
        function comparison = calculate_comparison(analysis, measure_code, group_1, group_2, varargin)
            verbose = get_from_varargin('AnalysisfMRI.ComparisonVerbose');
            interruptible = get_from_varargin('AnalysisfMRI.ComparionInterruptible');
            is_longitudinal = analysis.getSettings('AnalysisfMRI.Longitudinal');
            M = get_from_varargin(1e+3, 'NumerOfPermutations', varargin{:});
            
            measurements1 = analysis.getMeasurement(measure_code, group_1, varargin{:});
            values1 = measurements1.getMeasureValue();
            res1 = mean(reshape(cell2mat(values1), [size(values1{1}, 1), size(values1{1}, 2), group_1.subjectnumber()]), 3);
            
                        
            measurements2 = analysis.getMeasurement(measure_code, group_2, varargin{:});
            values2 = measurements2.getMeasureValue();
            res2 = mean(reshape(cell2mat(values2), [size(values2{1}, 1), size(values2{1}, 2), group_2.subjectnumber()]), 3);
                      
            difference_mean = res2 - res1;
            
            all_permutations_1 = cell(1, M);
            all_permutations_2 = cell(1, M);
            
            start = tic;
            for i = 1:1:M
                if verbose
                    disp(['** PERMUTATION TEST - sampling #' int2str(i) '/' int2str(M) ' - ' int2str(toc(start)) '.' int2str(mod(toc(start),1)*10) 's'])
                end
                                
                [permutation_1, permutation_2] = permutation(values1, values2, is_longitudinal);

                mean_permutated_1 = mean(reshape(cell2mat(permutation_1), [size(permutation_1{1}, 1), size(permutation_1{1}, 2), group_1.subjectnumber()]), 3);
                mean_permutated_2 = mean(reshape(cell2mat(permutation_2), [size(permutation_2{1}, 1), size(permutation_2{1}, 2), group_2.subjectnumber()]), 3);
                
                all_permutations_1(1, i) = {mean_permutated_1};
                all_permutations_2(1, i) = {mean_permutated_2};
                
                if interruptible
                    pause(interruptible)
                end
            end
            
            difference_all_permutations = cellfun(@(x, y) y - x, all_permutations_1, all_permutations_2, 'UniformOutput', false);
            p1 = {pvalue1(difference_mean{1}, difference_all_permutations)};  % singe tail,
            p2 = {pvalue2(difference_mean{1}, difference_all_permutations)};  % double tail
            qtl = quantiles(difference_all_permutations, 40);
            ci_lower = {cellfun(@(x) x(2), qtl)};
            ci_upper = {cellfun(@(x) x(40), qtl)};s            
            
            comparison = Comparison.getComparison('ComparisonfMRI', ...
                analysis.getComparisonID(measure_code, group_1, group_2, varargin{:}), ...
                analysis.getCohort().getBrainAtlases(), ...
                measure_code, ...
                group_1, ...
                group_2, ...
                'ComparisonfMRI.PermutationNumber', M, ...
                 'ComparisonfMRI.value_1', value_1, ...
                'ComparisonfMRI.value_2', value_2, ...
                'ComparisonfMRI.average_value_1', res1, ...
                'ComparisonfMRI.average_value_2', res2, ...
                'ComparisonfMRI.measure_code', measure_code, ...
                'ComparisonfMRI.difference', difference_mean, ...
                'ComparisonfMRI.all_differences', difference_all_permutations, ...
                'ComparisonfMRI.p1', p1, ...
                'ComparisonfMRI.p2', p2, ...
                'ComparisonfMRI.confidence_min', ci_lower, ...
                'ComparisonfMRI.confidence_max', ci_upper ...          
                );
        end
    end
    methods (Static)  % Descriptive functions
        function analysis_class = getClass()
            analysis_class = 'AnalysisfMRI';
        end
        function name = getName()
            name = 'Analysis Functional MRI';
        end
        function description = getDescription()
            description = [ ...
                'Analysis based on functional MRI data, ' ...
                'such as activation timeseries for each brain region. ' ...
                ];
        end
        function graph_type = getGraphType()
            graph_type = 'GraphWU';
        end
        function subject_class = getSubjectClass()
            subject_class = 'SubjectfMRI';
        end
        function measurement_class = getMeasurementClass()
            measurement_class =  'MeasurementfMRI';
        end
%         function randomcomparison_class = getRandomComparisonClass()
%             randomcomparison_class = 'RandomComparisonMRI';
%         end
        function comparison_class = getComparisonClass()
            comparison_class = 'ComparisonfMRI';
        end
        function available_settings = getAvailableSettings(m) %#ok<INUSD>
            available_settings = {
                {'AnalysisfMRI.CorrelationRule', BRAPH2.STRING, 'pearson', Correlation.CORRELATION_RULE_LIST}, ...
                {'AnalysisfMRI.NegativeWeightRule', BRAPH2.STRING, 'zero', Correlation.NEGATIVE_WEIGHT_RULE_LIST}, ...
                {'AnalysisfMRI.Longitudinal', BRAPH2.LOGICAL, false, {false, true}}, ...
                {'AnalysisfMRI.AttemptsPerEdge', BRAPH2.NUMERIC, 1, {}}, ...
                {'AnalysisfMRI.NumberOfWeights', BRAPH2.NUMERIC, 1, {}} ...
                };
        end
    end
end