%% ¡header!
Regression < Element (nn, regression neural network) is a regression neural network.

%%% ¡description!
Regression provides the methods necessary for all regression neural networks.
Instances of this class should not be created. 
Use one of its subclasses instead.

%%% ¡seealso!
Regression

%% ¡props!

%%% ¡prop!
ID (data, string) is a few-letter code for the regression.

%%% ¡prop!
LABEL (metadata, string) is an extended label of the regression.

%%% ¡prop!
NOTES (metadata, string) are some specific notes about the regression.

%%% ¡prop!
GR (data, item) is the subject group, which also defines the subject class.
%%%% ¡settings!
'Group'

%%% ¡prop!
A (result, scalar) is the accuracy obtained from this regression.
%%%% ¡calculate!
value = 0;