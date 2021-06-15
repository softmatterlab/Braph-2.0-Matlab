function GUI(el, varargin)
%GUI creates and displays GUI for an element.
%
% GUI(EL) creates and displays GUI for element EL.
%
% GUI(EL, 'CloseRequest', CLOSE_REQUEST, 'Name', NAME, 'Position', 
%  POSITION, 'BackgroundColor', BACKGROUNDCOLOR) sets the GUI close request, 
%  name, position, and background color. All these settings are optional 
%  and can be in any order.
%
% See also Element.

%% Parameters

% option whether close dialog

if el.existsTag('ID')
    name = get_from_varargin([el.getClass() ' - ' el.get('ID')], 'Name', varargin);
else
    name = get_from_varargin(el.getClass(), 'Name', varargin);
end

close_request = get_from_varargin(true, 'CloseRequest', varargin);

f_position = get_from_varargin([.02 .1 .30 .80], 'Position', varargin);

BKGCOLOR = get_from_varargin([.98 .95 .95], 'BackgroundColor', varargin);

%% Initialize GUI
f = init();
    function f = init()
        f = figure( ...
            'Visible', 'off', ...
            'NumberTitle', 'off', ...
            'Name', [name ' - ' BRAPH2.STR], ...
            'Units', 'normalized', ...
            'Position', f_position, ...
            'Units', 'character', ...
            'MenuBar', 'none', ...
            'DockControls', 'off', ...
            'Color', BKGCOLOR ...             
            );
        
        set_icon(f)
        
        if close_request
            set(f, 'CloseRequestFcn', {@cb_close})
        end
    end
    function cb_close(~, ~)
        selection = questdlg(['Do you want to close ' name '?'], ...
            ['Close ' name], ...
            'Yes', 'No', 'Yes');
        switch selection
            case 'Yes'
                delete(f)
            case 'No'
                return
        end
    end

%% Plot Element
pl = plot();
    function pl = plot()
        el_panel = uipanel( ...
            'Parent', f, ...
            'BorderType', 'none' ...
            );
        set(f, 'SizeChangedFcn', {@resize})
        function resize(~, ~)
            set(f, 'Units', 'character')    
            set(el_panel, ...
                'Units', 'Character', ...
                'Position', [0 1 Plot.w(f) Plot.h(f)-1] ...
                );
            set(ui_text_filename, 'Position', [0 0 Plot.w(f) 1])
        end
        
        pl = el.getPlotElement();        
        pl.draw('Parent', el_panel);
    end

%% Text File Name
ui_text_filename = uicontrol('Parent', f, 'Style','text');
init_filename()
    function init_filename()
        set(ui_text_filename, ...
            'Units', 'character', ...
            'HorizontalAlignment', 'left')
    end
    function update_filename(filename)
        set(ui_text_filename, 'String', filename)
    end

%% Menu
ui_menu_import = [];
ui_menu_export = [];
menu()
    function menu()
        ui_menu_file = uimenu(f, 'Label', 'File');
        uimenu(ui_menu_file, ...
            'Label', 'Open ...', ...
            'Accelerator', 'O', ...
            'Callback', {@cb_open})
        uimenu(ui_menu_file, ...
            'Label', 'Save', ...
            'Accelerator', 'S', ...
            'Callback', {@cb_save})
        uimenu(ui_menu_file, ...
            'Label', 'Save as ...', ...
            'Accelerator', 'A', ...
            'Callback', {@cb_saveas})
        uimenu(ui_menu_file, ...
            'Separator', 'on', ...
            'Label', 'Close', ...
            'Accelerator', 'C', ...
            'Callback', {@cb_close})
        
        ui_menu_import = uimenu(f, ...
            'Label', 'Import', ...
            'Callback', {@cb_refresh});
        
        ui_menu_export = uimenu(f, ...
            'Label', 'Export', ...
            'Callback', {@cb_refresh});        
        
        ui_menu_figure = uimenu(f, 'Label', 'Figure');
        uimenu(ui_menu_figure, ...
            'Label', 'Save figures ...', ...
            'Accelerator', 'F', ...
            'Callback', {@cb_save_image})

        ui_menu_about = uimenu(f, 'Label', 'About');
        uimenu(ui_menu_about, ...
            'Label', 'License ...', ...
            'Callback', {@cb_license})
        uimenu(ui_menu_about, ...
            'Label', 'About ...', ...
            'Callback', {@cb_about})
    end
    function sub_menus()
        imp_sub_menus = get(ui_menu_import, 'Children');
        for i = 1:length(imp_sub_menus)           
            delete(imp_sub_menus(i));
        end
        eval([el.getClass() '.getGUIMenuImport(el, ui_menu_import, pl)']);
        
        exp_sub_menus = get(ui_menu_export, 'Children');
        for i = 1:length(exp_sub_menus)
            delete(exp_sub_menus(i));
        end
        eval([el.getClass() '.getGUIMenuExport(el, ui_menu_export)']);
    end
    function cb_open(~, ~)
        % select file
        [file, path, filterindex] = uigetfile(BRAPH2.EXT_ELEMENT, ['Select the ' el.getName() ' file.']);
        if filterindex
            filename = fullfile(path, file);
            tmp = load(filename, '-mat', 'el');
            if isa(tmp.el, el.getClass())
                el = tmp.el;
                plot();
                update_filename(filename);
            end
        end
    end
    function cb_save(~, ~)
        fn = get(ui_text_filename, 'String');
        if isempty(fn)
            cb_saveas();
        else
            save(fn, 'el');
        end
    end
    function cb_saveas(~, ~)
        % select file
        [file, path, filterindex] = uiputfile(BRAPH2.EXT_ELEMENT, ['Select the ' el.getName() ' file.']);
        % save file
        if filterindex
            filename = fullfile(path, file);
            build = BRAPH2.BUILD;
            save(filename, 'el', 'build');
            update_filename(filename);
        end
    end
    function cb_license(~, ~)
        BRAPH2_LICENSE()
    end
    function cb_about(~, ~)
       BRAPH2_ABOUT();
    end
    function cb_refresh(~,~)
        sub_menus()
    end
    function cb_save_image(~, ~)
        figHandles = findobj('Type', 'figure');
        for i = 1:1:length(figHandles)
            fig_h = figHandles(i);
            if ~isempty(fig_h.CurrentAxes)
                h = figure('Name', fig_h.Name);
                set(gcf, 'Color', 'w')
                copyobj(fig_h.CurrentAxes, h)
                set(gca, 'Units', 'normalized')
                set(gca, 'OuterPosition', [0 0 1 1])
                colormap jet
            end
        end
    end

%% Toolbar
toolbar()
    function toolbar()
        set(f, 'Toolbar', 'figure')

        ui_toolbar = findall(f, 'Tag', 'FigureToolBar');

        delete(findall(ui_toolbar, 'Tag', 'Standard.NewFigure'))        
        delete(findall(ui_toolbar, 'Tag', 'Standard.PrintFigure'))
        delete(findall(ui_toolbar, 'Tag', 'Standard.EditPlot'))
        delete(findall(ui_toolbar, 'Tag', 'Standard.OpenInspector'))
        delete(findall(ui_toolbar, 'Tag', 'Exploration.Brushing'))
        delete(findall(ui_toolbar, 'Tag', 'DataManager.Linking'))
        delete(findall(ui_toolbar, 'Tag', 'Annotation.InsertColorbar'))
        delete(findall(ui_toolbar, 'Tag', 'Annotation.InsertLegend'))
        delete(findall(ui_toolbar, 'Tag', 'Plottools.PlottoolsOff'))
        delete(findall(ui_toolbar, 'Tag', 'Plottools.PlottoolsOn'))
        
        % Open
        ui_toolbar_open = findall(ui_toolbar, 'Tag', 'Standard.FileOpen');
        set(ui_toolbar_open, ...
            'TooltipString', ['Open ' el.getName()], ...
            'ClickedCallback', {@cb_open})
        % Save
        ui_toolbar_save = findall(ui_toolbar, 'Tag', 'Standard.SaveFigure');
        set(ui_toolbar_save, ...
            'TooltipString', ['Save ' el.getName()], ...
            'ClickedCallback', {@cb_save})
        
        % Copy
        % Clone
    end

%% Show GUI
set(f, 'Visible', 'on')

end
