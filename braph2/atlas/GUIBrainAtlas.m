function GUIBrainAtlas(atlas, restricted)
% GUIBRAINATLAS  Brain Atlas Editor
%
% GUIBRAINATLAS() opens empty atlas.
%
% GUIBRAINATLAS(atlas) opens atlas.
%
% GUIBRAINATLAS(atlas, true) opens atlas with only reading and basic writing permissions.
%
% See also BrainAtlas, GUI.

%% General Constants
APPNAME = GUI.BAE_NAME;  % application name
BUILD = BRAPH2.BUILD;

% Dimensions
MARGIN_X = .01;
MARGIN_Y = .01;
LEFTCOLUMN_WIDTH = .39;
FILENAME_HEIGHT = .02;

MAINPANEL_X0 = LEFTCOLUMN_WIDTH + 2 * MARGIN_X;
MAINPANEL_Y0 = FILENAME_HEIGHT + 2 * MARGIN_Y;
MAINPANEL_WIDTH = 1 - LEFTCOLUMN_WIDTH - 3 * MARGIN_X;
MAINPANEL_HEIGHT = 1 - FILENAME_HEIGHT - 3 * MARGIN_Y;
MAINPANEL_POSITION = [MAINPANEL_X0 MAINPANEL_Y0 MAINPANEL_WIDTH MAINPANEL_HEIGHT];

TABLE_WIDTH = LEFTCOLUMN_WIDTH;
TABLE_HEIGHT = MAINPANEL_HEIGHT;
TABLE_X0 = MARGIN_X;
TABLE_Y0 = FILENAME_HEIGHT + 2 * MARGIN_Y;
TABLE_POSITION = [TABLE_X0 TABLE_Y0 TABLE_WIDTH TABLE_HEIGHT];

FILENAME_WIDTH = 1 - 2 * MARGIN_X;
FILENAME_POSITION = [MARGIN_X MARGIN_Y FILENAME_WIDTH FILENAME_HEIGHT];

% Commands
OPEN_CMD = GUI.OPEN_CMD;
OPEN_SC = GUI.OPEN_SC;
OPEN_TP = ['Open brain atlas. Shortcut: ' GUI.ACCELERATOR '+' OPEN_SC];

SAVE_CMD = GUI.SAVE_CMD;
SAVE_SC = GUI.SAVE_SC;
SAVE_TP = ['Save current brain atlas. Shortcut: ' GUI.ACCELERATOR '+' SAVE_SC];

SAVEAS_CMD = GUI.SAVEAS_CMD;
SAVEAS_TP = 'Open dialog box to save current brain atlas';

IMPORT_TXT_CMD = GUI.IMPORT_TXT_CMD;
IMPORT_TXT_TP = 'Import brain atlas from a txt file (tab-delimited text file)';

IMPORT_XLS_CMD = GUI.IMPORT_XLS_CMD;
IMPORT_XLS_TP = 'Import brain atlas from an Excel file';

IMPORT_JSON_CMD = GUI.IMPORT_JSON_CMD;
IMPORT_JSON_TP = 'Import brain atlas from a json file.';

EXPORT_TXT_CMD = GUI.EXPORT_TXT_CMD;
EXPORT_TXT_TP = 'Export brain atlas as a txt file (tab-delimited text file)';

EXPORT_XLS_CMD = GUI.EXPORT_XLS_CMD;
EXPORT_XLS_TP = 'Export brain atlas as a xls file.';

EXPORT_JSON_CMD = GUI.EXPORT_JSON_CMD;
EXPRT_JSON_TP = 'Export brain atlas as a json file.';

CLOSE_CMD = GUI.CLOSE_CMD;
CLOSE_SC = GUI.CLOSE_SC;
CLOSE_TP = ['Close ' APPNAME '. Shortcut: ' GUI.ACCELERATOR '+' CLOSE_SC];

ID_TP = 'Brain atlas id';
LABEL_TP = 'Brain atlas label';
NOTES_TP = 'Brain atlas notes';

SELECTALL_CMD = GUI.SELECTALL_CMD;
SELECTALL_TP = 'Select all brain regions';

CLEARSELECTION_CMD = GUI.CLEARSELECTION_CMD;
CLEARSELECTION_TP = 'Clear selection';

ADD_CMD = GUI.ADD_CMD;
ADD_SC = GUI.ADD_SC;
ADD_TP = ['Add brain region at the end of table. Shortcut: ' GUI.ACCELERATOR '+' ADD_SC];

REMOVE_CMD = GUI.REMOVE_CMD;
REMOVE_SC = GUI.REMOVE_SC;
REMOVE_TP = ['Remove selected brain regions. Shortcut: ' GUI.ACCELERATOR '+' REMOVE_SC];

MOVEUP_CMD = GUI.MOVEUP_CMD;
MOVEUP_SC = GUI.MOVEUP_SC;
MOVEUP_TP = ['Move selected brain regions up. Shortcut: ' GUI.ACCELERATOR '+' MOVEUP_SC];

MOVEDOWN_CMD = GUI.MOVEDOWN_CMD;
MOVEDOWN_SC = GUI.MOVEDOWN_SC;
MOVEDOWN_TP = ['Move selected brain regions down. Shortcut: ' GUI.ACCELERATOR '+' MOVEDOWN_SC];

MOVE2TOP_CMD = GUI.MOVE2TOP_CMD;
MOVE2TOP_SC = GUI.MOVE2TOP_SC;
MOVE2TOP_TP = ['Move selected brain regions to top of table. Shortcut: ' GUI.ACCELERATOR '+' MOVE2TOP_SC];

MOVE2BOTTOM_CMD = GUI.MOVE2BOTTOM_CMD;
MOVE2BOTTOM_SC = GUI.MOVE2BOTTOM_SC;
MOVE2BOTTOM_TP = ['Move selected brain regions to bottom of table. Shortcut: ' GUI.ACCELERATOR '+' MOVE2BOTTOM_SC];

FIGURE_CMD = GUI.FIGURE_CMD;
FIGURE_SC = GUI.FIGURE_SC;
FIGURE_TP = ['Generate brain figure. Shortcut: ' GUI.ACCELERATOR '+' FIGURE_SC];

% MRICOHORT_CMD = 'New MRI Cohort ...';
% MRICOHORT_TP = ['Generate new MRI cohort and opens it with ' GUI.MCE_NAME];
%
% fMRICOHORT_CMD = 'New fMRI Cohort ...';
% fMRICOHORT_TP = ['Generate new fMRI cohort and opens it with ' GUI.fMCE_NAME];
%
% EEGCOHORT_CMD = 'New EEG Cohort ...';
% EEGCOHORT_TP = ['Generate new EEG cohort and opens it with ' GUI.ECE_NAME];
%
% PETCOHORT_CMD = 'New PET Cohort ...';
% PETCOHORT_TP = ['Generate new PET cohort and opens it with ' GUI.PCE_NAME];

%% Application data
if ~exist('atlas', 'var')
    atlas = BrainAtlas('BA ID', 'Brain Atlas Label', 'Brain atlas notes.', 'BrainMesh_ICBM152.nv', {});
end
selected = [];

% PlotBrainAtlas
ba = [];

% Callbacks to manage application data
    function cb_open(~, ~)  % (src, event)
        % select file
        [file, path, filterindex] = uigetfile(GUI.BAE_EXTENSION, GUI.BAE_MSG_GETFILE);
        % load file
        if filterindex
            filename = fullfile(path, file);
            tmp = load(filename, '-mat', 'atlas', 'selected', 'BUILD');
            if isfield(tmp, 'BUILD') && tmp.BUILD >= 2020 && ...
                    isfield(tmp, 'atlas') && isa(tmp.atlas, 'BrainAtlas') && ...
                    isfield(tmp, 'selected')
                atlas = tmp.atlas;
                selected = tmp.selected;
                setup()
                update_filename(filename)
            end
        end
    end
    function cb_save(~, ~)  % (src, event)
        filename = get(ui_text_filename, 'String');
        if isempty(filename)
            cb_saveas();
        else
            save(filename, 'atlas', 'selected', 'BUILD');
        end
    end
    function cb_saveas(~, ~)  % (src, event)
        % select file
        [file, path, filterindex] = uiputfile(GUI.BAE_EXTENSION, GUI.BAE_MSG_PUTFILE);
        % save file
        if filterindex
            filename = fullfile(path, file);
            save(filename, 'atlas', 'selected', 'BUILD');
            update_filename(filename)
        end
    end
    function cb_import_txt(~, ~)  % (scr, event)
        atlastmp = BrainAtlas.load_from_txt();
        if ~isempty(atlastmp)
            atlas = atlastmp;
            selected = [];
            setup()
            update_filename('')
        end
    end
    function cb_import_xls(~, ~)  % (scr, event)
        atlastmp = BrainAtlas.load_from_xls();
        if  ~isempty(atlastmp)
            atlas = atlastmp;
            selected = [];
            setup()
            update_filename('')
        end
    end
    function cb_import_json(~, ~)  % (src, event)
        atlastmp = BrainAtlas.load_from_json();
        if ~isempty(atlastmp)
            atlas = atlastmp;
            selected = [];
            setup()
            update_filename('')
        end
    end
    function cb_export_txt(~, ~)  % (scr, event)
        BrainAtlas.save_to_txt(atlas);
    end
    function cb_export_xls(~, ~)  % (src, event)
        BrainAtlas.save_to_xls(atlas);
    end
    function cb_export_json(~, ~)  % (src, event)
        BrainAtlas.save_to_json(atlas);
    end

%% GUI inizialization
f = GUI.init_figure(APPNAME, .8, .8, 'northwest');

dcm = datacursormode(f);
init_datacursormode()
    function init_datacursormode()
        set(dcm, 'UpdateFcn', {@cb_datacursor})
        set(dcm, 'Enable', 'off')
    end
    function txt = cb_datacursor(~, ~)  % (src, event)
        userdata = get(gco, 'UserData');
        if isempty(userdata)
            txt = 'brain surface';
        else
            i = userdata{2};
            txt = { ...
                [atlas.getBrainRegions().getValue(i).getID() ' #' int2str(i)], ...
                atlas.getBrainRegions().getValue(i).getLabel(), ...
                [FIG_XLABEL ' = ' num2str(atlas.getBrainRegions().getValue(i).getX()) ' ' FIG_UNITS], ...
                [FIG_YLABEL ' = ' num2str(atlas.getBrainRegions().getValue(i).getY()) ' ' FIG_UNITS], ...
                [FIG_ZLABEL ' = ' num2str(atlas.getBrainRegions().getValue(i).getZ()) ' ' FIG_UNITS] ...
                };
        end
    end

%% Text File Name
ui_text_filename = uicontrol('Style','text');
init_filename()
    function init_filename()
        GUI.setUnits(ui_text_filename)
        GUI.setBackgroundColor(ui_text_filename)
        
        set(ui_text_filename, 'Position', FILENAME_POSITION)
        set(ui_text_filename, 'HorizontalAlignment', 'left')
    end
    function update_filename(filename)
        set(ui_text_filename, 'String', filename)
    end

%% Panel Table
TAB_BR_SELECTED_COL = 1;
TAB_BR_ID_COL = 2;
TAB_BR_LABEL_COL = 3;
TAB_BR_X_COL = 4;
TAB_BR_Y_COL = 5;
TAB_BR_Z_COL = 6;
TAB_BR_NOTES_COL = 7;

ui_panel_table = uipanel();
ui_edit_table_id = uicontrol(ui_panel_table, 'Style', 'edit');
ui_edit_table_label = uicontrol(ui_panel_table, 'Style', 'edit');
ui_edit_table_notes = uicontrol(ui_panel_table, 'Style', 'edit');
ui_popup_table_brainsurf = uicontrol(ui_panel_table, 'Style', 'popupmenu');
ui_table_table = uitable(ui_panel_table);
ui_button_table_selectall = uicontrol(ui_panel_table,'Style', 'pushbutton');
ui_button_table_clearselection = uicontrol(ui_panel_table,'Style', 'pushbutton');
ui_button_table_add = uicontrol(ui_panel_table,'Style', 'pushbutton');
ui_button_table_remove = uicontrol(ui_panel_table,'Style', 'pushbutton');
ui_button_table_moveup = uicontrol(ui_panel_table,'Style', 'pushbutton');
ui_button_table_movedown = uicontrol(ui_panel_table,'Style', 'pushbutton');
ui_button_table_move2top = uicontrol(ui_panel_table,'Style', 'pushbutton');
ui_button_table_move2bottom = uicontrol(ui_panel_table,'Style', 'pushbutton');
init_table()
    function init_table()
        GUI.setUnits(ui_panel_table)
        GUI.setBackgroundColor(ui_panel_table)
        
        set(ui_panel_table, 'Position', TABLE_POSITION)
        set(ui_panel_table, 'BorderType', 'none')
        
        set(ui_edit_table_id, 'Position', [.02 .95 .36 .04])
        set(ui_edit_table_id, 'HorizontalAlignment', 'left')
        set(ui_edit_table_id, 'FontWeight', 'bold')
        set(ui_edit_table_id, 'TooltipString', ID_TP)
        set(ui_edit_table_id, 'Callback', {@cb_table_id})
        
        set(ui_edit_table_label, 'Position', [.42 .95 .56 .04])
        set(ui_edit_table_label, 'HorizontalAlignment', 'left')
        set(ui_edit_table_label, 'FontWeight', 'bold')
        set(ui_edit_table_label, 'TooltipString', LABEL_TP)
        set(ui_edit_table_label, 'Callback', {@cb_table_label})
        
        set(ui_edit_table_notes, 'Position', [.42 .90 .56 .04])
        set(ui_edit_table_notes, 'HorizontalAlignment', 'left')
        set(ui_edit_table_notes, 'FontWeight', 'bold')
        set(ui_edit_table_notes, 'TooltipString', NOTES_TP)
        set(ui_edit_table_notes, 'Callback', {@cb_table_notes})
        
        set(ui_popup_table_brainsurf, 'Position', [.02 .90 .36 .04])
        set(ui_popup_table_brainsurf, 'String', atlas.getBrainSurfList())
        set(ui_popup_table_brainsurf, 'Value', find(strcmpi(atlas.getBrainSurfFile(), get(ui_popup_table_brainsurf, 'String'))))
        set(ui_popup_table_brainsurf, 'Callback', {@cb_table_brainsurf})
        
        set(ui_table_table, 'Position', [.02 .16 .96 .72])
        set(ui_table_table, 'ColumnName', {'', 'ID', 'Label', 'x', 'y', 'z', 'Notes'})
        set(ui_table_table, 'ColumnFormat', {'logical', 'char', 'char', 'numeric', 'numeric', 'numeric', 'char'})
        set(ui_table_table, 'ColumnEditable', true)
        set(ui_table_table, 'CellEditCallback', {@cb_table_edit});
        
        set(ui_button_table_selectall, 'Position', [.02 .11 .21 .03])
        set(ui_button_table_selectall, 'String', SELECTALL_CMD)
        set(ui_button_table_selectall, 'TooltipString', SELECTALL_TP)
        set(ui_button_table_selectall, 'Callback', {@cb_table_selectall})
        
        set(ui_button_table_clearselection, 'Position', [.02 .08 .21 .03])
        set(ui_button_table_clearselection, 'String', CLEARSELECTION_CMD)
        set(ui_button_table_clearselection, 'TooltipString', CLEARSELECTION_TP)
        set(ui_button_table_clearselection, 'Callback', {@cb_table_clearselection})
        
        set(ui_button_table_add, 'Position', [.27 .11 .21 .03])
        set(ui_button_table_add, 'String', ADD_CMD)
        set(ui_button_table_add, 'TooltipString', ADD_TP);
        set(ui_button_table_add, 'Callback', {@cb_table_add})
        
        set(ui_button_table_remove, 'Position', [.52 .11 .21 .03])
        set(ui_button_table_remove, 'String', REMOVE_CMD)
        set(ui_button_table_remove, 'TooltipString', REMOVE_TP);
        set(ui_button_table_remove, 'Callback', {@cb_table_remove})
        
        set(ui_button_table_moveup, 'Position', [.77 .11 .21 .03])
        set(ui_button_table_moveup, 'String', MOVEUP_CMD)
        set(ui_button_table_moveup, 'TooltipString', MOVEUP_TP);
        set(ui_button_table_moveup, 'Callback', {@cb_table_moveup})
        
        set(ui_button_table_movedown, 'Position', [.77 .08 .21 .03])
        set(ui_button_table_movedown, 'String', MOVEDOWN_CMD)
        set(ui_button_table_movedown, 'TooltipString', MOVEDOWN_TP);
        set(ui_button_table_movedown, 'Callback', {@cb_table_movedown})
        
        set(ui_button_table_move2top, 'Position', [.77 .05 .21 .03])
        set(ui_button_table_move2top, 'String', MOVE2TOP_CMD)
        set(ui_button_table_move2top, 'TooltipString', MOVE2TOP_TP);
        set(ui_button_table_move2top, 'Callback', {@cb_table_move2top})
        
        set(ui_button_table_move2bottom, 'Position', [.77 .02 .21 .03])
        set(ui_button_table_move2bottom, 'String', MOVE2BOTTOM_CMD)
        set(ui_button_table_move2bottom, 'TooltipString', MOVE2BOTTOM_TP);
        set(ui_button_table_move2bottom, 'Callback', {@cb_table_move2bottom})
    end
    function update_table_id()
        atlas_id = atlas.getID();
        if isempty(atlas_id)
            set(f, 'Name', [APPNAME ' ' BRAPH2.VERSION])
        else
            set(f, 'Name', [APPNAME ' ' BRAPH2.VERSION ' - ' atlas_id])
        end
        set(ui_edit_table_id, 'String', atlas_id)
    end
    function update_table_label()
        atlas_label = atlas.getLabel();
        set(ui_edit_table_label, 'String', atlas_label)
    end
    function update_table_notes()
        atlas_notes = atlas.getNotes();
        set(ui_edit_table_notes, 'String', atlas_notes)
    end
    function update_table_brainsurf()
        ba = atlas.getPlotBrainAtlas();
        create_figure();
    end
    function update_table_table()
        data = cell(atlas.getBrainRegions().length(), 8);
        for i = 1:1:atlas.getBrainRegions().length()
            if any(selected == i)
                data{i, TAB_BR_SELECTED_COL} = true;
            else
                data{i, TAB_BR_SELECTED_COL} = false;
            end
            data{i, TAB_BR_ID_COL} = atlas.getBrainRegions().getValue(i).getID();
            data{i, TAB_BR_LABEL_COL} = atlas.getBrainRegions().getValue(i).getLabel();
            data{i, TAB_BR_X_COL} = atlas.getBrainRegions().getValue(i).getX();
            data{i, TAB_BR_Y_COL} = atlas.getBrainRegions().getValue(i).getY();
            data{i, TAB_BR_Z_COL} = atlas.getBrainRegions().getValue(i).getZ();
            data{i, TAB_BR_NOTES_COL} = atlas.getBrainRegions().getValue(i).getNotes();
        end
        set(ui_table_table, 'Data', data)
    end
    function cb_table_id(~, ~)  % (src, event)
        atlas.setID(get(ui_edit_table_id,  'String'));
        update_table_id()
    end
    function cb_table_label(~, ~)  % (src, event)
        atlas.setLabel(get(ui_edit_table_label,  'String'));
        update_table_label()
    end
    function cb_table_notes(~, ~)  % (src, event)
        atlas.setNotes(get(ui_edit_table_notes,  'String'));
        update_table_notes()
    end
    function cb_table_brainsurf(~, ~)  % (src, event)
        brainsurffile_list = get(ui_popup_table_brainsurf, 'String');
        atlas.setBrainSurfFile(brainsurffile_list{get(ui_popup_table_brainsurf, 'Value')});
        update_table_brainsurf()
    end
    function cb_table_edit(~, event)  % (src, event)
        i = event.Indices(1);
        col = event.Indices(2);
        newdata = event.NewData;
        switch col
            case TAB_BR_SELECTED_COL
                if newdata == 1
                    selected = sort(unique([selected(:); i]));
                else
                    selected = selected(selected~=i);
                end
            case TAB_BR_ID_COL
                if ~atlas.getBrainRegions().containsKey(newdata)
                    % change brain region id
                    atlas.getBrainRegions().getValue(i).setID(newdata)
                    % change brain region key in idict
                    oldkey = atlas.getBrainRegions().getKey(i);
                    atlas.getBrainRegions().replaceKey(oldkey, newdata);
                end
            case TAB_BR_LABEL_COL
                atlas.getBrainRegions().getValue(i).setLabel(newdata)
            case TAB_BR_X_COL
                atlas.getBrainRegions().getValue(i).setX(newdata)
            case TAB_BR_Y_COL
                atlas.getBrainRegions().getValue(i).setY(newdata)
            case TAB_BR_Z_COL
                atlas.getBrainRegions().getValue(i).setZ(newdata)
            case TAB_BR_NOTES_COL
                atlas.getBrainRegions().getValue(i).setNotes(newdata)
        end
        update_table_table()
        update_figure_brainview()
    end
    function cb_table_selectall(~, ~)  % (src, event)
        selected = (1:1:atlas.getBrainRegions().length())';
        update_table_table()
        update_figure_brainview()
    end
    function cb_table_clearselection(~, ~)  % (src, event)
        selected = [];
        update_table_table()
        update_figure_brainview()
    end
    function cb_table_add(~, ~)  % (src, event)
        br_id = 1;
        while atlas.getBrainRegions().containsKey(num2str(br_id))
            br_id = br_id + 1;
        end
        br = BrainRegion([num2str(br_id)], '', '', 0, 0, 0);
        atlas.getBrainRegions().add(br.getID(), br);
        update_table_table()
        update_figure_brainview()
    end
    function cb_table_remove(~, ~)  % (src, event)
        selected = atlas.getBrainRegions().remove_all(selected);
        update_table_table()
        update_figure_brainview('remove')
    end
    function cb_table_moveup(~, ~)  % (src, event)
        selected = atlas.getBrainRegions().move_up(selected);
        update_table_table()
        update_figure_brainview()
    end
    function cb_table_movedown(~, ~)  % (src, event)
        selected = atlas.getBrainRegions().move_down(selected);
        update_table_table()
        update_figure_brainview()
    end
    function cb_table_move2top(~, ~)  % (src, event)
        selected = atlas.getBrainRegions().move_to_top(selected);
        update_table_table()
        update_figure_brainview()
    end
    function cb_table_move2bottom(~, ~)  % (src, event)
        selected = atlas.getBrainRegions().move_to_bottom(selected);
        update_table_table()
        update_figure_brainview()
    end

%% Panel Figure
FIG_BRAIN_CMD = 'Show brain';
FIG_BRAIN_TP = 'Brain surface on/off';

FIG_DISTANCE_CMD = 'Highlights';
FIG_DISTANCE_TP = 'Highlights on/off';

FIG_BRAINALPHA_CMD = 'Brain transparency';
FIG_BRAINALPHA_TP = 'Adjust the transparency of the brain surface';

FIG_AXIS_CMD = 'Show axis';
FIG_AXIS_TP = 'Toggle axis on/off';

FIG_GRID_CMD = 'Show grid';
FIG_GRID_TP = 'Toggle grid on/off';

FIG_LABELS_CMD = 'Show labels';
FIG_LABELS_TP = 'Toggle labels on/off';

FIG_BR_CMD = 'Show brain regions';
FIG_BR_TP = 'Toggle brain regions markers on/off';

FIG_VIEW_3D_CMD = PlotBrainAtlas.VIEW_3D_CMD;
FIG_VIEW_SR_CMD = PlotBrainAtlas.VIEW_SR_CMD;
FIG_VIEW_SL_CMD = PlotBrainAtlas.VIEW_SL_CMD;
FIG_VIEW_AD_CMD = PlotBrainAtlas.VIEW_AD_CMD;
FIG_VIEW_AV_CMD = PlotBrainAtlas.VIEW_AV_CMD;
FIG_VIEW_CA_CMD = PlotBrainAtlas.VIEW_CA_CMD;
FIG_VIEW_CP_CMD = PlotBrainAtlas.VIEW_CP_CMD;

FIG_BRAINSURF_CMD = 'Brain Settings';
FIG_SELECTBR_CMD = 'Select';
FIG_DESELECTBR_CMD = 'Deselect';
FIG_INFOBR_CMD = 'Info';
FIG_SETTINGSBR_CMD = 'Brain Region Settings';
FIG_SETTINGSLAB_CMD = 'Label Settings';

FIG_XLABEL = 'x';
FIG_YLABEL = 'y';
FIG_ZLABEL = 'z';
FIG_UNITS = 'mm';

FIG_BR_MARKER = 'o';
FIG_BR_COLOR = [0 0 1];  % 'b'
FIG_BR_SIZE = 10;
FIG_BRSELECTED_MARKER = FIG_BR_MARKER;
FIG_BRSELECTED_COLOR = [1 0 0];  % 'r'
FIG_BRSELECTED_SIZE = FIG_BR_SIZE;

ui_panel_figure = uipanel();
ui_axes_figure = axes();
ui_checkbox_figure_brain = uicontrol(ui_panel_figure, 'Style', 'checkbox');
ui_checkbox_figure_distance = uicontrol(ui_panel_figure, 'Style', 'checkbox');
ui_slider_figure_brainalpha = uicontrol(ui_panel_figure, 'Style', 'slider');
ui_checkbox_figure_axis = uicontrol(ui_panel_figure, 'Style', 'checkbox');
ui_checkbox_figure_grid = uicontrol(ui_panel_figure, 'Style', 'checkbox');
ui_checkbox_figure_br = uicontrol(ui_panel_figure, 'Style', 'checkbox');
ui_checkbox_figure_labels = uicontrol(ui_panel_figure, 'Style', 'checkbox');
ui_button_figure_3d = uicontrol(ui_panel_figure, 'Style', 'pushbutton');
ui_button_figure_sagittalright = uicontrol(ui_panel_figure, 'Style', 'pushbutton');
ui_button_figure_sagittalleft = uicontrol(ui_panel_figure, 'Style', 'pushbutton');
ui_button_figure_axialdorsal = uicontrol(ui_panel_figure, 'Style', 'pushbutton');
ui_button_figure_axialventral = uicontrol(ui_panel_figure, 'Style', 'pushbutton');
ui_button_figure_coronalanterior = uicontrol(ui_panel_figure, 'Style', 'pushbutton');
ui_button_figure_coronalposterior = uicontrol(ui_panel_figure, 'Style', 'pushbutton');
init_figure()
    function init_figure()
        GUI.setUnits(ui_panel_figure)
        GUI.setBackgroundColor(ui_panel_figure)
        
        set(ui_panel_figure, 'Position', MAINPANEL_POSITION)
        
        set(ui_axes_figure, 'Parent', ui_panel_figure)
        set(ui_axes_figure, 'Position', [.02 .20 .96 .78])
        
        set(ui_checkbox_figure_brain, 'Position', [.10 .11 .10 .03])
        set(ui_checkbox_figure_brain, 'String', FIG_BRAIN_CMD)
        set(ui_checkbox_figure_brain, 'Value', true)
        set(ui_checkbox_figure_brain, 'TooltipString', FIG_BRAIN_TP)
        set(ui_checkbox_figure_brain, 'Callback', {@cb_figure_plotsettings})
        
        set(ui_checkbox_figure_distance, 'Position', [.10 .085 .10 .03])
        set(ui_checkbox_figure_distance, 'String', FIG_DISTANCE_CMD)
        set(ui_checkbox_figure_distance, 'Value', false)
        set(ui_checkbox_figure_distance, 'TooltipString', FIG_DISTANCE_TP)
        set(ui_checkbox_figure_distance, 'Callback', {@cb_figure_plotsettings})
        
        set(ui_slider_figure_brainalpha, 'Position', [.30 .105 .40 .03])
        set(ui_slider_figure_brainalpha, 'String', FIG_BRAINALPHA_CMD)
        set(ui_slider_figure_brainalpha, 'Min', 0, 'Max', 1, 'Value', .5)
        set(ui_slider_figure_brainalpha, 'TooltipString', FIG_BRAINALPHA_TP)
        set(ui_slider_figure_brainalpha, 'Callback', {@cb_figure_plotsettings})
        
        set(ui_checkbox_figure_axis, 'Position', [.80 .11 .18 .03])
        set(ui_checkbox_figure_axis, 'String', FIG_AXIS_CMD)
        set(ui_checkbox_figure_axis, 'Value', true)
        set(ui_checkbox_figure_axis, 'TooltipString', FIG_AXIS_TP)
        set(ui_checkbox_figure_axis, 'Callback', {@cb_figure_plotsettings})
        
        set(ui_checkbox_figure_grid, 'Position', [.80 .08 .18 .03])
        set(ui_checkbox_figure_grid, 'String', FIG_GRID_CMD)
        set(ui_checkbox_figure_grid, 'Value', true)
        set(ui_checkbox_figure_grid, 'TooltipString', FIG_GRID_TP);
        set(ui_checkbox_figure_grid, 'Callback', {@cb_figure_plotsettings})
        
        set(ui_checkbox_figure_br, 'Position', [.80 .05 .18 .03])
        set(ui_checkbox_figure_br, 'String', FIG_BR_CMD)
        set(ui_checkbox_figure_br, 'Value', true)
        set(ui_checkbox_figure_br, 'TooltipString', FIG_BR_TP);
        set(ui_checkbox_figure_br, 'Callback', {@cb_figure_plotsettings})
        
        set(ui_checkbox_figure_labels, 'Position', [.80 .02 .18 .03])
        set(ui_checkbox_figure_labels, 'String', FIG_LABELS_CMD)
        set(ui_checkbox_figure_labels, 'Value', true)
        set(ui_checkbox_figure_labels, 'TooltipString', FIG_LABELS_TP);
        set(ui_checkbox_figure_labels, 'Callback', {@cb_figure_plotsettings})
        
        set(ui_button_figure_3d, 'Position', [.10 .05 .14 .03])
        set(ui_button_figure_3d, 'String', FIG_VIEW_3D_CMD)
        set(ui_button_figure_3d, 'Callback', {@cb_figure_plotsettings})
        
        set(ui_button_figure_sagittalleft, 'Position', [.25 .05 .14 .03])
        set(ui_button_figure_sagittalleft, 'String', FIG_VIEW_SL_CMD)
        set(ui_button_figure_sagittalleft, 'Callback', {@cb_figure_plotsettings})
        
        set(ui_button_figure_sagittalright, 'Position', [.25 .02 .14 .03])
        set(ui_button_figure_sagittalright, 'String', FIG_VIEW_SR_CMD)
        set(ui_button_figure_sagittalright, 'Callback', {@cb_figure_plotsettings})
        
        set(ui_button_figure_axialdorsal, 'Position', [.40 .05 .14 .03])
        set(ui_button_figure_axialdorsal, 'String', FIG_VIEW_AD_CMD)
        set(ui_button_figure_axialdorsal, 'Callback', {@cb_figure_plotsettings})
        
        set(ui_button_figure_axialventral, 'Position', [.40 .02 .14 .03])
        set(ui_button_figure_axialventral, 'String', FIG_VIEW_AV_CMD)
        set(ui_button_figure_axialventral, 'Callback', {@cb_figure_plotsettings})
        
        set(ui_button_figure_coronalanterior, 'Position', [.55 .05 .14 .03])
        set(ui_button_figure_coronalanterior, 'String', FIG_VIEW_CA_CMD)
        set(ui_button_figure_coronalanterior, 'Callback', {@cb_figure_plotsettings})
        
        set(ui_button_figure_coronalposterior, 'Position', [.55 .02 .14 .03])
        set(ui_button_figure_coronalposterior, 'String', FIG_VIEW_CP_CMD)
        set(ui_button_figure_coronalposterior, 'Callback', {@cb_figure_plotsettings})
    end
ui_contextmenu_figure_brainsurf = uicontextmenu();
ui_contextmenu_figure_brainsurf_settings = uimenu(ui_contextmenu_figure_brainsurf);
ui_contextmenu_figure_select = uicontextmenu();
ui_contextmenu_figure_select_select = uimenu(ui_contextmenu_figure_select);
ui_contextmenu_figure_select_info = uimenu(ui_contextmenu_figure_select);
ui_contextmenu_figure_select_settings = uimenu(ui_contextmenu_figure_select);
ui_contextmenu_figure_deselect = uicontextmenu();
ui_contextmenu_figure_deselect_deselect = uimenu(ui_contextmenu_figure_deselect);
ui_contextmenu_figure_deselect_info = uimenu(ui_contextmenu_figure_deselect);
ui_contextmenu_figure_deselect_settings = uimenu(ui_contextmenu_figure_deselect);
ui_contextmenu_figure_labels = uicontextmenu();
ui_contextmenu_figure_labels_settings = uimenu(ui_contextmenu_figure_labels);
init_contextmenus()
    function init_contextmenus()
        set(ui_contextmenu_figure_brainsurf_settings, 'Label', FIG_BRAINSURF_CMD)
        set(ui_contextmenu_figure_brainsurf_settings, 'Callback', {@cb_figure_brainsurf})
        
        function cb_figure_brainsurf(~, ~)  % (src, event)
            ba.brain_settings();
        end
        
        set(ui_contextmenu_figure_select_select, 'Label', FIG_SELECTBR_CMD)
        set(ui_contextmenu_figure_select_select, 'Callback', {@cb_figure_selectbr})
        
        set(ui_contextmenu_figure_select_info, 'Label', FIG_INFOBR_CMD)
        set(ui_contextmenu_figure_select_info, 'Callback', {@cb_figure_infobr})
        
        set(ui_contextmenu_figure_select_settings, 'Label', FIG_SETTINGSBR_CMD)
        set(ui_contextmenu_figure_select_settings, 'Callback', {@cb_figure_settingsbr})
        
        set(ui_contextmenu_figure_deselect_deselect, 'Label', FIG_DESELECTBR_CMD)
        set(ui_contextmenu_figure_deselect_deselect, 'Callback', {@cb_figure_deselectbr})
        
        set(ui_contextmenu_figure_deselect_info, 'Label', FIG_INFOBR_CMD)
        set(ui_contextmenu_figure_deselect_info, 'Callback', {@cb_figure_infobr})
        
        set(ui_contextmenu_figure_deselect_settings, 'Label', FIG_SETTINGSBR_CMD)
        set(ui_contextmenu_figure_deselect_settings, 'Callback', {@cb_figure_settingsbr})
        
        function cb_figure_selectbr(~, ~)  % (src, event)
            userdata = get(gco, 'UserData');
            i = userdata{2};
            selected = sort([selected; i]);
            update_table_table()
            update_figure_brainview()
        end
        function cb_figure_deselectbr(~, ~)  % (src, event)
            userdata = get(gco, 'UserData');
            i = userdata{2};
            selected = selected(selected ~= i);
            update_table_table()
            update_figure_brainview()
        end
        function cb_figure_infobr(~, ~)  % (src, event)
            set(dcm, 'enable', 'on')
        end
        function cb_figure_settingsbr(~, ~)  % (src, event)
            userdata = get(gco, 'UserData');
            i = userdata{2};
            ba.br_syms_settings(i)
        end
        
        set(ui_contextmenu_figure_labels_settings, 'Label', FIG_SETTINGSLAB_CMD)
        set(ui_contextmenu_figure_labels_settings, 'Callback', {@cb_figure_settingslab})
        
        function cb_figure_settingslab(~, ~)  % (src, event)
            userdata = get(gco, 'UserData');
            i = userdata{2};
            ba.br_labs_settings(i)
        end
    end
    function create_figure()
        
        cla(ui_axes_figure)
        
        ba = atlas.getPlotBrainAtlas();
        ba.set_axes(ui_axes_figure)
        axes(ui_axes_figure)
        
        ba.axis_equal()
        ba.hold_on()
        
        ba.view(PlotBrainSurf.VIEW_3D)
        ba.brain('UiContextMenu', ui_contextmenu_figure_brainsurf)
        
        ba.br_syms()
        
        ba.br_labs()
        
        xlabel([FIG_XLABEL ' ' GUI.BRA_UNITS FIG_UNITS GUI.KET_UNITS])
        ylabel([FIG_YLABEL ' ' GUI.BRA_UNITS FIG_UNITS GUI.KET_UNITS])
        zlabel([FIG_ZLABEL ' ' GUI.BRA_UNITS FIG_UNITS GUI.KET_UNITS])
        
        update_figure_brainview()
    end
    function update_figure_brainview(varargin)
        if nargin < 1
            action_case = 'default';
        else
            action_case = varargin(1);
        end        
        
        if get(ui_checkbox_figure_axis, 'Value')
            ba.axis_on()
            set(ui_toolbar_axis, 'State', 'on')
        else
            ba.axis_off()
            set(ui_toolbar_axis, 'State', 'off')
        end
        
        if get(ui_checkbox_figure_grid, 'Value')
            ba.grid_on()
            set(ui_toolbar_grid, 'State', 'on');
        else
            ba.grid_off()
            set(ui_toolbar_grid, 'State', 'off');
        end
        
        if get(ui_button_figure_3d, 'Value')
            ba.view(PlotBrainAtlas.VIEW_3D)
            set(ui_button_figure_3d, 'Value', false);
        elseif get(ui_button_figure_sagittalleft, 'Value')
            ba.view(PlotBrainAtlas.VIEW_SL)
            set(ui_button_figure_sagittalleft, 'Value', false);
        elseif get(ui_button_figure_sagittalright, 'Value')
            ba.view(PlotBrainAtlas.VIEW_SR)
            set(ui_button_figure_sagittalright, 'Value', false);
        elseif get(ui_button_figure_axialdorsal, 'Value')
            ba.view(PlotBrainAtlas.VIEW_AD)
            set(ui_button_figure_axialdorsal, 'Value', false);
        elseif get(ui_button_figure_axialventral, 'Value')
            ba.view(PlotBrainAtlas.VIEW_AV)
            set(ui_button_figure_axialventral, 'Value', false);
        elseif get(ui_button_figure_coronalanterior, 'Value')
            ba.view(PlotBrainAtlas.VIEW_CA)
            set(ui_button_figure_coronalanterior, 'Value', false);
        elseif get(ui_button_figure_coronalposterior, 'Value')
            ba.view(PlotBrainAtlas.VIEW_CP)
            set(ui_button_figure_coronalposterior, 'Value', false);
        end
        
        % brain
        if get(ui_checkbox_figure_brain, 'Value')
            ba.brain_on()
            set(ui_toolbar_brain, 'State', 'on');
        else
            ba.brain_off()
            set(ui_toolbar_brain, 'State', 'off');
        end
        
        if get(ui_checkbox_figure_distance, 'Value')
            ba.distance_map_on(selected);
        else
            ba.distance_map_off();
        end
        
        ba.brain('FaceAlpha', get(ui_slider_figure_brainalpha, 'Value'))
        
        % brain regions
        if get(ui_checkbox_figure_br, 'Value') & ~isequal(action_case, {'remove'})
            ba.br_syms_on()
            for i = 1:1:atlas.getBrainRegions().length()
                X = atlas.getBrainRegions().getValue(i).getX();
                Y = atlas.getBrainRegions().getValue(i).getY();
                Z = atlas.getBrainRegions().getValue(i).getZ();
                label = atlas.getBrainRegions().getValue(i).getLabel();
                if any(selected == i)
                    h = ba.br_sym(i, ...
                        'UIContextMenu', ui_contextmenu_figure_deselect, ...
                        'UserData', {1 i X Y Z label});
                    if isequal(get(h, 'Marker'), FIG_BR_MARKER) && ...
                            isequal(get(h, 'MarkerFaceColor'), FIG_BR_COLOR) && ...
                            isequal(get(h, 'MarkerEdgeColor'), FIG_BR_COLOR) && ...
                            isequal(get(h, 'MarkerSize'), FIG_BR_SIZE)
                        ba.br_sym(i, ...
                            'Marker', FIG_BRSELECTED_MARKER, ...
                            'MarkerFaceColor', FIG_BRSELECTED_COLOR, ...
                            'MarkerEdgeColor', FIG_BRSELECTED_COLOR, ...
                            'MarkerSize', FIG_BRSELECTED_SIZE)
                    end
                else
                    h = ba.br_sym(i, ...
                        'UIContextMenu', ui_contextmenu_figure_select, ...
                        'UserData', {0 i X Y Z label});
                    if isequal(get(h, 'Marker'), FIG_BRSELECTED_MARKER) && ...
                            isequal(get(h, 'MarkerFaceColor'), FIG_BRSELECTED_COLOR) && ...
                            isequal(get(h, 'MarkerEdgeColor'), FIG_BRSELECTED_COLOR) && ...
                            isequal(get(h, 'MarkerSize'), FIG_BRSELECTED_SIZE)
                        ba.br_sym(i, ...
                            'Marker', FIG_BR_MARKER, ...
                            'MarkerFaceColor', FIG_BR_COLOR, ...
                            'MarkerEdgeColor', FIG_BR_COLOR, ...
                            'MarkerSize', FIG_BR_SIZE)
                    end
                end
            end
            set(ui_toolbar_br, 'State', 'on');
        elseif isequal(action_case, {'remove'})
            ba.br_syms_off()
            set(ui_toolbar_br, 'State', 'off');
        end
        
        % labels
        if get(ui_checkbox_figure_labels, 'Value')
            ba.br_labs_on()
            for i = 1:1:atlas.getBrainRegions().length()
                X = atlas.getBrainRegions().getValue(i).getX();
                Y = atlas.getBrainRegions().getValue(i).getY();
                Z = atlas.getBrainRegions().getValue(i).getZ();
                label = atlas.getBrainRegions().getValue(i).getLabel();
                ba.br_lab(i, ...
                    'UIContextMenu', ui_contextmenu_figure_labels, ...
                    'UserData', {1 i X Y Z label});
            end
            set(ui_toolbar_label, 'State', 'on');
        else
            ba.br_labs_off()
            set(ui_toolbar_label, 'State', 'off');
        end
    end
    function cb_figure_plotsettings(~, ~)  % (src, event)
        update_figure_brainview()
    end

%% Menus
MENU_FILE = GUI.MENU_FILE;
MENU_EDIT = GUI.MENU_EDIT;
MENU_BRAINVIEW = 'Brain View';
% MENU_COHORTS = 'Subject Cohorts';

ui_menu_file = uimenu(f, 'Label', MENU_FILE);
ui_menu_file_open = uimenu(ui_menu_file);
ui_menu_file_save = uimenu(ui_menu_file);
ui_menu_file_saveas = uimenu(ui_menu_file);
ui_menu_file_import_txt = uimenu(ui_menu_file);
ui_menu_file_import_xls = uimenu(ui_menu_file);
ui_menu_file_import_json = uimenu(ui_menu_file);
ui_menu_file_export_txt = uimenu(ui_menu_file);
ui_menu_file_export_xls = uimenu(ui_menu_file);
ui_menu_file_export_json = uimenu(ui_menu_file);
ui_menu_file_close = uimenu(ui_menu_file);
ui_menu_edit = uimenu(f, 'Label', MENU_EDIT);
ui_menu_edit_selectall = uimenu(ui_menu_edit);
ui_menu_edit_clearselection = uimenu(ui_menu_edit);
ui_menu_edit_add = uimenu(ui_menu_edit);
ui_menu_edit_remove = uimenu(ui_menu_edit);
ui_menu_edit_moveup = uimenu(ui_menu_edit);
ui_menu_edit_movedown = uimenu(ui_menu_edit);
ui_menu_edit_move2top = uimenu(ui_menu_edit);
ui_menu_edit_move2bottom = uimenu(ui_menu_edit);
ui_menu_brainview = uimenu(f, 'Label', MENU_BRAINVIEW);
ui_menu_brainview_figure = uimenu(ui_menu_brainview);
% % ui_menu_cohorts = uimenu(f, 'Label', MENU_COHORTS);
% % ui_menu_cohorts_mricohort = uimenu(ui_menu_cohorts);
% % ui_menu_cohorts_fmricohort = uimenu(ui_menu_cohorts);
% % ui_menu_cohorts_eegcohort = uimenu(ui_menu_cohorts);
% % ui_menu_cohorts_petcohort = uimenu(ui_menu_cohorts);
init_menu()
    function init_menu()
        % menu open/save
        set(ui_menu_file_open, 'Label', OPEN_CMD)
        set(ui_menu_file_open, 'Accelerator', OPEN_SC)
        set(ui_menu_file_open, 'Callback', {@cb_open})
        
        set(ui_menu_file_save, 'Separator', 'on')
        set(ui_menu_file_save, 'Label', SAVE_CMD)
        set(ui_menu_file_save, 'Accelerator', SAVE_SC)
        set(ui_menu_file_save, 'Callback', {@cb_save})
        
        set(ui_menu_file_saveas, 'Label', SAVEAS_CMD)
        set(ui_menu_file_saveas, 'Callback', {@cb_saveas});
        
        % menu import
        set(ui_menu_file_import_txt, 'Separator', 'on')
        set(ui_menu_file_import_txt, 'Label', IMPORT_TXT_CMD)
        set(ui_menu_file_import_txt, 'Callback', {@cb_import_txt})
        
        set(ui_menu_file_import_xls, 'Label', IMPORT_XLS_CMD)
        set(ui_menu_file_import_xls, 'Callback', {@cb_import_xls})
        
        set(ui_menu_file_import_json, 'Label', IMPORT_JSON_CMD)
        set(ui_menu_file_import_json, 'Callback', {@cb_import_json})
        
        % menu export
        set(ui_menu_file_export_txt, 'Label', EXPORT_TXT_CMD)
        set(ui_menu_file_export_txt, 'Callback', {@cb_export_txt})
        
        set(ui_menu_file_export_xls, 'Label', EXPORT_XLS_CMD)
        set(ui_menu_file_export_xls, 'Callback', {@cb_export_xls})
        
        set(ui_menu_file_export_json, 'Label', EXPORT_JSON_CMD)
        set(ui_menu_file_export_json, 'Callback', {@cb_export_json})
        
        % menu close
        set(ui_menu_file_close, 'Separator', 'on')
        set(ui_menu_file_close, 'Label', CLOSE_CMD)
        set(ui_menu_file_close, 'Accelerator', CLOSE_SC);
        set(ui_menu_file_close, 'Callback', ['GUI.close(''' APPNAME ''',gcf)'])
        
        set(ui_menu_edit_selectall, 'Label', SELECTALL_CMD)
        set(ui_menu_edit_selectall, 'Callback', {@cb_table_selectall})
        
        set(ui_menu_edit_clearselection, 'Label', CLEARSELECTION_CMD)
        set(ui_menu_edit_clearselection, 'Callback', {@cg_table_clearselection})
        
        set(ui_menu_edit_add, 'Separator', 'on')
        set(ui_menu_edit_add, 'Label', ADD_CMD)
        set(ui_menu_edit_add, 'Accelerator', ADD_SC)
        set(ui_menu_edit_add, 'Callback', {@cb_table_add})
        
        set(ui_menu_edit_remove, 'Label', REMOVE_CMD)
        set(ui_menu_edit_remove, 'Accelerator', REMOVE_SC)
        set(ui_menu_edit_remove, 'Callback', {@cb_table_remove})
        
        set(ui_menu_edit_moveup, 'Separator', 'on')
        set(ui_menu_edit_moveup, 'Label', MOVEUP_CMD)
        set(ui_menu_edit_moveup, 'Accelerator', MOVEUP_SC)
        set(ui_menu_edit_moveup, 'Callback', {@cb_table_moveup})
        
        set(ui_menu_edit_movedown, 'Label', MOVEDOWN_CMD)
        set(ui_menu_edit_movedown, 'Accelerator', MOVEDOWN_SC)
        set(ui_menu_edit_movedown, 'Callback', {@cb_table_movedown})
        
        set(ui_menu_edit_move2top, 'Label', MOVE2TOP_CMD)
        set(ui_menu_edit_move2top, 'Accelerator', MOVE2TOP_SC)
        set(ui_menu_edit_move2top, 'Callback', {@cb_vmove2top})
        
        set(ui_menu_edit_move2bottom, 'Label', MOVE2BOTTOM_CMD)
        set(ui_menu_edit_move2bottom, 'Accelerator', MOVE2BOTTOM_SC)
        set(ui_menu_edit_move2bottom, 'Callback', {@cb_table_move2bottom})
        
        set(ui_menu_brainview_figure, 'Label', FIGURE_CMD)
        set(ui_menu_brainview_figure, 'Accelerator', FIGURE_SC)
        set(ui_menu_brainview_figure, 'Callback', {@cb_menu_figure})
        
        %         set(ui_menu_cohorts_mricohort, 'Label', MRICOHORT_CMD)
        %         set(ui_menu_cohorts_mricohort, 'Callback', {@cb_menu_mricohort})
        %
        %         set(ui_menu_cohorts_fmricohort, 'Label', fMRICOHORT_CMD)
        %         set(ui_menu_cohorts_fmricohort, 'Callback', {@cb_menu_fmricohort})
        %
        %         set(ui_menu_cohorts_eegcohort, 'Label', EEGCOHORT_CMD)
        %         set(ui_menu_cohorts_eegcohort, 'Callback', {@cb_menu_eegcohort})
        %
        %         set(ui_menu_cohorts_petcohort, 'Label', PETCOHORT_CMD)
        %         set(ui_menu_cohorts_petcohort, 'Callback', {@cb_menu_petcohort})
    end
[ui_menu_about, ui_menu_about_about] = GUI.setMenuAbout(f, APPNAME); %#ok<ASGLU>
    function cb_menu_figure(~, ~)  % (src, event)
        h = figure('Name', ['Brain Atlas - ' atlas.getID()]);
        set(gcf, 'Color', 'w')
        copyobj(ui_axes_figure, h)
        set(gca, 'Units', 'normalized')
        set(gca, 'OuterPosition', [0 0 1 1])
    end
%     function cb_menu_mricohort(~, ~)  % (src, event)
%         if atlas.getBrainRegions().length() > 0
%             GUIMRICohort(atlas.copy())
%         else
%             msgbox('In order to create an MRI cohort the brain atlas must have at least one brain region.', ...
%                 'Warning: Empty brain atlas', ...
%                 'warn')
%         end
%     end
%     function cb_menu_fmricohort(~,~) % (src,event)
%         if atlas.getBrainRegions().length()>0
%             GUIfMRICohort(atlas.copy())
%         else
%             msgbox('In order to create an fMRI cohort the brain atlas must have at least one brain region.', ...
%                 'Warning: Empty brain atlas', ...
%                 'warn')
%         end
%     end
%     function cb_menu_eegcohort(~,~) % (src,event)
%         if atlas.getBrainRegions().length()>0
%             GUIEEGCohort(atlas.copy())
%         else
%             msgbox('In order to create an EEG cohort the brain atlas must have at least one brain region.', ...
%                 'Warning: Empty brain atlas', ...
%                 'warn')
%         end
%     end
%     function cb_menu_petcohort(~,~) % (src,event)
%         if atlas.getBrainRegions().length()>0
%             GUIPETCohort(atlas.copy())
%         else
%             msgbox('In order to create an PET cohort the brain atlas must have at least one brain region.', ...
%                 'Warning: Empty brain atlas', ...
%                 'warn')
%         end
%     end

%% Toolbar
set(f, 'Toolbar', 'figure')
ui_toolbar = findall(f, 'Tag', 'FigureToolBar');
ui_toolbar_open = findall(ui_toolbar, 'Tag', 'Standard.FileOpen');
ui_toolbar_save = findall(ui_toolbar, 'Tag', 'Standard.SaveFigure');
ui_toolbar_3D = uipushtool(ui_toolbar);
ui_toolbar_SL = uipushtool(ui_toolbar);
ui_toolbar_SR = uipushtool(ui_toolbar);
ui_toolbar_AD = uipushtool(ui_toolbar);
ui_toolbar_AV = uipushtool(ui_toolbar);
ui_toolbar_CA = uipushtool(ui_toolbar);
ui_toolbar_CP = uipushtool(ui_toolbar);
ui_toolbar_brain = uitoggletool(ui_toolbar);
ui_toolbar_axis = uitoggletool(ui_toolbar);
ui_toolbar_grid = uitoggletool(ui_toolbar);
ui_toolbar_br = uitoggletool(ui_toolbar);
ui_toolbar_label = uitoggletool(ui_toolbar);
init_toolbar()
    function init_toolbar()
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
        
        set(ui_toolbar_open, 'TooltipString', OPEN_TP);
        set(ui_toolbar_open, 'ClickedCallback', {@cb_open})
        
        set(ui_toolbar_save, 'TooltipString', SAVE_TP);
        set(ui_toolbar_save, 'ClickedCallback', {@cb_save})
        
        set(ui_toolbar_3D, 'Separator', 'on');
        
        set(ui_toolbar_3D, 'TooltipString', FIG_VIEW_3D_CMD);
        set(ui_toolbar_3D, 'CData', imread('icon_view_3d.png'));
        set(ui_toolbar_3D, 'ClickedCallback', {@cb_toolbar_3D})
        function cb_toolbar_3D(~, ~)  % (src, event)
            set(ui_button_figure_3d, 'Value', true);
            update_figure_brainview()
        end
        
        set(ui_toolbar_SL, 'TooltipString', FIG_VIEW_SL_CMD);
        set(ui_toolbar_SL, 'CData', imread('icon_view_sl.png'));
        set(ui_toolbar_SL, 'ClickedCallback', {@cb_toolbar_SL})
        function cb_toolbar_SL(~, ~)  % (src, event)
            set(ui_button_figure_sagittalleft, 'Value', true);
            update_figure_brainview()
        end
        
        set(ui_toolbar_SR, 'TooltipString', FIG_VIEW_SR_CMD);
        set(ui_toolbar_SR, 'CData', imread('icon_view_sr.png'));
        set(ui_toolbar_SR, 'ClickedCallback', {@cb_toolbar_SR})
        function cb_toolbar_SR(~, ~)  % (src, event)
            set(ui_button_figure_sagittalright, 'Value', true);
            update_figure_brainview()
        end
        
        set(ui_toolbar_AD, 'TooltipString', FIG_VIEW_AD_CMD);
        set(ui_toolbar_AD, 'CData', imread('icon_view_ad.png'));
        set(ui_toolbar_AD, 'ClickedCallback', {@cb_toolbar_AD})
        function cb_toolbar_AD(~, ~)  % (src, event)
            set(ui_button_figure_axialdorsal, 'Value', true);
            update_figure_brainview()
        end
        
        set(ui_toolbar_AV, 'TooltipString', FIG_VIEW_AV_CMD);
        set(ui_toolbar_AV, 'CData', imread('icon_view_av.png'));
        set(ui_toolbar_AV, 'ClickedCallback', {@cb_toolbar_AV})
        function cb_toolbar_AV(~, ~)  % (src, event)
            set(ui_button_figure_axialventral, 'Value', true);
            update_figure_brainview()
        end
        
        set(ui_toolbar_CA, 'TooltipString', FIG_VIEW_CA_CMD);
        set(ui_toolbar_CA, 'CData', imread('icon_view_ca.png'));
        set(ui_toolbar_CA, 'ClickedCallback', {@cb_toolbar_CA})
        function cb_toolbar_CA(~, ~)  % (src, event)
            set(ui_button_figure_coronalanterior, 'Value', true);
            update_figure_brainview()
        end
        
        set(ui_toolbar_CP, 'TooltipString', FIG_VIEW_CP_CMD);
        set(ui_toolbar_CP, 'CData', imread('icon_view_cp.png'));
        set(ui_toolbar_CP, 'ClickedCallback', {@cb_toolbar_CP})
        function cb_toolbar_CP(~, ~)  % (src, event)
            set(ui_button_figure_coronalposterior, 'Value', true);
            update_figure_brainview()
        end
        
        set(ui_toolbar_brain, 'Separator', 'on');
        
        set(ui_toolbar_brain, 'TooltipString', FIG_BRAIN_CMD);
        set(ui_toolbar_brain, 'State', 'on');
        set(ui_toolbar_brain, 'CData', imread('icon_brain.png'));
        set(ui_toolbar_brain, 'OnCallback', {@cb_toolbar_brain_on})
        set(ui_toolbar_brain, 'OffCallback', {@cb_toolbar_brain_off})
        function cb_toolbar_brain_on(~, ~)  % (src, event)
            set(ui_checkbox_figure_brain, 'Value', true)
            update_figure_brainview()
        end
        function cb_toolbar_brain_off(~, ~)  % (src, event)
            set(ui_checkbox_figure_brain, 'Value', false)
            update_figure_brainview()
        end
        
        set(ui_toolbar_axis, 'TooltipString', FIG_AXIS_CMD);
        set(ui_toolbar_axis, 'State', 'on');
        set(ui_toolbar_axis, 'CData', imread('icon_axis.png'));
        set(ui_toolbar_axis, 'OnCallback', {@cb_toolbar_axis_on})
        set(ui_toolbar_axis, 'OffCallback', {@cb_toolbar_axis_off})
        function cb_toolbar_axis_on(~, ~)  % (src, event)
            set(ui_checkbox_figure_axis, 'Value', true)
            update_figure_brainview()
        end
        function cb_toolbar_axis_off(~, ~)  % (src, event)
            set(ui_checkbox_figure_axis, 'Value', false)
            update_figure_brainview()
        end
        
        set(ui_toolbar_grid, 'TooltipString', FIG_GRID_CMD);
        set(ui_toolbar_grid, 'State', 'on');
        set(ui_toolbar_grid, 'CData', imread('icon_grid.png'));
        set(ui_toolbar_grid, 'OnCallback', {@cb_toolbar_grid_on})
        set(ui_toolbar_grid, 'OffCallback', {@cb_toolbar_grid_off})
        function cb_toolbar_grid_on(~, ~)  % (src, event)
            set(ui_checkbox_figure_grid, 'Value', true)
            update_figure_brainview()
        end
        function cb_toolbar_grid_off(~, ~)  % (src, event)
            set(ui_checkbox_figure_grid, 'Value', false)
            update_figure_brainview()
        end
        
        set(ui_toolbar_br, 'TooltipString', FIG_BR_CMD);
        set(ui_toolbar_br, 'State', 'on');
        set(ui_toolbar_br, 'CData', imread('icon_br.png'));
        set(ui_toolbar_br, 'OnCallback', {@cb_toolbar_br_on})
        set(ui_toolbar_br, 'OffCallback', {@cb_toolbar_br_off})
        function cb_toolbar_br_on(~, ~)  % (src, event)
            set(ui_checkbox_figure_br, 'Value', true)
            update_figure_brainview()
        end
        function cb_toolbar_br_off(~, ~)  % (src, event)
            set(ui_checkbox_figure_br, 'Value', false)
            update_figure_brainview()
        end
        
        set(ui_toolbar_label, 'TooltipString', FIG_LABELS_CMD);
        set(ui_toolbar_label, 'State', 'on');
        set(ui_toolbar_label, 'CData', imread('icon_label.png'));
        set(ui_toolbar_label, 'OnCallback', {@cb_toolbar_label_on})
        set(ui_toolbar_label, 'OffCallback', {@cb_toolbar_label_off})
        function cb_toolbar_label_on(~, ~)  % (src, event)
            set(ui_checkbox_figure_labels, 'Value', true)
            update_figure_brainview()
        end
        function cb_toolbar_label_off(~, ~)  % (src, event)
            set(ui_checkbox_figure_labels, 'Value', false)
            update_figure_brainview()
        end
    end

%% Make the GUI visible.
setup()
set(f, 'Visible', 'on');

setup_restrictions()
    function setup_restrictions()
        if exist('restricted', 'var') && restricted
            set(ui_button_table_add, 'enable', 'off')
            set(ui_button_table_remove, 'enable', 'off')
            set(ui_button_table_moveup, 'enable', 'off')
            set(ui_button_table_movedown, 'enable', 'off')
            set(ui_button_table_move2top, 'enable', 'off')
            set(ui_button_table_move2bottom, 'enable', 'off')
            
            set(ui_menu_file_open, 'enable', 'off')
            set(ui_menu_file_import_txt, 'enable', 'off')
            set(ui_menu_file_import_xls, 'enable', 'off')
            set(ui_menu_file_import_json, 'enable', 'off')
            set(ui_menu_edit_add, 'enable', 'off')
            set(ui_menu_edit_remove, 'enable', 'off')
            set(ui_menu_edit_moveup, 'enable', 'off')
            set(ui_menu_edit_movedown, 'enable', 'off')
            set(ui_menu_edit_move2top, 'enable', 'off')
            set(ui_menu_edit_move2bottom, 'enable', 'off')
            
            set(ui_toolbar_open, 'enable', 'off')
        end
    end

%% Auxiliary functions
    function setup()
        % setup table
        update_table_id()
        update_table_label()
        update_table_notes()
        update_table_table()
        % setup figure
        create_figure()
    end

end