%% ¡header!
EccentricityAv < Eccentricity (m, eccentricity) is the eccentricity.

%%% ¡description!
The average eccentricity of a graph is the sum of the nodal eccentricities divided by their number within a layer.

%%% ¡shape!
shape = Measure.GLOBAL;

%%% ¡scope!
scope = Measure.UNILAYER;

%%% ¡parametricity!
parametricity = Measure.NONPARAMETRIC;

%%% ¡compatible_graphs!
GraphWU
GraphBU
MultiplexGraphWU
MultiplexGraphBU

%% ¡props_update!

%%% ¡prop!
M (result, cell) is the average eccentricity.
%%%% ¡calculate!
g = m.get('G'); % graph from measure class
A = g.get('A'); % cell matrix (for graph) or 2D-cell array (for multigraph, multiplex, etc.)

eccentritivity = calculateValue@Eccentritivity(m, prop);	
g = m.get('G'); % graph from measure class

eccentritivity_av = cell(g.layernumber(), 1);

for li = 1:1:g.layernumber()
    eccentritivity_av(li) = {mean(eccentritivity{li})};
end

value = eccentritivity_av;

%% ¡tests!

%%% ¡test!
%%%% ¡name!
GraphBU
%%%% ¡code!
B = [
    0     .1  .2  .25  0;
    .125  0   0   0    0;
    .2    .5  0   .25  0;
    .125  10  0   0    0;
    0     0   0   0    0
    ];

known_eccentricity_av_subgraphs = {mean([1 1 1 1 0]')};
known_eccentricity_av_default = {mean([Inf Inf Inf Inf Inf]')};

g = GraphBU('B', B);
m_outside_g = EccentricityAv('G', g, 'rule', find(contains(Eccentricity.RULES, 'subgraphs')));
assert(isequal(m_outside_g.get('M'), known_eccentricity_av_subgraphs), ...
    [BRAPH2.STR ':Eccentricity:' BRAPH2.BUG_ERR], ...
    'Eccentricity is not being calculated correctly for GraphBU.')

g = GraphBU('B', B);
m_inside_g = g.getMeasure('Eccentricity', 'rule', find(contains(Eccentricity.RULES, 'subgraphs')));
assert(isequal(m_inside_g.get('M'), known_eccentricity_av_subgraphs), ...
    [BRAPH2.STR ':Eccentricity:' BRAPH2.BUG_ERR], ...
    'Eccentricity is not being calculated correctly for GraphBU.')

g = GraphBU('B', B);
m_outside_g = Eccentricity('G', g, 'rule', find(contains(Eccentricity.RULES, 'all')));
assert(isequal(m_outside_g.get('M'), known_eccentricity_av_default), ...
    [BRAPH2.STR ':Eccentricity:' BRAPH2.BUG_ERR], ...
    'Eccentricity is not being calculated correctly for GraphBU.')

g = GraphBU('B', B);
m_inside_g = g.getMeasure('Eccentricity', 'rule', find(contains(Eccentricity.RULES, 'all')));
assert(isequal(m_inside_g.get('M'), known_eccentricity_av_default), ...
    [BRAPH2.STR ':Eccentricity:' BRAPH2.BUG_ERR], ...
    'Eccentricity is not being calculated correctly for GraphBU.')

%%% ¡test!
%%%% ¡name!
GraphWU
%%%% ¡code!
B = [
    0     .1  .2  .25  0;
    .125  0   0   0    0;
    .2    .5  0   .25  0;
    .125  10  0   0    0;
    0     0   0   0    0
    ];

known_eccentricity_av_subgraphs = {mean([5 5 5 4 0]')};
known_eccentricity_av_default = {mean([Inf Inf Inf Inf Inf]')};

g = GraphWU('B', B);
m_outside_g = Eccentricity('G', g, 'rule', find(contains(Eccentricity.RULES, 'subgraphs')));
assert(isequal(m_outside_g.get('M'), known_eccentricity_av_subgraphs), ...
    [BRAPH2.STR ':Eccentricity:' BRAPH2.BUG_ERR], ...
    'Eccentricity is not being calculated correctly for GraphWU.')

g = GraphWU('B', B);
m_inside_g = g.getMeasure('Eccentricity', 'rule', find(contains(Eccentricity.RULES, 'subgraphs')));
assert(isequal(m_inside_g.get('M'), known_eccentricity_av_subgraphs), ...
    [BRAPH2.STR ':Eccentricity:' BRAPH2.BUG_ERR], ...
    'Eccentricity is not being calculated correctly for GraphWU.')

g = GraphWU('B', B);
m_outside_g = Eccentricity('G', g, 'rule', find(contains(Eccentricity.RULES, 'all')));
assert(isequal(m_outside_g.get('M'), known_eccentricity_av_default), ...
    [BRAPH2.STR ':Eccentricity:' BRAPH2.BUG_ERR], ...
    'Eccentricity is not being calculated correctly for GraphWU.')

g = GraphWU('B', B);
m_inside_g = g.getMeasure('Eccentricity', 'rule', find(contains(Eccentricity.RULES, 'all')));
assert(isequal(m_inside_g.get('M'), known_eccentricity_av_default), ...
    [BRAPH2.STR ':Eccentricity:' BRAPH2.BUG_ERR], ...
    'Eccentricity is not being calculated correctly for GraphWU.')

%%% ¡test!
%%%% ¡name!
MultiplexGraphBU
%%%% ¡code!
B11 = [
      0     .1  .2  .25  0;
      .125  0   0   0    0;
      .2    .5  0   .25  0;
      .125  10  0   0    0;
      0     0   0   0    0
      ];
B12 = eye(5);
B21 = eye(5);
B22 = [
      0     .1  .2  .25  0;
      .125  0   0   0    0;
      .2    .5  0   .25  0;
      .125  10  0   0    0;
      0     0   0   0    0
      ];
B = {
    B11     B12  
    B21     B22
    };

known_eccentricity_av_subgraphs = { 
                               mean([1 1 1 1 0]')
                               mean([1 1 1 1 0]')
                               };
known_eccentricity_av_default = {
                             mean([Inf Inf Inf Inf Inf]')
                             mean([Inf Inf Inf Inf Inf]')
                             };

g = MultiplexGraphBU('B', B);
m_outside_g = Eccentricity('G', g, 'rule', find(contains(Eccentricity.RULES, 'subgraphs')));
assert(isequal(m_outside_g.get('M'), known_eccentricity_av_subgraphs), ...
    [BRAPH2.STR ':Eccentricity:' BRAPH2.BUG_ERR], ...
    'Eccentricity is not being calculated correctly for MultiplexGraphBU.')

g = MultiplexGraphBU('B', B);
m_inside_g = g.getMeasure('Eccentricity', 'rule', find(contains(Eccentricity.RULES, 'subgraphs')));
assert(isequal(m_inside_g.get('M'), known_eccentricity_av_subgraphs), ...
    [BRAPH2.STR ':Eccentricity:' BRAPH2.BUG_ERR], ...
    'Eccentricity is not being calculated correctly for MultiplexGraphBU.')

g = MultiplexGraphBU('B', B);
m_outside_g = Eccentricity('G', g, 'rule', find(contains(Eccentricity.RULES, 'all')));
assert(isequal(m_outside_g.get('M'), known_eccentricity_av_default), ...
    [BRAPH2.STR ':Eccentricity:' BRAPH2.BUG_ERR], ...
    'Eccentricity is not being calculated correctly for MultiplexGraphBU.')

g = MultiplexGraphBU('B', B);
m_inside_g = g.getMeasure('Eccentricity', 'rule', find(contains(Eccentricity.RULES, 'all')));
assert(isequal(m_inside_g.get('M'), known_eccentricity_av_default), ...
    [BRAPH2.STR ':Eccentricity:' BRAPH2.BUG_ERR], ...
    'Eccentricity is not being calculated correctly for MultiplexGraphBU.')

%%% ¡test!
%%%% ¡name!
MultiplexGraphWU
%%%% ¡code!
B11 = [
      0   .2  1
      0   0   .8
      1   0   0
      ];
B12 = eye(3);
B21 = eye(3);
B22 = [
      0  1   .6
      1  0   .4
      0  .4  0
      ];
B = {
    B11 B12  
    B21 B22
    };

known_eccentricity_av_subgraphs = {
                               mean([5 5 5 4 0]')
                               mean([5 5 5 4 0]')
                               };
known_eccentricity_av_default = {
                             mean([Inf Inf Inf Inf Inf]')
                             mean([Inf Inf Inf Inf Inf]')
                             };
                           
g = MultiplexGraphWU('B', B);
m_outside_g = Eccentricity('G', g, 'rule', find(contains(Eccentricity.RULES, 'subgraphs')));
assert(isequal(m_outside_g.get('M'), known_eccentricity_av_subgraphs), ...
    [BRAPH2.STR ':Eccentricity:' BRAPH2.BUG_ERR], ...
    'Eccentricity is not being calculated correctly for MultiplexGraphWU.')

g = MultiplexGraphWU('B', B);
m_inside_g = g.getMeasure('Eccentricity', 'rule', find(contains(Eccentricity.RULES, 'subgraphs')));
assert(isequal(m_inside_g.get('M'), known_eccentricity_av_subgraphs), ...
    [BRAPH2.STR ':Eccentricity:' BRAPH2.BUG_ERR], ...
    'Eccentricity is not being calculated correctly for MultiplexGraphWU.')

g = MultiplexGraphWU('B', B);
m_outside_g = Eccentricity('G', g, 'rule', find(contains(Eccentricity.RULES, 'all')));
assert(isequal(m_outside_g.get('M'), known_eccentricity_av_default), ...
    [BRAPH2.STR ':Eccentricity:' BRAPH2.BUG_ERR], ...
    'Eccentricity is not being calculated correctly for MultiplexGraphWU.')

g = MultiplexGraphWU('B', B);
m_inside_g = g.getMeasure('Eccentricity', 'rule', find(contains(Eccentricity.RULES, 'all')));
assert(isequal(m_inside_g.get('M'), known_eccentricity_av_default), ...
    [BRAPH2.STR ':Eccentricity:' BRAPH2.BUG_ERR], ...
    'Eccentricity is not being calculated correctly for MultiplexGraphWU.')