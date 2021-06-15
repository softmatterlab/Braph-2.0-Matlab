%% ¡header!
CompareGroup < Element (c, group-based comparison) is a comparison between two group-based analyses.

%%% ¡description!
CompareGroup compares two group-based analyses, 
which need to be of the same class.

%%% ¡seealso!
AnalyzeGroup, ComparisonGroup

%% ¡props!

%%% ¡prop!
ID (data, string) is a few-letter code for the comparison.

%%% ¡prop!
LABEL (metadata, string) is an extended label of the comparison.

%%% ¡prop!
NOTES (metadata, string) are some specific notes about the comparison.

%%% ¡prop!
VERBOSE (metadata, logical) sets whether to write the progress of the comparisons.

%%% ¡prop!
INTERRUPTIBLE (metadata, scalar) sets whether the comparison computation is interruptible for multitasking.
%%%% ¡default!
0.001

%%% ¡prop!
MEMORIZE (metadata, logical) sets whether to memorize the permuted analysis.

%%% ¡prop!
P (parameter, scalar) is the permutation number.
%%%% ¡default!
1e+4
%%%% ¡check_prop!
check = value > 0 && value == round(value);

%%% ¡prop!
LONGITUDINAL (parameter, logical) determines whether the comparison is longitudinal.

%%% ¡prop!
A1 (data, item) is the first analysis to compare.
%%%% ¡settings!
'AnalyzeGroup'
%%%% ¡check_value!
check = isa(value, c.get('A2').getClass());

%%% ¡prop!
A2 (data, item) is the second analysis to compare.
%%%% ¡settings!
'AnalyzeGroup'
%%%% ¡check_value!
check = isa(value, c.get('A1').getClass());

%%% ¡prop!
PERM_SEEDS (result, rvector) is the list of seeds for the random permutations.
%%%% ¡calculate!
value = randi(intmax('uint32'), 1, c.get('P'));

%%% ¡prop!
A1_PERM_DICT (result, idict) is the list of permuted analyses for the first analysis.
%%%% ¡settings!
'AnalyzeGroup'
%%%% ¡calculate!
value = IndexedDictionary('IT_CLASS', 'AnalyzeGroup', 'IT_KEY', 1);

%%% ¡prop!
A2_PERM_DICT (result, idict) is the list of permuted analyses for the second analysis.
%%%% ¡settings!
'AnalyzeGroup'
%%%% ¡calculate!
value = IndexedDictionary('IT_CLASS', 'AnalyzeGroup', 'IT_KEY', 1);

%%% ¡prop!
CP_DICT (result, idict) contains the results of the comparison.
%%%% ¡settings!
'ComparisonGroup'
%%%% ¡calculate!
value = IndexedDictionary('IT_CLASS', 'ComparisonGroup', 'IT_KEY', 4);
%%%% ¡gui!
pl = PPCompareGroupCP('EL', c, 'PROP', CompareGroup.CP_DICT, varargin{:});

%% ¡methods!
function cp = getComparison(c, measure_class, varargin)
    %GETComparisonE returns comparison.
    %
    % CP = GETMEASURE(G, MEASURE_CLASS) checks if the measure exists in the
    % property MDICT. If not it creates a new measure M of class MEASURE_CLASS
    % with properties defined by the graph settings. The user must call
    % getValue() for the new measure M to retrieve the value of measure M.

    cp_dict = c.memorize('CP_DICT');
    if cp_dict.containsKey(measure_class)
        cp = cp_dict.getItem(measure_class);
    else
        cp = ComparisonGroup( ...
            'ID', [measure_class ' comparison ' c.get('A1').get('ID') ' vs. ' c.get('A2').get('ID')], ...
            'MEASURE', measure_class, ...
            'C', c, ...
            varargin{:} ...
            );
        cp_dict.add(cp);
    end
end
function [a1_perm, a2_perm] = getPerm(c, i, memorize)
    %GETPERM returns the permuted analyses.
    %
    % [A1P, A2P] = GETPERM(C, I) retunrs the I-th permutations for the analysis
    %  A1P and A2P. The number of perutations must be smaller than the
    %  permutation number P, which is one of the properties of the comparison.
    %
    % [A1P, A2P] = GETPERM(C, I, true) memorizes the resulting permutations.

    if nargin < 3
        memorize = false;
    end
    
    a1_perm_dict = c.memorize('A1_PERM_DICT');
    a2_perm_dict = c.memorize('A2_PERM_DICT');
    if a1_perm_dict.containsIndex(i) && a2_perm_dict.containsIndex(i)
        % retrieves if already memorized
        a1_perm = a1_perm_dict.getItem(i);
        a2_perm = a2_perm_dict.getItem(i);
    else    
        % permutation
        seeds = c.get('PERM_SEEDS');
        rng(seeds(i), 'twister')

        subs1 = c.get('A1').get('GR').get('SUB_DICT').get('IT_LIST');
        subs2 = c.get('A2').get('GR').get('SUB_DICT').get('IT_LIST');

        [subs1_perm, subs2_perm] = permutation(subs1, subs2, c.get('LONGITUDINAL'));

        a1_perm = c.get('A1').clone();
        a1_perm.set( ...
            'ID', [c.get('A1').get('ID') ' permutation ' int2str(i)], ...
            'GR', c.get('A1').get('GR').clone() ...
            )
        a1_perm.get('GR').set('SUB_DICT', c.get('A1').get('GR').get('SUB_DICT').clone())
        a1_perm.get('GR').get('SUB_DICT').set('IT_LIST', subs1_perm)

        a2_perm = c.get('A2').clone();
        a2_perm.set( ...
            'ID', [c.get('A2').get('ID') ' permutation ' int2str(i)], ...
            'GR', c.get('A2').get('GR').clone() ...
            )
        a2_perm.get('GR').set('SUB_DICT', c.get('A2').get('GR').get('SUB_DICT').clone())
        a2_perm.get('GR').get('SUB_DICT').set('IT_LIST', subs2_perm)

        % memorize permutations if required
        if memorize
            a1_perm_dict.add(a1_perm)
            a2_perm_dict.add(a2_perm)
        end
    end
end