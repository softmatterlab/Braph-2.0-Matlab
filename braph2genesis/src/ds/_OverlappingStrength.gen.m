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
