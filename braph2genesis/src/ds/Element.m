classdef Element < Category & Format & matlab.mixin.Copyable
    %Element is the base class for all elements.
    % Even though it is possible to create instances of Element, typically
    %  one uses its subclasses. It is a subclass of Category, Format,
    %  handle, and matlab.mixin.Copyable.
    %
    % See also Category, Format, NoValue, Callback, IndexedDictionary, handle, matlab.mixin.Copyable.

    properties (Access=private)
        % props is a private struct containing the element properties whose
        % details depend on the property category (YOCO, YADIR):
        %
        % METADATA:
        % props{prop}.value     - value
        % props{prop}.seed      - seed for rng
        % props{prop}.checked 	- true/false
        % props{prop}.locked    - false/true
        %
        % PARAMETER, DATA:
        % props{prop}.value     - NoValue() or value or Callback()
        % props{prop}.seed      - seed for rng
        % props{prop}.checked   - true/false
        % props{prop}.locked    - false/true
        %
        % RESULT:
        % props{prop}.value     - NoValue() or value
        % props{prop}.seed      - seed for rng
        % props{prop}.checked 	- true/false
        % props{prop}.locked    - false/true
        %
        % The parameter and data properties of the element get locked the
        % first time a result is successfully calculated.
        props
    end
    methods (Static) % inspection
        function el_class = getClass(el)
			%GETCLASS returns the class of the element.
			%
            % CLASS = Element.GETCLASS() returns the class 'Element'.
            % 
            % Alternative forms to call this method are:
            %  CLASS = EL.GETCLASS() returns the class of the element EL.
			%  CLASS = Element.GETCLASS(CLASS) returns CLASS.
			%  CLASS = EL.GETCLASS(CLASS) returns CLASS.
			%
			% See also getName, getDescription.

            % calls from Element
            if nargin < 1
                el_class = 'Element';
                return
            end
            
            % calls from subclasses of Element
            if isa(el, 'Element')
                el_class = class(el);
            else % el should be a string with the element class
                el_class = el;
                assert( ...
                    exist(el_class, 'class') == 8, ...
                    [BRAPH2.STR ':Element:' BRAPH2.WRONG_INPUT], ...
                    [BRAPH2.STR ':Element:' BRAPH2.WRONG_INPUT ' ' ...
                    'The value ' tostring(el, 100, '...') 'is not a valid class name.'] ...
                    )
            end
        end
        function el_name = getName(el)
			%GETNAME returns the name of the element.
			%
            % NAME = Element.GETNAME() returns the name of the element,
            %  which in this case is 'Base class for all elements.'
            % 
            % Alternative forms to call this method are:
            %  NAME = EL.GETNAME() returns the name of the element EL.
			%  NAME = Element.GETNAME(CLASS) returns the name of CLASS.
			%  NAME = EL.GETNAME(CLASS) returns the name of CLASS.
			%
			% See also getClass, getDescription.

            % calls from Element
            if nargin < 1
                el_name = 'Base class for all elements.';
                return
            end
            
            % calls from subclasses of Element
            el_name = eval([Element.getClass(el) '.getName()']);
        end
        function el_description = getDescription(el)
			%GETNAME returns the description of the element.
			%
            % STR = Element.GETDESCRIPTION() returns the description of the element,
            %  which in this case is:
            %
            %  Element is the base class for all elements. 
            %  Even though it is possible to create instances of Element, 
            %  typically one uses its subclasses.
            %
            % Alternative forms to call this method are:
            %  STR = EL.GETDESCRIPTION() returns the description of the element EL.
			%  STR = Element.GETDESCRIPTION(CLASS) returns the description of CLASS.
			%  STR = EL.GETDESCRIPTION(CLASS) returns the description of CLASS.
			%
			% See also getClass, getName.

            % calls from Element
            if nargin < 1
                el_description = [ ...
                    'Element is the base class for all elements. ' ...
                    'Even though it is possible to create instances of Element, ' ...
                    'typically one uses its subclasses.' ...
                    ];
                return
            end
            
            % calls from subclasses of Element
            el_description = eval([Element.getClass(el) '.getDescription()']);
        end
        function prop_list = getProps(el, category)
			%GETPROPS returns the property list of an element.
			%
            % PROPS = Element.GETPROPS() returns the property list of Element.
            %
            % PROPS = Element.GETPROPS(CATEGORY) returns the property list
            %  of category CATEGORY.
            %
            % Alternative forms to call this method are:
            %  PROPS = EL.GETPROPS([CATEGORY]) returns the property list of element EL.
			%  PROPS = Element.GETPROPS(CLASS[, CATEGORY]) returns the property list of CLASS.
			%  PROPS = EL.GETPROPS(CLASS[, CATEGORY]) returns the property list of CLASS.
			%
			% See also getPropNumber, Category.
            
            % calls from Element
            if nargin < 1 % no arguments
                prop_list = [];
                return
            elseif nargin == 1 && Category.existsCategory(el) % category argument
                prop_list = [];                
                return
            end
            
            % calls from subclasses of Element
            if nargin < 2
                prop_list = eval([Element.getClass(el) '.getProps()']);
            else
                Category.existsCategory(category);
                
                prop_list = eval([Element.getClass(el) '.getProps(category)']);
            end
        end
        function prop_number = getPropNumber(el)
			%GETPROPNUMBER returns the property number of an element.
			%
            % N = Element.GETPROPNUMBER() returns the number of properties in Element.
            %
            % Alternative forms to call this method are:
            %  N = EL.GETPROPNUMBER() returns the property number of element EL.
			%  N = Element.GETPROPNUMBER(CLASS) returns the property number of CLASS.
			%  N = EL.GETPROPNUMBER(CLASS) returns the property number of CLASS.
			%
			% See also getProps.
            
            % calls from Element
            if nargin < 1
                prop_number = 0;
                return
            end
            
            % calls from subclasses of Element
            prop_number = eval([Element.getClass(el) '.getPropNumber()']);
        end
        function check = existsProp(el, prop)
            %EXISTSPROP checks whether property exists/error.
			%
            % CHECK = Element.EXISTSPROP(PROP) checks whether the property 
            %  PROP exists.
            %
            % Alternative forms to call this method are:
            %  CHECK = EL.EXISTSPROP(PROP) checks PROP for EL.
            %  CHECK = Element.EXISTSPROP(CLASS, PROP) checks PROP for CLASS.
            %  CHECK = EL.EXISTSPROP(CLASS, PROP) checks PROP for CLASS.
            % 
            % Element.EXISTSPROP(PROP) throws an error if the PROP does NOT
            %  exist.
            %  Error id: [BRAPH2:Element:WrongInput]
			%
            % Alternative forms to call this method are:
            %  EL.EXISTSPROP(PROP) throws error if PROP does NOT exist for EL.
            %   Error id: [BRAPH2:Element:WrongInput]
            %  Element.EXISTSPROP(CLASS, PROP) throws error if PROP does NOT exist for EL.
            %   Error id: [BRAPH2:CLASS:WrongInput]
            %  EL.EXISTSPROP(CLASS, PROP) throws error if PROP does NOT exist for EL.
            %   Error id: [BRAPH2:CLASS:WrongInput]
            %
			% See also getProps, existsTag.
            
            % calls from Element
            if nargin < 2
                prop = el;
                el = 'Element';
            end
            
            % calls from subclasses of Element
            if nargout == 1
                check = any(prop == Element.getProps(el));
            else
                assert( ...
                    Element.existsProp(el, prop), ...
                    [BRAPH2.STR ':Element:' BRAPH2.WRONG_INPUT], ...
                    [BRAPH2.STR ':Element:' BRAPH2.WRONG_INPUT ' ' ...
                    'The value ' tostring(prop) ' is not a valid prop for ' Element.getClass(el) '.'] ...
                    )
            end
        end
        function check = existsTag(el, tag)
            %EXISTSTAG checks whether tag exists/error.
			%
            % CHECK = Element.EXISTSTAG(TAG) checks whether tag TAG exists.
            %
            % Alternative forms to call this method are:
            %  CHECK = EL.EXISTSTAG(TAG) checks tag TAG for EL.
            %  CHECK = Element.EXISTSTAG(CLASS, TAG) checks tag TAG for EL.
            %  CHECK = EL.EXISTSTAG(CLASS, TAG) checks tag TAG for EL.
            %
            % Element.EXISTSTAG(TAG) throws an error if the TAG NOT exist.
            %  Error id: [BRAPH2:Element:WrongInput]
            %
            % Alternative forms to call this method are:
            %  EL.EXISTSTAG(TAG) throws error if TAG does NOT exist for EL.
            %   Error id: [BRAPH2:Element:WrongInput]
            %  Element.EXISTSTAG(CLASS, TAG) throws error if TAG does NOT 
            %   exist for EL. Error id: [BRAPH2:Element:WrongInput]
            %  Element.EXISTSTAG(CLASS, TAG) throws error if TAG does NOT 
            %   exist for EL. Error id: [BRAPH2:Element:WrongInput] 
            %
			% See also getProps, existsProp.
            
            % calls from Element
            if nargin < 2
                tag = el;
                el = 'Element';
            end
            
            % calls from subclasses of Element
            if nargout == 1
                tag_list = cellfun(@(x) Element.getPropTag(el, x), num2cell(Element.getProps(el)'), 'UniformOutput', false);
                check = any(strcmpi(tag, tag_list));
            else
                assert( ...
                    Element.existsTag(el, tag), ...
                    [BRAPH2.STR ':Element:' BRAPH2.WRONG_INPUT], ...
                    [BRAPH2.STR ':Element:' BRAPH2.WRONG_INPUT ' ' ...
                    'The value ''' tag ''' is not a valid tag for ' Element.getClass(el) '.'] ...
                    )
            end
        end
        function prop_prop = getPropProp(el, pointer)
            % GETPROPPROP returns the property number of a property.
			%
            % PROP = Element.GETPROPPROP(PROP) returns PROP, i.e., the
            %  property number of the property PROP.
            %
            % PROP = Element.GETPROPPROP(TAG) returns the property number
            %  of the property with tag TAG.
            %
            % Alternative forms to call this method are (POINTER = PROP or TAG):
            %  PROP = EL.GETPROPPROP(POINTER) returns property number of POINTER of EL.
			%  PROP = Element.GETPROPPROP(CLASS, POINTER) returns property number of POINTER of CLASS.
			%  PROP = EL.GETPROPPROP(CLASS, POINTER) returns property number of POINTER of CLASS.
			%
			% See also getPropFormat, getPropTag, getPropCategory,
			% getPropDescription, getPropSettings, getPropDefault,
			% checkProp.
            
            % calls from Element
            if nargin < 2
                pointer = el; %#ok<NASGU>
                el = 'Element';
            end
            
            % calls from subclasses of Element
            prop_prop = eval([Element.getClass(el) '.getPropProp(pointer)']);
        end       
        function prop_tag = getPropTag(el, pointer)
            % GETPROPTAG returns the tag of a property.
			%
            % TAG = Element.GETPROPTAG(PROP) returns the tag TAG of the
            %  property PROP.
            %
            % TAG = Element.GETPROPTAG(TAG) returns TAG, i.e. the tag of
            %  the property with tag TAG.
            %
            % Alternative forms to call this method are (POINTER = PROP or TAG):
            %  TAG = EL.GETPROPTAG(POINTER) returns tag of POINTER of EL.
			%  TAG = Element.GETPROPTAG(CLASS, POINTER) returns tag of POINTER of CLASS.
			%  TAG = EL.GETPROPTAG(CLASS, POINTER) returns tag of POINTER of CLASS.
            %
			% See also getPropProp, getPropSettings, getPropCategory,
			% getPropFormat, getPropDescription, getPropDefault,
			% checkProp.
            
            % calls from Element
            if nargin < 2
                pointer = el; %#ok<NASGU>
                el = 'Element';
            end
            
            % calls from subclasses of Element
            prop_tag = eval([Element.getClass(el) '.getPropTag(pointer)']);
        end
        function prop_category = getPropCategory(el, pointer)
            % GETPROPCATEGORY returns the category of a property.
			%
            % CATEGORY = Element.GETPROPCATEGORY(PROP) returns the 
            %  category of the property PROP.
            %
            % CATEGORY = Element.GETPROPCATEGORY(TAG) returns the
            %  category of the property with tag TAG.
            %
            % Alternative forms to call this method are (POINTER = PROP or TAG):
            %  CATEGORY = EL.GETPROPCATEGORY(POINTER) returns category of POINTER of EL.
			%  CATEGORY = Element.GETPROPCATEGORY(CLASS, POINTER) returns category of POINTER of CLASS.
			%  CATEGORY = EL.GETPROPCATEGORY(CLASS, POINTER) returns category of POINTER of CLASS.
            %
			% See also Category, getPropProp, getPropTag, getPropSettings,
			% getPropFormat, getPropDescription, getPropDefault,
			% checkProp.
            
            % calls from Element
            if nargin < 2
                pointer = el; %#ok<NASGU>
                el = 'Element';
            end
            
            % calls from subclasses of Element
            prop_category = eval([Element.getClass(el) '.getPropCategory(pointer)']);
        end
        function prop_format = getPropFormat(el, pointer)
            % GETPROPFORMAT returns the format of a property.
			%
            % FORMAT = Element.GETPROPFORMAT(PROP) returns the format of
            %  property PROP.
            %
            % FORMAT = Element.GETPROPFORMAT(TAG) returns the format of
            %  the property with tag TAG.
            %
            % Alternative forms to call this method are (POINTER = PROP or TAG):
            %  FORMAT = EL.GETPROPFORMAT(POINTER) returns format of POINTER of EL.
			%  FORMAT = Element.GETPROPFORMAT(CLASS, POINTER) returns format of POINTER of CLASS.
			%  FORMAT = EL.GETPROPFORMAT(CLASS, POINTER) returns format of POINTER of CLASS.
			%
			% See also Format, getPropProp, getPropTag, getPropCategory,
			% getPropDescription, getPropSettings, getPropDefault,
			% checkProp.

            % calls from Element
            if nargin < 2
                pointer = el; %#ok<NASGU>
                el = 'Element';
            end
            
            % calls from subclasses of Element
            prop_format = eval([Element.getClass(el) '.getPropFormat(pointer)']);
        end
        function prop_description = getPropDescription(el, pointer)
            % GETPROPDESCRIPTION returns the description of a property.
			%
            % DESCRIPTION = Element.GETPROPDESCRIPTION(PROP) returns the 
            %  description of the property PROP.
            %
            % DESCRIPTION = Element.GETPROPDESCRIPTION(TAG) returns the
            %  description of the property with tag TAG.
            %
            % Alternative forms to call this method are (POINTER = PROP or TAG):
            %  DESCRIPTION = EL.GETPROPDESCRIPTION(POINTER) returns description of POINTER of EL.
			%  DESCRIPTION = Element.GETPROPDESCRIPTION(CLASS, POINTER) returns description of POINTER of CLASS.
			%  DESCRIPTION = EL.GETPROPDESCRIPTION(CLASS, POINTER) returns description of POINTER of CLASS.
            %
			% See also getPropProp, getPropTag, getPropCategory,
			% getPropFormat, getPropSettings, getPropDefault,
			% checkProp.
            
            % calls from Element
            if nargin < 2
                pointer = el; %#ok<NASGU>
                el = 'Element';
            end
            
            % calls from subclasses of Element
            prop_description = eval([Element.getClass(el) '.getPropDescription(pointer)']);
        end 
        function prop_settings = getPropSettings(el, pointer)
            % GETPROPSETTINGS returns the settings of a property.
			%
            % SETTINGS = Element.GETPROPSETTINGS(PROP) returns the 
            %  settings of the property PROP.
            %
            % SETTINGS = Element.GETPROPSETTINGS(TAG) returns the
            %  settings of the property with tag TAG.
            %
            % Alternative forms to call this method are (POINTER = PROP or TAG):
            %  SETTINGS = EL.GETPROPSETTINGS(POINTER) returns settings of POINTER of EL.
			%  SETTINGS = Element.GETPROPSETTINGS(CLASS, POINTER) returns settings of POINTER of CLASS.
			%  SETTINGS = EL.GETPROPSETTINGS(CLASS, POINTER) returns settings of POINTER of CLASS.
            %
			% See also getPropProp, getPropTag, getPropCategory,
			% getPropFormat, getPropDescription, getPropDefault,
			% checkProp.
            
            % calls from Element
            if nargin < 2
                pointer = el; %#ok<NASGU>
                el = 'Element';
            end
            
            % calls from subclasses of Element
            prop_settings = eval([Element.getClass(el) '.getPropSettings(pointer)']);
        end 
        function prop_default = getPropDefault(el, pointer)
            %GETPROPDEFAULT returns the default value of a property.
			%
            % DEFAULT = Element.GETPROPDEFAULT(PROP) returns the default
            %   value of the property PROP.
            %
            % DEFAULT = Element.GETPROPDEFAULT(TAG) returns the default
            %   value of the property with tag TAG.
            % 
            % Alternative forms to call this method are (POINTER = PROP or TAG):
            %  TAG = EL.GETPROPDEFAULT(POINTER) returns the default value of POINTER of EL.
			%  TAG = Element.GETPROPDEFAULT(CLASS, POINTER) returns the default value of POINTER of CLASS.
			%  TAG = EL.GETPROPDEFAULT(CLASS, POINTER) returns the default value of POINTER of CLASS.
			%
			% See also getPropProp, getPropTag, getPropSettings,
			% getPropCategory, getPropFormat, getPropDescription,
			% checkProp.

            % calls from Element
            if nargin < 2
                pointer = el; %#ok<NASGU>
                el = 'Element';
            end
            
            % calls from subclasses of Element
            prop_default = eval([Element.getClass(el) '.getPropDefault(pointer)']);
        end
        function prop_check = checkProp(el, pointer, value)
            %CHECKPROP checks whether a value has the correct format/error.
			%
            % CHECK = Element.CHECKPROP(POINTER, VALUE) checks whether
            %  VALUE is an acceptable value for the format of the property
            %  POINTER (POINTER = PROP or TAG).
            %
            % Alternative forms to call this method are:
            %  CHECK = EL.CHECKPROP(POINTER, VALUE) checks VALUE format for PROP of EL.
            %  CHECK = Element.CHECKPROP(CLASS, PROP, VALUE) checks VALUE format for PROP of CLASS.
            %  CHECK = EL.CHECKPROP(CLASS, PROP, VALUE) checks VALUE format for PROP of CLASS.
            % 
            % Element.CHECKPROP(POINTER, VALUE) throws an error if VALUE is
            %  NOT an acceptable value for the format of the property POINTER.
            %  Error id: [BRAPH2:Element:WrongInput]
			%
            % Alternative forms to call this method are:
            %  EL.CHECKPROP(POINTER, VALUE) throws error if VALUE has not a valid format for PROP of EL.
            %   Error id: [BRAPH2:Element:WrongInput]
            %  Element.CHECKPROP(CLASS, PROP, VALUE) throws error if VALUE has not a valid format for PROP of CLASS.
            %   Error id: [BRAPH2:CLASS:WrongInput]
            %  EL.CHECKPROP(CLASS, PROP, VALUE) throws error if VALUE has not a valid format for PROP of CLASS.
            %   Error id: [BRAPH2:CLASS:WrongInput]
            % 
			% See also Format, getPropProp, getPropTag, getPropSettings,
			% getPropCategory, getPropFormat, getPropDescription,
			% getPropDefault.

            if nargout == 1
                prop_check = eval([Element.getClass(el) '.checkProp(pointer, value)']);
            else
                eval([Element.getClass(el) '.checkProp(pointer, value)']);
            end
        end
    end
    methods % constructor
        function el = Element(varargin)
            % ELEMENT() creates an Element.
            %
            % ELEMENT(PROP, VALUE, ...) with property PROP initialized to VALUE.
            %
            % ELEMENT(TAG, VALUE, ...) with property with tag TAG set to VALUE.
            %
            % Multiple properties can be initialized at once identifying
            %  them with either property numbers (PROP) or tags (TAG).
            %
            % See also Category, Format, set, check.
            
            % COMPUTATIONAL EFFICIENCY TRICK
            % undocumented trick to avoid inizialization of props
            % by having a single value (42) in the varargin (e.g. when deep-copying)
            if length(varargin) == 1 && varargin{1} == 42
                return
            end

            % rng('shuffle', 'twister') % this should be done before creating the element to ensure reproducibitlity of the random numbers
            for prop = 1:1:el.getPropNumber()
                el.props{prop}.value = NoValue.getNoValue();
                el.props{prop}.seed = randi(intmax('uint32'));
                el.props{prop}.checked = true;
                el.props{prop}.locked = false;
            end
            
            el.set(varargin{:})
        end
    end
    methods % set/check/get/seed/locked/checked
        function set(el, varargin)
            % varargin = {prop/tag, value, ...}

            % backup properties (if any prop is checked)
            checked = el.getPropNumber() && any(cellfun(@(x) x.checked, el.props));
            if checked
                props_backup = el.props; % props backup
            end
            
            % set
            for i = 1:2:length(varargin)
                prop = el.getPropProp(varargin{i}); % also Element.existsProp(el, prop)
                value = el.conditioning(prop, varargin{i+1}); % also conditions the value
                
                switch el.getPropCategory(prop)
                    case Category.METADATA
                        if el.isChecked(prop)
                            el.checkProp(prop, value) % check value format
                        end
                        
                        el.props{prop}.value = value;
                        
                    case {Category.PARAMETER, Category.DATA}
                        if ~el.isLocked(prop)
                            if isa(value, 'Callback')
                                if ~isequal(el.getPropFormat(prop), value.get('EL').getPropFormat(value.get('PROP')))
                                    warning( ...
                                        [BRAPH2.STR ':' class(el)], ...
                                        [class(el) ': Different formats for a prop (' el.getPropFormat(prop) ') ' ...
                                        'and a callback (' value.get('EL').getPropFormat(value.get('PROP')) '). ' ...
                                        'This is not necessarily an problem.'] ...
                                        )
                                elseif  ~isequal(el.getPropSettings(prop), value.get('EL').getPropSettings(value.get('PROP')))
                                    warning( ...
                                        [BRAPH2.STR ':' class(el)], ...
                                        [class(el) ': Different format settings for a prop (' el.getPropFormat(prop) ', ' tostring(el.getPropSettings(prop)) ') ' ...
                                        'and a callback (' value.get('EL').getPropFormat(value.get('PROP')) ', ' tostring(value.get('EL').getPropSettings(value.get('PROP'))) '). ' ...
                                        'This is not necessarily an problem.'] ...
                                        )                                
                                end

                                el.props{prop}.value = value;
                            else
                                if el.isChecked(prop)
                                    el.checkProp(prop, value) % check value format
                                end

                                el.props{prop}.value = value;
                            end
                        else
                            warning( ...
                                [BRAPH2.STR ':' class(el)], ...
                                [BRAPH2.STR ':' class(el) ' ' ... 
                                'Attempt to set the values of a LOCKED property (' el.getPropTag(prop) '), which was obviously not done. ' ...
                                'Hopefully this won''t create probblems, but your code shouldn''t let this happen!'] ...
                                )                            
                        end
                       
                    case Category.RESULT
                        if isa(value, 'NoValue')
                            el.props{prop}.value = NoValue.getNoValue();
                        else
                            warning( ...
                                [BRAPH2.STR ':' class(el)], ...
                                [BRAPH2.STR ':' class(el) ' ' ...
                                'Rightfully unsuccessful attempt to set result (' el.getPropTag(prop) ') to a value. ' ...
                                'Probably not a problem, but shouldn''t happen with well-written code!'] ...
                                )
                        end
                end
            end
            
            for prop = 1:1:el.getPropNumber()
                el.postprocessing(prop)
            end
            
            % check values and restore (if any prop is checked)
            if checked
                [check, msg] = el.check();
                if ~check
                    el.props = props_backup; % restore props backup
                    error( ...
                        [BRAPH2.STR ':' class(el) ':' BRAPH2.WRONG_INPUT], ...
                        [BRAPH2.STR ':' class(el) ':' BRAPH2.WRONG_INPUT ' ' ...
                        msg '\n' ...
                        'The value of this ' class(el) ' has been restored, \n' ...
                        'so you can keep on working if you are using command line. \n' ...
                        'Nevertheless, there might be problems, so better you check your code!'] ...
                        )
                end
            end
        end
        function [element_check, element_msg] = check(el, varargin)

            value_checks = ones(el.getPropNumber(), true);
            value_msgs = repmat({''}, el.getPropNumber(), 1);
            for prop = 1:1:el.getPropNumber()
                if el.isChecked(prop)
                    value = el.getr(prop);
                    switch el.getPropCategory(prop)
                        case Category.METADATA
                            if ~isa(value, 'NoValue')
                                [value_check, value_msg] = el.checkValue(prop, value);
                            else % NoValue
                                value_check = true;
                                value_msg = '';
                            end
                    
                        case {Category.PARAMETER, Category.DATA}
                            while isa(value, 'Callback')
                                value = value.get('EL').get(value.get('PROP'));
                            end
                            if ~isa(value, 'NoValue')
                                [value_check, value_msg] = el.checkValue(prop, value);
                            else % NoValue
                                value_check = true;
                                value_msg = '';
                            end
                        
                        case Category.RESULT
                            if ~isa(value, 'NoValue')
                                [value_check, value_msg] = el.checkValue(prop, value);
                            else % NoValue
                                value_check = true;
                                value_msg = '';
                            end
                    end
                    value_checks(prop) = value_check;
                    if ~value_check
                        value_msgs{prop} = value_msg;
                    end
                end
            end
            check = all(value_checks);
            msg = join(value_msgs);
            msg = strtrim(msg{1});
            
            if nargout >= 1
                element_check = check;
                element_msg = msg;
            else
                assert( ...
                    check, ...
                    [BRAPH2.STR ':' el.getClass() ':' BRAPH2.BUG_ERR], ...
                    [BRAPH2.STR ':' el.getClass() ':' BRAPH2.BUG_ERR ' ' ...
                    msg] ...
                    )
            end
        end
        function value = getr(el, pointer)
            %GETR returns the row value of a property.
            %
            % VALUE = GETR(EL, PROP) returns the row value of property PROP
            %  of element EL.
            %
            % VALUE = GETR(EL, TAG) returns the row value of property TAG
            %  of element EL.
            %
            % See also get, memorize, set, check.
            
            prop = el.getPropProp(pointer); % also Element.existsProp(el, prop)
            
            value = el.props{prop}.value; % raw element value
        end
        function value = get(el, pointer)
            % prop can also be tag

            prop = el.getPropProp(pointer);
            
            value = el.getr(prop);
            
            switch el.getPropCategory(prop)
                case Category.METADATA
                    if isa(value, 'NoValue')
                        value = el.getPropDefault(prop);
                    end
                    
                case {Category.PARAMETER, Category.DATA}
                    if isa(value, 'NoValue')
                        value = el.getPropDefault(prop);
                    elseif isa(value, 'Callback')
                        value = value.get(Callback.EL).get(value.get(Callback.PROP));
                    end
                    
                case Category.RESULT
                    if isa(value, 'NoValue')
                        
                        % backup properties (if prop is checked)
                        if el.isChecked(prop)
                            props_backup = el.props; % props backup
                        end                        
                        
                        value = el.calculateValue(prop);

                        if ~el.isChecked(prop)
                            el.lock()
                        else
                            % check values and restore (if prop is checked)
                            [check, msg] = el.check();
                            if check
                                el.lock()
                            else
                                el.props = props_backup; % restore props backup
                                value = el.props{prop}.value; % value is also set to the original NoValue()
                                warning( ...
                                    [BRAPH2.STR ':' class(el)], ...
                                    [BRAPH2.STR ':' class(el) msg '\n' ...
                                    'The value of this ' class(el) ' has been restored,\n' ...
                                    'but there might be problems, so better you check your code!'] ...
                                    )
                            end
                        end
                    end
            end
        end
        function value = memorize(el, pointer)
            % prop can also be tag

            prop = el.getPropProp(pointer);
            
            value = el.get(prop);

            if isequal(el.getPropCategory(prop), Category.RESULT)
                el.props{prop}.value = value;
            end
        end
        function seed = getPropSeed(el, pointer)
            
            prop = el.getPropProp(pointer);

            seed = el.props{prop}.seed;
        end
        function locked = isLocked(el, pointer)
            % prop can also be tag

            prop = el.getPropProp(pointer);
            
            locked = el.props{prop}.locked;
        end
        function lock(el, pointer)
            % prop can also be tag

            if nargin < 2
                for prop = 1:1:el.getPropNumber()
                    if any(strcmp(el.getPropCategory(prop), {Category.PARAMETER, Category.DATA}))
                        el.lock(prop)
                    end
                end
            else
                if ~el.isLocked(pointer) % This condition is for computational efficiency 
                    prop = el.getPropProp(pointer);

                    el.props{prop}.locked = true;

                    value = el.getr(prop);
                    if isa(value, 'Element')
                        value.lock();
                    elseif iscell(value) && all(all(cellfun(@(x) isa(x, 'Element'), value)))
                        cellfun(@(x) x.lock(), value)
                    end
                end
            end
        end
        function checked = isChecked(el, pointer)
            % prop can also be tag

            prop = el.getPropProp(pointer);
            
            checked = el.props{prop}.checked;
        end
        function checked(el, pointer)
            % prop can also be tag

            if nargin < 2
                for prop = 1:1:el.getPropNumber()
                    el.checked(prop)
                end
            else
                if ~el.isChecked(pointer) % This condition is for computational efficiency 
                    prop = el.getPropProp(pointer);

                    el.props{prop}.checked = true;

                    value = el.getr(prop);
                    if isa(value, 'Element')
                        value.checked();
                    elseif iscell(value) && all(cellfun(@(x) isa(x, 'Element'), value))
                        cellfun(@(x) x.checked(), value)
                    end
                end
            end
        end
        function unchecked(el, pointer)
            % prop can also be tag

            if nargin < 2
                for prop = 1:1:el.getPropNumber()
                    el.unchecked(prop)
                end
            else
                if el.isChecked(pointer) % This condition is for computational efficiency 
                    prop = el.getPropProp(pointer);

                    el.props{prop}.checked = false;

                    value = el.getr(prop);
                    if isa(value, 'Element')
                        value.unchecked();
                    elseif iscell(value) && all(cellfun(@(x) isa(x, 'Element'), value))
                        cellfun(@(x) x.unchecked(), value)
                    end
                end
            end
        end     
    end
    methods % operators
        function check = isequal(el1, el2)
            
            check = isa(el2, el1.getClass());
            
            if check
                for prop = 1:1:el1.getPropNumber()
                    check = check && isequal(el1.getr(prop), el2.getr(prop)) && (el1.isLocked(prop) == el2.isLocked(prop));
                end
            end
        end
    end
    methods (Access=protected) % conditioning
        function value = conditioning(el, prop, value) %#ok<INUSL>
            % returns the same value
        end
    end
    methods (Access=protected) % postprocessing
        function postprocessing(el, prop) %#ok<*INUSD>
            % no action
        end
    end
    methods (Access=protected) % check value
        function [value_check, value_msg] = checkValue(el, prop, value)
            value_check = true;
            value_msg = '';
        end
    end
    methods (Access=protected) % calculate value
        function value = calculateValue(el, prop)
            value = el.getPropDefault(prop);
        end
    end
    methods % display
        function str = tostring(el, varargin)
            if el.getPropNumber() > 0
                % str = char(join([class(el) 'with properties' cellfun(@(prod) el.getPropTag(prod), num2cell(Element.getProps(el)'), 'UniformOutput', false)]));
                str = [class(el) ' with ' int2str(el.getPropNumber()) ' properties ' el.getPropTag(1) ' = ' tostring(el.get(1)) '.'];
            else
                str = [class(el) ' without properties.'];
            end
            str = tostring(str, varargin{:});
            str = str(2:1:end-1);
        end
        function disp(el)

            disp(['<a href="matlab:help ' class(el) '">' class(el) '</a>']);
            el.tree(0)
            
            % for prop = 1:1:el.getPropNumber()
            %     if ~el.isLocked(prop)
            %         disp([upper(el.getPropTag(prop)) ...
            %             ' (' ...
            %             Category.getCategoryName(el.getPropCategory(prop)) ...
            %             ', ' ...
            %             Format.getFormatName(el.getPropFormat(prop)) ...
            %             ') = ' ...
            %             tostring(el.getr(prop))])
            %     else % prop locked
            %         disp([upper(el.getPropTag(prop)) ...
            %             ' (' ...
            %             Category.getCategoryName(el.getPropCategory(prop)) ...
            %             ', ' ...
            %             Format.getFormatName(el.getPropFormat(prop)) ...
            %             ', locked' ...
            %             ') = ' ...
            %             tostring(el.getr(prop))])
            %     end
            % end
        end
        function txt_output = tree(el, level, prop_list, n, ending)
                        
            if nargin < 5
                ending = ' ...';
            end

            if nargin < 4 || isempty(n)
                n = 100;
            end

            if nargin < 3 || isempty(prop_list)
                prop_list = 1:1:el.getPropNumber();
            end
            
            if nargin < 2 || isempty(level)
                level = 0;
            end
            
            txt_el = sprintf(['<strong>' class(el) '</strong>\n']);
            
            for prop = prop_list
                category = el.getPropCategory(prop);
                format = el.getPropFormat(prop);
                value = el.getr(prop);
                
                if el.isLocked(prop)
                    txt_locked = ['<strong>' char(254) '</strong>'];
                else
                    txt_locked = ' ';
                end
                
                if el.isChecked(prop)
                    txt_checked = ['<strong>' char(391) '</strong> '];
                else
                    txt_checked = '  ';
                end
                
                txt_el = [txt_el ...
                    sprintf([ ...
                    int2str(prop) ' ' ...
                    category ' ' ...
                    format ...
                    '\t' upper(el.getPropTag(prop)) ...
                    '\t' txt_locked txt_checked ...
                    '\t' int2str(el.getPropSeed(prop)) ...
                    '\t' tostring(value, n, ending) ...
                    '\n'])]; %#ok<AGROW>
                
                if level > 0
                    if isa(value, 'Callback')
                        cb = value;
                        cb_element = cb.get('el');
                        cb_prop = cb.get('prop');
                        txt_cd = cb_element.tree(level - 1, cb_prop, n, ending);
                        lines = splitlines(txt_cd);
                        for i = 1:1:length(lines)
                            txt_el = [txt_el ...
                                sprintf(['  ' lines{i} '\n']) ... % indent
                                ]; %#ok<AGROW>
                        end
                    elseif isa(value, 'Element')
                        value_el = value;
                        txt_value_el = value_el.tree(level - 1, [], n, ending);
                        lines = splitlines(txt_value_el);
                        for i = 1:1:length(lines)
                            txt_el = [txt_el ...
                                sprintf(['  ' lines{i} '\n']) ... % indent
                                ]; %#ok<AGROW>
                        end                    
                    elseif iscell(value) && all(cellfun(@(x) isa(x, 'Element'), value))
                        for i = 1:1:length(value)
                            txt_el = [txt_el ...
                                sprintf(['  index:<strong>' int2str(i) '</strong> item:']) ... % indent
                                ]; %#ok<AGROW>
                            txt_value_dict_i = value{i}.tree(level - 1, [], n, ending);
                            lines = splitlines(txt_value_dict_i);
                            txt_el = [txt_el ...
                                sprintf([lines{1} '\n']) ...
                                ]; %#ok<AGROW>
                            for j = 2:1:length(lines)
                                txt_el = [txt_el ...
                                    sprintf(['  ' lines{j} '\n']) ... % indent
                                    ]; %#ok<AGROW>
                            end
                        end
                    end
                end
            end
            
            txt_el = txt_el(1:end - 1); % eliminates last carriage return

            if nargout == 1
                txt_output = txt_el;
            else
                disp(txt_el)
            end
        end
    end
    methods % el_list
        function el_list = getElementList(el, el_list)

            if nargin < 2
                el_list = {};
            end
            
            if all(cellfun(@(x) el ~= x, el_list))
                el_list = [el_list(:); {el}];
            end
            
            for prop = 1:1:el.getPropNumber()
                value = el.getr(prop);
                
                if isa(value, 'Element')
                    el_list = value.getElementList(el_list);
                elseif iscell(value) && all(cellfun(@(x) isa(x, 'Element'), value))
                    for i = 1:1:length(value)
                        el_list = value{i}.getElementList(el_list);
                    end
                end
            end
        end        
    end
    methods % encodeJSON
%         function [json, struct, el_list] = encodeJSON(el) %#ok<STOUT>
%             
%             el_list = el.getElementList();
%             
%             for i = 1:1:length(el_list)
%                 el = el_list{i};
%                 
%                 eval(['struct{i}.class = ''' el.getClass() ''';'])
%                 
%                 for prop = 1:1:el.getPropNumber()
%                     value = el.getr(prop);
%                     
%                     switch el.getPropFormat(prop)
%                         case {Format.EMPTY, Format.STRING, Format.OPTION, Format.CLASS}
%                             json_str = regexprep(tostring(value), '''', '''''');
%                         case {Format.LOGICAL, Format.SCALAR, Format.RVECTOR, Format.CVECTOR, Format.MATRIX, Format.SMATRIX}
%                             json_str = mat2str(value);
%                         case Format.CLASSLIST
%                             json_str = '{';
%                             for j = 1:1:length(value)
%                                 json_str = [json_str ' ''' value{j} ''' ']; %#ok<AGROW>
%                             end
%                             json_str = [json_str '}']; %#ok<AGROW>
%                             json_str = regexprep(tostring(json_str), '''', '''''');
%                         case {Format.ITEM, Format.IDICT}
%                             json_str = int2str(find(cellfun(@(x) value == x, el_list)));
%                         case Format.ITEMLIST
%                             indices = zeros(1, length(value));
%                             for j = 1:1:length(value)
%                                 indices(j) = find(cellfun(@(x) value{j} == x, el_list));
%                             end
%                             json_str = mat2str(indices);
%                         case Format.ADJACENCY
%                             % TODO correct this once Format.ADJACENCY is finalized
%                             json_str = mat2str(value);
%                         case Format.MEASURE
%                             % TODO correct this once Format.MEASURE is finalized
%                             json_str = mat2str(value);
%                     end
%                     eval(['struct{i}.props{prop}.value = ''' json_str ''';'])
%                     eval(['struct{i}.props{prop}.locked = ' mat2str(el.isLocked(prop)) ';'])
%                 end
%             end
% 
%             json = jsonencode(struct);
%         end
    end
    methods (Static) % decodeJSON
%         function [el, struct, el_list] = decodeJSON(json)
%             
%             struct = jsondecode(json);
% 
%             % creates empty elements
%             el_list = cell(length(struct), 1);
%             for i = 1:1:length(struct)
%                 el_list{i} = eval([struct{i}.class '()']);
%             end
%             
%             % fills in props
%             for i = 1:1:length(el_list)
%                 el = el_list{i};
%                 
%                 for prop = 1:1:el.getPropNumber()
%                     switch el.getPropFormat(prop)
%                         case {Format.EMPTY, Format.STRING, Format.OPTION, Format.CLASS}
%                             el.props{prop}.value = struct{i}.props(prop).value;
%                         case {Format.LOGICAL, Format.SCALAR, Format.RVECTOR, Format.CVECTOR, Format.MATRIX, Format.SMATRIX}
%                             el.props{prop}.value = eval(struct{i}.props(prop).value);
%                         case Format.CLASSLIST
%                             el.props{prop}.value = eval(struct{i}.props(prop).value(2:end-1));
%                         case {Format.ITEM, Format.IDICT}
%                             el.props{prop}.value = el_list(eval(struct{i}.props(prop).value));
%                         case Format.ITEMLIST
%                             indices = eval(struct{i}.props(prop).value);
%                             el.props{prop}.value = el_list(indices);
%                         case Format.ADJACENCY
%                             % TODO correct this once Format.ADJACENCY is finalized
%                             el.props{prop}.value = eval(struct{i}.props(prop).value);
%                         case Format.MEASURE
%                             % TODO correct this once Format.MEASURE is finalized
%                             el.props{prop}.value = eval(struct{i}.props(prop).value);
%                     end
%                     el.props{prop}.value = struct{i}.props(prop).locked;
%                 end
%             end
%             
%             el = el_list{1};
%         end
    end
    methods (Access=protected) % deep copy
        function el_copy = copyElement(el)

            el_list = el.getElementList();
            
            % creates empty elements
            % fills them with shallow copies of props
            el_copy_list = cell(size(el_list));
            for i = 1:1:length(el_list)
                el_class = el_list{i}.getClass();
                if strcmp(el_class, 'NoValue')
                    el_copy_list{i} = NoValue.getNoValue();
                else
                    el_copy_list{i} = eval([el_class '(42)']);
                    el_copy_list{i}.props = el_list{i}.props;
                end
            end

            % fills in handle props
            for i = 1:1:length(el_list)
                el = el_list{i};
                
                for prop = 1:1:el.getPropNumber()
                    value = el.getr(prop);

                    if isa(value, 'Element')
                        el_copy_list{i}.props{prop}.value = el_copy_list{cellfun(@(x) x == value, el_list)};
                    elseif iscell(value) && all(cellfun(@(x) isa(x, 'Element'), value))
                        for j = 1:1:length(value)
                            el_copy_list{i}.props{prop}.value{j} = el_copy_list{cellfun(@(x) x == value{j}, el_list)};
                        end
                    end
                end
            end
            
            el_copy = el_copy_list{1};
        end
    end
    methods % clone
        function el_clone = clone(el)
            el_clone = el.copy();
            
            el_list = el_clone.getElementList();
            for i = 1:1:length(el_list)
                el = el_list{i};
                for prop = 1:1:el.getPropNumber()
                    el.props{prop}.seed = randi(intmax('uint32'));
                    el.props{prop}.locked = false;
                end
            end
        end
    end
end