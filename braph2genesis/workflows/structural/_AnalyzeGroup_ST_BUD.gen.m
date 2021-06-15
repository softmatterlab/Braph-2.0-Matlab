%% ¡header!
AnalyzeGroup_ST_BUD < AnalyzeGroup (a, graph analysis with structural data of fixed density) is a graph analysis using structural data of fixed density.

%% ¡description!
This graph analysis uses structural data of fixed density and analyzes them using binary undirected graphs.

%%% ¡seealso!
AnalyzeGroup_ST_WU, AnalyzeGroup_ST_BUT, Subject_ST, MultigraphBUD.

%% ¡props!

%%% ¡prop!
CORRELATION_RULE (parameter, option) is the correlation type.
%%%% ¡settings!
Correlation.CORRELATION_RULE_LIST
%%%% ¡default!
Correlation.CORRELATION_RULE_LIST{1}

%%% ¡prop!
NEGATIVE_WEIGHT_RULE (parameter, option) determines how to deal with negative weights.
%%%% ¡settings!
Correlation.NEGATIVE_WEIGHT_RULE_LIST
%%%% ¡default!
Correlation.NEGATIVE_WEIGHT_RULE_LIST{1}

%%% ¡prop!
USE_COVARIATES (parameter, logical) determines the use of covariates in the analysis.
%%%% ¡default!
false

%%% ¡prop!
DENSITIES (parameter, rvector) is the vector of densities.
%%%% ¡default!
0

%% ¡props_update!

%%% ¡prop!
GR (data, item) is the subject group, which also defines the subject class SubjectST.
%%%% ¡default!
Group('SUB_CLASS', 'SubjectST')

%%% ¡prop!
G (result, item) is the graph obtained from this analysis.
%%%% ¡settings!
'MultigraphBUD'
%%%% ¡default!
MultigraphBUD()
%%%% ¡calculate!
gr = a.get('GR');
data_list = cellfun(@(x) x.get('ST'), gr.get('SUB_DICT').getItems, 'UniformOutput', false);
data = cat(2, data_list{:})'; % correlation is a column based operation
atlas = gr.get('SUB_DICT').getItem(1).get('BA');

if a.get('USE_COVARIATES')
    age_list = cellfun(@(x) x.get('age'), gr.get('SUB_DICT').getItems, 'UniformOutput', false);
    age = cat(2, age_list{:})';
    sex_list = cellfun(@(x) x.get('sex'), gr.get('SUB_DICT').getItems, 'UniformOutput', false);
    sex = zeros(size(age));
    for i=1:length(sex_list)
        switch lower(sex_list{i})
            case 'female'
                sex(i) = 1;
            case 'male'
                sex(i) = 0;
            otherwise
                sex(i) = -1;
        end
    end
    A = Correlation.getAdjacencyMatrix(data, a.get('CORRELATION_RULE'), a.get('NEGATIVE_WEIGHT_RULE'), [age, sex]);
else
    A = Correlation.getAdjacencyMatrix(data, a.get('CORRELATION_RULE'), a.get('NEGATIVE_WEIGHT_RULE'));
end

densities = a.get('DENSITIES'); % this is a vector

g = MultigraphBUD( ...
    'ID', ['g ' gr.get('ID')], ...
    'B', A, ...
    'DENSITIES', densities, ...
    'BRAINATLAS', atlas ...
    );

value = g;
%%%% ¡gui!
pl = PPAnalyzeGroupGraph('EL', a, 'PROP', AnalyzeGroup_ST_BUD.G, varargin{:});

%% ¡tests!

%%% ¡test!
%%%% ¡name!
Example
%%%% ¡code!
example_ST_BUD