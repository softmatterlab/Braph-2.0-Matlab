%% ¡header!
PPGraphA < PlotProp (pl, plot property of graph A) is a plot of graph A.

%%% ¡description!
PPGraphA plots a Analyze Group graph table.

%%% ¡seealso!
GUI, PlotElement, PlotProp, AnalyzeGroup, AnalyzeGroup_ST_WU, AnalyzeGroup_ST_BUT, AnalyzeGroup_ST_BUD

%% ¡properties!
pp
table_value_cell

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
    value = el.getr(prop);
    layer_to_plot = 1;
    if el.getPropCategory(prop) == Category.RESULT && isa(value, 'NoValue')
        %
    else
        value_cell = el.get(prop);
        if isempty(pl.table_value_cell)
            pl.table_value_cell = cell(size(value_cell));
        end
        for i = 1:1:1 % because its only diagonal
            for j = 1:1:size(pl.table_value_cell, 2)
                if isempty(pl.table_value_cell{i, j}) || ~isgraphics(pl.table_value_cell{i, j}, 'uitable')
                    pl.table_value_cell{i, j} = uitable('Parent', pl.pp);
                end
                set(pl.table_value_cell{i, j}, ...
                    'Data', value_cell{j, j}, ...  % diagonal will advance with j values
                    'Tooltip', [num2str(el.getPropProp(prop)) ' ' el.getPropDescription(prop)], ...
                    'CellEditCallback', {@cb_matrix_value, i, j} ...
                    )
            end
        end
        
        ui_layer_edit  = uicontrol('Parent', pl.pp, 'Style', 'Edit');
        ui_adj_matrix = uicontrol('Parent', pl.pp, 'Style', 'pushbutton');
        init_adj_area()           
    end
    
    % functions
    function init_adj_area()
        set(ui_layer_edit, ...            
            'Units', 'normalized', ...
            'Tooltip', 'Select the Graph Layer to be Plotted. Value set to 1 if Unilayer.', ...
            'String', '1', ...
            'Position', [.01 .02 .3 .08], ...
            'Tooltip', 'Choose a layer number', ...
            'Callback', {@cb_adj_layer} ...
            );
        if Graph.is_graph(el)
            set(ui_layer_edit, ...
                'Enable', 'off' ...
                )
        else
            set(ui_layer_edit, ...
                'Enable', 'on' ...
                )
        end
        set(ui_adj_matrix, ... 
            'String', 'Adjacency Matrix Plot', ...
            'Tooltip', 'Plot the Adjacency Matrix of the Graph', ...
            'Units', 'normalized', ...
            'Position', [.32 .02 .3 .08], ...
            'Callback', {@cb_adj_matrix} ...
            );
    end
    function cb_adj_layer(source, ~)
        layer_to_plot = str2double(source.String);
    end
    function cb_adj_matrix(~, ~)
        A = el.get('A');
        
        [~, normalized] = get_figure_position();
        x2 = normalized(1) + normalized(3);
        h2 = normalized(4);
        y2 = normalized(2);
        w2 = normalized(3) * 1.61;
        
        adj_matrix_figure = figure( ...
            'Visible', 'on', ...
            'NumberTitle', 'off', ...
            'Name', ['Adjacency Matrix - ' BRAPH2.STR], ...
            'Units', 'normalized', ...
            'Position', [x2 y2 w2 h2], ...
            'MenuBar', 'none', ...
            'Toolbar', 'figure', ...
            'Color', 'w' ...
            );        
        set_icon(adj_matrix_figure);
        
        ui_toolbar = findall(adj_matrix_figure, 'Tag', 'FigureToolBar');
        
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
        
        % if ... how to know which plot?
        handle_plot = plotw(A{layer_to_plot});
        % else
        % handle_plot = plotb(A{layer_to_plot});
        % end
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
    function h = plotw(A, varargin)
        % PLOTW plots a weighted matrix
        %
        % H = PLOTW(A) plots the weighted matrix A and returns the handle to
        %   the plot H.
        %
        % H = PLOTW(A,'PropertyName',PropertyValue) sets the property of the
        %   matrix plot PropertyName to PropertyValue.
        %   All standard plot properties of surf can be used.
        %   Additional admissive properties are:
        %       xlabels   -   1:1:number of matrix elements (default)
        %       ylabels   -   1:1:number of matrix elements (default)
        %
        % See also Graph, plotb, surf.
        
        N = length(A);
        
        % x labels
        xlabels = (1:1:N);
        for n = 1:2:length(varargin)
            if strcmpi(varargin{n}, 'xlabels')
                xlabels = varargin{n + 1};
            end
        end
        if ~iscell(xlabels)
            xlabels = {xlabels};
        end
        
        % y labels
        ylabels = (1:1:N);
        for n = 1:2:length(varargin)
            if strcmpi(varargin{n}, 'ylabels')
                ylabels = varargin{n + 1};
            end
        end
        if ~iscell(ylabels)
            ylabels = {ylabels};
        end
        
        ht = surf((0:1:N), ...
            (0:1:N), ...
            [A, zeros(size(A, 1), 1); zeros(1, size(A, 1) + 1)]);
        view(2)
        shading flat
        axis equal square tight
        grid off
        box on
        set(gca, ...
            'XAxisLocation', 'top', ...
            'XTick', (1:1:N) - .5, ...
            'XTickLabel', {}, ...
            'YAxisLocation', 'left', ...
            'YDir', 'Reverse', ...
            'YTick', (1:1:N) - .5, ...
            'YTickLabel', ylabels)
        
        if ~verLessThan('matlab', '8.4.0')
            set(gca, ...
                'XTickLabelRotation', 90, ...
                'XTickLabel', xlabels)
        else
            t = text((1:1:N) - .5, zeros(1, N), xlabels);
            set(t, ...
                'HorizontalAlignment', 'left', ...
                'VerticalAlignment', 'middle', ...
                'Rotation', 90);
        end
        
        colormap jet
        
        % output if needed
        if nargout > 0
            h = ht;
        end
    end
    function h = plotb(A, varargin)
        % PLOTB plots a binary matrix
        %
        % H = PLOTB(A) plots the binarized version of weighted matrix A and
        %   returns the handle to the plot H.
        %   The matrix A can be binarized by fixing the threshold
        %   (default, threshold = 0.5).
        %
        % H = PLOTB(A, 'PropertyName', PropertyValue) sets the property of the
        %   matrix plot PropertyName to PropertyValue.
        %   All standard plot properties of surf can be used.
        %   Additional admissive properties are:
        %       threshold   -   0.5 (default)
        %       xlabels     -   1:1:number of matrix elements (default)
        %       ylabels     -   1:1:number of matrix elements (default)
        %
        % See also Graph, binarize, plotw, surf.
        
        N = length(A);
        
        % threshold
        threshold = get_from_varargin(0, 'threshold', varargin{:});
        
        % density
        density = get_from_varargin([], 'density', varargin{:});
        
        % x labels
        xlabels = (1:1:N);
        for n = 1:2:length(varargin)
            if strcmpi(varargin{n}, 'xlabels')
                xlabels = varargin{n + 1};
            end
        end
        if ~iscell(xlabels)
            xlabels = {xlabels};
        end
        
        % y labels
        ylabels = (1:1:N);
        for n = 1:2:length(varargin)
            if strcmpi(varargin{n}, 'ylabels')
                ylabels = varargin{n + 1};
            end
        end
        if ~iscell(ylabels)
            ylabels = {ylabels};
        end
        
        B = binarize(A, 'threshold', threshold, 'density', density);
        
        ht = surf((0:1:N), ...
            (0:1:N), ...
            [B, zeros(size(B, 1), 1); zeros(1, size(B, 1) + 1)]);
        view(2)
        shading flat
        axis equal square tight
        grid off
        box on
        set(gca, ...
            'XAxisLocation', 'top',  ...
            'XTick', (1:1:N) - .5, ...
            'XTickLabel', {},  ...
            'YAxisLocation', 'left',  ...
            'YDir', 'Reverse',  ...
            'YTick', (1:1:N) - .5, ...
            'YTickLabel', ylabels)
        
        if ~verLessThan('matlab',  '8.4.0')
            set(gca, ...
                'XTickLabelRotation',90, ...
                'XTickLabel', xlabels)
        else
            t = text((1:1:N) - .5, zeros(1,N), xlabels);
            set(t, ...
                'HorizontalAlignment', 'left',  ...
                'VerticalAlignment', 'middle',  ...
                'Rotation',90);
        end
        
        colormap bone
        
        % output if needed
        if nargout > 0
            h = ht;
        end
    end
    % callback
    function cb_matrix_value(src, event, i, j)
        value = el.get(prop);
        value_ij = value{i, j};
        value_ij(event.Indices(1), event.Indices(2)) = event.NewData;
        value{i, j} = value_ij;
        el.set(prop, value)
        
        pl.update()
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
        
        for i = 1:1:1  % same as update
            for j = 1:1:size(value_cell, 2)
                set(pl.table_value_cell{i, j}, ...
                    'Units', 'character', ...
                    'Position', ...
                    [ ...
                    (0.01 + (i - 1) * 0.98 / size(pl.table_value_cell, 1)) * Plot.w(pl.pp) ...
                    (0.2 + (j - 1) * 0.8 / size(pl.table_value_cell, 2)) * (Plot.h(pl.pp) - 1.8) ...
                    0.98 / 1 * Plot.w(pl.pp) ...
                    0.8 / size(pl.table_value_cell, 2) * (Plot.h(pl.pp) - 1.8) ...
                    ] ...
                    )
            end
        end
    end
end