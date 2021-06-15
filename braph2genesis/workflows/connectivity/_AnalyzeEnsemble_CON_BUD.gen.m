%% ¡header!
AnalyzeEnsemble_CON_BUD < AnalyzeEnsemble (a, graph analysis with connectivity data of fixed density) is a graph analysis using connectivity data of fixed density.

%% ¡description!
This graph analysis uses connectivity data and analyzes them using
binary undirected multigraphs with fixed densities.

%%% ¡seealso!
AnalyzeEnsemble_CON_WU, Subject_CON, MultigraphBUD.

%% ¡props!

%%% ¡prop!
DENSITIES (parameter, rvector) is the vector of densities.
%%%% ¡default!
0

%% ¡props_update!

%%% ¡prop!
GR (data, item) is the subject group, which also defines the subject class SubjectCON.
%%%% ¡default!
Group('SUB_CLASS', 'SubjectCON')

%%% ¡prop!
G_DICT (result, idict) is the graph (MultigraphBUD) ensemble obtained from this analysis.
%%%% ¡settings!
'MultigraphBUD'
%%%% ¡default!
IndexedDictionary('IT_CLASS', 'MultigraphBUD')
%%%% ¡calculate!
g_dict = IndexedDictionary('IT_CLASS', 'MultigraphBUD');
gr = a.get('GR');
densities = a.get('DENSITIES');
node_labels = '';

if ~isempty(gr) && ~isa(gr, 'NoValue')   
    atlas = gr.get('SUB_DICT').getItem(1).get('BA');
end

for i = 1:1:gr.get('SUB_DICT').length()
	sub = gr.get('SUB_DICT').getItem(i);
    g = MultigraphBUD( ...
        'ID', ['g ' sub.get('ID')], ...
        'B', Callback('EL', sub, 'TAG', 'CON'), ...
        'DENSITIES', densities, ...
        'BRAINATLAS', atlas ...
        );
    g_dict.add(g)
end

value = g_dict;
%%%% ¡gui!
pl = PPAnalyzeEnsembleGraph('EL', a, 'PROP', AnalyzeEnsemble_CON_BUD.G_DICT, varargin{:});

%% ¡tests!

%%% ¡test!
%%%% ¡name!
Example
%%%% ¡code!
example_CON_BUD