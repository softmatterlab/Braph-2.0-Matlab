%% ¡header!
YW_Trial < Element (yw_tr, trial element) is a trial element.

%% ¡props!

%%% ¡prop!
a (data, cvector) is column vector a.
%%%% ¡default!
[0; 0; 0; 0]

%%% ¡prop!
b (data, rvector) is row vector b.
%%%% ¡default!
[0 0 0 0]


%%% ¡prop!
res (result, MATRIX) is result (a * b).

%%%% ¡calculate!
% value = yw_tr.get('A') * yw_tr.get('B')
value = yw_tr.get('A') * yw_tr.get('B') * rand(4);

%% ¡tests!

%%% ¡test!
%%%% ¡name!
% 


