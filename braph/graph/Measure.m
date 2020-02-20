classdef Measure < handle
    properties (GetAccess=protected, SetAccess=protected)
        g  % graph
        settings  % structure with the constructor varagin
        value  % graph measure value
        % scalar for global measures
        % column vector for nodal measures
    end
    methods (Access=protected)
        function m = Measure(g, varargin)
            
            if ~are_compatible(g, m)
                error( ...
                    'BRAPH:Measure:IncompatibleGM', ...
                    [class(g) ' is not compatible with ' class(m)] ...
                    )
            end
            
            settings = get_from_varargin(varargin, 'Settings', varargin{:});
            value = get_from_varargin([], 'Value', varargin{:});
            
            m.g = g;
            m.settings = settings;
            m.value = value;
        end
    end
    methods
        function str = tostring(m)
            str = [Measure.getClass(m) ' size:'  int2str(size(m.getValue(), 1)) ' x '  int2str(size(m.getValue(), 2))];
        end
        function disp(m)
            disp(['<a href="matlab:help ' Measure.getClass(m) '">' Measure.getClass(m) '</a>'])
            if m.is_value_calculated()
                disp([' value: ' int2str(size(m.getValue(), 1))  ' x ' int2str(size(m.getValue(), 2))])
            else
                disp(' value: not calculated yet')
            end
            disp(['graph: ' m.getGraph().tostring()]);
            disp([' settings']); %#ok<NBRAK>
            settings = m.getSettings(); %#ok<PROP>
            for i = 1:2:length(settings) %#ok<PROP>
                disp(['  ' settings{i} ' = ' tostring(settings{i+1})]); %#ok<PROP>
            end
        end
        function g = getGraph(m)
            g = m.g;
        end
        function res = getSettings(m, setting_code)
            
            if nargin<2
                res = m.settings;
            else
                res = get_from_varargin([], setting_code, m.settings{:});
            end
        end
        function bool = is_value_calculated(m)
            bool = ~isempty(m.value);
        end
        function value = getValue(m)
            
            if ~m.is_value_calculated()
                m.value = m.calculate();
            end
            
            value = m.value;
        end
    end
    methods (Abstract, Access=protected)
        calculate(m)  % calculates the value of the measure
    end
    methods (Static)
        function measure_list = getList()
            measure_list = subclasses( ...
                'Measure', ...
                [fileparts(which('Measure')) filesep 'measures'] ...
                );
        end
        function measure_class = getClass(m)
            % measure class (same as the measure object name)
            
            if isa(m, 'Measure')
                measure_class = class(m);
            else % g should be a string with the measure class
                measure_class = m;
            end
        end
        function name = getName(m)
            % measure name
            
            name = eval([Measure.getClass(m) '.getName()']);
        end
        function name = getDescription(m)
            % measure description
            
            name = eval([Measure.getClass(m) '.getDescription()']);
        end
        function bool = is_global(m)
            % whether is global measure
            
            bool = eval([Measure.getClass(m) '.is_global()']);
        end
        function bool = is_nodal(m)
            % whether is nodal measure
            
            bool = eval([Measure.getClass(m) '.is_nodal()']);
        end
        function bool = is_binodal(m)
            bool = eval([Measure.getClass(m) '.is_binodal()']);
        end
        function m = getMeasure(measure_code, g, varargin) %#ok<INUSD>
            m = eval([measure_code '(g, varargin{:})']);
        end
        function list = getCompatibleGraphList(m)
            % list of graphs with which measure works
            
            list = eval([Measure.getClass(m) '.getCompatibleGraphList()']);
        end
        function n = getCompatibleGraphNumber(m)
            % number of graphs with which measure works
            
            list = Measure.getCompatibleGraphList(m);
            n = numel(list);
        end
    end
end
