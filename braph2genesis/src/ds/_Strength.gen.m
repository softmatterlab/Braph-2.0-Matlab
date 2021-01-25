%% ¡header!
Strength < Element (s, Strength) is a strength element.

%%% ¡description!

%%% ¡seealso!

%% ¡props!

%%% ¡prop!
A (data, cell) is a cell with an adjacency matrix, it is a data, cell.
%%%% ¡default!
{zeros(3)}

%%% ¡prop!
S (result, cell) is the result of strength of A.

%%%% ¡calculate!
A = s.get('A');
L = length(A);
S = cell(L, 1);
for li = 1:1:L
 Aii = A{li, li};
 S(li) = {sum(Aii, 2)};  % calculates the strength of a node for layer li
end
value = S;

%% ¡tests!

%%% ¡test!
%%%% ¡name!
GraphWU
%%%% ¡code!
A = {[
    0  .2 1
    .2 0  0
    1  0  0
    ]};

known_strength = {[1.2 0.2 1]'};

strength = Strength('a', A);

assert(isequal(strength.get('S'), known_strength), ...
    [BRAPH2.STR ':Strength:' BRAPH2.BUG_ERR], ...
    'Strength is not being calculated correctly for GraphWU.') 

%%% ¡test!
%%%% ¡name!
MultiplexGraphWU
%%%% ¡code!

A11 = [
    0  .2 1
    .2 0  0
    1  0  0
    ];
A12 = eye(3);
A21 = eye(3);
A22 = [
    0 1  0
    1 0  .4
    0 .4 0
    ];
A = {
    A11     A12  
    A21     A22
    };

known_strength = {
                 [1.2 .2  1]'
                 [1   1.4 .4]'
                 };
                                
strength = Strength('a', A);

assert(isequal(strength.get('S'), known_strength), ...
    [BRAPH2.STR ':Strength:' BRAPH2.BUG_ERR], ...
    'Strength is not being calculated correctly for MultiplexGraphWU.')