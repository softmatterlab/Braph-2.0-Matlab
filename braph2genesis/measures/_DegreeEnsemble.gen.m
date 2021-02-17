%% ¡header!
DegreeEnsemble < Degree (m, degree of a graph ensemble) is the degree of a graph ensemble.

%%% ¡description!
The degree of a node is the number of edges connected to the node within a layer. 
Connection weights are ignored in calculations.

%%% ¡compatible_graphs!
GraphWUEnsemble
MultigraphBUTEnsemble

%% ¡props_update!

%%% ¡prop!
M (result, measure) is the ensemble-averaged degree.
%%%% ¡calculate!
ge = m.get('G'); % graph ensemble from measure class

degree_ensemble = cell(ge.layernumber(), 1);

degree_list = cellfun(@(x) x.getMeasure('Degree').get('M'), ge.get('G_DICT').getItems, 'UniformOutput', false);
for li = 1:1:ge.layernumber()
    degree_li_list = cellfun(@(x) x{li}, degree_list, 'UniformOutput', false);
    degree_ensemble{li} = mean(cat(3, degree_li_list{:}), 3);
end

value = degree_ensemble;

%% ¡tests!

%%% ¡test!
%%%% ¡name!
GraphWUEnsemble
%%%% ¡code!
B = [
    0   1   1
    1   0   0
    1   0   0
    ];

known_degree = {[2 1 1]'};

ge = GraphWUEnsemble();
for i = 1:1:10
    g = GraphWU( ...
        'ID', ['g ' int2str(i)], ...
        'B', B ...
        );
    ge.get('G_DICT').add(g)
end

m_outside_g = DegreeEnsemble('G', ge);
assert(isequal(m_outside_g.get('M'), known_degree), ...
    [BRAPH2.STR ':DegreeEnsemble:' BRAPH2.BUG_ERR], ...
    'DegreeEnsemble is not being calculated correctly for GraphWUEnsemble.')

m_inside_g = ge.getMeasure('DegreeEnsemble');
assert(isequal(m_inside_g.get('M'), known_degree), ...
    [BRAPH2.STR ':DegreeEnsemble:' BRAPH2.BUG_ERR], ...
    'DegreeEnsemble is not being calculated correctly for GraphWUEnsemble.')

%%% ¡test!
%%%% ¡name!
MultigraphBUTEnsemble
%%%% ¡code!
B = [
    0   .2   .7
    .2   0   0
    .7   0   0
    ];

thresholds = [0 .5 1];

known_degree = { ...
    [2 1 1]'
    [1 0 1]'
    [0 0 0]'
    };

ge = MultigraphBUTEnsemble('THRESHOLDS', thresholds);
for i = 1:1:10
    g = MultigraphBUT( ...
        'ID', ['g ' int2str(i)], ...
        'THRESHOLDS', ge.get('THRESHOLDS'), ...
        'B', B ...
        );
    ge.get('G_DICT').add(g)
end

m_outside_g = DegreeEnsemble('G', ge);
assert(isequal(m_outside_g.get('M'), known_degree), ...
    [BRAPH2.STR ':DegreeEnsemble:' BRAPH2.BUG_ERR], ...
    'DegreeEnsemble is not being calculated correctly for MultigraphBUTEnsemble.')

m_inside_g = ge.getMeasure('DegreeEnsemble');
assert(isequal(m_inside_g.get('M'), known_degree), ...
    [BRAPH2.STR ':DegreeEnsemble:' BRAPH2.BUG_ERR], ...
    'DegreeEnsemble is not being calculated correctly for MultigraphBUTEnsemble.')

%%% ¡test!
%%%% ¡name!
MultigraphBUDEnsemble
%%%% ¡code!
B = [
    0   .2   .7
    .2   0   .1
    .7  .1   0
    ];

densities = [0 33 67 100];

known_degree = { ...
    [0 0 0]'
    [1 0 1]'
    [2 1 1]'
    [2 2 2]'
    };

ge = MultigraphBUDEnsemble('DENSITIES', densities);
for i = 1:1:10
    g = MultigraphBUD( ...
        'ID', ['g ' int2str(i)], ...
        'DENSITIES', ge.get('DENSITIES'), ...
        'B', B ...
        );
    ge.get('G_DICT').add(g)
end

m_outside_g = DegreeEnsemble('G', ge);
assert(isequal(m_outside_g.get('M'), known_degree), ...
    [BRAPH2.STR ':DegreeEnsemble:' BRAPH2.BUG_ERR], ...
    'DegreeEnsemble is not being calculated correctly for MultigraphBUDEnsemble.')

m_inside_g = ge.getMeasure('DegreeEnsemble');
assert(isequal(m_inside_g.get('M'), known_degree), ...
    [BRAPH2.STR ':DegreeEnsemble:' BRAPH2.BUG_ERR], ...
    'DegreeEnsemble is not being calculated correctly for MultigraphBUDEnsemble.')