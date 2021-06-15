%% ¡header!
MultigraphBUT < GraphWU (g, binary undirected multigraph with fixed thresholds) is a binary undirected multigraph with fixed thresholds.

%%% ¡description!
In a binary undirected multigraph with fixed thresholds, 
all the layers consist of binary undirected (BU) graphs 
derived from the same weighted connectivity matrix 
binarized at different thresholds.
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
THRESHOLDS (data, rvector) is the vector of thresholds.

%% ¡props_update!

%%% ¡prop!
A (result, cell) is the cell array with the symmetric binary adjacency matrices of the binary undirected multigraph.
%%%% ¡calculate!
A_WU = calculateValue@GraphWU(g, prop);

thresholds = g.get('THRESHOLDS');
A = cell(length(thresholds));

for i = 1:1:length(thresholds)
    threshold = thresholds(i);
    A{i, i} = binarize(cell2mat(A_WU), 'threshold', threshold);
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
    .1 0 .1 .2 .3
    .2 .1 0 .1 .2
    .3 .2 .1 0 .1
    .4 .3 .2 .1 0
    ];
g = MultigraphBUT('B', B, 'THRESHOLDS', [0 .1 .2 .3 .4 .5]);

A = g.get('A');

assert(isequal( ...
    A{1, 1}, ...
    [
    0 1 1 1 1
    1 0 1 1 1
    1 1 0 1 1
    1 1 1 0 1
    1 1 1 1 0
    ]) ...
    && ...
    isequal( ...
    A{2, 2}, ...
    [
    0 0 1 1 1
    0 0 0 1 1
    1 0 0 0 1
    1 1 0 0 0
    1 1 1 0 0
    ]) ...
    && ...
    isequal( ...
    A{3, 3}, ...
    [
    0 0 0 1 1
    0 0 0 0 1
    0 0 0 0 0
    1 0 0 0 0
    1 1 0 0 0
    ]) ...
    && ...
    isequal( ...
    A{4, 4}, ...
    [
    0 0 0 0 1
    0 0 0 0 0
    0 0 0 0 0
    0 0 0 0 0
    1 0 0 0 0
    ]) ...
    && ...
    isequal( ...
    A{5, 5}, ...
    [
    0 0 0 0 0
    0 0 0 0 0
    0 0 0 0 0
    0 0 0 0 0
    0 0 0 0 0
    ]) ...
    && ...
    isequal( ...
    A{6, 6}, ...
    [
    0 0 0 0 0
    0 0 0 0 0
    0 0 0 0 0
    0 0 0 0 0
    0 0 0 0 0
    ]), ...
    [BRAPH2.STR ':MultigraphBUT:' BRAPH2.BUG_ERR], ...
    'MultigraphBUT is not constructing well.')