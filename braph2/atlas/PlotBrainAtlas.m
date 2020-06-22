classdef PlotBrainAtlas < PlotBrainSurf
    % PlotBrainAtlas Plot and manage of a brain atlas
    % PlotBrainAtlas plots and manages the brain regions that make up a
    % brain atlas. The brain regions can be plotted by using symbols,
    % spheres or labels.
    % It is a subclass of PlotBrainSurf.
    %
    % PlotBrainAtlas manages the plot of the brain regions symbols,
    % spheres, ids and labels. PlotBrainAtlas utilizes the surface created
    % from PlotBrainSurf to integrate the regions to a brain surface.
    %
    % PlotBrainAtlas properties (Constants):
    %   INIT_SYM_MARKER           - symbol type (default = 'o')
    %   INIT_SYM_SIZE             - symbol size (default = 10)
    %   INIT_SYM_EDGE_COLOR       - symbol edge color (default = 'none')
    %   INIT_SYM_FACE_COLOR       - symbol face color (default = 'b')
    %
    %   INIT_SPH_EDGE_COLOR       - sphere edge color (default = 'none')
    %   INIT_SPH_EDGE_ALPHA       - sphere edge transparency (default = 0.5)
    %   INIT_SPH_FACE_COLOR       - sphere face color (default = [.9 .4 .1])
    %   INIT_SPH_FACE_ALPHA       - sphere face transparency (default = 0.5)
    %   INIT_SPH_R                - sphere radius (default = 1)
    %
    %   INIT_ID_FONT_SIZE         - id font size (default = 13)
    %   INIT_ID_FONT_NAME         - id font name (default = 'Helvetica')
    %   INIT_ID_FONT_COLOR        - id font color (default = [0 0 0])
    %   INIT_ID_FONT_INTERPRETER  - id font interpreter (default = 'none')
    %
    %   INIT_LAB_FONT_SIZE        - label font size (default = 13)
    %   INIT_LAB_FONT_NAME        - label font name (default = 'Helvetica')
    %   INIT_LAB_FONT_COLOR       - label font color (default = [0 0 0])
    %   INIT_LAB_FONT_INTERPRETER - label font interpreter (default = 'none')
    %
    % PlotBrainAtlas basic methods:
    %   PlotBrainAtlas    -   constructor
    %   tostring          -   returns a string representing the plot brain atlas
    %   disp              -   displays the plot brain atlas
    %   getBrainAtlas     -   returns the plot brain atlas
    %   
    % PlotBrainAtlas symbol methods:
    %   br_sym            -   displays brain region as symbol
    %   br_sym_on         -   shows a symbol
    %   br_sym_off        -   hides a symbol
    %   br_sym_is_on      -   checks if symbol is visible
    %   br_syms           -   displays multiple brain regions as symbols
    %   br_syms_on        -   shows multiple symbols
    %   br_syms_off       -   hides multiple symbols
    %   get_sym_i         -   returns the order number of brain region corresponding to a symbol
    %   get_sym_br        -   returns the properties of brain region corresponding to a symbol
    %   br_syms_settings  -   panel to set symbol properties
    %
    % PlotBrainAtlas sphere methods:
    %   br_sph            -   displays brain region as sphere
    %   br_sph_on         -   shows a sphere
    %   br_sph_off        -   hides a sphere
    %   br_sph_is_on      -   checks if sphere is visible
    %   br_sphs           -   displays multiple brain regions as spheres
    %   br_sphs_on        -   shows multiple spheres
    %   br_sphs_off       -   hides multiple spheres
    %   get_sph_i         -   returns the order number of brain region corresponding to a sphere
    %   get_sph_br        -   returns the properties of brain region corresponding to a sphere
    %   br_sphs_settings  -   panel to set sphere properties
    %
    % PlotBrainAtlas id methods:
    %   br_id             -   displays brain region as id
    %   br_id_on          -   shows an id
    %   br_id_off         -   hides an id
    %   br_id_is_on       -   checks if id is visible
    %   br_ids            -   displays multiple brain regions as id
    %   br_ids_on         -   shows multiple ids
    %   br_ids_off        -   hides multiple ids
    %   get_id_i          -   returns the order number of brain region corresponding to an id
    %   get_id_br         -   returns properties of brain region corresponding to an id
    %   br_ids_settings   -   panel to sets id properties
    %
    % PlotBrainAtlas label methods:
    %   br_lab            -   displays brain region as label
    %   br_lab_on         -   shows a label
    %   br_lab_off        -   hides a label
    %   br_lab_is_on      -   checks if label is visible
    %   br_labs           -   displays multiple brain regions as label
    %   br_labs_on        -   shows multiple labels
    %   br_labs_off       -   hides multiple labels
    %   get_lab_i         -   returns the order number of brain region corresponding to a label
    %   get_lab_br        -   returns the properties of brain region corresponding to a label
    %   br_labs_settings  -   panel to set label properties
    %
    % PlotBrainAtlas distance methods:
    %   distance_map_on   -  highlights brain surface around select brain regions
    %   distance_map_off  -  removes the highlights
    %
    % See also PlotBrainSurf, BrainAtlas, BrainRegion, PlotBrainGraph.
    
    properties (Constant)
        % Symbols
        INIT_SYM_MARKER = 'o'
        INIT_SYM_SIZE = 10
        INIT_SYM_EDGE_COLOR = 'b'
        INIT_SYM_FACE_COLOR = 'b'
        
        % Spheres
        INIT_SPH_EDGE_COLOR = 'none'
        INIT_SPH_EDGE_ALPHA = .5
        INIT_SPH_FACE_COLOR = [.9 .4 .1]
        INIT_SPH_FACE_ALPHA = .5
        INIT_SPH_R = 1
        
        % IDs
        INIT_ID_FONT_SIZE = 13
        INIT_ID_FONT_NAME = GUI.FONT
        INIT_ID_FONT_COLOR = [0 0 0]
        INIT_ID_FONT_INTERPRETER = 'none'

        % Labels
        INIT_LAB_FONT_SIZE = 13
        INIT_LAB_FONT_NAME = GUI.FONT
        INIT_LAB_FONT_COLOR = [0 0 0]
        INIT_LAB_FONT_INTERPRETER = 'none'
    end
    properties (Access = protected)
        atlas  % BrainAtlas
        
        % syms is a cell array containing the symbols' properties
        % syms{n}.h     -   graphic handle
        % syms{n}.X     -   x-coordinate
        % syms{n}.Y     -   y-coordinate
        % syms{n}.Z     -   z-coordinate
        syms
        f_syms_settings  % symbols settings figure handle
        
        % sphs is a cell array containing the spheres' properties
        % sphs{n}.h     -   graphic handle
        % sphs{n}.X     -   x-coordinate
        % sphs{n}.Y     -   y-coordinate
        % sphs{n}.Z     -   z-coordinate
        % sphs{n}.R     -   sphere radius
        sphs
        f_sphs_settings  % spheres setting figure handle
        
        % ids is a cell array containing the IDs' properties
        % ids{n}.h      -   graphic handle
        % ids{n}.X      -   x-coordinate
        % ids{n}.Y      -   y-coordinate
        % ids{n}.Z      -   z-coordinate
        % ids{n}.ID     -   id string
        ids
        f_ids_settings  % ids setting figure handle

        % labs is a cell array containing the labels' properties
        % labs{n}.h     -   graphic handle
        % labs{n}.X     -   x-coordinate
        % labs{n}.Y     -   y-coordinate
        % labs{n}.Z     -   z-coordinate
        % labs{n}.LAB   -   label string
        labs
        f_labs_settings  % labels setting figure handle
    end
    methods  % Basic functions
        function ba = PlotBrainAtlas(atlas, varargin)
            % BA = PLOTBRAINATLAS(ATLAS) constructs the brain atlas plot.
            %
            % BA = PLOTBRAINATLAS (ATLAS, 'Property', VALUE, ...) passes
            % the properties to the PlotBrainSurf. 
            %
            % See also PlotBrainSurf, BrainAtlas.
            
            assert(isa(atlas, 'BrainAtlas'), ...
                [BRAPH2.STR ':' class(atlas) ':' BRAPH2.WRONG_INPUT], ...
                'Argument must be a BrainAtlas.')
            
            ba = ba@PlotBrainSurf(atlas.getBrainSurfFile(), varargin{:});
            
            ba.atlas = atlas;
            ba.setRegions();
        end
        function str = tostring(ba)
            % TOSTRING string with information about plot brain atlas properties
            %
            % STR = TOSTRING(BA) returns string with information about the
            % plot brain atlas and the plot brain surface. 
            %
            % See also disp.
            
            str = [tostring@PlotBrainSurf(ba) ' ' ba.getBrainAtlas().tostring()];
        end
        function disp(ba)
            % DISP displays brain atlas properties
            %
            % DISP(BA) displays information about the plot brain atlas and
            % the plot brain surface.
            %
            % See also tostring.
            
            disp@PlotBrainSurf(ba)
            disp(ba.getBrainAtlas().tostring())
        end
        function atlas = getBrainAtlas(ba)
            % GETBRAINATLAS returns the brain atlas
            %
            % ATLAS = GETBRAINATLAS(BA) gets the brain atlas.
            
            atlas = ba.atlas;
        end
    end
    methods (Access = protected)  % Set Brain Regions
        function setRegions(ba)
            % SETREGIONS reads the atlas and sets the data
            %
            % SETREGIONS(BA) reads the atlas and loads the data.
            %
            % See getBrainAtlas.
            
            X = cellfun(@(br) br.getX(), ba.getBrainAtlas().getBrainRegions().getValues(), 'UniformOutput', false);
            Y = cellfun(@(br) br.getY(), ba.getBrainAtlas().getBrainRegions().getValues(), 'UniformOutput', false);
            Z = cellfun(@(br) br.getZ(), ba.getBrainAtlas().getBrainRegions().getValues(), 'UniformOutput', false);
            ids = cellfun(@(br) br.getID(), ba.getBrainAtlas().getBrainRegions().getValues(), 'UniformOutput', false); %#ok<PROP>
            labels = cellfun(@(br) br.getLabel(), ba.getBrainAtlas().getBrainRegions().getValues(), 'UniformOutput', false);
            
            if ba.getBrainAtlas().getBrainRegions().length() > 0
                
                ba.syms.h = NaN(1, ba.getBrainAtlas().getBrainRegions().length());
                ba.syms.X = X;
                ba.syms.Y = Y;
                ba.syms.Z = Z;
                
                ba.sphs.h = NaN(1, ba.getBrainAtlas().getBrainRegions().length());
                ba.sphs.X = X;
                ba.sphs.Y = Y;
                ba.sphs.Z = Z;
                ba.sphs.R = PlotBrainAtlas.INIT_SPH_R * ones(1, ba.getBrainAtlas().getBrainRegions().length());
                
                ba.ids.h = NaN(1, ba.getBrainAtlas().getBrainRegions().length());
                ba.ids.X = X;
                ba.ids.Y = Y;
                ba.ids.Z = Z;
                ba.ids.ID = ids;  %#ok<PROP>

                ba.labs.h = NaN(1,  ba.getBrainAtlas().getBrainRegions().length());
                ba.labs.X = X;
                ba.labs.Y = Y;
                ba.labs.Z = Z;
                ba.labs.LAB = labels;
            end
        end
    end
    methods  % Functions symbols
        function h = br_sym(ba, i, varargin)
            % BR_SYM displays brain region as symbol
            %
            % BR_SYM(BA, I) plots the brain regions I as a symbol, if not plotted.
            %
            % H = BR_SYM(BA, I) returns the handle to the symbol denoting the brain
            % region I.
            %
            % BR_SYM(BA, I, 'PropertyName', PropertyValue) sets the property
            % of the symbol's PropertyName to PropertyValue.
            % All standard plot properties of plot3 can be used and also
            % the symbol properties listed below.
            % Symbole-specific properties:
            %   Color  -   symbol color both marker edge and face
            %   Size   -   symbol size
            % The symbol properties can also be changed when hidden.
            %
            % See also plot3, br_sym_on, br_sym_off.
            
            ba.set_axes()
            
            % center coordinates
            X = ba.getBrainAtlas().getBrainRegions().getValue(i).getX();
            Y = ba.getBrainAtlas().getBrainRegions().getValue(i).getY();
            Z = ba.getBrainAtlas().getBrainRegions().getValue(i).getZ();
            
            if ~ishandle(ba.syms.h(i))
                
                ba.syms.h(i) = plot3(...
                    ba.get_axes(), ...
                    X,...
                    Y,...
                    Z,...
                    'Marker', PlotBrainAtlas.INIT_SYM_MARKER,...
                    'MarkerSize', PlotBrainAtlas.INIT_SYM_SIZE,...
                    'MarkerEdgeColor', PlotBrainAtlas.INIT_SYM_EDGE_COLOR,...
                    'MarkerFaceColor', PlotBrainAtlas.INIT_SYM_FACE_COLOR);
                
            else
                if ~isequal(ba.syms.X(i), X) || ~isequal(ba.syms.Y(i), Y) || ~isequal(ba.syms.Z(i), Z)
                    
                    set(ba.syms.h(i), 'XData', X);
                    set(ba.syms.h(i), 'YData', Y);
                    set(ba.syms.h(i), 'ZData', Z);
                end
            end
            
            % saves new data
            ba.syms.X(i) = num2cell(X);
            ba.syms.Y(i) = num2cell(Y);
            ba.syms.Z(i) = num2cell(Z);
            
            % sets properties
            for n = 1:2:length(varargin)
                switch lower(varargin{n})
                    case 'color'
                        set(ba.syms.h(i), 'MarkerFaceColor', varargin{n + 1});
                        set(ba.syms.h(i), 'MarkerEdgeColor', varargin{n + 1});
                    case 'size'
                        set(ba.syms.h(i), 'MarkerSize', varargin{n + 1});
                    otherwise
                        set(ba.syms.h(i), varargin{n}, varargin{n + 1});
                end
            end
            
            % output if needed
            if nargout>0
                h = ba.syms.h(i);
            end
        end
        function br_sym_on(ba, i)
            % BR_SYM_ON shows a symbol
            %
            % BR_SYM_ON(BA, I) shows the symbol denoting the brain region I.
            %
            % See also br_sym, br_sym_off.
            
            if ishandle(ba.syms.h(i))
                set(ba.syms.h(i), 'Visible', 'on')
            end
        end
        function br_sym_off(ba, i)
            % BR_SYM_OFF hides a symbol
            %
            % BR_SYM_OFF(BA, I) hides the symbol denoting the brain region I.
            %
            % See also br_sym, br_sym_on.
            
            if  ishandle(ba.syms.h(i))
                set(ba.syms.h(i), 'Visible', 'off')
            end
        end
        function bool = br_sym_is_on(ba, i)
            % BR_SYM_IS_ON checks if symbol is visible
            %
            % BOOL = BR_SYM_IS_ON(BA, I) returns true if the symbol denoting
            % the brain region I is visible and false otherwise.
            %
            % See also br_sym_on, br_sym_off.
            
            bool = ishandle(ba.syms.h(i)) && strcmpi(get(ba.syms.h(i), 'Visible'), 'on');
        end        
        function br_syms(ba, i_vec, varargin)
            % BR_SYMS displays multiple brain regions as symbols
            %
            % BR_SYMS(BA, I_VEC) plots the symbols denoting the brain regions
            % specified in I_VEC, if not plotted.
            %
            % BR_SYMS(BA, []) plots the symbols for all brain regions.
            %
            % BR_SYMS(BA, I_VEC, 'PropertyName', PropertyValue, ...) sets the property
            % of the multiple symbols' PropertyName to PropertyValue.
            % All standard plot properties of plot3 can be used and also
            % the symbol properties listed below.
            % Symbole-specific properties:
            %   Color  -   symbol color both marker edge and face
            %   Size   -   symbol size
            % The symbols properties can also be changed when hidden.
            %
            % See also plot3, br_syms_on, br_syms_off.
            
            % Marker - MarkerEdgeColor - MarkerFaceColor - Color - Size
            for n = 1:2:length(varargin)
                switch lower(varargin{n})
                    case 'marker'
                        Marker = varargin{n + 1};
                        nmarker = n + 1;
                    case 'markeredgecolor'
                        MarkerEdgeColor = varargin{n + 1};
                        nmarkeredgecolor = n + 1;
                    case 'markerfacecolor'
                        MarkerFaceColor = varargin{n + 1};
                        nmarkerfacecolor = n + 1;
                    case 'color'
                        Color = varargin{n + 1};
                        ncolor = n + 1;
                    case 'size'
                        Size = varargin{n + 1};
                        nsize = n + 1;
                end
            end
            
            if nargin < 2 || isempty(i_vec)
                i_vec = 1:1:ba.getBrainAtlas().getBrainRegions().length();
            end
            
            for m = 1:1:length(i_vec)
                if exist('Marker', 'var') && numel(Marker) == length(i_vec)
                    varargin{nmarker} = Marker(m);
                end
                if exist('MarkerEdgeColor', 'var') && size(MarkerEdgeColor, 1) == length(i_vec) && size(MarkerEdgeColor, 2) == 3
                    varargin{nmarkeredgecolor} = MarkerEdgeColor(m, :);
                end
                if exist('MarkerFaceColor', 'var') && size(MarkerFaceColor, 1) == length(i_vec) && size(MarkerFaceColor, 2) == 3
                    varargin{nmarkerfacecolor} = MarkerFaceColor(m, :);
                end
                if exist('Color', 'var') && size(Color, 1) == length(i_vec) && size(Color, 2) == 3
                    varargin{ncolor} = Color(m, :);
                end
                if exist('Size', 'var') && numel(Size) == length(i_vec)
                    varargin{nsize} = Size(m);
                end
                
                ba.br_sym(i_vec(m), varargin{:})
            end
        end
        function br_syms_on(ba, i_vec)
            % BR_SYMS_ON shows multiple symbols
            %
            % BR_SYMS_ON(BA, I_VEC) shows multiple symbols denoting the
            % brain regions specified in I_VEC.
            %
            % BR_SYMS_ON(BA, []) shows the symbols denoting all possible
            % brain region combinations.
            %
            % See also br_syms_off, br_syms.
            
            if nargin<2 || isempty(i_vec)
                i_vec = 1:1:ba.getBrainAtlas().getBrainRegions().length();
            end
            
            for m = 1:1:length(i_vec)
                ba.br_sym_on(i_vec(m))
            end
        end
        function br_syms_off(ba, i_vec)
            % BR_SYMS_OFF hides multiple symbols
            %
            % BR_SYMS_OFF(BA, I_VEC) hides multiple symbols denoting the
            % brain regions specified in I_VEC.
            %
            % BR_SYMS_OFF(BA, []) hides the symbols denoting all possible
            % brain region combinations.
            %
            % See also br_syms_on, br_syms.
            
            if nargin<2 || isempty(i_vec)
                i_vec = 1:1:ba.getBrainAtlas().getBrainRegions().length();
            end
            
            for m = 1:1:length(i_vec)
                ba.br_sym_off(i_vec(m))
            end
        end
        function i = get_sym_i(ba, h)
            % GET_SYM_I returns index of brain region corresponding to symbol
            %
            % I = GET_SYM_I(BA, H) returns the index of the brain regions
            % corresponding to the symbol with handle H.
            %
            % See also get_sym_br.
            
            i = NaN;
            if ~isempty(h)
                for j = 1:1:ba.getBrainAtlas().getBrainRegions().length()
                    if h == ba.syms.h(j)
                        i = j;
                    end
                end
            end
        end
        function br = get_sym_br(ba, h)
            % GET_SYM_BR returns brain region corresponding to symbol
            %
            % BR = GET_SYM_BR(BA, H) returns the properties of the brain region
            % BR corresponding to the symbol with handle H.
            %
            % See also get_sym_i.
            
            i = ba.get_sym_i(h);
            br = ba.getBrainAtlas().getBrainRegions().getValue(i);
        end
        function br_syms_settings(ba, i_vec, varargin)
            % BR_SYMS_SETTINGS panel to set symbol properties
            %
            % BR_SYMS_SETTINGS(BA) allows the user to interactively
            % change the symbol settings via a graphical user interface.
            %
            % BR_SYMS_SETTINGS(BA, 'PropertyName', PropertyValue, ... )
            % sets the property of the GUI's PropertyName to PropertyValue.
            % Admissible properties are:
            %     FigPosition  -   normalized position of the GUI on the screen 
            %                      [X0 Y0 DX DY]
            %     FigColor     -   background color of the GUI
            %     FigName      -   name of the GUI
            
            if nargin<2
                i_vec = [];
            end
            
            FigPosition = get_from_varargin([.50 .30 .30 .30], 'figposition', varargin);
            FigColor = get_from_varargin(GUI.BKGCOLOR, 'figcolor', varargin);
            FigName = get_from_varargin('Brain Region Symbol Settings', 'figname', varargin);
            
            % create a figure
            if isempty(ba.f_syms_settings) || ~ishandle(ba.f_syms_settings)
                ba.f_syms_settings = figure('Visible', 'off');
            end
            f = ba.f_syms_settings;
            set(f, 'units', 'normalized')
            set(f, 'Position', FigPosition)
            set(f, 'Color', FigColor)
            set(f, 'Name', FigName)
            set(f, 'MenuBar', 'none')
            set(f, 'Toolbar', 'none')
            set(f, 'NumberTitle', 'off')
            set(f, 'DockControls', 'off')
            
            % Initialization
            ui_list = uicontrol(f, 'Style', 'listbox');
            set(ui_list, 'Units', 'normalized')
            set(ui_list, 'BackgroundColor', GUI.BKGCOLOR)
            set(ui_list, 'Value', i_vec)
            set(ui_list, 'Max', 2, 'Min',0)
            set(ui_list, 'BackgroundColor', [1 1 1])
            set(ui_list, 'Position', [.05 .15 .40 .80])
            set(ui_list, 'TooltipString', 'Select brain regions');
            set(ui_list, 'Callback', {@cb_list});
            
            ui_checkbox_id = uicontrol(f, 'Style', 'checkbox');
            set(ui_checkbox_id, 'Units', 'normalized')
            set(ui_checkbox_id, 'BackgroundColor', GUI.BKGCOLOR)
            set(ui_checkbox_id, 'Position', [.05 .05 .20 .10])
            set(ui_checkbox_id, 'String', 'id')
            set(ui_checkbox_id, 'Value', true)
            set(ui_checkbox_id, 'FontWeight', 'bold')
            set(ui_checkbox_id, 'TooltipString', 'Shows brain regions by id')
            set(ui_checkbox_id, 'Callback', {@cb_id})

            ui_checkbox_label = uicontrol(f, 'Style', 'checkbox');
            set(ui_checkbox_label, 'Units', 'normalized')
            set(ui_checkbox_label, 'BackgroundColor', GUI.BKGCOLOR)
            set(ui_checkbox_label, 'Position', [.20 .05 .15 .10])
            set(ui_checkbox_label, 'String', 'label')
            set(ui_checkbox_label, 'Value', false)
            set(ui_checkbox_label, 'TooltipString', 'Shows brain regions by label')
            set(ui_checkbox_label, 'Callback', {@cb_label})
            
            ui_checkbox_xyz = uicontrol(f, 'Style', 'checkbox');
            set(ui_checkbox_xyz, 'Units', 'normalized')
            set(ui_checkbox_xyz, 'BackgroundColor', GUI.BKGCOLOR)
            set(ui_checkbox_xyz, 'Position', [.35 .05 .15 .10])
            set(ui_checkbox_xyz, 'String', 'xyz')
            set(ui_checkbox_xyz, 'Value', false)
            set(ui_checkbox_xyz, 'TooltipString', 'Shows brain regions by name')
            set(ui_checkbox_xyz, 'Callback', {@cb_xyz})
            
            ui_button_show = uicontrol(f, 'Style', 'pushbutton');
            set(ui_button_show, 'Units','normalized')
            set(ui_button_show, 'Position', [.50 .85 .45 .10])
            set(ui_button_show, 'String', 'Show Regions')
            set(ui_button_show, 'TooltipString', 'Show selected brain regions')
            set(ui_button_show, 'Callback', {@cb_show})
            
            ui_button_hide = uicontrol(f, 'Style', 'pushbutton');
            set(ui_button_hide, 'Units', 'normalized')
            set(ui_button_hide, 'Position', [.50 .75 .45 .10])
            set(ui_button_hide, 'String', 'Hide Regions')
            set(ui_button_hide, 'TooltipString', 'Hide selected brain regions')
            set(ui_button_hide, 'Callback', {@cb_hide})
            
            ui_popup_marker = uicontrol(f, 'Style', 'popup', 'String', {''});
            set(ui_popup_marker, 'Units', 'normalized')
            set(ui_popup_marker, 'BackgroundColor', GUI.BKGCOLOR)
            set(ui_popup_marker, 'Position', [.50 .50 .45 .10])
            set(ui_popup_marker, 'String', GUI.PLOT_SYMBOL_NAME)
            set(ui_popup_marker, 'Value', 2)
            set(ui_popup_marker, 'TooltipString', 'Select symbol');
            set(ui_popup_marker, 'Callback', {@cb_marker})
            
            ui_text_size = uicontrol(f, 'Style', 'text');
            set(ui_text_size, 'Units', 'normalized')
            set(ui_text_size, 'BackgroundColor', GUI.BKGCOLOR)
            set(ui_text_size, 'Position', [.50 .375 .20 .10])
            set(ui_text_size, 'String', 'symbol size ')
            set(ui_text_size, 'HorizontalAlignment', 'left')
            set(ui_text_size, 'FontWeight', 'bold')
            
            ui_edit_size = uicontrol(f, 'Style', 'edit');
            set(ui_edit_size, 'Units','normalized')
            set(ui_edit_size, 'BackgroundColor', GUI.BKGCOLOR)
            set(ui_edit_size, 'Position', [.70 .40 .25 .10])
            set(ui_edit_size, 'HorizontalAlignment', 'center')
            set(ui_edit_size, 'FontWeight', 'bold')
            set(ui_edit_size, 'String', '1')
            set(ui_edit_size, 'Callback', {@cb_size})
            
            ui_button_facecolor = uicontrol(f, 'Style', 'pushbutton');
            set(ui_button_facecolor, 'Units', 'normalized')
            set(ui_button_facecolor, 'Position', [.50 .25 .45 .10])
            set(ui_button_facecolor, 'String', 'Symbol Color')
            set(ui_button_facecolor, 'TooltipString', 'Select symbol color')
            set(ui_button_facecolor, 'Callback', {@cb_facecolor})
            
            ui_button_edgecolor = uicontrol(f, 'Style', 'pushbutton');
            set(ui_button_edgecolor, 'Units', 'normalized')
            set(ui_button_edgecolor, 'Position', [.50 .15 .45 .10])
            set(ui_button_edgecolor, 'String', 'Edge Color')
            set(ui_button_edgecolor, 'TooltipString', 'Select symbol edge color')
            set(ui_button_edgecolor, 'Callback', {@cb_edgecolor})
             
            update_list()
            set(f, 'Visible', 'on')
            
            function update_list()
                % get info
                ids = cellfun(@(br) br.getID(), ba.getBrainAtlas().getBrainRegions().getValues(), 'UniformOutput', false); %#ok<PROPLC>
                labels = cellfun(@(br) br.getLabel(), ba.getBrainAtlas().getBrainRegions().getValues(), 'UniformOutput', false);
                xs = cellfun(@(br) br.getX(), ba.getBrainAtlas().getBrainRegions().getValues(), 'UniformOutput', false);
                ys = cellfun(@(br) br.getY(), ba.getBrainAtlas().getBrainRegions().getValues(), 'UniformOutput', false);
                zs = cellfun(@(br) br.getZ(), ba.getBrainAtlas().getBrainRegions().getValues(), 'UniformOutput', false);
                
                % Set list names
                if get(ui_checkbox_id, 'Value')
                    set(ui_list, 'String', ids) %#ok<PROPLC>
                elseif get(ui_checkbox_label, 'Value')
                    set(ui_list, 'String', labels)
                elseif get(ui_checkbox_xyz, 'Value')
                    xyz = cell(1, ba.getBrainAtlas().getBrainRegions().length());
                    for j = 1:1:ba.getBrainAtlas().getBrainRegions().length()
                        xyz{j} = [num2str(xs{j}) '   ' ...
                            num2str(ys{j}) '   ' ...
                            num2str(zs{j})];
                    end
                    set(ui_list, 'String', xyz)
                end
            end
            function cb_list(~, ~)  % (src, event)
                update_list()
            end
            function cb_id(~,~)  % (src,event)
                set(ui_checkbox_id, 'Value', true)
                set(ui_checkbox_id, 'FontWeight', 'bold')

                set(ui_checkbox_label, 'Value', false)
                set(ui_checkbox_label, 'FontWeight', 'normal')
                
                set(ui_checkbox_xyz, 'Value', false)
                set(ui_checkbox_xyz, 'FontWeight', 'normal')
                
                update_list()
            end
            function cb_label(~, ~)  % (src, event)
                set(ui_checkbox_id, 'Value', false)
                set(ui_checkbox_id, 'FontWeight', 'normal')

                set(ui_checkbox_label, 'Value', true)
                set(ui_checkbox_label, 'FontWeight', 'bold')
                                
                set(ui_checkbox_xyz, 'Value', false)
                set(ui_checkbox_xyz, 'FontWeight', 'normal')
                
                update_list()
            end
            function cb_xyz(~, ~)  % (src, event)
                set(ui_checkbox_id, 'Value', false)
                set(ui_checkbox_id, 'FontWeight', 'normal')

                set(ui_checkbox_label, 'Value', false)
                set(ui_checkbox_label, 'FontWeight', 'normal')
                
                set(ui_checkbox_xyz, 'Value', true)
                set(ui_checkbox_xyz, 'FontWeight', 'bold')
                
                update_list()
            end
            function cb_show(~, ~)  % (src, event)
                ba.br_syms(get_br_list())
                ba.br_syms_on(get_br_list())
            end
            function cb_hide(~, ~)  % (src, event)
                ba.br_syms_off(get_br_list())
            end
            function cb_marker(~, ~)  % (src, event)
                symbol = GUI.PLOT_SYMBOL_TAG{get(ui_popup_marker, 'Value')};
                ba.br_syms(get_br_list(), 'Marker', symbol)
            end
            function cb_size(~, ~)  % (src, event)
                size = real(str2double(get(ui_edit_size, 'String')));
                
                if isempty(size) || size <= 1
                    set(ui_edit_size, 'String', '1')
                    size = 1;
                end
                ba.br_syms(get_br_list(), 'MarkerSize', size)
            end
            function cb_facecolor(~, ~)  % (src, event)
                color = uisetcolor();
                
                if length(color) == 3
                    ba.br_syms(get_br_list(), 'MarkerFaceColor', color)
                end
            end
            function cb_edgecolor(~, ~)  % (src, event)
                color = uisetcolor();
                
                if length(color) == 3
                    ba.br_syms(get_br_list(), 'MarkerEdgeColor', color)
                end
            end
            function bri = get_br_list()
                if ba.getBrainAtlas().getBrainRegions().length()>0
                    bri = get(ui_list, 'Value');
                else
                    bri = [];
                end
            end
        end
        function is_empty = is_syms_empty(ba)
            if ~isempty(ba.syms)
                is_empty = 0;
            else
                is_empty = 1;
            end
        end
        function sym_length = get_sym_length(ba)
            sym_length = length(ba.syms);
        end
        function remove_sym(ba, i_vec)
            % ill wait for aprovl
        end
    end
    methods  % Functions spheres
        function h = br_sph(ba, i, varargin)
            % BR_SPH displays brain region as sphere
            %
            % BR_SPH(BA, I) plots the brain regions I as a sphere, if not plotted.
            %
            % H = BR_SPH(BA, I) returns the handle to the sphere denoting the brain
            % region I.
            %
            % BR_SPH(BA, I, 'PropertyName', PropertyValue, ...) sets the property
            % of the sphere's PropertyName to PropertyValue.
            % All standard plot properties of surf can be used and also the sphere
            % properties listed below.
            % Sphere-specific properties:
            %   Color  -   sphere color both edges and faces
            %   Alpha  -   sphere transparency both edges and faces
            %   R      -   sphere radius
            %   The sphere properties can also be changed when hidden.
            %
            % See also surf, br_sph_on, br_sph_off.
            
            ba.set_axes()
            
            % radius
            R = get_from_varargin(ba.sphs.R(i), 'r', varargin);
            
            % center coordinates
            X = ba.getBrainAtlas().getBrainRegions().getValue(i).getX();
            Y = ba.getBrainAtlas().getBrainRegions().getValue(i).getY();
            Z = ba.getBrainAtlas().getBrainRegions().getValue(i).getZ();
            
            % plot sphere
            if ~ishandle(ba.sphs.h(i))
                color = PlotBrainAtlas.INIT_SPH_FACE_COLOR;
                alpha = PlotBrainAtlas.INIT_SPH_FACE_ALPHA;
                
                [sx, sy, sz] = sphere();
                ba.sphs.h(i) = surf( ...
                    ba.get_axes(), ...
                    X + R * sx, ...
                    Y + R * sy, ...
                    Z + R * sz, ...
                    'EdgeColor', color, ...
                    'EdgeAlpha', alpha, ...
                    'FaceColor', color, ...
                    'FaceAlpha', alpha ...
                    );
            else
                if ~isequal(ba.sphs.X(i), num2cell(X)) || ~isequal(ba.sphs.Y(i), num2cell(Y)) || ~isequal(ba.sphs.Z(i), num2cell(Z)) || ba.sphs.R(i) ~= (R)
                    
                    [sx, sy, sz] = sphere();
                    set(ba.sphs.h(i), 'XData',X + R * sx);
                    set(ba.sphs.h(i), 'YData',Y + R * sy);
                    set(ba.sphs.h(i), 'ZData',Z + R * sz);
                end
            end
            
            % saves new data
            ba.sphs.X(i) = num2cell(X);
            ba.sphs.Y(i) = num2cell(Y);
            ba.sphs.Z(i) = num2cell(Z);
            ba.sphs.R(i) = R;
            
            % sets properties
            for n = 1:2:length(varargin)
                switch lower(varargin{n})
                    case 'r'
                        [sx, sy, sz] = sphere();
                        set(ba.sphs.h(i), 'XData', X + R * sx);
                        set(ba.sphs.h(i), 'YData', Y + R * sy);
                        set(ba.sphs.h(i), 'ZData', Z + R * sz);
                    case 'color'
                        color = varargin{n + 1};
                        set(ba.sphs.h(i), 'FaceColor', color);
                        set(ba.sphs.h(i), 'EdgeColor', color);
                    case 'alpha'
                        alpha = varargin{n + 1};
                        set(ba.sphs.h(i), 'FaceAlpha', alpha);
                        set(ba.sphs.h(i), 'EdgeAlpha', alpha);
                    otherwise
                        set(ba.sphs.h(i), varargin{n}, varargin{n + 1});
                end
            end
            
            % output if needed
            if nargout>0
                h = ba.sphs.h(i);
            end
        end
        function br_sph_on(ba, i)
            % BR_SPH_ON shows a sphere
            %
            % BR_SPH_ON(BA, I) shows the sphere denoting the brain region I.
            %
            % See also br_sph, br_sph_off.
            
            if ishandle(ba.sphs.h(i))
                set(ba.sphs.h(i), 'Visible', 'on')
            end
        end
        function br_sph_off(ba, i)
            % BR_SPH_OFF hides a sphere
            %
            % BR_SPH_OFF(BA, I) hides the sphere denoting the brain region I.
            %
            % See also br_sph, br_sph_on.
            
            if ishandle(ba.sphs.h(i))
                set(ba.sphs.h(i), 'Visible', 'off')
            end
        end
        function bool = br_sph_is_on(ba, i)
            % BR_SPH_IS_ON checks if sphere is visible
            %
            % BOOL = BR_SPH_IS_ON(BA, I) returns true if the sphere denoting
            % the brain region I is visible and false otherwise.
            %
            % See also PlotBrainAtlas.
            
            bool = ~ishandle(ba.sphs.h(i)) && strcmpi(get(ba.sphs.h(i), 'Visible'), 'on');
        end
        function br_sphs(ba, i_vec, varargin)
            % BR_SPHS displays multiple brain regions as spheres
            %
            % BR_SPHS(BA, I_VEC) plots the spheres denoting the brain regions
            % specified in I_VEC, if not plotted.
            %
            % BR_SPHS(BA, []) plots the spheres for all possible brain regions.
            %
            % BR_SPHS(BA, I_VEC, 'PropertyName', PropertyValue, ...) sets the property
            % of the multiple spheres' PropertyName to PropertyValue.
            % All standard plot properties of surf can be used and also the sphere
            % properties listed below.
            % SPHERE properties:
            %   Color  -   sphere color both edges and faces [default = 'k']
            %   Alpha  -   sphere transparency both edges and faces [default = 0.5]
            %   R      -   sphere radius [default = 1]
            % The spheres properties can also be changed when hidden.
            %
            % See also surf, br_sphs_on, br_sphs_off.
            
            % R - EdgeColor - EdgeAlpha - FaceColor - FaceAlpha - Color - Alpha
            for n = 1:2:length(varargin)
                switch lower(varargin{n})
                    case 'r'
                        R = varargin{n + 1};
                        nr = n + 1;
                    case 'edgecolor'
                        EdgeColor = varargin{n + 1};
                        nedgecolor = n + 1;
                    case 'edgealpha'
                        EdgeAlpha = varargin{n + 1};
                        nedgealpha = n + 1;
                    case 'facecolor'
                        FaceColor = varargin{n + 1};
                        nfacecolor = n + 1;
                    case 'facealpha'
                        FaceAlpha = varargin{n + 1};
                        nfacealpha = n + 1;
                    case 'color'
                        Color = varargin{n + 1};
                        ncolor = n + 1;
                    case 'alpha'
                        Alpha = varargin{n + 1};
                        nalpha = n + 1;
                end
            end
            
            if nargin<2 || isempty(i_vec)
                i_vec = 1:1:ba.getBrainAtlas().getBrainRegions().length();
            end

            for m = 1:1:length(i_vec)
                if exist('R', 'var') && numel(R) == length(i_vec)
                    varargin{nr} = R(m);
                end
                if exist('EdgeColor', 'var') && size(EdgeColor, 1) == length(i_vec) && size(EdgeColor, 2) == 3
                    varargin{nedgecolor} = EdgeColor(m, :);
                end
                if exist('EdgeAlpha', 'var') && numel(EdgeAlpha) == length(i_vec)
                    varargin{nedgealpha} = EdgeAlpha(m);
                end
                if exist('FaceColor', 'var') && size(FaceColor, 1) == length(i_vec) && size(FaceColor, 2) == 3
                    varargin{nfacecolor} = FaceColor(m, :);
                end
                if exist('FaceAlpha', 'var') && numel(FaceAlpha) == length(i_vec)
                    varargin{nfacealpha} = FaceAlpha(m);
                end
                if exist('Color', 'var') && size(Color, 1)==length(i_vec) && size(Color, 2) == 3
                    varargin{ncolor} = Color(m, :);
                end
                if exist('Alpha', 'var') && numel(Alpha) == length(i_vec)
                    varargin{nalpha} = Alpha(m);
                end

                ba.br_sph(i_vec(m), varargin{:})
            end
        end
        function br_sphs_on(ba, i_vec)
            % BR_SPHS_ON shows multiple spheres
            %
            % BR_SPHS_ON(BA, I_VEC) shows multiple spheres denoting the
            % brain regions specified in I_VEC.
            %
            % BR_SPHS_ON(BA, []) shows the spheres denoting all possible
            % brain region combinations.
            %
            % See also br_sphs_off, br_sphs.
            
            if nargin<2 || isempty(i_vec)
                i_vec = 1:1:ba.getBrainAtlas().getBrainRegions().length();
            end
            
            for m = 1:1:length(i_vec)
                ba.br_sph_on(i_vec(m))
            end
        end
        function br_sphs_off(ba, i_vec)
            % BR_SPHS_OFF hides multiple spheres
            %
            % BR_SPHS_OFF(BA, I_VEC) hides multiple spheres denoting the
            % brain regions specified in I_VEC.
            %
            % BR_SPHS_OFF(BA, []) hides the spheres denoting all possible
            % brain region combinations.
            %
            % See also br_sphs_on, br_sphs.
            
            if nargin<2 || isempty(i_vec)
                i_vec = 1:1:ba.getBrainAtlas().getBrainRegions().length();
            end
            
            for m = 1:1:length(i_vec)
                ba.br_sph_off(i_vec(m))
            end
        end
        function i = get_sph_i(ba, h)
            % GET_SPH_I returns index of brain region corresponding to sphere
            %
            % I = GET_SPH_I(BA, H) returns the index of the brain region
            % corresponding to the sphere with handle H.
            %
            % See also get_sph_br.
            
            i = NaN;
            if ~isempty(h)
                for j = 1:1:ba.getBrainAtlas().getBrainRegions().length()
                    if h == ba.sphs.h(j)
                        i = j;
                    end
                end
            end
        end
        function br = get_sph_br(ba, h)
            % GET_SPH_BR returns brain region corresponding to sphere
            %
            % BR = GET_SPH_BR(BA, H) returns the properties of the brain region
            % BR corresponding to the sphere with handle H.
            %
            % See also get_sph_i.
            
            i = ba.get_sph_i(h);
            br = ba.getBrainAtlas().get(i);
        end
        function br_sphs_settings(ba, i_vec, varargin)
            % BR_SPHS_SETTINGS panel to set sphere properties
            %
            % BR_SPHS_SETTINGS(BA) allows the user to interactively
            % change the spheres settings via a graphical user interface.
            %
            % BR_SPHS_SETTINGS(BA, 'PropertyName', PropertyValue, ...) 
            % sets the property of the GUI's PropertyName to PropertyValue.
            % Admissible properties are:
            %     FigPosition  -   normalized position of the GUI on the screen
            %                      [X0 Y0 DX DY]
            %     FigColor     -   background color of the GUI
            %     FigName      -   name of the GUI
            
            if nargin<2
                i_vec = [];
            end
            
            FigPosition = get_from_varargin([.55 .35 .30 .30], 'figposition', varargin);
            FigColor = get_from_varargin(GUI.BKGCOLOR, 'figcolor', varargin);
            FigName = get_from_varargin('Brain Region Sphere Settings', 'figname', varargin);

            % create a figure
            if isempty(ba.f_sphs_settings) || ~ishandle(ba.f_sphs_settings)
                ba.f_sphs_settings = figure('Visible', 'off');
            end
            f = ba.f_sphs_settings;
            set(f,'units', 'normalized')
            set(f,'Position', FigPosition)
            set(f,'Color', FigColor)
            set(f,'Name', FigName)
            set(f,'MenuBar', 'none')
            set(f,'Toolbar', 'none')
            set(f,'NumberTitle', 'off')
            set(f,'DockControls', 'off')
            
            % Initialization
            ui_list = uicontrol(f, 'Style', 'listbox');
            set(ui_list, 'Units','normalized')
            set(ui_list, 'BackgroundColor', GUI.BKGCOLOR)
            set(ui_list, 'Value', i_vec)
            set(ui_list, 'Max', 2, 'Min', 0)
            set(ui_list, 'BackgroundColor', [1 1 1])
            set(ui_list, 'Position', [.05 .15 .40 .80])
            set(ui_list, 'TooltipString', 'Select brain regions');
            set(ui_list, 'Callback', {@cb_list});
            
            ui_checkbox_id = uicontrol(f, 'Style', 'checkbox');
            set(ui_checkbox_id, 'Units','normalized')
            set(ui_checkbox_id, 'BackgroundColor', GUI.BKGCOLOR)
            set(ui_checkbox_id, 'Position', [.05 .05 .20 .10])
            set(ui_checkbox_id, 'String', 'id')
            set(ui_checkbox_id, 'Value', true)
            set(ui_checkbox_id, 'FontWeight', 'bold')
            set(ui_checkbox_id, 'TooltipString', 'Shows brain regions by name')
            set(ui_checkbox_id, 'Callback', {@cb_id})

            ui_checkbox_label = uicontrol(f, 'Style', 'checkbox');
            set(ui_checkbox_label, 'Units','normalized')
            set(ui_checkbox_label, 'BackgroundColor', GUI.BKGCOLOR)
            set(ui_checkbox_label, 'Position', [.20 .05 .15 .10])
            set(ui_checkbox_label, 'String', 'label')
            set(ui_checkbox_label, 'Value', false)
            set(ui_checkbox_label, 'TooltipString', 'Shows brain regions by label')
            set(ui_checkbox_label, 'Callback', {@cb_label})
            
            ui_checkbox_xyz = uicontrol(f, 'Style', 'checkbox');
            set(ui_checkbox_xyz, 'Units','normalized')
            set(ui_checkbox_xyz, 'BackgroundColor', GUI.BKGCOLOR)
            set(ui_checkbox_xyz, 'Position', [.35 .05 .15 .10])
            set(ui_checkbox_xyz, 'String', 'xyz')
            set(ui_checkbox_xyz, 'Value', false)
            set(ui_checkbox_xyz, 'TooltipString', 'Shows brain regions by position')
            set(ui_checkbox_xyz, 'Callback', {@cb_xyz})
            
            ui_button_show = uicontrol(f, 'Style', 'pushbutton');
            set(ui_button_show, 'Units','normalized')
            set(ui_button_show, 'Position', [.50 .85 .45 .10])
            set(ui_button_show, 'String', 'Show Regions')
            set(ui_button_show, 'TooltipString', 'Show selected brain regions')
            set(ui_button_show, 'Callback', {@cb_show})
            
            ui_button_hide = uicontrol(f, 'Style', 'pushbutton');
            set(ui_button_hide, 'Units','normalized')
            set(ui_button_hide, 'Position', [.50 .75 .45 .10])
            set(ui_button_hide, 'String', 'Hide Regions')
            set(ui_button_hide, 'TooltipString', 'Hide selected brain regions')
            set(ui_button_hide, 'Callback', {@cb_hide})
            
            ui_text = uicontrol(f, 'Style', 'text');
            set(ui_text, 'Units','normalized')
            set(ui_text, 'BackgroundColor', GUI.BKGCOLOR)
            set(ui_text, 'String', 'transparency')
            set(ui_text, 'Position', [.70 .60 .25 .10])
            set(ui_text, 'HorizontalAlignment', 'center')
            set(ui_text, 'FontWeight', 'bold')
            
            ui_button_color = uicontrol(f, 'Style', 'pushbutton');
            set(ui_button_color, 'Units','normalized')
            set(ui_button_color, 'Position', [.50 .50 .15 .10])
            set(ui_button_color, 'String', 'sphere color')
            set(ui_button_color, 'HorizontalAlignment', 'center')
            set(ui_button_color, 'TooltipString', 'Brain region color (applied both to faces and edges)')
            set(ui_button_color, 'Callback', {@cb_color})
            
            ui_slider_alpha = uicontrol(f, 'Style', 'slider');
            set(ui_slider_alpha, 'Units','normalized')
            set(ui_slider_alpha, 'BackgroundColor', GUI.BKGCOLOR)
            set(ui_slider_alpha, 'Position', [.70 .475 .25 .10])
            set(ui_slider_alpha, 'String', 'Brain region transparency')
            set(ui_slider_alpha, 'Min', 0, 'Max',1, 'Value',.5);
            set(ui_slider_alpha, 'TooltipString','Brain region transparency (applied both to faces and edges)')
            set(ui_slider_alpha, 'Callback',{@cb_alpha})
            
            ui_button_facecolor = uicontrol(f, 'Style', 'pushbutton');
            set(ui_button_facecolor, 'Units','normalized')
            set(ui_button_facecolor, 'Position', [.50 .35 .15 .10])
            set(ui_button_facecolor, 'String', 'face color')
            set(ui_button_facecolor, 'HorizontalAlignment', 'center')
            set(ui_button_facecolor, 'TooltipString', 'Brain region face color')
            set(ui_button_facecolor, 'Callback', {@cb_facecolor})
            
            ui_slider_facealpha = uicontrol(f, 'Style', 'slider');
            set(ui_slider_facealpha, 'Units', 'normalized')
            set(ui_slider_facealpha, 'BackgroundColor', GUI.BKGCOLOR)
            set(ui_slider_facealpha, 'Position', [.70 .325 .25 .10])
            set(ui_slider_facealpha, 'String', 'Brain region transparency')
            set(ui_slider_facealpha, 'Min', 0, 'Max', 1, 'Value', .5)
            set(ui_slider_facealpha, 'TooltipString', 'Brain region face transparency')
            set(ui_slider_facealpha, 'Callback', {@cb_facealpha})
            
            ui_button_edgecolor = uicontrol(f, 'Style', 'pushbutton');
            set(ui_button_edgecolor, 'Units', 'normalized')
            set(ui_button_edgecolor, 'Position', [.50 .20 .15 .10])
            set(ui_button_edgecolor, 'String', 'edge color')
            set(ui_button_edgecolor, 'HorizontalAlignment', 'center')
            set(ui_button_edgecolor, 'TooltipString', 'Brain region edge color')
            set(ui_button_edgecolor, 'Callback', {@cb_edgecolor})
            
            ui_slider_edgealpha = uicontrol(f, 'Style', 'slider');
            set(ui_slider_edgealpha, 'Units', 'normalized')
            set(ui_slider_edgealpha, 'BackgroundColor', GUI.BKGCOLOR)
            set(ui_slider_edgealpha, 'Position', [.70 .175 .25 .10])
            set(ui_slider_edgealpha, 'String', 'Brain transparency')
            set(ui_slider_edgealpha, 'Min', 0, 'Max', 1, 'Value', .5)
            set(ui_slider_edgealpha, 'TooltipString', 'Brain region edge transparency')
            set(ui_slider_edgealpha, 'Callback', {@cb_edgealpha})
            
            ui_text_radius = uicontrol(f, 'Style', 'text');
            set(ui_text_radius, 'Units', 'normalized')
            set(ui_text_radius, 'BackgroundColor', GUI.BKGCOLOR)
            set(ui_text_radius, 'Position', [.50 .025 .20 .10])
            set(ui_text_radius, 'String', 'sphere radius ')
            set(ui_text_radius, 'HorizontalAlignment', 'left')
            set(ui_text_radius, 'FontWeight', 'bold')
            
            ui_edit_radius = uicontrol(f, 'Style', 'edit');
            set(ui_edit_radius, 'Units', 'normalized')
            set(ui_edit_radius, 'BackgroundColor', GUI.BKGCOLOR)
            set(ui_edit_radius, 'Position', [.70 .05 .25 .10])
            set(ui_edit_radius, 'HorizontalAlignment', 'center')
            set(ui_edit_radius, 'FontWeight', 'bold')
            set(ui_edit_radius, 'TooltipString', 'Brain region sphere radius')
            set(ui_edit_radius, 'String', '1')
            set(ui_edit_radius, 'Callback', {@cb_radius})
            
            update_list()
            set(f,'Visible','on');
            
            function update_list()
                % get info
                ids = cellfun(@(br) br.getID(), ba.getBrainAtlas().getBrainRegions().getValues(), 'UniformOutput', false); %#ok<PROPLC>
                labels = cellfun(@(br) br.getLabel(), ba.getBrainAtlas().getBrainRegions().getValues(), 'UniformOutput', false);
                xs = cellfun(@(br) br.getX(), ba.getBrainAtlas().getBrainRegions().getValues(), 'UniformOutput', false);
                ys = cellfun(@(br) br.getY(), ba.getBrainAtlas().getBrainRegions().getValues(), 'UniformOutput', false);
                zs = cellfun(@(br) br.getZ(), ba.getBrainAtlas().getBrainRegions().getValues(), 'UniformOutput', false);
                
                % Set list names
                if get(ui_checkbox_id, 'Value')
                    set(ui_list, 'String', ids) %#ok<PROPLC>
                elseif get(ui_checkbox_label, 'Value')
                    set(ui_list, 'String', labels)
                elseif get(ui_checkbox_xyz, 'Value')
                    xyz = cell(1, ba.getBrainAtlas().getBrainRegions().length());
                    for j = 1:1:ba.getBrainAtlas().getBrainRegions().length()
                        xyz{j} = [num2str(xs{j}) '   ' ...
                            num2str(ys{j}) '   ' ...
                            num2str(zs{j})];
                    end
                    set(ui_list, 'String', xyz)
                end
            end
            function cb_list(~, ~)  % (src, event)
                update_list()
            end
            function cb_id(~,~)  % (src,event)
                set(ui_checkbox_id, 'Value', true)
                set(ui_checkbox_id, 'FontWeight', 'bold')

                set(ui_checkbox_label, 'Value', false)
                set(ui_checkbox_label, 'FontWeight', 'normal')
                
                set(ui_checkbox_xyz, 'Value', false)
                set(ui_checkbox_xyz, 'FontWeight', 'normal')
                
                update_list()
            end
            function cb_label(~, ~)  % (src, event)
                set(ui_checkbox_id, 'Value', false)
                set(ui_checkbox_id, 'FontWeight', 'normal')

                set(ui_checkbox_label, 'Value', true)
                set(ui_checkbox_label, 'FontWeight', 'bold')
                                
                set(ui_checkbox_xyz, 'Value', false)
                set(ui_checkbox_xyz, 'FontWeight', 'normal')
                
                update_list()
            end
            function cb_xyz(~, ~)  % (src, event)
                set(ui_checkbox_id, 'Value', false)
                set(ui_checkbox_id, 'FontWeight', 'normal')

                set(ui_checkbox_label, 'Value', false)
                set(ui_checkbox_label, 'FontWeight', 'normal')
                
                set(ui_checkbox_xyz, 'Value', true)
                set(ui_checkbox_xyz, 'FontWeight', 'bold')
                
                update_list()
            end
            function cb_show(~, ~)  % (src, event)
                ba.br_sphs_on(get_br_list())
            end
            function cb_hide(~, ~)  % (src, event)
                ba.br_sphs_off(get_br_list())
            end
            function cb_color(~, ~)  %  (src, event)
                color = uisetcolor();
                
                if length(color) == 3
                    ba.br_sphs(get_br_list(), 'color', color)
                end
            end
            function cb_facecolor(~, ~)  % (src, event)
                color = uisetcolor();
                
                if length(color) == 3
                    ba.br_sphs(get_br_list(), 'FaceColor', color)
                end
            end
            function cb_edgecolor(~, ~)  % (src, event)
                color = uisetcolor();
                
                if length(color) == 3
                    ba.br_sphs(get_br_list(), 'EdgeColor', color)
                end
            end
            function cb_alpha(~, ~)  % (src, event)
                ba.br_sphs(get_br_list(), 'alpha', get(ui_slider_alpha, 'Value'))
                set(ui_slider_facealpha, 'Value', get(ui_slider_alpha, 'Value'))
                set(ui_slider_edgealpha, 'Value', get(ui_slider_alpha, 'Value'))
            end
            function cb_facealpha(~, ~)  % (src, event)
                ba.br_sphs(get_br_list(), 'FaceAlpha', get(ui_slider_facealpha, 'Value'))
            end
            function cb_edgealpha(~, ~)  % (src, event)
                ba.br_sphs(get_br_list(), 'EdgeAlpha', get(ui_slider_edgealpha, 'Value'))
            end
            function cb_radius(~, ~)  % (src, event)
                R = real(str2double(get(ui_edit_radius, 'String')));
                
                if isempty(R) || R <= 0
                    set(ui_edit_radius, 'String', '1')
                    R = 1;
                end
                ba.br_sphs(get_br_list(), 'r', R)
            end
            function bri = get_br_list()
                if ba.getBrainAtlas().getBrainRegions().length() > 0
                    bri = get(ui_list, 'Value');
                else
                    bri = [];
                end
            end
        end
    end
    methods  % Functions ids
        function h = br_id(ba, i, varargin)
            % BR_ID displays brain region as id
            %
            % BR_ID(BA, I) plots the brain regions I as an id, if not plotted.
            %
            % H = BR_ID(BA, I) returns the handle to the id denoting the brain
            %   region I.
            %
            % BR_ID(BA, I, 'PropertyName', PropertyValue, ...) 
            % sets the property of the id's PropertyName to PropertyValue.
            % All standard plot properties of text can be used and also the
            % id properties listed below.
            % Id-specific properties:
            %   Color   -   Id font color
            %   Size    -   Id font size
            %   Name    -   Id font name
            % The id properties can also be changed when hidden.
            %
            % See also text, br_id_on, br_id_off.
            
            ba.set_axes();
            
            % center coordinates and label
            X = ba.getBrainAtlas().getBrainRegions().getValue(i).getX();
            Y = ba.getBrainAtlas().getBrainRegions().getValue(i).getY();
            Z = ba.getBrainAtlas().getBrainRegions().getValue(i).getZ();
            ID = ba.getBrainAtlas().getBrainRegions().getValue(i).getID();
            
            % display the text
            if ~ishandle(ba.ids.h(i))
                
                ba.ids.h(i) = text( ...
                    X, ...
                    Y, ...
                    Z, ...
                    ID,...
                    'Parent', ba.get_axes(), ...
                    'FontSize', PlotBrainAtlas.INIT_ID_FONT_SIZE,...
                    'Color' ,PlotBrainAtlas.INIT_ID_FONT_COLOR,...
                    'FontName', PlotBrainAtlas.INIT_ID_FONT_NAME,...
                    'Interpreter', PlotBrainAtlas.INIT_ID_FONT_INTERPRETER);
            else
                if ~isequal(ba.ids.X(i), {X}) || ~isequal(ba.ids.Y(i), {Y}) || ~isequal(ba.ids.Z(i), {Z}) || ~strcmp(ba.ids.ID(i), ID)
                    
                    set(ba.ids.h(i), 'Position', [X Y Z]);
                    set(ba.ids.h(i), 'String', ID);
                end
            end
            
            % saves new data
            ba.ids.X(i) = num2cell(X);
            ba.ids.Y(i) = num2cell(Y);
            ba.ids.Z(i) = num2cell(Z);
            ba.ids.ID(i) = {ID};
            
            % sets properties
            for n = 1:2:length(varargin)
                switch lower(varargin{n})
                    case 'color'
                        set(ba.ids.h(i), 'Color', varargin{n + 1});
                    case 'size'
                        set(ba.ids.h(i), 'FontSize', varargin{n + 1});
                    case 'name'
                        set(ba.ids.h(i), 'FontName', varargin{n + 1});
                    otherwise
                        set(ba.ids.h(i), varargin{n}, varargin{n + 1});
                end
            end
            
            % output if needed
            if nargout>0
                h = ba.ids.h(i);
            end
        end
        function br_id_on(ba, i)
            % BR_ID_ON shows an id
            %
            % BR_ID_ON(BA, I) shows the id denoting the brain region I.
            %
            % See also br_id, br_id_off.
            
            if ishandle(ba.ids.h(i))
                set(ba.ids.h(i), 'Visible', 'on')
            end
        end
        function br_id_off(ba, i)
            % BR_ID_OFF hides an id
            %
            % BR_ID_OFF(BA, I) hides the id denoting the brain region I.
            %
            % See also br_id, br_id_on.
            
            if ishandle(ba.labs.h(i))
                set(ba.labs.h(i), 'Visible', 'off')
            end
        end
        function bool = br_id_is_on(ba, i)
            % BR_ID_IS_ON checks if id is visible
            %
            % BOOL = BR_ID_IS_ON(BA, I) returns true if the id denoting
            % the brain region I is visible and false otherwise.
            %
            % See also PlotBrainAtlas.
            
            bool = ishandle(ba.ids.h(i)) && strcmpi(get(ba.ids.h(i), 'Visible'), 'on');
        end
        function br_ids(ba, i_vec, varargin)
            % BR_IDS displays multiple brain regions as ids
            %
            % BR_IDS(BA, I_VEC) plots the ids denoting the brain regions
            % specified in I_VEC, if not plotted.
            %
            % BR_IDS(BA, []) plots the ids for all possible brain regions.
            %
            % BR_IDS(BA, I_VEC, 'PropertyName', PropertyValue, ...) sets the property
            % of the multiple ids PropertyName to PropertyValue.
            % All standard plot properties of text can be used and also the
            % id properties listed below.
            % Id-specific properties:
            %   Color   -   Id font color
            %   Size    -   Id font size
            %   Name    -   Id font name
            % The id properties can also be changed when hidden.
            %
            % See also text, br_ids_on, br_ids_off.
            
            % FontSize - FontName - Color - Interpreter
            for n = 1:2:length(varargin)
                switch lower(varargin{n})
                    case 'fontsize'
                        FontSize = varargin{n+1};
                        nfontsize = n+1;
                    case 'fontname'
                        FontName = varargin{n+1};
                        nfontname = n+1;
                    case 'color'
                        Color = varargin{n+1};
                        ncolor = n+1;
                    case 'interpreter'
                        INTERP = varargin{n+1};
                        ninterp = n+1;
                end
            end
            
            if nargin<2 || isempty(i_vec)
                i_vec = 1:1:ba.getBrainAtlas().getBrainRegions().length();
            end
            
            for m = 1:1:length(i_vec)
                if exist('FontSize', 'var') && numel(FontSize) == length(i_vec)
                    varargin{nfontsize} = FontSize(m);
                end
                if exist('FontName', 'var') && iscell(FontName) && numel(FontName) == length(i_vec)
                    varargin{nfontname} = FontName{m};
                end
                if exist('Color', 'var') && size(Color, 1) == length(i_vec) && size(Color, 2) == 3
                    varargin{ncolor} = Color(m, :);
                end
                if exist('INTERP', 'var') && iscell(INTERP) && numel(INTERP) == length(i_vec)
                    varargin{ninterp} = INTERP{m};
                end
                
                ba.br_id(i_vec(m), varargin{:})
            end
        end
        function br_ids_on(ba, i_vec)
            % BR_IDS_ON shows multiple ids
            %
            % BR_IDS_ON(BA, I_VEC) shows multiple ids denoting the
            % brain regions specified in I_VEC.
            %
            % BR_IDS_ON(BA, []) shows the ids denoting all possible
            % brain region combinations.
            %
            % See also br_ids_off, br_ids.
            
            if nargin<2 || isempty(i_vec)
                i_vec = 1:1:ba.getBrainAtlas().getBrainRegions().length();
            end
            
            for m = 1:1:length(i_vec)
                ba.br_id_on(i_vec(m))
            end
        end
        function br_ids_off(ba, i_vec)
            % BR_IDS_OFF hides multiple ids
            %
            % BR_IDS_OFF(BA,I_VEC) hides multiple ids denoting the
            % brain regions specified in I_VEC.
            %
            % BR_LABS_OFF(BA,[]) hides the ids denoting all possible
            % brain region combinations.
            %
            % See also br_ids_on, br_ids.
            
            if nargin<2 || isempty(i_vec)
                i_vec = 1:1:ba.getBrainAtlas().getBrainRegions().length();
            end
            
            for m = 1:1:length(i_vec)
                ba.br_id_off(i_vec(m))
            end
        end
        function i = get_id_i(ba, h)
            % GET_ID_I returns index of brain region corresponding to id
            %
            % I = GET_ID_I(BA,H) returns the index of the brain regions
            % corresponding to the id with handle H.
            %
            % See also get_id_br.
            
            i = NaN;
            if ~isempty(h)
                for j = 1:1:ba.getBrainAtlas().getBrainRegions().length()
                    if h == ba.ids.h(j)
                        i = j;
                    end
                end
            end
        end
        function br = get_id_br(ba, h)
            % GET_ID_BR returns brain region corresponding to id
            %
            % BR = GET_ID_BR(BA,H) returns the properties of the brain region
            % BR corresponding to the id with handle H.
            %
            % See also get_id_i.
            
            i = ba.get_id_i(h);
            br = ba.getBrainAtlas().get(i);
        end
        function br_ids_settings(ba, i_vec, varargin)
            % BR_IDS_SETTINGS sets ids' properties
            %
            % BR_IDS_SETTINGS(BA) allows the user to interactively
            % change the ids settings via a graphical user interface.
            %
            % BR_IDS_SETTINGS(BA, 'PropertyName', PropertyValue) sets the property
            % of the GUI's PropertyName to PropertyValue.
            % Admissible properties are:
            %	FigPosition	-  normalized position of the GUI on the screen
            %                  [X0 Y0 DX DY]
            %	FigColor	-  background color of the GUI
            %	FigName     -  name of the GUI
            
            if nargin<2
                i_vec = [];
            end
            
            FigPosition = get_from_varargin([.65 .45 .30 .30], 'figposition', varargin);
            FigColor = get_from_varargin(GUI.BKGCOLOR, 'figcolor', varargin);
            FigName = get_from_varargin('Brain Region ID Settings', 'figname', varargin);
            
            % create a figure
            if isempty(ba.f_ids_settings) || ~ishandle(ba.f_ids_settings)
                ba.f_ids_settings = figure('Visible', 'off');
            end
            f = ba.f_ids_settings;
            set(f, 'units', 'normalized')
            set(f, 'Position', FigPosition)
            set(f, 'Color', FigColor)
            set(f, 'Name', FigName)
            set(f, 'MenuBar', 'none')
            set(f, 'Toolbar', 'none')
            set(f, 'NumberTitle', 'off')
            set(f, 'DockControls', 'off')
            
            % Initialization
            ui_list = uicontrol(f, 'Style', 'listbox');
            set(ui_list, 'Units', 'normalized')
            set(ui_list, 'BackgroundColor', GUI.BKGCOLOR)
            set(ui_list, 'Value', i_vec)
            set(ui_list, 'Max', 2, 'Min',0)
            set(ui_list, 'BackgroundColor', [1 1 1])
            set(ui_list, 'Position', [.05 .15 .40 .80])
            set(ui_list, 'TooltipString', 'Select brain regions');
            set(ui_list, 'Callback', {@cb_list});
            
            ui_checkbox_id = uicontrol(f, 'Style', 'checkbox');
            set(ui_checkbox_id, 'Units', 'normalized')
            set(ui_checkbox_id, 'BackgroundColor', GUI.BKGCOLOR)
            set(ui_checkbox_id, 'Position', [.05 .05 .20 .10])
            set(ui_checkbox_id, 'String', 'id')
            set(ui_checkbox_id, 'Value', true)
            set(ui_checkbox_id, 'FontWeight', 'bold')
            set(ui_checkbox_id, 'TooltipString', 'Shows brain regions by id')
            set(ui_checkbox_id, 'Callback', {@cb_id})

            ui_checkbox_label = uicontrol(f, 'Style', 'checkbox');
            set(ui_checkbox_label, 'Units', 'normalized')
            set(ui_checkbox_label, 'BackgroundColor', GUI.BKGCOLOR)
            set(ui_checkbox_label, 'Position', [.20 .05 .15 .10])
            set(ui_checkbox_label, 'String', 'label')
            set(ui_checkbox_label, 'Value', false)
            set(ui_checkbox_label, 'TooltipString', 'Shows brain regions by label')
            set(ui_checkbox_label, 'Callback', {@cb_label})
            
            ui_checkbox_xyz = uicontrol(f, 'Style', 'checkbox');
            set(ui_checkbox_xyz, 'Units', 'normalized')
            set(ui_checkbox_xyz, 'BackgroundColor', GUI.BKGCOLOR)
            set(ui_checkbox_xyz, 'Position', [.35 .05 .15 .10])
            set(ui_checkbox_xyz, 'String', 'xyz')
            set(ui_checkbox_xyz, 'Value', false)
            set(ui_checkbox_xyz, 'TooltipString', 'Shows brain regions by name')
            set(ui_checkbox_xyz, 'Callback', {@cb_xyz})

            ui_button_show = uicontrol(f, 'Style', 'pushbutton');
            set(ui_button_show, 'Units','normalized')
            set(ui_button_show, 'Position', [.50 .85 .45 .10])
            set(ui_button_show, 'String', 'Show Regions')
            set(ui_button_show, 'TooltipString', 'Show selected brain regions')
            set(ui_button_show, 'Callback', {@cb_show})
            
            ui_button_hide = uicontrol(f, 'Style', 'pushbutton');
            set(ui_button_hide, 'Units', 'normalized')
            set(ui_button_hide, 'Position', [.50 .75 .45 .10])
            set(ui_button_hide, 'String', 'Hide Regions')
            set(ui_button_hide, 'TooltipString', 'Hide selected brain regions')
            set(ui_button_hide, 'Callback', {@cb_hide})

            ui_button_font = uicontrol(f,'Style', 'pushbutton');
            set(ui_button_font, 'Units', 'normalized')
            set(ui_button_font,'Position',[.50 .50 .45 .10])
            set(ui_button_font,'String','Font')
            set(ui_button_font,'TooltipString','Brain regions ids font')
            set(ui_button_font,'Callback',{@cb_font})
            
            ui_button_color = uicontrol(f, 'Style', 'pushbutton');
            set(ui_button_color, 'Units', 'normalized')
            set(ui_button_color, 'Position' ,[.50 .35 .45 .10])
            set(ui_button_color, 'String', 'Font Color')
            set(ui_button_color, 'TooltipString', 'Brain regions ids color')
            set(ui_button_color, 'Callback', {@cb_color})
            
            ui_text_interpreter = uicontrol(f, 'Style', 'text');
            set(ui_text_interpreter, 'Units', 'normalized')
            set(ui_text_interpreter, 'BackgroundColor', GUI.BKGCOLOR)
            set(ui_text_interpreter, 'Position', [.50 .175 .20 .10])
            set(ui_text_interpreter, 'String', 'interpreter')
            set(ui_text_interpreter, 'HorizontalAlignment', 'left')
            set(ui_text_interpreter, 'FontWeight', 'bold')
            
            ui_popup_interpreter = uicontrol(f, 'Style', 'popup', 'String', {''});
            set(ui_popup_interpreter, 'Units', 'normalized')
            set(ui_popup_interpreter, 'BackgroundColor', GUI.BKGCOLOR)
            set(ui_popup_interpreter, 'Position', [.75 .20 .20 .10])
            set(ui_popup_interpreter, 'String', {'none', 'tex', 'latex'})
            set(ui_popup_interpreter, 'Value', 2)
            set(ui_popup_interpreter, 'TooltipString', 'Brain regions ids interpreter');
            set(ui_popup_interpreter, 'Callback', {@cb_interpreter})
            
            update_list()
            set(f,'Visible','on')

            function update_list()
                % get info
                ids = cellfun(@(br) br.getID(), ba.getBrainAtlas().getBrainRegions().getValues(), 'UniformOutput', false); %#ok<PROPLC>
                labels = cellfun(@(br) br.getLabel(), ba.getBrainAtlas().getBrainRegions().getValues(), 'UniformOutput', false);
                xs = cellfun(@(br) br.getX(), ba.getBrainAtlas().getBrainRegions().getValues(), 'UniformOutput', false);
                ys = cellfun(@(br) br.getY(), ba.getBrainAtlas().getBrainRegions().getValues(), 'UniformOutput', false);
                zs = cellfun(@(br) br.getZ(), ba.getBrainAtlas().getBrainRegions().getValues(), 'UniformOutput', false);
                
                % Set list names
                if get(ui_checkbox_id, 'Value')
                    set(ui_list, 'String', ids) %#ok<PROPLC>
                elseif get(ui_checkbox_label, 'Value')
                    set(ui_list, 'String', labels)
                elseif get(ui_checkbox_xyz, 'Value')
                    xyz = cell(1, ba.getBrainAtlas().getBrainRegions().length());
                    for j = 1:1:ba.getBrainAtlas().getBrainRegions().length()
                        xyz{j} = [num2str(xs{j}) '   ' ...
                            num2str(ys{j}) '   ' ...
                            num2str(zs{j})];
                    end
                    set(ui_list, 'String', xyz)
                end
            end
            function cb_list(~, ~)  % (src, event)
                update_list()
            end
            function cb_id(~,~)  % (src,event)
                set(ui_checkbox_id, 'Value', true)
                set(ui_checkbox_id, 'FontWeight', 'bold')

                set(ui_checkbox_label, 'Value', false)
                set(ui_checkbox_label, 'FontWeight', 'normal')
                
                set(ui_checkbox_xyz, 'Value', false)
                set(ui_checkbox_xyz, 'FontWeight', 'normal')
                
                update_list()
            end
            function cb_label(~, ~)  % (src, event)
                set(ui_checkbox_id, 'Value', false)
                set(ui_checkbox_id, 'FontWeight', 'normal')

                set(ui_checkbox_label, 'Value', true)
                set(ui_checkbox_label, 'FontWeight', 'bold')
                                
                set(ui_checkbox_xyz, 'Value', false)
                set(ui_checkbox_xyz, 'FontWeight', 'normal')
                
                update_list()
            end
            function cb_xyz(~, ~)  % (src, event)
                set(ui_checkbox_id, 'Value', false)
                set(ui_checkbox_id, 'FontWeight', 'normal')

                set(ui_checkbox_label, 'Value', false)
                set(ui_checkbox_label, 'FontWeight', 'normal')
                
                set(ui_checkbox_xyz, 'Value', true)
                set(ui_checkbox_xyz, 'FontWeight', 'bold')
                
                update_list()
            end
            function cb_show(~, ~)  % (src, event)
                ba.br_ids(get_br_list())
                ba.br_ids_on(get_br_list())
            end
            function cb_hide(~, ~)  % (src, event)
                ba.br_ids_off(get_br_list())
            end
            function cb_color(~, ~)  % (src, event)
                color = uisetcolor();
                
                if length(color) == 3
                    ba.br_ids(get_br_list(), 'color', color)
                end
            end
            function cb_font(~,~)  % (src,event)
                font = uisetfont;
                
                if isstruct(font)
                    ba.br_ids(get_br_list(), 'FontSize', font.FontSize, ...
                        'FontName', font.FontName, ...
                        'FontWeight', font.FontWeight, ...
                        'FontAngle', font.FontAngle, ...
                        'FontUnits', font.FontUnits)
                end
            end
            function cb_interpreter(~,~)  %  (src,event)
                string = get(ui_popup_interpreter, 'String');
                interpreter = string{get(ui_popup_interpreter, 'Value')};
                ba.br_ids(get_br_list(), 'interpreter', interpreter)
            end
            function bri = get_br_list()
                if ba.getBrainAtlas().getBrainRegions().length() > 0
                    bri = get(ui_list, 'Value');
                else
                    bri = [];
                end
            end
        end
    end
    methods  % Functions labels
        function h = br_lab(ba, i, varargin)
            % BR_LAB displays brain region as label
            %
            % BR_LAB(BA, I) plots the brain regions I as a label, if not plotted.
            %
            % H = BR_LAB(BA, I) returns the handle to the label denoting the brain
            % region I.
            %
            % BR_LAB(BA, I, 'PropertyName', PropertyValue, ...) 
            % sets the property of the label's PropertyName to PropertyValue.
            % All standard plot properties of text can be used and also the
            % label properties listed below.
            % Label-specific properties:
            %	Color   -   Label font color
            %	Size    -   Label font size
            %	Name    -   Label font name
            % The label properties can also be changed when hidden.
            %
            % See also text, br_lab_on, br_lab_off.
            
            ba.set_axes();
            
            % center coordinates and label
            X = ba.getBrainAtlas().getBrainRegions().getValue(i).getX();
            Y = ba.getBrainAtlas().getBrainRegions().getValue(i).getY();
            Z = ba.getBrainAtlas().getBrainRegions().getValue(i).getZ();
            LAB = ba.getBrainAtlas().getBrainRegions().getValue(i).getLabel();
            
            % display the text
            if ~ishandle(ba.labs.h(i))
                
                ba.labs.h(i) = text( ...
                    X, ...
                    Y, ...
                    Z, ...
                    LAB,...
                    'Parent', ba.get_axes(), ...
                    'FontSize', PlotBrainAtlas.INIT_LAB_FONT_SIZE,...
                    'Color' ,PlotBrainAtlas.INIT_LAB_FONT_COLOR,...
                    'FontName', PlotBrainAtlas.INIT_LAB_FONT_NAME,...
                    'Interpreter', PlotBrainAtlas.INIT_LAB_FONT_INTERPRETER);
            else
                if ~isequal(ba.labs.X(i), {X}) || ~isequal(ba.labs.Y(i), {Y}) || ~isequal(ba.labs.Z(i), {Z}) || ~strcmp(ba.labs.LAB(i), LAB)
                    
                    set(ba.labs.h(i), 'Position', [X Y Z]);
                    set(ba.labs.h(i), 'String', LAB);
                end
            end
            
            % saves new data
            ba.labs.X(i) = num2cell(X);
            ba.labs.Y(i) = num2cell(Y);
            ba.labs.Z(i) = num2cell(Z);
            ba.labs.LAB(i) = {LAB};
            
            % sets properties
            for n = 1:2:length(varargin)
                switch lower(varargin{n})
                    case 'color'
                        set(ba.labs.h(i), 'Color', varargin{n + 1});
                    case 'size'
                        set(ba.labs.h(i), 'FontSize', varargin{n + 1});
                    case 'name'
                        set(ba.labs.h(i), 'FontName', varargin{n + 1});
                    otherwise
                        set(ba.labs.h(i), varargin{n}, varargin{n + 1});
                end
            end
            
            % output if needed
            if nargout>0
                h = ba.labs.h(i);
            end
        end
        function br_lab_on(ba, i)
            % BR_LAB_ON shows a label
            %
            % BR_LAB_ON(BA, I) shows the label denoting the brain region I.
            %
            % See also br_lab, br_lab_off.
            
            if ishandle(ba.labs.h(i))
                set(ba.labs.h(i), 'Visible', 'on')
            end
        end
        function br_lab_off(ba, i)
            % BR_LAB_OFF hides a label
            %
            % BR_LAB_OFF(BA, I) hides the label denoting the brain region I.
            %
            % See also br_lab, br_lab_on.
            
            if ishandle(ba.labs.h(i))
                set(ba.labs.h(i), 'Visible', 'off')
            end
        end
        function bool = br_lab_is_on(ba, i)
            % BR_LAB_IS_ON checks if label is visible
            %
            % BOOL = BR_LAB_IS_ON(BA, I) returns true if the label denoting
            % the brain region I is visible and false otherwise.
            %
            % See also PlotBrainAtlas.
            
            bool = ishandle(ba.labs.h(i)) && strcmpi(get(ba.labs.h(i), 'Visible'), 'on');
        end
        function br_labs(ba, i_vec, varargin)
            % BR_LABS displays multiple brain regions as labels
            %
            % BR_LABS(BA, I_VEC) plots the labels denoting the brain regions
            % specified in I_VEC, if not plotted.
            %
            % BR_LABS(BA, []) plots the labels for all possible brain regions.
            %
            % BR_LABS(BA, I_VEC, 'PropertyName', PropertyValue) sets the property
            % of the multiple labels' PropertyName to PropertyValue.
            % All standard plot properties of text can be used and also the
            % label properties listed below.
            % Label-specific properties:
            %	Color   -   Label font color
            %	Size    -   Label font size
            %	Name    -   Label font name
            % The label properties can also be changed when hidden.
            %
            % See also text, br_labs_on, br_labs_off.
            
            % FontSize - FontName - Color - Interpreter
            for n = 1:2:length(varargin)
                switch lower(varargin{n})
                    case 'fontsize'
                        FontSize = varargin{n+1};
                        nfontsize = n+1;
                    case 'fontname'
                        FontName = varargin{n+1};
                        nfontname = n+1;
                    case 'color'
                        Color = varargin{n+1};
                        ncolor = n+1;
                    case 'interpreter'
                        INTERP = varargin{n+1};
                        ninterp = n+1;
                end
            end
            
            if nargin<2 || isempty(i_vec)
                i_vec = 1:1:ba.getBrainAtlas().getBrainRegions().length();
            end
            
            for m = 1:1:length(i_vec)
                if exist('FontSize','var') && numel(FontSize) == length(i_vec)
                    varargin{nfontsize} = FontSize(m);
                end
                if exist('FontName', 'var') && iscell(FontName) && numel(FontName) == length(i_vec)
                    varargin{nfontname} = FontName{m};
                end
                if exist('Color', 'var') && size(Color, 1) == length(i_vec) && size(Color, 2) == 3
                    varargin{ncolor} = Color(m, :);
                end
                if exist('INTERP', 'var') && iscell(INTERP) && numel(INTERP) == length(i_vec)
                    varargin{ninterp} = INTERP{m};
                end
                
                ba.br_lab(i_vec(m), varargin{:})
            end
        end
        function br_labs_on(ba, i_vec)
            % BR_LABS_ON shows multiple labels
            %
            % BR_LABS_ON(BA, I_VEC) shows multiple labels denoting the
            % brain regions specified in I_VEC.
            %
            % BR_LABS_ON(BA, []) shows the labels denoting all possible
            % brain region combinations.
            %
            % See also br_labs_off, br_labs.
            
            if nargin<2 || isempty(i_vec)
                i_vec = 1:1:ba.getBrainAtlas().getBrainRegions().length();
            end
            
            for m = 1:1:length(i_vec)
                ba.br_lab_on(i_vec(m))
            end
        end
        function br_labs_off(ba, i_vec)
            % BR_LABS_OFF hides multiple labels
            %
            % BR_LABS_OFF(BA, I_VEC) hides multiple labels denoting the
            % brain regions specified in I_VEC.
            %
            % BR_LABS_OFF(BA, []) hides the labels denoting all possible
            % brain region combinations.
            %
            % See also br_labs_on, br_labs.
            
            if nargin<2 || isempty(i_vec)
                i_vec = 1:1:ba.getBrainAtlas().getBrainRegions().length();
            end
            
            for m = 1:1:length(i_vec)
                ba.br_lab_off(i_vec(m))
            end
        end
        function i = get_lab_i(ba, h)
            % GET_LAB_I returns index of brain region corresponding to label
            %
            % I = GET_LAB_I(BA, H) returns the index of the brain regions
            % corresponding to the label with handle H.
            %
            % See also get_lab_br.
            
            i = NaN;
            if ~isempty(h)
                for j = 1:1:ba.getBrainAtlas().getBrainRegions().length()
                    if h == ba.labs.h(j)
                        i = j;
                    end
                end
            end
        end
        function br = get_lab_br(ba, h)
            % GET_LAB_BR returns brain region corresponding to label
            %
            % BR = GET_LAB_BR(BA, H) returns the properties of the brain region
            % BR corresponding to the label with handle H.
            %
            % See also get_lab_i.
            
            i = ba.get_lab_i(h);
            br = ba.getBrainAtlas().get(i);
        end
        function br_labs_settings(ba, i_vec, varargin)
            % BR_LABS_SETTINGS panel to set label properties
            %
            % BR_LABS_SETTINGS(BA) allows the user to interactively
            % change the label settings via a graphical user interface.
            %
            % BR_LABS_SETTINGS(BA, 'PropertyName', PropertyValue, ...) sets 
            % the property of the GUI's PropertyName to PropertyValue.
            % Admissible properties are:
            %     FigPosition  -   normalized position of the GUI on the screen 
            %                      [X0 Y0 DX DY]
            %     FigColor     -   background color of the GUI
            %     FigName      -   name of the GUI
            
            if nargin<2
                i_vec = [];
            end
            
            FigPosition = get_from_varargin([.65 .45 .30 .30], 'figposition', varargin);
            FigColor = get_from_varargin(GUI.BKGCOLOR, 'figcolor', varargin);
            FigName = get_from_varargin('Brain Region Label Settings', 'figname', varargin);
            
            % create a figure
            if isempty(ba.f_labs_settings) || ~ishandle(ba.f_labs_settings)
                ba.f_labs_settings = figure('Visible', 'off');
            end
            f = ba.f_labs_settings;
            set(f,'units', 'normalized')
            set(f,'Position', FigPosition)
            set(f,'Color', FigColor)
            set(f,'Name', FigName)
            set(f,'MenuBar', 'none')
            set(f,'Toolbar', 'none')
            set(f,'NumberTitle', 'off')
            set(f,'DockControls', 'off')
            
            % Initialization
            ui_list = uicontrol(f, 'Style', 'listbox');
            set(ui_list, 'Units', 'normalized')
            set(ui_list, 'BackgroundColor', GUI.BKGCOLOR)
            set(ui_list, 'Value', i_vec)
            set(ui_list, 'Max', 2, 'Min',0)
            set(ui_list, 'BackgroundColor', [1 1 1])
            set(ui_list, 'Position', [.05 .15 .40 .80])
            set(ui_list, 'TooltipString', 'Select brain regions');
            set(ui_list, 'Callback', {@cb_list});
            
            ui_checkbox_id = uicontrol(f, 'Style', 'checkbox');
            set(ui_checkbox_id, 'Units', 'normalized')
            set(ui_checkbox_id, 'BackgroundColor', GUI.BKGCOLOR)
            set(ui_checkbox_id, 'Position', [.05 .05 .20 .10])
            set(ui_checkbox_id, 'String', 'id')
            set(ui_checkbox_id, 'Value', true)
            set(ui_checkbox_id, 'FontWeight', 'bold')
            set(ui_checkbox_id, 'TooltipString', 'Shows brain regions by id')
            set(ui_checkbox_id, 'Callback', {@cb_id})

            ui_checkbox_label = uicontrol(f, 'Style', 'checkbox');
            set(ui_checkbox_label, 'Units', 'normalized')
            set(ui_checkbox_label, 'BackgroundColor', GUI.BKGCOLOR)
            set(ui_checkbox_label, 'Position', [.20 .05 .15 .10])
            set(ui_checkbox_label, 'String', 'label')
            set(ui_checkbox_label, 'Value', false)
            set(ui_checkbox_label, 'TooltipString', 'Shows brain regions by label')
            set(ui_checkbox_label, 'Callback', {@cb_label})
            
            ui_checkbox_xyz = uicontrol(f, 'Style', 'checkbox');
            set(ui_checkbox_xyz, 'Units', 'normalized')
            set(ui_checkbox_xyz, 'BackgroundColor', GUI.BKGCOLOR)
            set(ui_checkbox_xyz, 'Position', [.35 .05 .15 .10])
            set(ui_checkbox_xyz, 'String', 'xyz')
            set(ui_checkbox_xyz, 'Value', false)
            set(ui_checkbox_xyz, 'TooltipString', 'Shows brain regions by name')
            set(ui_checkbox_xyz, 'Callback', {@cb_xyz})

            ui_button_show = uicontrol(f, 'Style', 'pushbutton');
            set(ui_button_show, 'Units','normalized')
            set(ui_button_show, 'Position', [.50 .85 .45 .10])
            set(ui_button_show, 'String', 'Show Regions')
            set(ui_button_show, 'TooltipString', 'Show selected brain regions')
            set(ui_button_show, 'Callback', {@cb_show})
            
            ui_button_hide = uicontrol(f, 'Style', 'pushbutton');
            set(ui_button_hide, 'Units', 'normalized')
            set(ui_button_hide, 'Position', [.50 .75 .45 .10])
            set(ui_button_hide, 'String', 'Hide Regions')
            set(ui_button_hide, 'TooltipString', 'Hide selected brain regions')
            set(ui_button_hide, 'Callback', {@cb_hide})

            ui_button_font = uicontrol(f,'Style', 'pushbutton');
            set(ui_button_font, 'Units', 'normalized')
            set(ui_button_font,'Position',[.50 .50 .45 .10])
            set(ui_button_font,'String','Font')
            set(ui_button_font,'TooltipString','Brain regions labels font')
            set(ui_button_font,'Callback',{@cb_font})
            
            ui_button_color = uicontrol(f, 'Style', 'pushbutton');
            set(ui_button_color, 'Units', 'normalized')
            set(ui_button_color, 'Position' ,[.50 .35 .45 .10])
            set(ui_button_color, 'String', 'Font Color')
            set(ui_button_color, 'TooltipString', 'Brain regions labels color')
            set(ui_button_color, 'Callback', {@cb_color})
            
            ui_text_interpreter = uicontrol(f, 'Style', 'text');
            set(ui_text_interpreter, 'Units', 'normalized')
            set(ui_text_interpreter, 'BackgroundColor', GUI.BKGCOLOR)
            set(ui_text_interpreter, 'Position', [.50 .175 .20 .10])
            set(ui_text_interpreter, 'String', 'interpreter')
            set(ui_text_interpreter, 'HorizontalAlignment', 'left')
            set(ui_text_interpreter, 'FontWeight', 'bold')
            
            ui_popup_interpreter = uicontrol(f, 'Style', 'popup', 'String', {''});
            set(ui_popup_interpreter, 'Units', 'normalized')
            set(ui_popup_interpreter, 'BackgroundColor', GUI.BKGCOLOR)
            set(ui_popup_interpreter, 'Position', [.75 .20 .20 .10])
            set(ui_popup_interpreter, 'String', {'none', 'tex', 'latex'})
            set(ui_popup_interpreter, 'Value', 2)
            set(ui_popup_interpreter, 'TooltipString', 'Brain regions labels interpreter');
            set(ui_popup_interpreter, 'Callback', {@cb_interpreter})
            
            update_list()
            set(f,'Visible','on')

            function update_list()
                % get info
                ids = cellfun(@(br) br.getID(), ba.getBrainAtlas().getBrainRegions().getValues(), 'UniformOutput', false); %#ok<PROPLC>
                labels = cellfun(@(br) br.getLabel(), ba.getBrainAtlas().getBrainRegions().getValues(), 'UniformOutput', false);
                xs = cellfun(@(br) br.getX(), ba.getBrainAtlas().getBrainRegions().getValues(), 'UniformOutput', false);
                ys = cellfun(@(br) br.getY(), ba.getBrainAtlas().getBrainRegions().getValues(), 'UniformOutput', false);
                zs = cellfun(@(br) br.getZ(), ba.getBrainAtlas().getBrainRegions().getValues(), 'UniformOutput', false);
                
                % Set list names
                if get(ui_checkbox_id, 'Value')
                    set(ui_list, 'String', ids) %#ok<PROPLC>
                elseif get(ui_checkbox_label, 'Value')
                    set(ui_list, 'String', labels)
                elseif get(ui_checkbox_xyz, 'Value')
                    xyz = cell(1, ba.getBrainAtlas().getBrainRegions().length());
                    for j = 1:1:ba.getBrainAtlas().getBrainRegions().length()
                        xyz{j} = [num2str(xs{j}) '   ' ...
                            num2str(ys{j}) '   ' ...
                            num2str(zs{j})];
                    end
                    set(ui_list, 'String', xyz)
                end
            end
            function cb_list(~, ~)  % (src, event)
                update_list()
            end
            function cb_id(~,~)  % (src,event)
                set(ui_checkbox_id, 'Value', true)
                set(ui_checkbox_id, 'FontWeight', 'bold')

                set(ui_checkbox_label, 'Value', false)
                set(ui_checkbox_label, 'FontWeight', 'normal')
                
                set(ui_checkbox_xyz, 'Value', false)
                set(ui_checkbox_xyz, 'FontWeight', 'normal')
                
                update_list()
            end
            function cb_label(~, ~)  % (src, event)
                set(ui_checkbox_id, 'Value', false)
                set(ui_checkbox_id, 'FontWeight', 'normal')

                set(ui_checkbox_label, 'Value', true)
                set(ui_checkbox_label, 'FontWeight', 'bold')
                                
                set(ui_checkbox_xyz, 'Value', false)
                set(ui_checkbox_xyz, 'FontWeight', 'normal')
                
                update_list()
            end
            function cb_xyz(~, ~)  % (src, event)
                set(ui_checkbox_id, 'Value', false)
                set(ui_checkbox_id, 'FontWeight', 'normal')

                set(ui_checkbox_label, 'Value', false)
                set(ui_checkbox_label, 'FontWeight', 'normal')
                
                set(ui_checkbox_xyz, 'Value', true)
                set(ui_checkbox_xyz, 'FontWeight', 'bold')
                
                update_list()
            end
            function cb_show(~, ~)  % (src, event)
                ba.br_labs(get_br_list())
                ba.br_labs_on(get_br_list())
            end
            function cb_hide(~, ~)  % (src, event)
                ba.br_labs_off(get_br_list())
            end
            function cb_color(~, ~)  % (src, event)
                color = uisetcolor();
                
                if length(color) == 3
                    ba.br_labs(get_br_list(), 'color', color)
                end
            end
            function cb_font(~,~)  % (src,event)
                font = uisetfont;
                
                if isstruct(font)
                    ba.br_labs(get_br_list(), 'FontSize', font.FontSize, ...
                        'FontName', font.FontName, ...
                        'FontWeight', font.FontWeight, ...
                        'FontAngle', font.FontAngle, ...
                        'FontUnits', font.FontUnits)
                end
            end
            function cb_interpreter(~,~)  %  (src,event)
                string = get(ui_popup_interpreter, 'String');
                interpreter = string{get(ui_popup_interpreter, 'Value')};
                ba.br_labs(get_br_list(), 'interpreter', interpreter)
            end
            function bri = get_br_list()
                if ba.getBrainAtlas().getBrainRegions().length() > 0
                    bri = get(ui_list, 'Value');
                else
                    bri = [];
                end
            end
        end
    end
    methods  % distance
        function distance_map_on(ba, i_vec)
            % DISTANCE_MAP_ON highlights brain surface around select brain regions
            %
            % DISTANCE_MAP_ON(BA, I_VEC) sets the BA colormap axis as a
            % function of distance to brain regions specified by the I_VEC.
            %
            % See also distance_map_off.
            
            if ~isempty(i_vec)
                brain_surf_coords = ba.coord;
                inverse_distance = zeros(length(i_vec), size(brain_surf_coords, 2));
                for m = 1:1:length(i_vec)
                    i = i_vec(m);
                    inverse_distance(m, :) = sum((ba.coord - ba.getBrainAtlas().getBrainRegions().getValue(i).getPosition()').^2).^-.5;
                end
                inverse_distance = max(inverse_distance, [], 1);

                ba.brain('FaceColor', 'interp', 'CData', inverse_distance)
                caxis([prctile(inverse_distance, 1) prctile(inverse_distance, 99)])
            end
        end
        function distance_map_off(ba)
            % DISTANCE_MAP_OFF removes the highlights
            %
            % DISTANCE_MAP_OFF(BA, I_VEC) sets the BA colormap axis to default
            % to brain regions specified by the I_VEC.
            %
            % See also distance_map_on.
            
            z_vector = ba.coord(3, :);
            ba.brain('CData', z_vector)
            caxis([min(z_vector) max(z_vector)])
        end
    end
end