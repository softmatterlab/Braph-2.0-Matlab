%% ¡header!
RichClubStrength < Element (rc, Rich Club Strength) is a rich club strength element.

%%% ¡description!

%%% ¡seealso!

%% ¡props!

%%% ¡prop!
A (data, cell) is a cell with an adjacency matrix, it is a data, cell.
%%%% ¡default!
{zeros(3)}

%%% ¡prop!
rcs_parameter (data, scalar) is a positive number greater than 1. It is a data, scalar.
%%%% ¡conditioning!
if value <= 0
    value = 1;
end
%%%% ¡check_prop!
check = value > 0;
%%%% ¡default!
1

%%% ¡prop!
RCS (result, cell) is the result of rich club strength of A.

%%%% ¡calculate!
A = rc.get('A');
L = length(A);
N = length(A{1, 1});

s =  Strength('a', A);
strength = s.get('S');
p = rc.get('rcs_parameter');
rich_club_strength = zeros(N, 1);
RCS = cell(L, 1);
for li = 1:1:L
    Aii = A{li, li};
    count = 1;
    for level = p
        low_rich_nodes = find(strength{li} <= level);  % get lower rich nodes with strength <= s
        subAii = Aii;  % extract subnetwork of nodes >s by removing nodes <=s of Aii
        subAii(low_rich_nodes, :) = 0;  % remove rows
        subAii(:, low_rich_nodes) = 0;  % remove columns
        rich_club_strength(:, :, count) = round(sum(subAii, 1), 6)'; 
        count = count + 1;
    end
    RCS(li) = {rich_club_strength};
end
value = RCS;