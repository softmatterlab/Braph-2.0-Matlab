%% ¡header!
PPAnalyzeEnsembleMeasure < PlotProp (pl, plot property of analyze ensemble measure) is a plot of analyze ensemble measure.

%%% ¡description!
PPAnalyzeEnsembleMeasure plots a Analyze Ensemble Measure table.

%%% ¡seealso!
GUI, PlotElement, PlotProp, AnalyzeEnsemble, PPAnalyzeEnsembleGraph.

%% ¡properties!
pp
measure_tbl
selected

%% ¡methods!
function h_panel = draw(pl, varargin)
    %DRAW draws the idict for group ensemble property graphical panel.
    %
    % DRAW(PL) draws the idict property graphical panel.
    %
    % H = DRAW(PL) returns a handle to the idict property graphical panel.
    %
    % DRAW(PL, 'Property', VALUE, ...) sets the properties of the graphical
    %  panel with custom property-value couples.
    %  All standard plot properties of uipanel can be used.
    %
    % It is possible to access the properties of the various graphical
    %  objects from the handle to the brain surface graphical panel H.
    %
    % see also update, redraw, refresh, settings, uipanel, isgraphics.

    el = pl.get('EL');
    prop = pl.get('PROP');
    pl.selected = [];
    graph_dict = el.get('G_DICT'); 
    if isa(graph_dict, 'NoValue')
        graph_dict = el.getPropDefault('G_DICT');
    end
    measures_guis = [];
    analysis_type = [];
    mlist = [];

    pl.pp = draw@PlotProp(pl, varargin{:});
    set(pl.pp, 'DeleteFcn', {@close_f_settings}, ...
        varargin{:})
    
    function close_f_settings(~,~)
        if ~isempty(measures_guis)
            for k = 1:length(measures_guis)                
                m_gui_h = measures_guis{k};
                if isgraphics(m_gui_h)
                    close(m_gui_h)
                end
            end
        end        
    end

    if isempty(pl.measure_tbl) || ~isgraphics(pl.measure_tbl, 'uitable')
        graph = get_selected_graph();
        
        pl.measure_tbl = uitable();
        set( pl.measure_tbl, ...
            'Parent', pl.pp, ...
            'Units', 'normalized', ...
            'Position', [.02 .15 .95 .7], ...
            'ColumnName', {'', 'Measure', 'Shape', 'Scope', 'Notes'}, ...
            'ColumnFormat', {'logical', 'char', 'char', 'char', 'char'}, ...
            'Tooltip', [num2str(el.getPropProp(prop)) ' ' el.getPropDescription(prop)], ...
            'ColumnEditable', [true false false false false], ...
            'CellEditCallback', {@cb_measure_selection} ...
            )            
        
        % get compatible measures for specific graph
        
        mlist = Graph.getCompatibleMeasureList(graph);
        if ~isa(graph, 'Graph')
            [~, normalized] = get_figure_position();
            data = cell(length(mlist), 5);
            for mi = 1:1:length(mlist)
                if any(pl.selected == mi)
                    data{mi, 1} = true;
                else
                    data{mi, 1} = false;
                end
                data{mi, 2} = mlist{mi};
                if Measure.is_nodal(mlist{mi})
                    data{mi, 3} = 'NODAL';
                elseif Measure.is_global(mlist{mi})
                    data{mi, 3} = 'GLOBAL';
                else
                    data{mi, 3} = 'BINODAL';
                end
                
                if Measure.is_superglobal(mlist{mi})
                    data{mi, 4} = 'SUPERGLOBAL';
                elseif Measure.is_unilayer(mlist{mi})
                    data{mi, 4} = 'UNILAYER';
                else
                    data{mi, 4} = 'BILAYER';
                end
                
                data{mi, 5} = eval([mlist{mi} '.getDescription()']);
            end
            set(pl.measure_tbl, 'Data', data)
            set(pl.measure_tbl, 'ColumnWidth', ['auto' 'auto' 'auto' 'auto' normalized(3)*.9*.3])
        end
    end
    
    ui_button_table_update = uicontrol(pl.pp, 'Style', 'pushbutton', 'Units', 'normalized');
    ui_button_table_calculate = uicontrol(pl.pp, 'Style', 'pushbutton', 'Units', 'normalized');
    ui_button_table_selectall = uicontrol(pl.pp, 'Style', 'pushbutton', 'Units', 'normalized');
    ui_button_table_clearselection = uicontrol(pl.pp, 'Style', 'pushbutton', 'Units', 'normalized');    
    
    init_buttons()
        function init_buttons()         
            set(ui_button_table_update, ...
                'Position', [0 0 0 0], ...
                'Visible', 'off', ...
                'Callback', {@cb_measures_update})
            
            set(ui_button_table_calculate, ...
                'Position', [.02 .01 .3 .07], ...
                'String', 'Calculate Measures', ...
                'TooltipString', 'Calculate Selected Measures', ...
                'Callback', {@cb_table_calculate})

            set(ui_button_table_selectall, ...
                'Position', [.34 .01 .3 .07], ...
                'String', 'Select All', ...
                'TooltipString', 'Select all measures', ...
                'Callback', {@cb_table_selectall})

            set(ui_button_table_clearselection, ...
                'Position', [.66 .01 .3 .07], ...
                'String', 'Clear All', ...
                'TooltipString', 'Clear selection', ...
                'Callback', {@cb_table_clearselection})
        end
        function cb_measure_selection(~, event)
            i = event.Indices(1);
            col = event.Indices(2);
            newdata = event.NewData;
            switch col
                case 1
                    if newdata == 1
                        pl.selected = sort(unique([pl.selected(:); i]));
                    else
                        pl.selected = pl.selected(pl.selected ~= i);
                    end
                otherwise
            end
            pl.update()            
        end
        function cb_table_selectall(~, ~)  % (src, event)            
            pl.selected = (1:1:length(mlist))';
            pl.update()
        end
        function cb_table_clearselection(~, ~)  % (src, event)            
            pl.selected = [];
            pl.update()
        end
        function cb_table_calculate(~, ~)
            mlist = Graph.getCompatibleMeasureList(graph);
            calculate_measure_list = mlist(pl.selected);
            g_dict = el.memorize('G_DICT');
            
            % calculate
            f = waitbar(0, ['Calculating ' num2str(length(calculate_measure_list))  ' measures ensemble ...'], 'Name', BRAPH2.NAME);
            set_icon(f)

            n = length(calculate_measure_list);
            for j = 1:n
                progress = (.85 * i )/ n;   
                extra = progress * 1.1;
                measure = calculate_measure_list{j};
                waitbar(progress, f, ['Measure: ' measure '  ...']);
                result_measure{j} = el.getMeasureEnsemble(measure); %#ok<AGROW>
                
                %precalculte
                el.getMeasureEnsemble(measure).memorize('M');
                
                waitbar(extra, f, ['Measure: ' measure ' Calculated! ...']);
            end
            
            [~, normalized] = get_figure_position();
            % create window for results            
            % golden ratio is defined as a+b/a = a/b = phi. phi = 1.61
            x2 = normalized(1) + normalized(3);
            h2 = normalized(4);
            y2 = normalized(2);
            w2 = normalized(3) * 1.61;            
            
            waitbar(.95, f, 'Plotting the Measures GUI ...') 
            for j = 1:length(result_measure)              
                offset = 0.02 * (j - 1);
                if offset > .45 
                    offset = 0;
                end
                measure = result_measure{j};
                GUI(measure, 'CloseRequest', false, 'POSITION', [x2+offset y2-offset w2 h2]);
            end

            % close progress bar
            if exist('f', 'var')
                waitbar(1, f, 'Finishing')
                pause(.5)
                close(f)
            end 
            measures_guis = get_measure_guis();                   
        end
        function [pixels, normalized] = get_figure_position()
            fig_h = getGUIFigureObj();
            set(fig_h, 'Units', 'normalized'); % set it to get position on normal units
            pixels = getpixelposition(fig_h);
            normalized = get(fig_h, 'Position');
            set(fig_h, 'Units', 'characters'); % go back
        end
        function obj = getGUIFigureObj()
            obj = get_handle_objs('figure', 'AnalyzeEnsemble');
        end
        function graph = get_selected_graph()
            if isa(graph_dict, 'NoValue')
                graph_dict = el.getPropDefault('G_DICT');
            end
            graph = graph_dict.getItem(1);
        end
        function guis = get_measure_guis()
            guis = get_handle_objs('figure', [], 'MeasureEnsemble');
        end
        function cb_measures_update(~, ~)
            pl.update();
        end
        
    % output
    if nargout > 0
        h_panel = pl.pp;
    end
end
function update(pl)
    %UPDATE updates the content of the property graphical panel.
    %
    % UPDATE(PL) updates the content of the property graphical panel.
    %
    % See also draw, redraw, refresh.

    update@PlotProp(pl)

    el = pl.get('EL');
    prop = pl.get('PROP');
    graph_dict = el.get('G_DICT');
    graph = graph_dict.getItem(1);
    
    function [pixels, normalized] = get_figure_position()
        fig_h = getGUIFigureObj();
        set(fig_h, 'Units', 'normalized'); % set it to get position on normal units
        pixels = getpixelposition(fig_h);
        normalized = get(fig_h, 'Position');
        set(fig_h, 'Units', 'characters'); % go back
    end
    function obj = getGUIFigureObj()
        obj = get_handle_objs('figure', 'AnalyzeEnsemble');
    end

    if isa(graph, 'NoValue')
        %
    else
        % construct a data holder
        if isa(graph, 'Graph')  
            [parent_position_pixels, ~] = get_figure_position();
            mlist = Graph.getCompatibleMeasureList(graph);
            data = cell(length(mlist), 5);
            for mi = 1:1:length(mlist)
                if any(pl.selected == mi)
                    data{mi, 1} = true;
                else
                    data{mi, 1} = false;
                end
                data{mi, 2} = mlist{mi};
                if Measure.is_nodal(mlist{mi})
                    data{mi, 3} = 'NODAL';
                elseif Measure.is_global(mlist{mi})
                    data{mi, 3} = 'GLOBAL';
                else
                    data{mi, 3} = 'BINODAL';
                end
                
                if Measure.is_superglobal(mlist{mi})
                    data{mi, 4} = 'SUPERGLOBAL';
                elseif Measure.is_unilayer(mlist{mi})
                    data{mi, 4} = 'UNILAYER';
                else
                    data{mi, 4} = 'BILAYER';
                end
                
                data{mi, 5} = eval([mlist{mi} '.getDescription()']);
            end            

            set(pl.measure_tbl, ...
                'Data', data, ...
                'Tooltip', [num2str(el.getPropProp(prop)) ' ' el.getPropDescription(prop)] ...
                )
            set(pl.measure_tbl, 'ColumnWidth', {'auto', 'auto', 'auto', 'auto', parent_position_pixels(3)})
        end

    end
end
function redraw(pl, varargin)
    %REDRAW redraws the element graphical panel.
    %
    % REDRAW(PL) redraws the plot PL.
    %
    % REDRAW(PL, 'Height', HEIGHT) sets the height of PL (by default HEIGHT=3.3).
    %
    % See also draw, update, refresh.

    pl.redraw@PlotProp('Height', 30, varargin{:});
end
function selected = getSelected(pl)
    selected = pl.selected;
end