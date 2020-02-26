% test Data
data_class_list = Data.getList();

br1 = BrainRegion('BR1', 'brain region 1', 1, 11, 111);
br2 = BrainRegion('BR2', 'brain region 2', 2, 22, 222);
br3 = BrainRegion('BR3', 'brain region 3', 3, 33, 333);
br4 = BrainRegion('BR4', 'brain region 4', 4, 44, 444);
br5 = BrainRegion('BR5', 'brain region 5', 5, 55, 555);
ba = BrainAtlas('brain atlas', {br1, br2, br3, br4, br5});

%% Test 1: All data not abstract
for i = 1:1:length(data_class_list)
    data_class = data_class_list{i};

    d = Data.getData(data_class, ba);
end

%% Test 2: Implementation static methods
for i = 1:1:length(data_class_list)
    data_class = data_class_list{i};
    
    d = Data.getData(data_class, ba);

    assert(isequal(d.getClass(), data_class), ...
        ['BRAPH:' data_class ':StaticFuncImplementation'], ...
        [data_class '.getClass() should return ''' data_class ''''])

    assert(ischar(d.getClass()), ...
        ['BRAPH:' data_class ':StaticFuncImplementation'], ...
        [data_class '.getClass() should return a char array'])

    assert(ischar(d.getName()), ...
        ['BRAPH:' data_class ':StaticFuncImplementation'], ...
        [data_class '.getName() should return a char array'])

    assert(ischar(d.getDescription()), ...
        ['BRAPH:' data_class ':StaticFuncImplementation'], ...
        [data_class '.getDescription() should return a char array'])

end