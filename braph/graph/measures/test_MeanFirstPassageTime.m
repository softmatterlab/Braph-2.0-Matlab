% test MeanFirstPassageTime
graph_class_list = Graph.getList();

%% Test 1: Calculation AllGraphs
for i = 1:1:length(graph_class_list)
    graph_class = graph_class_list{i};
    A = rand(randi([2 5]));
    g = Graph.getGraph(graph_class, A);
    MFPT = MeanFirstPassageTime(g);
    value = MFPT.getValue();
    
    assert(~isempty(value), ...
        ['BRAPH:' graph_class ':MeanFirstPassageTime'], ...
        ['MeanFirstPassageTime is not calculated for ' graph_class])
    
    assert(isequal(size(value), size(g.getA())), ...
        ['BRAPH:MeanFirstPassageTime: ' graph_class], ...
        ['MeanFirstPassageTime dim is not correct for ' graph_class])
end

%% Test 2: Calculation vs Known Values
for i = 1:1:length(graph_class_list)
    graph_class = graph_class_list{i};
    L = [
         0  .1  
        .5   0
        ];
    g = Graph.getGraph(graph_class, L);
    MFPT = MeanFirstPassageTime(g);
    value = MFPT.getValue();
    
    known_solution = [
                0.0 1.0;
                1.0 0.0;
                ];
    
    assert( isequal(value, known_solution), ...
        ['BRAPH:MeanFirstPassageTime: ' graph_class], ...
        ['MeanFirstPassageTime is not working for: ' graph_class ])
end

%% Test 3: Calculation vs BCT
for i = 1:1:length(graph_class_list)
    graph_class = graph_class_list{i};
    L = [
        0 .1  0  0
       .2  0 .1  0
        0 .1  0 .2
        0  0 .1  0
        ];
    g = Graph.getGraph(graph_class, L);
    A = g.getA();
    value_bct = mean_first_passage_time(A);
    g = Graph.getGraph(graph_class, A);
    MFPT = MeanFirstPassageTime(g);
    value = MFPT.getValue();
    
    assert(isequal(value, value_bct), ...
        ['BRAPH:' graph_class ':MeanFirstPassageTime'], ...
        ['MeanFirstPassageTime is not calculated for ' graph_class])
end

% Functions from 2020_03_23_BCT
function MFPT = mean_first_passage_time(adj)
    % MEAN_FIRST_PASSAGE_TIME           Mean first passage time
    %
    %   MFPT = mean_first_passage_time(adj)
    %
    %   The first passage time (MFPT) from i to j is the expected number of
    %   steps it takes a random walker starting at node i to arrive for the
    %   first time at node j. The mean first passage time is not a
    %   symmetric measure: mfpt(i,j) may be different from mfpt(j,i).  
    % 
    %   Input:
    %       adj,    Weighted/Unweighted, directed/undirected adjacency matrix 
    %
    %   Output:
    %       MFPT, 	Pairwise mean first passage time matrix.   
    %
    %
    %   References: Goñi J, et al (2013) PLoS ONE
    %               
    %   Joaquin Goñi, IU Bloomington, 2012


    P = diag(sum(adj,2))\adj; % matrix of transition probabilities

    tol=10^(-3); %tolerance to find value of 1 at the eigenvector

    n = length(P); %number of nodes
    [V,D_eigen] = eig(P');  %diagonal matrix D_eigen of eigenvalues. Full matrix V whose columns are the corresponding eigenvectors so that X*V = V*D. In our case X=P';

    aux = abs(diag(D_eigen)-1);
    index = find(aux==min(aux));
    if aux(index)>tol
        error('cannot find eigenvalue of 1. Minimum eigenvalue value is %0.6f. Tolerance was set at %0.6f',aux(index)+1,tol);
    end

    w = V(:,index)'; %left-eigen vector associated to eigenvalue of 1.
    w = w/sum(w); %rescale of left-eigen vector to the sum of it (hence is now in probabilites form. The inverse of this vector is the return-times vector

    W = repmat(w,n,1); %convert column-vector w to a full matrix W by making copies of w.
    I = eye(n,n); %Identity matrix I is computed

    Z = inv(I-P+W); %Fundamental matrix Z is computed

    MFPT = (repmat(diag(Z)',n,1)-Z)./W;  % this performs MFPT(i,j)=(Z(j,j)-Z(i,j))/w(j) in a matricial way. Corresponds to theorem 11.16 pag. 459
    % r = 1./w; %as demostrated in theorem 11.15 pag. 455. Each entry r_i is the 'mean-recurrence' or 'return-time' of state i (node i when states represent nodes of a graph)
end