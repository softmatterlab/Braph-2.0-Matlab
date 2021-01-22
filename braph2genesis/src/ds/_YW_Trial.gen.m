%% ¡header!
YW_Trial < Element (yw_tr, trial element) is a trial element.

%% ¡props!

%%% ¡prop!
a (data, cvector) is a.

%%% ¡prop!
b (data, rvector) is b.

%%% ¡prop!
res (result, MATRIX) is result (a * b).

%%%% ¡calculate!
value = yw_tr.get('A') * yw_tr.get('B')

%% ¡tests!

%%% ¡test!
%%%% ¡name!



