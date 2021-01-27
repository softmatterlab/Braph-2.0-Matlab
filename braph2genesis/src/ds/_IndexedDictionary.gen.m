%% ¡header!
IndexedDictionary < Element (idict, indexed dictionary) is an indexed dictionary.

%%% ¡description!
IndexedDictionary provides the methods necessary to handle data in an indexed dictionary. 
It contains and manages an ordered list of couples {KEY, ITEM}, 
where KEY is a unique alphanumeric key (a string) provided by a property of category PARAMETER or DATA and 
ITEM is an element of a class defined in the constructor using the property IT_CLASS.

%%% ¡seealso!
Element

%% ¡props!

%%% ¡prop!
ID (data, string) is a few-letter code.

%%% ¡prop!
IT_CLASS (data, class) is the class of the item elements.
%%%% ¡default!
'IndexedDictionary'

%%% ¡prop!
IT_KEY (data, scalar) is the property of the elements to be used as key (its category must be parameter or data, and its format must be string).
%%%% ¡default!
1
%%%% ¡check_value!
it_class = idict.get('IT_CLASS');
category = Element.getPropCategory(it_class, value);
format = Element.getPropFormat(it_class, value);
check = isequal(format, Format.STRING) && any(strcmp(category, {Category.PARAMETER, Category.DATA}));
if check 
    msg = 'All ok!';
else
    msg = [ ...
        'The format of property ''IT_KEY'' must be ''' Format.STRING ''' (it is ''' format '''). ' ...
        'Its category must be ''' Category.PARAMETER ''' or ''' Category.DATA ''' (it is ''' category ''').' ...
        ];
end

%%% ¡prop!
IT_LIST (data, itemlist) is the list containing the items.
%%%% ¡check_value!
check = all(cellfun(@(x) isa(x, idict.get('IT_CLASS')), idict.get('IT_LIST')));
if check 
    msg = 'All ok!';
else
    msg = ['All items of ''IT_LIST'' must be ' idict.get('IT_CLASS') '.'];
end

%% ¡methods!
function str = tostring(idict, varargin)
    %TOSTRING string with information about the indexed dictionary.
    %
    % STR = TOSTRING(IDICT) returns a string with information about the
    %  indexed dictionary. 
    %
    % STR = TOSTRING(IDICT, N) trims the string to the first N characters.
    %
    % STR = TOSTRING(IDICT, N, ENDING) ends the string with ENDING if it has
    %  been trimmed.
    %
    % See also disp, tree.

	str = [class(idict) ' with ' int2str(idict.length()) ' ' idict.get('IT_CLASS') '.'];
end
% inspection
function it_class = getItemClass(idict)
    %GETITEMCLASS returns the item class of the indexed dictionary.
    %
    % ITEM_CLASS = GETITEMCLASS(IDICT) returns the item class of the indexed dictionary.

    it_class = idict.get('IT_CLASS');
end
function n = length(idict)
    %LENGTH returns the number of items in the indexed dictionary.
    %
    % N = LENGTH(IDICT) returns the number of items in the indexed dictionary.

    n = length(idict.get('IT_LIST'));
end
function bool = contains(idict, pointer)
    %CONTAINS checks if an item exists in an indexed dictionary.
    %
    % BOOL = CONTAINS(IDICT, POINTER) returns true if POINTER (index, key or
    %  item) exists in the indexed dictionary DICT.
    %
    % See also containsIndex, containsKey, containsItem.

    if isa(pointer, 'numeric')  % pointer is index
        bool = idict.containsIndex(pointer);
    elseif isa(pointer, 'char')  % pointer is key
        bool = idict.containsKey(pointer);
    elseif isa(pointer, idict.get('IT_CLASS'))  % pointer is item - not necessarily unique
        bool = idict.containsItem(pointer);
    else
        bool = false;
    end
end
function bool = containsIndex(idict, index)
    %CONTAINSINDEX checks if an index exists in an indexed dictionary.
    %
    % BOOL = CONTAINS(IDICT, INDEX) returns true if the INDEX exists in the
    %  indexed dictionary IDICT.
    %
    % See also contains, containsKey, containsItem.

    if index > 0 && index <= idict.length() && index == round(index)
        bool = true;
    else
        bool = false;
    end
end
function bool = containsKey(idict, key)
    %CONTAINSKEY checks if a key exists in an indexed dictionary.
    %
    % BOOL = CONTAINS(IDICT, KEY) returns true if the KEY exists in the indexed
    %  dictionary DICT.
    %
    % See also contains, containsIndex, containsItem.

    bool = false;
    for i = 1:1:idict.length()
        if isequal(idict.getKey(i), key)
            bool = true;
            break;
        end
    end
end
function bool = containsItem(idict, item)
    %CONTAINSITEM checks if an item exists in an indexed dictionary
    %
    % BOOL = CONTAINSITEM(IDICT, ITEM) returns true if ITEM exists in the
    %  indexed dictionary DICT.
    %
    % See also contains, containsIndex, containsKey.

    bool = false;
    for i = 1:1:idict.length()
        if isequal(idict.getItem(i), item)
            bool = true;
            break;
        end
    end
end
function index = getIndex(idict, pointer) 
    %GETINDEX returns the index of a key or item.
    %
    % INDEX = GETINDEX(IDICT, POINTER) returns the index of a POINTER (a key or
    %  item).
    %
    % See also getIndexFromItem, getIndexFromKey.

   if isa(pointer, 'char')  % pointer is key
        index = idict.getIndexFromKey(pointer);
    elseif isa(pointer, idict.get('IT_CLASS'))  % pointer is item - not necessarily unique
        index = idict.getIndexFromItem(pointer);
    end
end
function index = getIndexFromKey(idict, key)
    %GETINDEXFROMKEY returns the index of a key.
    %
    % INDEX = GETINDEXFROMKEY(IDICT, KEY) returns the index of KEY.
    %
    % See also getIndex, getIndexFromItem.

    for i = 1:1:idict.length()
        if isequal(idict.getKey(i), key)
            index = i;
            break;
        end
    end
end
function index = getIndexFromItem(idict, item)
    %GETINDEXFROMITEM returns the index of a item.
    %
    % INDEX = GETINDEXFROMITEM(IDICT, ITEM) returns the index of the first
    %  occurrence of ITEM.
    %
    % See also getIndex, getIndexFromKey.

    for i = 1:1:idict.length()
        if isequal(idict.getItem(i), item)
            index = i;  % return the first occurrence
            break;
        end
    end
end
function keys = getKeys(idict)
    %GETKEYS returns all the keys in the indexed dictionary.
    %
    % KEYS = GETKEYS(IDICT) returns all the keys in the indexed dictionary.
    %
    % See also getItems.

    keys = cellfun(@(x) x.get(idict.get('IT_KEY')), idict.get('IT_LIST'), 'UniformOutput', false);
end
function key = getKey(idict, pointer)
    %GETKEY returns the key of an index or item.
    %
    % KEY = GETKEY(IDICT, POINTER) returns the key of POINTER (a index or
    %  item). If the POINTER is a item, it returns the first occurrence.
    %
    % See also getKeyFromIndex, getKeyFromItem.

    if isa(pointer, idict.get('IT_CLASS'))  % pointer is item - not necessarily unique
       key = idict.getKeyFromItem(pointer);  % first occurrence
    else  % pointer is an index
        it_list = idict.get('IT_LIST');
        key = it_list{pointer}.get(idict.get('IT_KEY'));
    end
end
function key = getKeyFromIndex(idict, index)
    %GETKEYFROMINDEX returns the key of an index
    %
    % KEY = GETKEYFROMINDEX(IDICT, INDEX) returns the key of INDEX.
    %
    % See also getKey, getKeyFromItem.

    it_list = idict.get('IT_LIST');
    key = it_list{index}.get(idict.get('IT_KEY'));
end
function key = getKeyFromItem(idict, item)
    %GETKEYFROMITEM returns the key of a item.
    %
    % KEY = GETKEYFROMITEM(IDICT, ITEM) returns the key of the first occurrence
    %  of ITEM.
    %
    % See also getKey, getKeyFromIndex.

    it_list = idict.get('IT_LIST');
    index = idict.getIndexFromItem(item);
    key = it_list{index}.get(idict.get('IT_KEY'));
end
function items = getItems(idict)
    %GETITEMS returns all the items in the indexed dictionary
    %
    % ITEMS = GETITEMS(IDICT) returns all the items in the indexed dictionary.
    %
    % See also getKeys.

    items = idict.get('IT_LIST');
end
function item = getItem(idict, pointer)
    %GETITEM returns the item of an index or key.
    %
    % ITEM = GETITEM(IDICT, POINTER) returns the item of POINTER (an index or key).
    %
    % See also getItemFromIndex, getItemFromKey.

    if isa(pointer, 'char')  % pointer is a key
        item = idict.getItemFromKey(pointer);
    else  % pointer is an index
        item = idict.getItemFromIndex(pointer);
    end            
end 
function item = getItemFromIndex(idict, index)    
    %GETITEMFROMINDEX returns the item of an index.
    %
    % ITEM = GETITEMFROMINDEX(IDICT, INDEX) returns the item of INDEX.
    %
    % See also getItem, getItemFromKey.

    it_list = idict.get('IT_LIST');
    item = it_list{index};
end
function item = getItemFromKey(idict, key)
    %GETITEMFROMKEY returns the item of a key.
    %
    % ITEM = GETITEMFROMKEY(IDICT, KEY) returns the item of KEY.
    %
    % See also getItem, getItemFromIndex.

    index = idict.getIndexFromKey(key);
    item  = idict.getItemFromIndex(index);
end
% editing
function add(idict, item, index)
    %ADD adds an item and key to an indexed dictionary
    %
    % ADD(IDICT, ITEM, INDEX) adds an item and key to the indexed dictionary in
    %  position INDEX. If INDEX is empty, it adds it to the end of IDICT.
    %
    % See also remove, replace.

    if nargin < 3 || index <= 0 || index > idict.length()
        index = idict.length() + 1;
    end
    
    assert(isa(item, idict.get('IT_CLASS')), ...
        [BRAPH2.STR ':' class(idict) ':' BRAPH2.WRONG_INPUT], ...
        ['Item must be an object of class ' idict.get('IT_CLASS') ',' ...
        ' while it is of class ' class(item) '.'])
    
    key = item.get(idict.get('IT_KEY'));
    assert(~any(strcmp(key, idict.getKeys())), ...
        [BRAPH2.STR ':' class(idict) ':' BRAPH2.WRONG_INPUT], ...
        ['Key ''' key ''' is already contained in the indexed dictionary.'])

    it_list = idict.get('IT_LIST');
    if index <= idict.length()  
        % create space for {key, item}
        it_list(index + 1:end + 1) = it_list(index:end);
        it_list{index} = item;
    else
        it_list{end + 1} = item;
    end
    idict.set('IT_LIST', it_list)
end
function remove(idict, pointer)            
    %REMOVE removes a key and item from an indexed dictionary.
    %
    % REMOVE(IDICT, POINTER) removes the key and item of POINTER (an index, key
    %  or item) from the indexed dictionary IDICT.
    %
    % See also add, replace.

    if isa(pointer, 'char')  % pointer is a key
        index = idict.getKeyIndex(pointer);
    elseif isa(pointer, 'numeric')  % pointer is an index
        index = pointer;
    elseif isa(pointer, idict.get('IT_CLASS'))  % pointer is a item
        index = idict.getIndex(pointer);
    end

    if index > 0 && index <= idict.length() && index == round(index)
        it_list = idict.get('IT_LIST');
        it_list(index) = [];
        idict.set('IT_LIST', it_list);
    end
end
function replace(idict, new_item, index)
    %REPLACE replaces an item and key in an indexed dictionary.
    %
    % REPLACE(IDICT, NEW_ITEM, INDEX) replaces the item and key of INDEX in the
    %  indexed dictionary IDICT with NEW_ITEM.
    %
    % See also add, remove, replaceKey, replaceItem.

    assert(isequal(idict.get('IT_CLASS'), class(new_item)), ...
        [BRAPH2.STR ':IndexedDictionary:' BRAPH2.WRONG_INPUT], ...
        'The item is not of the correct class.')

    if idict.contains(index)
        idict.remove(index)
        idict.add(new_item, index)
    end
end
function replaceKey(idict, old_key, new_key)
    %REPLACEKEY replaces key in indexed dictionary.
    %
    % REPLACEKEY(IDICT, OLD_KEY, NEW_KEY) replaces OLD_KEY in the indexed
    %  dictionary IDICT with NEW_KEY.
    %
    % See also replace, replaceItem.

    item = idict.getItemFromKey(old_key);
    item.set(idict.get('IT_KEY'), new_key)
end
function replaceItem(idict, old_item, new_item)
    %REPLACEITEM replaces item in indexed dictionary.
    %
    % REPLACEITEM(IDICT, OLD_ITEM, NEW_ITEM) replaces OLD_ITEM with NEW_ITEM in
    %  the indexed dictionary IDICT. It replaces only the first occurrence of
    %  OLD_ITEM.
    %
    % See also replace, replaceKey.

    index = idict.getIndexFromItem(old_item);
    idict.replace(new_item, index);
end
function invert(idict, i, j)
    %INVERT inverts position of two items in indexed dictionary.
    %
    % INVERT(IDICT, INDEXI, INDEXJ) inverts the positions of the items at
    %  INDEX_I and INDEX_J in the indexed dictionary IDICT.
    %
    % See also move_to.

    if i > j
        if i > 0 && i <= idict.length() && j > 0 && j <= idict.length() && i ~= j
            item_i = idict.getItem(i);
            item_j = idict.getItem(j);

            idict.remove(i)
            idict.remove(j)

            idict.add(item_i, j);
            idict.add(item_j, i);
        end
    else
        idict.invert(j, i);
    end
end
function move_to(idict, i, j)
    %MOVE_TO moves an item of an indexed dictionary to another position.
    %
    % MOVE_TO(IDICT, OLD_INDEX, NEW_INDEX) moves an item from position
    %  OLD_INDEX to position NEW_INDEX in the indexed dictionary IDICT.
    %
    % See also invert.

    if i > 0 && i <= idict.length() && j > 0 && j <= idict.length() && i ~= j
        item = idict.getItem(i);
        idict.remove(i)
        idict.add(item, j)
    end
end
function selected = remove_all(idict, selected)
    %REMOVE_ALL removes selected items.
    %
    % SELECTED = REMOVE_ALL(IDICT, SELECTED) removes all items whose positions
    %  in the indexed dictionary DICT are included in the array SELECTED. It
    %  returns an empty array.
    %
    % See also move_up, move_down, move_to_top, move_to_bottom.

    for i = length(selected):-1:1
        idict.remove(selected(i))
    end
    selected = [];
end
function selected =  move_up(idict, selected)
    %MOVE_UP moves up selected items.
    %
    % SELECTED = MOVE_UP(IDICT, SELECTED) moves up by one position all items
    %  whose positions in the indexed dictionary DICT are included in the
    %  SELECTED array and returns their final positions.
    %
    % See also remove_all, move_down, move_to_top, move_to_bottom.

    if ~isempty(selected)
        first_index_to_process = 1;
        unprocessable_length = 1;
        while first_index_to_process <= idict.length() ...
                && first_index_to_process <= numel(selected) ...
                && selected(first_index_to_process) == unprocessable_length
            first_index_to_process = first_index_to_process + 1;
            unprocessable_length = unprocessable_length + 1;
        end

        for i = first_index_to_process:1:numel(selected)
            idict.invert(selected(i), selected(i)-1);
            selected(i) = selected(i) - 1;
        end
    end
end
function selected = move_down(idict, selected)
    %MOVE_DOWN moves down selected items.
    %
    % SELECTED = MOVE_DOWN(IDICT, SELECTED) moves down by one position all
    %  items whose positions in the indexed dictionary DICT are included in the
    %  SELECTED array and returns their final positions.  
    %
    % See also remove_all, move_up, move_to_top, move_to_bottom.

    if ~isempty(selected)
        last_index_to_process = numel(selected);
        unprocessable_length = idict.length();
        while last_index_to_process > 0 ...
                && selected(last_index_to_process) == unprocessable_length
            last_index_to_process = last_index_to_process - 1;
            unprocessable_length = unprocessable_length - 1;
        end

        for i = last_index_to_process:-1:1
            idict.invert(selected(i), selected(i) + 1);
            selected(i) = selected(i) + 1;
        end
    end
end
function selected = move_to_top(idict, selected)
    %MOVE_TO_TOP moves selected items to top.
    %
    % SELECTED = MOVE_TO_TOP(IDICT, SELECTED) moves to top all items whose
    %  positions in the indexed dictionary DICT are included in the SELECTED
    %  array and returns their final positions.
    %
    % See also remove_all, move_up, move_down, move_to_bottom.

    if ~isempty(selected)
        for i = 1:1:numel(selected)
            idict.move_to(selected(i), i);
        end
        selected = reshape(1:1:numel(selected), size(selected));
    end
end
function selected = move_to_bottom(idict, selected)
    %MOVE_TO_BOTTOM moves selected items to bottom.
    %
    % SELECTED = MOVE_TO_BOTTOM(IDICT, SELECTED) moves to bottom all items
    %  whose positions in the indexed dictionary DICT dictionary are included in
    %  the SELECTED array and returns their final positions.
    %
    % See also remove_all, move_up, move_down, move_to_top.

    if ~isempty(selected)
        for i = numel(selected):-1:1
            idict.move_to(selected(i), idict.length() - (numel(selected)-i));
        end
        selected = reshape(idict.length() - numel(selected)+1:1:idict.length(), size(selected));
    end
end

%% ¡tests!

%%% ¡test!
%%%% ¡name!
Instantiation with items
%%%% ¡code!
it1 = ETA('PROP_STRING_P', 'item_1');
it2 = ETA('PROP_STRING_P', 'item_2');
it3 = ETA('PROP_STRING_P', 'item_3');
it4 = ETA('PROP_STRING_P', 'item_4');
it5 = ETA('PROP_STRING_P', 'item_5');
it6 = ETA('PROP_STRING_P', 'item_6');

items = {it1, it2, it3, it4, it5, it6};
keys = cellfun(@(x) x.get('PROP_STRING_P'), items, 'UniformOutput', false);

assert_with_error( ...
    ['idict = IndexedDictionary(' ...
    '''id'', ''idict'', ' ...
    '''it_class'', ''ETA'', '...
    '''it_key'', 2, '...
    '''it_list'', {varargin{1}, varargin{2}, varargin{3}, varargin{4}, varargin{5}, NoValue()}' ...
    ');'], ...
    [BRAPH2.STR ':IndexedDictionary:' BRAPH2.WRONG_INPUT], ...
    it1, it2, it3, it4, it5 ...
    )

idict = IndexedDictionary( ...
    'id', 'idict', ...
    'it_class', 'ETA', ...
    'it_key', 17, ...
    'it_list', items ...
    );

%%% ¡test!
%%%% ¡name!
Inspection
%%%% ¡code!
it1 = ETA('PROP_STRING_P', 'Key 1');
it2 = ETA('PROP_STRING_P', 'Key 2');
it3 = ETA('PROP_STRING_P', 'Key 3');
it4 = ETA('PROP_STRING_P', 'Key 4');
it5 = ETA('PROP_STRING_P', 'Key 5');
it6 = ETA('PROP_STRING_P', 'Key 6');

items = {it1, it2, it3, it4, it5, it6};
keys = cellfun(@(x) x.get('PROP_STRING_P'), items, 'UniformOutput', false);

idict = IndexedDictionary( ...
    'id', 'idict', ...
    'it_class', 'ETA', ...
    'it_key', 17, ...
    'it_list', items ...
    );

assert(isequal(idict.length(), 6), ...
	[BRAPH2.STR ':' class(idict) ':' BRAPH2.WRONG_OUTPUT], ...
    'IndexedDictionary.length() does not work.')

assert(isequal(idict.containsIndex(2), true), ...
	[BRAPH2.STR ':' class(idict) ':' BRAPH2.WRONG_OUTPUT], ...
    'IndexedDictionary.containsIndex() does not work.')
assert(isequal(idict.contains(2), true), ...
	[BRAPH2.STR ':' class(idict) ':' BRAPH2.WRONG_OUTPUT], ...
    'IndexedDictionary.contains() does not work.')
assert(isequal(idict.containsKey('Key 3'), true), ...
	[BRAPH2.STR ':' class(idict) ':' BRAPH2.WRONG_OUTPUT], ...
    'IndexedDictionary.containsKey() does not work.')
assert(isequal(idict.contains('Key 3'), 1), ...
	[BRAPH2.STR ':' class(idict) ':' BRAPH2.WRONG_OUTPUT], ...
    'IndexedDictionary.contains() does not work.')
assert(isequal(idict.containsItem(it4), true), ...
	[BRAPH2.STR ':' class(idict) ':' BRAPH2.WRONG_OUTPUT], ...
    'IndexedDictionary.containsItem() does not work.')
assert(isequal(idict.contains(it4), 1), ...
	[BRAPH2.STR ':' class(idict) ':' BRAPH2.WRONG_OUTPUT], ...
    'IndexedDictionary.contains() does not work.')

assert(isequal(idict.getIndexFromKey('Key 1'), 1), ...
	[BRAPH2.STR ':' class(idict) ':' BRAPH2.WRONG_OUTPUT], ...
    'IndexedDictionary.getIndexFromKey() does not work.')
assert(isequal(idict.getIndex('Key 1'), 1), ...
	[BRAPH2.STR ':' class(idict) ':' BRAPH2.WRONG_OUTPUT], ...
    'IndexedDictionary.getIndex() does not work.')
assert(isequal(idict.getIndexFromItem(it4), 4), ...
	[BRAPH2.STR ':' class(idict) ':' BRAPH2.WRONG_OUTPUT], ...
    'IndexedDictionary.getIndexFromItem() does not work.')
assert(isequal(idict.getIndex(it4), 4), ...
	[BRAPH2.STR ':' class(idict) ':' BRAPH2.WRONG_OUTPUT], ...
    'IndexedDictionary.getIndex() does not work.')

assert(isequal(idict.getKeys(), keys), ...
	[BRAPH2.STR ':' class(idict) ':' BRAPH2.WRONG_OUTPUT], ...
    'IndexedDictionary.getKeys() does not work.')
assert(isequal(idict.getKeyFromIndex(2), 'Key 2'), ...
	[BRAPH2.STR ':' class(idict) ':' BRAPH2.WRONG_OUTPUT], ...
    'IndexedDictionary.getKeyFromIndex() does not work.')
assert(isequal(idict.getKey(2), 'Key 2'), ...
	[BRAPH2.STR ':' class(idict) ':' BRAPH2.WRONG_OUTPUT], ...
    'IndexedDictionary.getKey() does not work.')
assert(isequal(idict.getKeyFromItem(it2), 'Key 2'), ...
	[BRAPH2.STR ':' class(idict) ':' BRAPH2.WRONG_OUTPUT], ...
    'IndexedDictionary.getKeyFromItem() does not work.')
assert(isequal(idict.getKey(it2), 'Key 2'), ...
	[BRAPH2.STR ':' class(idict) ':' BRAPH2.WRONG_OUTPUT], ...
    'IndexedDictionary.getKey() does not work.')

assert(isequal(idict.getItems(), items), ...
	[BRAPH2.STR ':' class(idict) ':' BRAPH2.WRONG_OUTPUT], ...
    'IndexedDictionary.getItems() does not work.')
assert(isequal(idict.getItemFromIndex(3), it3), ...
	[BRAPH2.STR ':' class(idict) ':' BRAPH2.WRONG_OUTPUT], ...
    'IndexedDictionary.getItemFromIndex() does not work.')
assert(isequal(idict.getItem(3), it3), ...
	[BRAPH2.STR ':' class(idict) ':' BRAPH2.WRONG_OUTPUT], ...
    'IndexedDictionary.getItemFromIndex() does not work.')
assert(isequal(idict.getItemFromKey('Key 3'), it3), ...
	[BRAPH2.STR ':' class(idict) ':' BRAPH2.WRONG_OUTPUT], ...
    'IndexedDictionary.getItemFromKey() does not work.')
assert(isequal(idict.getItem('Key 3'), it3), ...
	[BRAPH2.STR ':' class(idict) ':' BRAPH2.WRONG_OUTPUT], ...
    'IndexedDictionary.getItem() does not work.')

%%% ¡test!
%%%% ¡name!
Add
%%%% ¡code!    
it1 = ETA('PROP_STRING_P', 'Key 1');
it2 = ETA('PROP_STRING_P', 'Key 2');
it3 = ETA('PROP_STRING_P', 'Key 3');
it4 = ETA('PROP_STRING_P', 'Key 4');
it5 = ETA('PROP_STRING_P', 'Key 5');
it6 = ETA('PROP_STRING_P', 'Key 6');

items = {it1, it2, it3, it4};
keys = cellfun(@(x) x.get('PROP_STRING_P'), items, 'UniformOutput', false);

idict = IndexedDictionary( ...
    'id', 'idict', ...
    'it_class', 'ETA', ...
    'it_key', 17, ...
    'it_list', items ...
    );

idict.add(it6)
assert(isequal(idict.length(), 5), ...
	[BRAPH2.STR ':' class(idict) ':' BRAPH2.BUG_FUNC], ...
    'IndexedDictionary.add() does not work.')
assert(isequal(idict.getItem(5), it6), ...
	[BRAPH2.STR ':' class(idict) ':' BRAPH2.BUG_FUNC], ...
    'IndexedDictionary.add() does not work.')

idict.add(it5, 5)
assert(isequal(idict.length(), 6), ...
	[BRAPH2.STR ':' class(idict) ':' BRAPH2.BUG_FUNC], ...
    'IndexedDictionary.add() does not work.')
assert(isequal(idict.getItem(5), it5) && isequal(idict.getItem(6), it6), ...
	[BRAPH2.STR ':' class(idict) ':' BRAPH2.BUG_FUNC], ...
    'IndexedDictionary.add() does not work.')

%%% ¡test!
%%%% ¡name!
Remove
%%%% ¡code!
it1 = ETA('PROP_STRING_P', 'Key 1');
it2 = ETA('PROP_STRING_P', 'Key 2');
it3 = ETA('PROP_STRING_P', 'Key 3');
it4 = ETA('PROP_STRING_P', 'Key 4');
it5 = ETA('PROP_STRING_P', 'Key 5');
it6 = ETA('PROP_STRING_P', 'Key 6');

items = {it1, it2, it3, it4, it5, it6};
keys = cellfun(@(x) x.get('PROP_STRING_P'), items, 'UniformOutput', false);

idict = IndexedDictionary( ...
    'id', 'idict', ...
    'it_class', 'ETA', ...
    'it_key', 17, ...
    'it_list', items ...
    );

idict.remove(4)
assert(isequal(idict.length(), 5), ...
	[BRAPH2.STR ':' class(idict) ':' BRAPH2.BUG_FUNC], ...
    'IndexedDictionary.remove() does not work.')
assert(isequal(idict.getItem(idict.length()), it6), ...
	[BRAPH2.STR ':' class(idict) ':' BRAPH2.BUG_FUNC], ...
    'IndexedDictionary.remove() does not work.')

idict.remove(5)
idict.remove(1)
assert(isequal(idict.getItems(), {it2, it3, it5}), ...
	[BRAPH2.STR ':' class(idict) ':' BRAPH2.BUG_FUNC], ...
    'IndexedDictionary.remove() does not work.')

%%% ¡test!
%%%% ¡name!
Replace
%%%% ¡code!    
it1 = ETA('PROP_STRING_P', 'Key 1');
it2 = ETA('PROP_STRING_P', 'Key 2');
it3 = ETA('PROP_STRING_P', 'Key 3');
it4 = ETA('PROP_STRING_P', 'Key 4');
it5 = ETA('PROP_STRING_P', 'Key 5');
it6 = ETA('PROP_STRING_P', 'Key 6');

items = {it1, it2, it3, it4};
keys = cellfun(@(x) x.get('PROP_STRING_P'), items, 'UniformOutput', false);

idict = IndexedDictionary( ...
    'id', 'idict', ...
    'it_class', 'ETA', ...
    'it_key', 17, ...
    'it_list', items ...
    );

idict.replace(it5, 4)

idict.replace(it5, 4)
assert(isequal(idict.length(), 4), ...
	[BRAPH2.STR ':' class(idict) ':' BRAPH2.BUG_FUNC], ...
    'IndexedDictionary.replace() does not work.')
assert(isequal(idict.getKey(4), 'Key 5') && isequal(idict.getItem(4), it5), ...
	[BRAPH2.STR ':' class(idict) ':' BRAPH2.BUG_FUNC], ...
    'IndexedDictionary.replace() does not work.')

idict.replaceKey('Key 5', 'Key 4')
assert(isequal(idict.length(), 4), ...
	[BRAPH2.STR ':' class(idict) ':' BRAPH2.BUG_FUNC], ...
    'IndexedDictionary.replaceKey() does not work.')
assert(isequal(idict.getKey(4), 'Key 4') && isequal(idict.getItem(4), it5), ...
	[BRAPH2.STR ':' class(idict) ':' BRAPH2.BUG_FUNC], ...
    'IndexedDictionary.replaceKey() does not work.')

idict.replaceItem(it5, it4)
assert(isequal(idict.length(), 4), ...
	[BRAPH2.STR ':' class(idict) ':' BRAPH2.BUG_FUNC], ...
    'IndexedDictionary.replaceItem() does not work.')
assert(isequal(idict.getKey(4), 'Key 4') && isequal(idict.getItem(4), it4), ...
	[BRAPH2.STR ':' class(idict) ':' BRAPH2.BUG_FUNC], ...
    'IndexedDictionary.replaceItem() does not work.')

%%% ¡test!
%%%% ¡name!
Invert
%%%% ¡code!
it1 = ETA('PROP_STRING_P', 'Key 1');
it2 = ETA('PROP_STRING_P', 'Key 2');
it3 = ETA('PROP_STRING_P', 'Key 3');
it4 = ETA('PROP_STRING_P', 'Key 4');
it5 = ETA('PROP_STRING_P', 'Key 5');
it6 = ETA('PROP_STRING_P', 'Key 6');

items = {it1, it2, it3, it4};
keys = cellfun(@(x) x.get('PROP_STRING_P'), items, 'UniformOutput', false);

idict = IndexedDictionary( ...
    'id', 'idict', ...
    'it_class', 'ETA', ...
    'it_key', 17, ...
    'it_list', items ...
    );

idict.invert(1, 4)
idict.invert(3, 2)
assert(isequal(idict.length(), 4), ...
	[BRAPH2.STR ':' class(idict) ':' BRAPH2.BUG_FUNC], ...
    'IndexedDictionary.invert() does not work.')
assert(isequal(idict.getKeys(), {'Key 4', 'Key 3', 'Key 2', 'Key 1'}), ...
	[BRAPH2.STR ':' class(idict) ':' BRAPH2.BUG_FUNC], ...
    'IndexedDictionary.invert() does not work.')

%%% ¡test!
%%%% ¡name!
Move_to
%%%% ¡code!
it1 = ETA('PROP_STRING_P', 'Key 1');
it2 = ETA('PROP_STRING_P', 'Key 2');
it3 = ETA('PROP_STRING_P', 'Key 3');
it4 = ETA('PROP_STRING_P', 'Key 4');
it5 = ETA('PROP_STRING_P', 'Key 5');
it6 = ETA('PROP_STRING_P', 'Key 6');

items = {it1, it2, it3, it4};
keys = cellfun(@(x) x.get('PROP_STRING_P'), items, 'UniformOutput', false);

idict = IndexedDictionary( ...
    'id', 'idict', ...
    'it_class', 'ETA', ...
    'it_key', 17, ...
    'it_list', items ...
    );

idict.move_to(1, 4);
idict.move_to(1, 3);
idict.move_to(1, 2);
assert(isequal(idict.length(), 4), ...
	[BRAPH2.STR ':' class(idict) ':' BRAPH2.BUG_FUNC], ...
    'IndexedDictionary.move_to() does not work.')
assert(isequal(idict.getKeys(), {'Key 4', 'Key 3', 'Key 2', 'Key 1'}), ...
	[BRAPH2.STR ':' class(idict) ':' BRAPH2.BUG_FUNC], ...
    'IndexedDictionary.move_to() does not work.')


%%% ¡test!
%%%% ¡name!
Remove all
%%%% ¡code!
it1 = ETA('PROP_STRING_P', 'Key 1');
it2 = ETA('PROP_STRING_P', 'Key 2');
it3 = ETA('PROP_STRING_P', 'Key 3');
it4 = ETA('PROP_STRING_P', 'Key 4');
it5 = ETA('PROP_STRING_P', 'Key 5');
it6 = ETA('PROP_STRING_P', 'Key 6');

items = {it1, it2, it3, it4, it5, it6};
keys = cellfun(@(x) x.get('PROP_STRING_P'), items, 'UniformOutput', false);

idict = IndexedDictionary( ...
    'id', 'idict', ...
    'it_class', 'ETA', ...
    'it_key', 17, ...
    'it_list', items ...
    );

selected = idict.remove_all([1 3 6]);
assert(isequal(idict.length(), 3), ...
	[BRAPH2.STR ':' class(idict) ':' BRAPH2.BUG_FUNC], ...
    'IndexedDictionary.remove_all() does not work.')
assert(isequal(idict.getKeys(), {'Key 2', 'Key 4', 'Key 5'}), ...
	[BRAPH2.STR ':' class(idict) ':' BRAPH2.BUG_FUNC], ...
    'IndexedDictionary.remove_all() does not work.')
assert(isequal(selected, []), ...
	[BRAPH2.STR ':' class(idict) ':' BRAPH2.BUG_FUNC], ...
    'IndexedDictionary.remove_all() does not work.')

%%% ¡test!
%%%% ¡name!
Move up
%%%% ¡code!
it1 = ETA('PROP_STRING_P', 'Key 1');
it2 = ETA('PROP_STRING_P', 'Key 2');
it3 = ETA('PROP_STRING_P', 'Key 3');
it4 = ETA('PROP_STRING_P', 'Key 4');
it5 = ETA('PROP_STRING_P', 'Key 5');
it6 = ETA('PROP_STRING_P', 'Key 6');

items = {it1, it2, it3, it4, it5, it6};
keys = cellfun(@(x) x.get('PROP_STRING_P'), items, 'UniformOutput', false);

idict = IndexedDictionary( ...
    'id', 'idict', ...
    'it_class', 'ETA', ...
    'it_key', 17, ...
    'it_list', items ...
    );

selected = idict.move_up([1 2 4 6]);
assert(isequal(idict.length(), 6), ...
	[BRAPH2.STR ':' class(idict) ':' BRAPH2.BUG_FUNC], ...
    'IndexedDictionary.move_up() does not work.')
assert(isequal(idict.getKeys(), {'Key 1', 'Key 2', 'Key 4', 'Key 3', 'Key 6', 'Key 5'}), ...
	[BRAPH2.STR ':' class(idict) ':' BRAPH2.BUG_FUNC], ...
    'IndexedDictionary.move_up() does not work.')
assert(isequal(selected, [1 2 3 5]), ...
	[BRAPH2.STR ':' class(idict) ':' BRAPH2.BUG_FUNC], ...
    'IndexedDictionary.move_up() does not work.')

%%% ¡test!
%%%% ¡name!
Move down
%%%% ¡code!
it1 = ETA('PROP_STRING_P', 'Key 1');
it2 = ETA('PROP_STRING_P', 'Key 2');
it3 = ETA('PROP_STRING_P', 'Key 3');
it4 = ETA('PROP_STRING_P', 'Key 4');
it5 = ETA('PROP_STRING_P', 'Key 5');
it6 = ETA('PROP_STRING_P', 'Key 6');

items = {it1, it2, it3, it4, it5, it6};
keys = cellfun(@(x) x.get('PROP_STRING_P'), items, 'UniformOutput', false);

idict = IndexedDictionary( ...
    'id', 'idict', ...
    'it_class', 'ETA', ...
    'it_key', 17, ...
    'it_list', items ...
    );

selected = idict.move_down([1 3 5 6]);
assert(isequal(idict.length(), 6), ...
	[BRAPH2.STR ':' class(idict) ':' BRAPH2.BUG_FUNC], ...
    'IndexedDictionary.move_down() does not work.')
assert(isequal(idict.getKeys(), {'Key 2', 'Key 1', 'Key 4', 'Key 3', 'Key 5', 'Key 6'}), ...
	[BRAPH2.STR ':' class(idict) ':' BRAPH2.BUG_FUNC], ...
    'IndexedDictionary.move_down() does not work.')
assert(isequal(selected, [2 4 5 6]), ...
	[BRAPH2.STR ':' class(idict) ':' BRAPH2.BUG_FUNC], ...
    'IndexedDictionary.move_down() does not work.')

%%% ¡test!
%%%% ¡name!
Move to top
%%%% ¡code!
it1 = ETA('PROP_STRING_P', 'Key 1');
it2 = ETA('PROP_STRING_P', 'Key 2');
it3 = ETA('PROP_STRING_P', 'Key 3');
it4 = ETA('PROP_STRING_P', 'Key 4');
it5 = ETA('PROP_STRING_P', 'Key 5');
it6 = ETA('PROP_STRING_P', 'Key 6');

items = {it1, it2, it3, it4, it5, it6};
keys = cellfun(@(x) x.get('PROP_STRING_P'), items, 'UniformOutput', false);

idict = IndexedDictionary( ...
    'id', 'idict', ...
    'it_class', 'ETA', ...
    'it_key', 17, ...
    'it_list', items ...
    );

selected = idict.move_to_top([1 3 5 6]);
assert(isequal(idict.length(), 6), ...
	[BRAPH2.STR ':' class(idict) ':' BRAPH2.BUG_FUNC], ...
    'IndexedDictionary.move_to_top() does not work.')
assert(isequal(idict.getKeys(), {'Key 1', 'Key 3', 'Key 5', 'Key 6', 'Key 2', 'Key 4'}), ...
	[BRAPH2.STR ':' class(idict) ':' BRAPH2.BUG_FUNC], ...
    'IndexedDictionary.move_to_top() does not work.')
assert(isequal(selected, [1 2 3 4]), ...
	[BRAPH2.STR ':' class(idict) ':' BRAPH2.BUG_FUNC], ...
    'IndexedDictionary.move_to_top() does not work.')

%%% ¡test!
%%%% ¡name!
Move to bottom
%%%% ¡code!
it1 = ETA('PROP_STRING_P', 'Key 1');
it2 = ETA('PROP_STRING_P', 'Key 2');
it3 = ETA('PROP_STRING_P', 'Key 3');
it4 = ETA('PROP_STRING_P', 'Key 4');
it5 = ETA('PROP_STRING_P', 'Key 5');
it6 = ETA('PROP_STRING_P', 'Key 6');

items = {it1, it2, it3, it4, it5, it6};
keys = cellfun(@(x) x.get('PROP_STRING_P'), items, 'UniformOutput', false);

idict = IndexedDictionary( ...
    'id', 'idict', ...
    'it_class', 'ETA', ...
    'it_key', 17, ...
    'it_list', items ...
    );

selected = idict.move_to_bottom([1 3 5 6]);
assert(isequal(idict.length(), 6), ...
	[BRAPH2.STR ':' class(idict) ':' BRAPH2.BUG_FUNC], ...
    'IndexedDictionary.move_to_top() does not work.')
assert(isequal(idict.getKeys(), {'Key 2', 'Key 4', 'Key 1', 'Key 3', 'Key 5', 'Key 6'}), ...
	[BRAPH2.STR ':' class(idict) ':' BRAPH2.BUG_FUNC], ...
    'IndexedDictionary.move_to_top() does not work.')
assert(isequal(selected, [3 4 5 6]), ...
	[BRAPH2.STR ':' class(idict) ':' BRAPH2.BUG_FUNC], ...
    'IndexedDictionary.move_to_top() does not work.')