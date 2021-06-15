%% ¡header!
BaseNN < Element (nn, based neural network) is a based neural network.

%%% ¡description!
basedNN provides the methods necessary for setting up neural networks.
Instances of this class should not be created. 
Use one of its subclasses instead.


%% ¡props!

%%% ¡prop!
ID (data, string) is a few-letter code for the classification.

%%% ¡prop!
LABEL (metadata, string) is an extended label of the classification.

%%% ¡prop!
NOTES (metadata, string) are some specific notes about the classification.

%%% ¡prop!
GR1 (data, item) is the subject group, which also defines the subject class.
%%%% ¡settings!
'Group'

%%% ¡prop!
GR2 (data, item) is the subject group, which also defines the subject class.
%%%% ¡settings!
'Group'

%%% ¡prop!
G_DICT (result, idict) is the graph enemble obtained from this analysis.
%%%% ¡settings!
'Graph'

%%% ¡prop!
NEURAL_NETWORK (result, cell) is the neural network trained from this analysis.

%% ¡methods!
function nn_binary_format = net_binary_transformer(nn)
    filename = 'nn.bin';
    exportONNXNetwork(net,cell2mat(nn.get('NEURAL_NETWORK')));
    fileID = fopen(filename);
    nn_binary_format = fread(fileID);
    fclose(fileID);
    delete nn.bin
end


