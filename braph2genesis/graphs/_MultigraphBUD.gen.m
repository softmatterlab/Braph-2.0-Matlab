%% ¡header!
MultigraphBUD < GraphWU (g, binary undirected multigraph with fixed densities) is a binary undirected multigraph with fixed densities.

%%% ¡description!
In a binary undirected multigraph with fixed densities, 
all the layers consist of binary undirected (BU) graphs 
derived from the same weighted connectivity matrix 
binarized at different densities.
There are no connections between layers.

%%% ¡graph!
graph = Graph.MULTIGRAPH;

%%% ¡connectivity!
connectivity = Graph.BINARY * ones(layernumber);

%%% ¡directionality!
directionality = Graph.UNDIRECTED * ones(layernumber);

%%% ¡selfconnectivity!
selfconnectivity = Graph.NONSELFCONNECTED * ones(layernumber);

%%% ¡negativity!
negativity = Graph.NONNEGATIVE * ones(layernumber);

%% ¡props!

%%% ¡prop!
DENSITIES (data, rvector) is the vector of densities.

%% ¡props_update!

%%% ¡prop!
A (result, cell) is the cell array with the symmetric binary adjacency matrices of the binary undirected multigraph.
%%%% ¡calculate!
A_WU = calculateValue@GraphWU(g, prop);

densities = g.get('DENSITIES');
A = cell(length(densities));

for i = 1:1:length(densities)
    density = densities(i);
    A{i, i} = binarize(cell2mat(A_WU), 'density', density);
end

value = A;

%% ¡methods!
function [l, ls] = layernumber(g)
    %LAYERNUMBER returns the number of layers in the graph.
    %
    % L = LAYERNUMBER(G) returns the number of layers in graph G. L is a scalar.
    %
    % [~, LS] = LAYERNUMBER(G) returns the number of layers in the partitions
    %  of graph G. LS is a vector of integers.
    %
    % See also nodenumber.

    l = length(g.get('A'));
    ls = ones(1, l);
end

%% ¡tests!

%%% ¡test!
%%%% ¡name!
Constructor
%%%% ¡code!
B = [
     0 .1 .2 .3 .4
    .1  0 .5 .6 .7
    .2 .5  0 .8 .9
    .3 .6 .8  0  1
    .4 .7 .9  1  0
    ];
g = MultigraphBUD('B', B, 'DENSITIES', [0 55 100]);

A = g.get('A');

assert( ...
    sum(sum(A{1, 1})) == 0 && ...
    sum(sum(A{2, 2})) == 10 && ...
    sum(sum(A{3, 3})) == 20, ...
    [BRAPH2.STR ':MultigraphBUD:' BRAPH2.BUG_ERR], ...
    'MultigraphBUD is not constructing well.')