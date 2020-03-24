classdef MeanFirstPassageTime < Measure
    methods
        function m = MeanFirstPassageTime(g, varargin)
            
            settings = clean_varargin({'MeanFirstPassageTimeRule'}, varargin{:});

            m = m@Measure(g, settings{:});
        end
    end
    methods (Access=protected)
        function MFPT = calculate(m)
            g = m.getGraph();
            A = g.getA();
            
            P = diag(sum(A,2))\A; % matrix of transition probabilities by solving B*p=A the system linear equations
            tol = 10^(-3); % tolerance to find value of 1 at the eigenvector.
            n = length(P); % number of nodes.
            
            [V,D_eigenvalue] = eig(P');  % diagonal matrix D_eigenvalue of eigenvalues. The columns of matrix V are the corresponding eigenvectors,so that P'*V = V*D_eigenvalue.
            aux = abs(diag(D_eigenvalue)-1);
            index = find(aux==min(aux));
            
            if aux(index)>tol
                error('cannot find eigenvalue of 1. Minimum eigenvalue value is %0.6f. Tolerance was set at %0.6f',aux(index)+1,tol);
            end

            w = V(:,index)'; % eigenvector associated to eigenvalue of 1.
            w = w/sum(w); % rescale the eigenvector to its sum of it.
            W = repmat(w,n,1); % convert column-vector w to a full matrix W by making copies of w.
            I = eye(n,n); % identity matrix I with rank n
            Z = inv(I-P+W); % fundamental matrix Z is computed
            MFPT = (repmat(diag(Z)',n,1)-Z)./W;
        end
    end
    methods (Static)
        function measure_class = getClass()
            measure_class = 'MeanFirstPassageTime';
        end
        function name = getName()
            name = 'Mean First Passage Time';
        end
        function description = getDescription()
            description = [ ...
                'The first passage time is ' ...
                'the expected number of steps it takes a random walker to reach one node from another. ' ...
                ];
        end
        function bool = is_global()
            bool = false;
        end
        function bool = is_nodal()
            bool = false;
        end
        function bool = is_binodal()
            bool = true;
        end
        function list = getCompatibleGraphList()
            list = { ...
                'GraphBD', ...
                'GraphBU', ...
                'GraphWD', ...
                'GraphWU' ...
                };
        end
        function n = getCompatibleGraphNumber()
            n = Measure.getCompatibleGraphNumber('MeanFirstPassageTime');
        end
    end
end
