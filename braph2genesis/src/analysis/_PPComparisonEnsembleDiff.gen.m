%% ¡header!
PPComparisonEnsembleDiff < PlotProp (pl, plot property of comparison ensemble difference) is a plot of comparison ensemble difference.

%%% ¡description!
PPComparisonEnsembleDiff plots a Compairson Ensemble difference.

%%% ¡seealso!
GUI, PlotElement, PlotProp, CompareEnsemble, ComparisonEnsemble.

%% ¡properties!
pp
comparison_tbl

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

    pl.pp = draw@PlotProp(pl, varargin{:});
    
    if isempty(pl.comparison_tbl)
        pl.comparison_tbl = uitable('Parent', pl.pp);
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

    el = pl.get('EL');
    prop = pl.get('PROP');
    value = el.getr(prop);
    compare_ensemble = el.get('C');
    graph = compare_ensemble.get('A1').get('G_DICT').getItem(1);
    node1_to_plot = 1;
    node2_to_plot = 1;
    node_labels = [];
    x_range = 1:10;
    m = el.get('MEASURE');    
    node_labels_tmp = graph.get('BRAINATLAS').get('BR_DICT');    
    node_labels = cellfun(@(x) x.get('ID') , node_labels_tmp.getItems(), 'UniformOutput', false); 
    
    if el.getPropCategory(prop) == Category.RESULT && isa(value, 'NoValue')
        % do nothing
    elseif isa(graph, 'MultigraphBUD') || isa(graph, 'MultigraphBUT')

        if isa(graph, 'MultigraphBUD')
            x_range = graph.get('DENSITIES');
            x_name = 'Densities';
        else
            x_range = graph.get('THRESHOLDS');
            x_name = 'Thresholds';
        end
        
        if Measure.is_global(m) % global
            node_labels = 'Global';
            for k = 1:size(value, 1)
                row_names{k} = ['Layer ' num2str(k)]; %#ok<AGROW>
            end
        elseif Measure.is_nodal(m) % nodal
            for k = 1:size(value, 1)
                row_names{k} = ['Layer ' num2str(k)]; %#ok<AGROW>
            end
            
        else  % binodal
            current_layer = 1;
            count = 1;
            for k = 1:size(value{1}, 1)*size(value, 1)
                if count > size(value{1}, 1)
                    current_layer = current_layer + 1;
                    count = 0;
                end
                row_names{k} = ['Layer ' num2str(current_layer)]; %#ok<AGROW>
                count = count + 1;
            end
        end
        
        value_double =  cell2mat(cellfun(@(x) x', value, 'UniformOutput', false));
        set(pl.comparison_tbl, ...
            'Data', value_double, ...
            'Tooltip', [num2str(el.getPropProp(prop)) ' ' el.getPropDescription(prop)], ...
            'Units', 'normalized', ...
            'Position', [.01 .15 .98 .75], ...
            'ColumnName', node_labels, ...
            'RowName', row_names, ...
            'CellEditCallback', {@cb_matrix_value} ...
            )
        ui_node1_popmenu  = uicontrol('Parent', pl.pp, 'Style', 'popupmenu');
        ui_node2_popmenu  = uicontrol('Parent', pl.pp, 'Style', 'popupmenu');
        ui_measure_plot = uicontrol('Parent', pl.pp, 'Style', 'pushbutton');
        init_measure_plot_area()
        
    else
        % paint a normal cell tables
        value_cell = el.get(prop);
        value_double = cell2mat(cellfun(@(x) x', value_cell, 'UniformOutput', false));
        set(pl.comparison_tbl, ...
            'Data', value_double, ...
            'Tooltip', [num2str(el.getPropProp(prop)) ' ' el.getPropDescription(prop)], ...
            'Units', 'normalized', ...
            'Position', [.01 .2 .98 .8], ...
            'ColumnName', node_labels, ...
            'CellEditCallback', {@cb_matrix_value} ...
            )
    end
    
    % functions
    function init_measure_plot_area()
        set(ui_node1_popmenu, ...
            'Units', 'normalized', ...
            'Tooltip', 'Select the Node to be Plotted.', ...
            'String', node_labels, ...
            'Position', [.01 .02 .3 .08], ...
            'Callback', {@cb_node_1} ...
            );
        set(ui_node2_popmenu, ...
            'Units', 'normalized', ...
            'Tooltip', 'Select the Node to be Plotted.', ...
            'String', node_labels, ...
            'Position', [.32 .02 .3 .08], ...
            'Callback', {@cb_node_2} ...
            );
        
        set(ui_measure_plot, ...
            'String', 'Measure Plot', ...
            'Tooltip', 'Plot the Measure. Will plot depending on the node selection.', ...
            'Units', 'normalized', ...
            'Position', [.63 .02 .3 .08], ...
            'Callback', {@cb_plot_m} ...
            );
        
        rules_node_popmenu_deactivation()
    end
    function rules_node_popmenu_deactivation()
        if Measure.is_global(m)
            set(ui_node1_popmenu, ...
                'Visible', 'off', ...
                'Enable', 'off' ...
                )
            set(ui_node2_popmenu, ...
                'Visible', 'off', ...
                'Enable', 'off' ...
                )
        elseif Measure.is_nodal(m)
            set(ui_node1_popmenu, ...
                'Visible', 'on', ...
                'Enable', 'on' ...
                )
            set(ui_node2_popmenu, ...
                'Visible', 'off', ...
                'Enable', 'off' ...
                )
        else
            set(ui_node1_popmenu, ...
                'Visible', 'on', ...
                'Enable', 'on' ...
                )
            set(ui_node2_popmenu, ...
                'Visible', 'on', ...
                'Enable', 'on' ...
                )
        end
    end
    function cb_node_1(source, ~)
        node1_to_plot = double(source.Value);
    end
    function cb_node_2(source, ~)
        node2_to_plot = double(source.Value);
    end
    function cb_plot_m(~, ~)
        plot_value = value;
        x_label = graph.get('NODELABELS');
        y_name = m;
        title_plot = [y_name ' vs ' x_name];
        cil = el.memorize('CIL');
        ciu = el.memorize('CIU');
        
        if Measure.is_global(m) % global
            is_inf_vector = cellfun(@(x) isinf(x), plot_value);
            if any(is_inf_vector)
                return;
            end
            y_ = [plot_value{:}];
        elseif Measure.is_nodal(m) % nodal
            for l = 1:length(plot_value)
                tmp = plot_value{l};
                tmp_y = tmp(node1_to_plot);
                if isinf(tmp_y)
                    return;
                end
                y_(l) = tmp_y; %#ok<AGROW>
            end
        else  % binodal
            for l = 1:length(plot_value)
                tmp = plot_value{l};
                tmp_y = tmp(node1_to_plot, node2_to_plot);
                if isinf(tmp_y)
                    return;
                end
                y_(l) = tmp_y; %#ok<AGROW>
            end
        end
        
        x_ = x_range;
        
        [~, normalized] = get_figure_position();
        x2 = normalized(1) + normalized(3);
        h2 = normalized(4);
        y2 = normalized(2);
        w2 = normalized(3) * 1.61;
        
        plot_figure = figure( ...
            'Visible', 'on', ...
            'NumberTitle', 'off', ...
            'Name', ['Plot of Measure - ' BRAPH2.STR], ...
            'Units', 'normalized', ...
            'Position', [x2 y2 w2 h2], ...
            'MenuBar', 'none', ...
            'Toolbar', 'figure', ...
            'Color', 'w' ...
            );
        h_axes = axes(plot_figure);
        set_icon(plot_figure);
        ui_toolbar = findall(plot_figure, 'Tag', 'FigureToolBar');
        delete(findall(ui_toolbar, 'Tag', 'Standard.NewFigure'))
        delete(findall(ui_toolbar, 'Tag', 'Standard.FileOpen'))
        delete(findall(ui_toolbar, 'Tag', 'Standard.SaveFigure'))
        delete(findall(ui_toolbar, 'Tag', 'Standard.PrintFigure'))
        delete(findall(ui_toolbar, 'Tag', 'Standard.EditPlot'))
        delete(findall(ui_toolbar, 'Tag', 'Standard.OpenInspector'))
        delete(findall(ui_toolbar, 'Tag', 'Exploration.Brushing'))
        delete(findall(ui_toolbar, 'Tag', 'DataManager.Linking'))
        delete(findall(ui_toolbar, 'Tag', 'Annotation.InsertColorbar'))
        delete(findall(ui_toolbar, 'Tag', 'Annotation.InsertLegend'))
        delete(findall(ui_toolbar, 'Tag', 'Plottools.PlottoolsOff'))
        delete(findall(ui_toolbar, 'Tag', 'Plottools.PlottoolsOn'))
        
        if ~isempty(x_) && ~isempty(y_)
            
            handle_plot = plot(h_axes, ...
                x_, ...
                y_, ...
                'Marker', 'o', ...
                'MarkerSize', 10, ...
                'MarkerEdgeColor', [0 0 1], ...
                'MarkerFaceColor', [.9 .4 .1], ...
                'LineStyle', '-', ...
                'LineWidth', 1, ...
                'Color', [0 0 1]);
            title(title_plot)
            xlabel(x_name)
            ylabel(y_name)
        else
        end
        
        hold(h_axes, 'on')
        xlabel(h_axes, x_label)
        ylabel(h_axes, m.getClass())
        
        ui_confidence_interval_min_checkbox = uicontrol(f, 'Style', 'checkbox', 'Units', 'normalized');
        ui_confidence_interval_max_checkbox = uicontrol(f, 'Style', 'checkbox', 'Units', 'normalized');
        init_plot_panel()
        function init_plot_panel()
            set(ui_confidence_interval_min_checkbox, 'Position', [.02 .06 .25 .05]);
            set(ui_confidence_interval_min_checkbox, 'String', 'Show Confidence Interval Min');
            set(ui_confidence_interval_min_checkbox, 'Value', false);
            set(ui_confidence_interval_min_checkbox, 'Callback', {@cb_show_confidence_interval_min})
            
            set(ui_confidence_interval_max_checkbox, 'Position', [.02 .01 .25 .05]);
            set(ui_confidence_interval_max_checkbox, 'String', 'Show Confidence Interval Max');
            set(ui_confidence_interval_max_checkbox, 'Value', false);
            set(ui_confidence_interval_max_checkbox, 'Callback', {@cb_show_confidence_interval_max})
        end
        
        h_p_min = [];
        h_p_max = [];
        function cb_show_confidence_interval_min(src, ~)
            if src.Value == true
                
                y_ = cil;
                x_ = x_range;
                h_p_min = plot(h_axes, ...
                    x_, ...
                    y_, ...
                    'Marker', 'x', ...
                    'MarkerSize', 10, ...
                    'MarkerEdgeColor', [0 0 1], ...
                    'MarkerFaceColor', [.3 .4 .5], ...
                    'LineStyle', '-', ...
                    'LineWidth', 1, ...
                    'Color', [0 1 1]);
                h_p_min.Visible = true;
            else
                h_p_min.Visible = false;
            end
        end
        function cb_show_confidence_interval_max(src, ~)
            if src.Value == true
                
                y_ = ciu;
                x_ = x_range;
                h_p_max = plot(h_axes, ...
                    x_, ...
                    y_, ...
                    'Marker', 'x', ...
                    'MarkerSize', 10, ...
                    'MarkerEdgeColor', [0 0 1], ...
                    'MarkerFaceColor', [.3 .4 .5], ...
                    'LineStyle', '-', ...
                    'LineWidth', 1, ...
                    'Color', [0 1 1]);
                h_p_max.Visible = true;
            else
                h_p_max.Visible = false;
            end
        end
    end
    function [pixels, normalized] = get_figure_position()
        fig_h = getGUIFigureObj();
        set(fig_h, 'Units', 'normalized'); % set it to get position on normal units
        pixels = getpixelposition(fig_h);
        normalized = get(fig_h, 'Position');
        set(fig_h, 'Units', 'characters'); % go back
    end
    function obj = getGUIFigureObj()
        figHandles = findobj('Type', 'figure');
        for i = 1:1:length(figHandles)
            fig_h = figHandles(i);
            if contains(fig_h.Name, el.getClass())
                obj = fig_h;
            end
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

    el = pl.get('EL');
    prop = pl.get('PROP');
    
    value = el.getr(prop);
    if el.getPropCategory(prop) == Category.RESULT && isa(value, 'NoValue')
        pl.redraw@PlotProp('Height', 1.8, varargin{:})
    else
        value_cell = el.get(prop);
        
        if isempty(value_cell)
            pl.redraw@PlotProp('Height', 1.8, varargin{:})
        else
            pl.redraw@PlotProp('Height', 30, varargin{:})
        end
        
    end
end
