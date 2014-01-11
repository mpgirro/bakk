function [ emap, smap ] = drawmaps( subbands )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%
%   emap...Energy -> classpointer
%   smap...String -> classpointer
%

smap = containers.Map('KeyType','char','ValueType','any');
emap = containers.Map('KeyType','double','ValueType','any');

for i=1:3
	emap(subbands(i).E) = subbands(i);
end

unsorted_E = [subbands(:).E];
sorted_E = sort(unsorted_E);

smap('min') = emap(sorted_E(1));
smap('med') = emap(sorted_E(2));
smap('max') = emap(sorted_E(3));

end





