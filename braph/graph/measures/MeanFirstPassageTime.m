classdef MeanFirstPassageTime < Measure
    methods
        function m = MeanFirstPassageTime(g, varargin)
            
            settings = clean_varargin({'MeanFirstPassageTimeRule'}, varargin{:});

            m = m@Measure(g, settings{:});
        end
    end
    methods (Access=protected)
        function mean_first_passage_time = calculate(m)
            g = m.getGraph();
            A = g.getA();
            
            % Get the matrix P, which is transition probabilities
            % by solving B*P=A the system linear equations.
            B = diag(sum(A,2));
            P = B\A;
            if(sum(isnan(P))>0)
                error('cannot find transition probabilities');
            end
            % Set the tolerance to find the closest value to 1 at the eigenvalue.
            tol = 10^(-3); 
            n = length(P);
            
            % Get diagonal matrix D_eigenvalue of eigenvalues.
            % The columns of matrix V are the corresponding eigenvectors,
            % so that P'*V = V*D_eigenvalue
            [V,D_eigenvalue] = eig(P');
            aux = abs(diag(D_eigenvalue)-1);
            
            % Get the index of whom is closest to 1.
            index = find(aux==min(aux)); 
            
            if aux(index)>tol
                error('cannot find eigenvalue of 1. Minimum eigenvalue value is %0.6f. Tolerance was set at %0.6f',aux(index)+1,tol);
            end

            w = V(:,index)'; % Get eigenvector associated to eigenvalue of 1.
            w = w/sum(w); % Rescale the eigenvector to its sum.
            W = repmat(w,n,1); % Convert column-vector w to a full matrix W by making copies of w.
            I = eye(n,n); % Get identity matrix I with rank n.
            Z = inv(I-P+W); % Get fundamental matrix Z.
            mean_first_passage_time = (repmat(diag(Z)',n,1)-Z)./W;
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
                'The mean first passage time is ' ...
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
