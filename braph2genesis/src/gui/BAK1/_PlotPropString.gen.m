%% ¡header!
PlotPropString < PlotProp (pl, plot property string) is a plot of a property string.

%%% ¡description!
PlotProp plots a property string of an element in a panel.

%%% ¡seealso!
GUI, PlotElement, PlotProp

%% ¡properties!
edit_value

%% ¡methods!
function h_panel = draw(pl, varargin)
    %DRAW draws the string property graphical panel.
    %
    % DRAW(PL) draws the string property graphical panel.
    %
    % H = DRAW(PL) returns a handle to the string property graphical panel.
    %
    % DRAW(PL, 'Property', VALUE, ...) sets the properties of the graphical
    %  panel with custom property-value couples.
    %  All standard plot properties of uipanel can be used.
    %
    % It is possible to access the properties of the various graphical
    %  objects from the handle to the brain surface graphical panel H.
    %
    % see also resize, settings, uipanel, isgraphics.

    el = pl.get('EL');
    prop = pl.get('PROP');
    
    pp = draw@PlotProp(pl, varargin{:});
    
    if isempty(pl.edit_value) || ~isgraphics(pl.edit_value, 'edit')
        pl.edit_value = uicontrol( ...
                'Style', 'edit', ...
                'Parent', pp ...
                );
    end

    % output
    if nargout > 0
        h_panel = pp;
    end
end
function resize(pl)
    %RESIZE resizes the element graphical panel.
    %
    % RESIZE(PL) resizes the plot PL.
    %
    % See also draw.

    resize@PlotProp(pl)
    
    el = pl.get('EL');
    prop = pl.get('PROP');
    
    pp = get(pl.edit_value, 'Parent');

    % resize
    set(pp, 'Position', [x0(pp) y0(pp) w(pp) 3])
    
    set(pl.edit_value, ...
        'Units', 'normalized', ...
        'Position', [.01 .10 .98 .50], ...
        'HorizontalAlignment', 'left', ...
        'BackgroundColor', 'w', ...
        'Tooltip', [num2str(el.getPropProp(prop)) ' ' el.getPropDescription(prop)], ...
        'Callback', {@cb_edit_value} ...
        )
    
    % callback function
    function cb_edit_value(src, ~)
        el.set(prop, get(src, 'String'))
   
        pl.resize()
        pl.refresh()
    end    
    
    % update
    if el.isLocked(prop)
        set(pl.edit_value, 'Enable', 'off')
    end

    switch el.getPropCategory(prop)
        case Category.METADATA
            set(pl.edit_value, 'String', el.get(prop))

        case {Category.PARAMETER, Category.DATA}
            set(pl.edit_value, 'String', el.get(prop))

            value = el.getr(prop);
            if isa(value, 'Callback')
                set(pr{prop}.edit_value, 'Enable', 'off')
            end

        case Category.RESULT
            value = el.getr(prop);

            if isa(value, 'NoValue')
                set(pl.edit_value, ...
                    'String', el.getPropDefault(prop), ...
                    'Enable', 'off')
            else
                set(pl.edit_value, ...
                    'String', el.get(prop), ...
                    'Enable', 'off')
            end
    end
    
    % auxiliary functions
    function r = x0(h)
        r = PlotElement.x0(h);
    end
    function r = y0(h)
        r = PlotElement.y0(h);
    end
    function r = w(h)
        r = PlotElement.w(h);
    end
    function r = h(h)
        r = PlotElement.h(h);
    end
end