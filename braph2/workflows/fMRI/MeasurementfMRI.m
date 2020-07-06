classdef MeasurementfMRI < Measurement
    % single group of fMRI subjects
    properties
        values  % array with the values of the measure for each subject
        average_value  % average value of the group
    end
    methods  % Constructor
        function m =  MeasurementfMRI(id, label, notes, atlas, measure_code, group, varargin)
            
            m = m@Measurement(id, label, notes, atlas, measure_code, group, varargin{:});
        end
    end
    methods  % Get functions
        function value = getMeasureValues(m)
            value = m.values;
        end
        function average_value = getGroupAverageValue(m)
            average_value = m.average_value;
        end
    end
    methods (Access=protected)
        function initialize_data(m, varargin)
            atlases = m.getBrainAtlases();
            atlas = atlases{1};
            
            measure_code = m.getMeasureCode();
            
            if Measure.is_global(measure_code)  % global measure
                m.values = get_from_varargin( ...
                    repmat({0}, 1, m.getGroup().subjectnumber()), ...
                    'MeasurementfMRI.values', ...
                    varargin{:});
                assert(iscell(m.getMeasureValues()) & ...
                    isequal(size(m.getMeasureValues()), [1, m.getGroup().subjectnumber]) & ...
                    all(cellfun(@(x) isequal(size(x), [1, 1]), m.getMeasureValues())), ...
                    [BRAPH2.STR ':MeasurementfMRI:' BRAPH2.WRONG_INPUT], ...
                    'Data not compatible with MeasurementfMRI')
                m.average_value = get_from_varargin( ...
                    0, ...
                    'MeasurementfMRI.average_value', ...
                    varargin{:});
                assert(isequal(size(m.getGroupAverageValue()), [1, 1]), ...  
                    [BRAPH2.STR ':MeasurementfMRI:' BRAPH2.WRONG_INPUT], ...
                    'Data not compatible with MeasurementfMRI') 
           
            elseif Measure.is_nodal(measure_code)  % nodal measure
                m.values = get_from_varargin( ...
                    repmat({zeros(atlas.getBrainRegions().length(), 1)}, 1, m.getGroup().subjectnumber()), ...
                    'MeasurementfMRI.values', ...
                    varargin{:});
                assert(iscell(m.getMeasureValues()) & ...
                    isequal(size(m.getMeasureValues()), [1, m.getGroup().subjectnumber]) & ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), 1]), m.getMeasureValues())), ...
                    [BRAPH2.STR ':MeasurementfMRI:' BRAPH2.WRONG_INPUT], ...
                    'Data not compatible with MeasurementfMRI') 
                
                m.average_value = get_from_varargin( ...
                    zeros(atlas.getBrainRegions().length(), 1), ...
                    'MeasurementfMRI.average_value', ...
                    varargin{:});
                assert(isequal(size(m.getGroupAverageValue()), [atlas.getBrainRegions().length(), 1]), ...
                    [BRAPH2.STR ':MeasurementfMRI:' BRAPH2.WRONG_INPUT], ...
                    'Data not compatible with MeasurementfMRI') 
            
            elseif Measure.is_binodal(measure_code)  % binodal measure
                m.values = get_from_varargin( ...
                    repmat({zeros(atlas.getBrainRegions().length())}, 1, m.getGroup().subjectnumber()), ...
                    'MeasurementfMRI.values', ...
                    varargin{:});
                assert(iscell(m.getMeasureValues()) & ...
                    isequal(size(m.getMeasureValues()), [1, m.getGroup().subjectnumber]) & ...
                    all(cellfun(@(x) isequal(size(x), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), m.getMeasureValues())), ...
                    [BRAPH2.STR ':MeasurementfMRI:' BRAPH2.WRONG_INPUT], ...
                    'Data not compatible with MeasurementfMRI')
                
                m.average_value = get_from_varargin( ...
                    zeros(atlas.getBrainRegions().length()), ...
                    'MeasurementfMRI.average_value', ...
                    varargin{:});
                assert(isequal(size(m.getGroupAverageValue()), [atlas.getBrainRegions().length(), atlas.getBrainRegions().length()]), ...
                    [BRAPH2.STR ':MeasurementfMRI:' BRAPH2.WRONG_INPUT], ...
                    'Data not compatible with MeasurementfMRI')
            end
        end
    end
    methods (Static)
        function class = getClass(m) %#ok<*INUSD>
            class = 'MeasurementfMRI';
        end
        function name = getName(m)
            name = 'Measurement fMRI';
        end
        function description = getDescription(m)
            description = 'fMRI measurement.';
        end
        function atlas_number = getBrainAtlasNumber(m)
            atlas_number =  1;
        end
        function analysis_class = getAnalysisClass(m)
            % measurement analysis class
            analysis_class = 'AnalysisfMRI';
        end
        function subject_class = getSubjectClass(m)
            % measurement subject class
            subject_class = 'SubjectfMRI';
        end
        function available_settings = getAvailableSettings()           
            available_settings = {};
        end
        function m = getMeasurement(measurement_class, id, label, notes, atlas, measure_code, group, varargin) 
            m = eval([measurement_class '(id, atlas, label, notes, measure_code, group, varargin{:})']);
        end
    end
end