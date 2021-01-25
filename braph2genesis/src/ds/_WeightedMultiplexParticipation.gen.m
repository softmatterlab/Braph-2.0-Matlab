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
%%%% ¡conditioning!


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
