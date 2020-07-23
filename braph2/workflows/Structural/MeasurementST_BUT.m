classdef MeasurementST_BUT < MeasurementST_WU
    % MeasurementST_BUT A measurement of structural data with BU graphs at fixed threshold
    % MeasurementST_BUT is a subclass of MeasurementST_WU.
    %
    % MeasurementST_BUT store a measurement of structural data with BU
    % graphs at fixes threshold, for this it implements MeasurementST_WU
    % initialization of data. Structural data can be for example MRI or PET data.
    %
    % MeasurementST_BUT constructor methods:
    %  MeasurementST_BUT            - Constructor
    %
    % MeasurementST_BUT get methods:
    %  getThreshold                 - returns the threshold
    %
    % MeasurementST_BUT descriptive methods (Static):
    %  getClass                     - returns the class of the measurement
    %  getName                      - returns the name of the measurement
    %  getDescription               - returns the description of the measurement
    %  getAnalysisClass             - returns the class of the analysis

    %
    % See also Comparison, AnalysisST_BUT, ComparisonST_BUT, RandomComparisonST_BUT. 
   
    properties (Access = protected)
        threshold  % threshold of the values
    end
    methods  % Constructor
        function m =  MeasurementST_BUT(id, label, notes, atlas, measure_code, group, varargin)
            % MEASUREMENTST_BUT(ID, LABEL, NOTES, ATLAS, MEASURE_CODE, GROUP, 'threshold',  THRESHOLD)
            % creates a measurement with ID, LABEL, ATLAS and MEASURE_CODE
            % with the data from GROUP, this data will have a fixed THRESHOLD. 
            %
            % MeasurementST_BUT(ID, LABEL, NOTES, ATLAS, MEASURE_CODE, GROUP) 
            % creates a comparison with ID, LABEL, ATLAS, MEASURE_CODE,
            % with the data from GROUP, this data will have a fixed default threshold.
            %
            % See also ComparisonST_BUT, RandomComparisonST_BUT, AnalysisST_BUT.
            
            m = m@MeasurementST_WU(id, label, notes, atlas, measure_code, group, varargin{:});

            threshold = get_from_varargin(0, 'threshold', varargin{:});
            m.setThreshold(threshold)
        end
    end
    methods (Access = protected) % Set functions
        function setThreshold(m, threshold)
            % SETTHRESHOLD sets the measure value of the group
            %
            % SETTHRESHOLD(M, THRESHOLD) sets the measure value of 
            % the group.
            % 
            % See also getThreshold.
            
            m.threshold = threshold;
        end
    end
    methods  % Get functions
        function threshold = getThreshold(m)
            % GETTHRESHOLD returns the threshold of the data values
            %
            % THRESHOLD = GETTHRESHOLD(M) returns the threshold of the data values.
            %
            % See also getMeasureValue.
            
            threshold = m.threshold;
        end
    end
    methods (Static)  % Descriptive functions
        function class = getClass()
            % GETCLASS returns the class of structural measurement BUT
            %
            % ANALYSIS_CLASS = GETCLASS(ANALYSIS) returns the class of 
            % measurement. In this case 'MeasurementST_BUT'.
            %
            % See also getList, getName, getDescription.
            
            class = 'MeasurementST_BUT';
        end
        function name = getName()
            % GETNAME returns the name of structural measurement BUT
            %
            % NAME = GETNAME() returns the name, Measurement ST BUT.
            %
            % See also getList, getClass, getDescription.
            
            name = 'Measurement ST BUT';
        end
        function description = getDescription()
            % GETDESCRIPTION returns the description of structural measurement
            %
            % DESCRIPTION = GETDESCRIPTION() returns the description
            % of MeasurementST_BUT.
            %
            % See also getList, getClass, getName
            
            description = [ ...
                'ST measurement with structural data using binary graphs ' ...
                'calculated at a fixed threshold. ' ...
                'For example, it can use MRI or PET data.' ...
                ];
        end
        function analysis_class = getAnalysisClass()
            % GETANALYSISCLASS returns the class of the analsysis 
            %
            % ANALYSIS_CLASS = GETANALYSISCLASS() returns the class of the
            % analysis the measurement is part of, 'AnalysisST_BUT'.
            %
            % See also getClass, getName, getDescription.
            
            analysis_class = 'AnalysisST_BUT';
        end     
    end
end 