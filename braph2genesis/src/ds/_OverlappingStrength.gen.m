%% ¡header!
OverlappingStrength < Element (os, Overlapping Strength) is a overlapping strength element.

%%% ¡description!

%%% ¡seealso!

%% ¡props!

%%% ¡prop!
A (data, cell) is a cell with an adjacency matrix, it is a data, cell.
%%%% ¡default!
{zeros(3)}

%%% ¡prop!
OSR (result, cell) is the result of overlapping strength of A.

%%%% ¡calculate!
A = os.get('A');
L = length(A);
N = length(A{1, 1});

s =  Strength('a', A);
strength = s.get('S');
overlapping_strength = zeros(N, 1);
OSR = cell(1, 1);
for li = 1:1:L
 overlapping_strength = overlapping_strength + strength{li};
end
OSR = {overlapping_strength};
value = OSR;


%% ¡tests!

%%% ¡test!
%%%% ¡name!
MultiplexGraphWU
%%%% ¡code!
A11 = [
    0   .2  1
    .2  0   0
    1   0   0
    ];
A12= eye(3);
A21 = eye(3);
A22 = [
    0   1   0
    1   0   .3
    0   .3  0
    ];
A = {
    A11     A12  
    A21     A22
    };

known_overlapping_strength = {[2.2 1.5 1.3]'};
                 
overlapping_strength = OverlappingStrength('a', A);

assert(isequal(overlapping_strength.get('OSR'), known_overlapping_strength), ...
    [BRAPH2.STR ':OverlappingStrength:' BRAPH2.BUG_ERR], ...
    'OverlappingStrength is not being calculated correctly for MultiplexGraphWU.')