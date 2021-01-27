%% ¡header!
WeightedMultiplexParticipation < Element (wmp, Weighted Multiplex Participation) is a WeightedMultiplexParticipation element.

%%% ¡description!

%%% ¡seealso!

%% ¡props!

%%% ¡prop!
A (data, cell) is a cell with an adjacency matrix, it is a data, cell.
%%%% ¡default!
{zeros(3)}

%%% ¡prop!
WMPC (result, cell) is the Weighted Multiplex Participation coefficient of A.

%%%% ¡calculate!
A = wmp.get('A');
L = length(A);
N = length(A{1, 1});
s = Strength('a', A);
strength = s.get('S');
os = OverlappingStrength('a', A);
overlapping_strength = os.get('OSR');

participation =  zeros(N, 1);
WMPC = cell(1, 1);
for li = 1:1:L
 participation = participation + (strength{li}./overlapping_strength{1}).^2;
end
participation = L / (L - 1) * (1 - participation);
%weighted_multiplex_participation(isnan(weighted_multiplex_participation)) = 0;  % Should return zeros, since NaN happens when strength = 0 and overlapping strength = 0 for all regions
WMPC = {participation}
value = WMPC;

%% ¡tests!

%%% ¡test!
%%%% ¡name!
MultiplexGraphWU
%%%% ¡code!
A11 = [
    0   .5  1
    .5  0   0
    1   0   0
    ];
A12 = eye(3);
A21 = eye(3);
A22 = [
    0   1   0
    1   0   .5
    0   .5  0
    ];
A = {
    A11     A12
    A21     A22
    };

known_weighted_multiplex_participation = {[24/25 3/4 8/9]'};
          
weighted_multiplex_participation = WeightedMultiplexParticipation('a', A);

assert(isequal(weighted_multiplex_participation.get('WMPC'), known_weighted_multiplex_participation), ...
    [BRAPH2.STR ':WeightedMultiplexParticipation:' BRAPH2.BUG_ERR], ...
    'WeightedMultiplexParticipation is not being calculated correctly for MultiplexGraphWU.')
