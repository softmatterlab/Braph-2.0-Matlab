%% ¡header!
ClassifierNN_CON_WU < BaseNN (nn, classification with connectivity data) is a classification using neural network with connectivity data.

%% ¡description!
This classification uses connectivity data and trains neural network with them using weighted undirected graphs.

%% ¡properties!
training_accuracy
test_accuracy
y_tblTrain
X_tblTrain
y_tblTest
X_tblTest
class_name

%% ¡props_update!

%%% ¡prop!
GR1 (data, item) is the subject group, which also defines the subject class SubjectCON.
%%%% ¡default!
Group('SUB_CLASS', 'SubjectCON')

%%% ¡prop!
GR2 (data, item) is the subject group, which also defines the subject class SubjectCON.
%%%% ¡default!
Group('SUB_CLASS', 'SubjectCON')

%%% ¡prop!
G_DICT (result, idict) is the graph (GraphWU) ensemble obtained from this analysis.
%%%% ¡settings!
'GraphWU'
%%%% ¡default!
IndexedDictionary('IT_CLASS', 'GraphWU');

%%% ¡prop!
NEURAL_NETWORK (result, cell) is the neural network trained from this analysis.
%%%% ¡calculate!
% import the data
g_dict = nn.get('G_DICT');

gr1 = nn.get('GR1');
label = [];
for i = 1:1:gr1.get('SUB_DICT').length()
	sub = gr1.get('SUB_DICT').getItem(i);
    g = GraphWU( ...
        'ID', ['g ' sub.get('ID')], ...
        'B', Callback('EL', sub, 'TAG', 'CON') ...
        );
    g_dict.add(g)
    label =[label string(gr1.get('ID'))];
end

gr2 = nn.get('GR2');
for i = 1:1:gr2.get('SUB_DICT').length()
	sub = gr2.get('SUB_DICT').getItem(i);
    g = GraphWU( ...
        'ID', ['g ' sub.get('ID')], ...
        'B', Callback('EL', sub, 'TAG', 'CON') ...
        );
    g_dict.add(g)
    label =[label string(gr2.get('ID'))];
end

% flattern the input
dataset = cellfun(@(x) x.get('A'), g_dict.getItems(), 'UniformOutput', true);
dataset = cellfun(@(x) triu(x, 1), dataset, 'UniformOutput', false);
dataset = cellfun(@(x) nonzeros(x(:)), dataset, 'UniformOutput', false);
dataset = array2table(cell2mat(dataset)');
label = array2table(label', 'VariableNames', {'DX'})
dataset = [dataset label];

% get classes
dataset = convertvars(dataset,'DX', 'categorical');
classNames = categories(dataset{:,end})
nn.class_name = classNames;
% split the datset into training and test set
numObservations = size(dataset, 1);
numObservationsTrain = floor(0.9*numObservations);
numObservationsTest = numObservations - numObservationsTrain;

idx = randperm(numObservations);
idxTrain = idx(1:numObservationsTrain);
idxTest = idx(numObservationsTrain+1:end);

tblTrain = dataset(idxTrain, :);
tblTest = dataset(idxTest, :);

y_tblTrain = tblTrain{:, end};
X_tblTrain = tblTrain{:, 1:end-1};
X_tblTrain = reshape(X_tblTrain', [1, 1, size(X_tblTrain,2), size(X_tblTrain,1)]);
y_tblTest = tblTest{:, end};
X_tblTest = tblTest{:, 1:end-1};
X_tblTest = reshape(X_tblTest', [1, 1, size(X_tblTest,2), size(X_tblTest,1)]);

nn.X_tblTrain = X_tblTrain;
nn.y_tblTrain = y_tblTrain;
nn.X_tblTest = X_tblTest;
nn.y_tblTest = y_tblTest;


% specify the parameters and layers
numFeatures = size(dataset, 2) - 1;
numClasses = numel(classNames);
layers = [
    %featureInputLayer(numFeatures,'Normalization', 'zscore','Name','input')
    imageInputLayer([1 1 numFeatures],'Normalization', 'zscore','Name','input')
    fullyConnectedLayer(floor(1.5*numFeatures),'Name','fc1')
    batchNormalizationLayer('Name','batchNormalization1')
    fullyConnectedLayer(floor(1.5*numFeatures),'Name','fc2')
    batchNormalizationLayer('Name','batchNormalization2')
    reluLayer('Name','relu1')
    fullyConnectedLayer(numClasses,'Name','fc3')
    softmaxLayer('Name','sfmax1')
    classificationLayer('Name','output')];
lgraph = layerGraph(layers);
plot(lgraph)
miniBatchSize = 16;

options = trainingOptions('sgdm', ...
    'MiniBatchSize',miniBatchSize, ...
    'Shuffle','every-epoch', ...
    'Plots','training-progress', ...
    'Verbose',false);

% fit the model
net = trainNetwork(X_tblTrain, y_tblTrain, layers, options);

% save the trained net
nn_binary_format = nn.net_binary_transformer(net);

% get prediction accuracy on training set
YPred = classify(net, nn.X_tblTrain);
YTest = y_tblTrain;
nn.training_accuracy = sum(YPred == YTest)/numel(YTest);

% get prediction accuracy on test set
YPred = classify(net, X_tblTest);
YTest = y_tblTest;
nn.test_accuracy = sum(YPred == YTest)/numel(YTest);

value = num2cell(nn_binary_format);

if(~isempty(dataset))
    dataset = cellfun(@(x) triu(x, 1), dataset, 'UniformOutput', false);
    dataset = cellfun(@(x) nonzeros(x(:)), dataset, 'UniformOutput', false);
    dataset = array2table(cell2mat(dataset)');
    label = array2table(label', 'VariableNames', {'DX'})
    dataset = [dataset label];

    % get classes
    dataset = convertvars(dataset,'DX', 'categorical');
    classNames = categories(dataset{:,end})
    nn.class_name = classNames;
    % split the datset into training and test set
    numObservations = size(dataset, 1);
    numObservationsTrain = floor(0.9*numObservations);
    numObservationsTest = numObservations - numObservationsTrain;

    idx = randperm(numObservations);
    idxTrain = idx(1:numObservationsTrain);
    idxTest = idx(numObservationsTrain+1:end);

    tblTrain = dataset(idxTrain, :);
    tblTest = dataset(idxTest, :);

    y_tblTrain = tblTrain{:, end};
    X_tblTrain = tblTrain{:, 1:end-1};
    X_tblTrain = reshape(X_tblTrain', [1, 1, size(X_tblTrain,2), size(X_tblTrain,1)]);
    y_tblTest = tblTest{:, end};
    X_tblTest = tblTest{:, 1:end-1};
    X_tblTest = reshape(X_tblTest', [1, 1, size(X_tblTest,2), size(X_tblTest,1)]);

    nn.X_tblTrain = X_tblTrain;
    nn.y_tblTrain = y_tblTrain;
    nn.X_tblTest = X_tblTest;
    nn.y_tblTest = y_tblTest;


    % specify the parameters and layers
    numFeatures = size(dataset, 2) - 1;
    numClasses = numel(classNames);
    layers = [
        %featureInputLayer(numFeatures,'Normalization', 'zscore','Name','input')
        imageInputLayer([1 1 numFeatures],'Normalization', 'zscore','Name','input')
        fullyConnectedLayer(floor(1.5*numFeatures),'Name','fc1')
        batchNormalizationLayer('Name','batchNormalization1')
        fullyConnectedLayer(floor(1.5*numFeatures),'Name','fc2')
        batchNormalizationLayer('Name','batchNormalization2')
        reluLayer('Name','relu1')
        fullyConnectedLayer(numClasses,'Name','fc3')
        softmaxLayer('Name','sfmax1')
        classificationLayer('Name','output')];
    lgraph = layerGraph(layers);
    plot(lgraph)
    miniBatchSize = 16;

    options = trainingOptions('sgdm', ...
        'MiniBatchSize',miniBatchSize, ...
        'Shuffle','every-epoch', ...
        'Plots','training-progress', ...
        'Verbose',false);

    % fit the model
    net = trainNetwork(X_tblTrain, y_tblTrain, layers, options);

    % save the trained net
    nn_binary_format = nn.net_binary_transformer(net);

    % get prediction accuracy on training set
    YPred = classify(net, nn.X_tblTrain);
    YTest = y_tblTrain;
    nn.training_accuracy = sum(YPred == YTest)/numel(YTest);

    % get prediction accuracy on test set
    YPred = classify(net, X_tblTest);
    YTest = y_tblTest;
    nn.test_accuracy = sum(YPred == YTest)/numel(YTest);

    value = nn_binary_format;
else
    value = [];
end
%% ¡methods!
function accuracy = getTrainingAccuracy(nn)
    accuracy = nn.training_accuracy
end

function accuracy = getTestAccuracy(nn)
    accuracy = nn.test_accuracy
end

function class_name = getClassName(nn)
    class_name = nn.class_name
end

function m = getTrainingConfusionMatrix(nn)
    YPred = classify(cell2mat(nn.get('NEURAL_NETWORK')), nn.X_tblTrain);
	YTest = nn.y_tblTrain;
    % plot result
    [m,order] = confusionmat(YTest,YPred)
    figure
    confusionchart(YTest,YPred, ...
        'Title','Classification', ...
        'RowSummary','row-normalized', ...
        'ColumnSummary','column-normalized');
end

function m = getTestConfusionMatrix(nn)
    YPred = classify(cell2mat(nn.get('NEURAL_NETWORK')), nn.X_tblTest);
	YTest = nn.y_tblTest;
    % plot result
    [m,order] = confusionmat(YTest,YPred)
    figure
    confusionchart(YTest,YPred, ...
        'Title','Classification', ...
        'RowSummary','row-normalized', ...
        'ColumnSummary','column-normalized');
end

function tbl = getTrainingTable(nn)
    tbl = nn.X_tblTrain
end

function tbl = getTrainingLable(nn)
    tbl = nn.y_tblTrain
end

function tbl = getTestTable(nn)
    tbl = nn.X_tblTest
end

function tbl = getTestLable(nn)
    tbl = nn.y_tblTest
end

function nn_obj_format = net_obj_transformer(nn)
    filename = 'nn.onnx';
    fileID = fopen(filename,'w');
    fwrite(fileID, cell2mat(nn.get('NEURAL_NETWORK')));
    fclose(fileID);
    nn_obj_format = importONNXNetwork(filename,'OutputLayerType','classification','Classes',string(nn.class_name));
    delete nn.onnx
end
%% ¡tests!

%%% ¡test!
%%%% ¡name!
Example
%%%% ¡code!
example_classification_CON_WU