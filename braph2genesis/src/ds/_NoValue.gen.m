%% ¡header!
NoValue < Element (nv, NoValue) represents a value that has not been set or calculated.

%%% ¡class_attributes!
Sealed = true

%%% ¡description!
NoValue is an element without values used to represent a value that has
not been set (for properties of categories PARAMETER AND DATA) or
calculated (for properties of category RESULT). 
For computational efficiency, it is best to use only one instance of NV 
using NoValue.getNoValue(), instead of creating new instances using the 
constructor NoValue(). 
No element can be a subclass of NoValue.

%%% ¡seealso!
Element

%% ¡staticmethods!
function nv = getNoValue()
    %GETNOVALUE returns a pointer to a persistent instance of NoValue.
    %
    % NV = GETNOVALUE() returns a pointer to a persistent instance of NoValue.
    %  For computational efficiency, it is best to use NoValue.getNoValue(),
    %  instead of creating new instances using the  constructor NoValue().

    persistent local_nv
    
    if isempty(local_nv) || ~isvalid(local_nv)
        local_nv = NoValue();
    end
    nv = local_nv;
end

%% ¡tests!

%%% ¡test!
%%%% ¡name!
Copy
%%%% ¡code!
nv = NoValue.getNoValue();

nv_copy = nv.copy();

assert( ...
    nv == nv_copy, ...
    [BRAPH2.STR ':NoValue:' BRAPH2.BUG_COPY], ...
    ['The copy of a NoValue must return a pointer to the persistent NoValue.getNoValue().'] ...
    )

%%% ¡test!
%%%% ¡name!
Clone
%%%% ¡code!
nv = NoValue.getNoValue();

nv_clone = nv.clone();

assert( ...
    nv == nv_clone, ...
    [BRAPH2.STR ':NoValue:' BRAPH2.BUG_CLONE], ...
    ['The clone of a NoValue must return a pointer to the persistent NoValue.getNoValue().'] ...
    )

%%% ¡test!
%%%% ¡name!
JSON
%%%% ¡code!
nv = NoValue.getNoValue();

json = nv.encodeJSON();

nv_json = NoValue.decodeJSON(json);

assert( ...
    nv == nv_json, ...
    [BRAPH2.STR ':NoValue:' BRAPH2.BUG_JSON], ...
    ['The encoding/decoding of a NoValue must return a pointer to the persistent NoValue.getNoValue().'] ...
    )