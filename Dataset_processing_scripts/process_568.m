clear all;

bits      =  12;    % 8 or 1 bit2
DATASET = '568';

if ~ispc
    DATA_DIR = '/cs/chroma/data/canon_dataset/568_dataset/';
else
    DATA_DIR = 'S:\data\canon_dataset\568_dataset\';
end

LIST_FILES = textread([DATA_DIR 'filelist.txt'], '%s');
BLACK = 129; %  [117 122 117];
test_set = 1;

% loop through each image
for i = 1:length(test_set)
    id = test_set(i)
    
    filename = [char(LIST_FILES(id,:))];
  
    if bits == 8
        if gamma == 1
            I = double(srgb2rgb(imread([DATA_DIR 'srgb8bit' filesep filename  '.tif'])))*255;
        else 
            I = double(imread([DATA_DIR 'srgb8bit' filesep filename  '.tif']));
        end
        input_im = I;
    else
        I = double(imread([DATA_DIR 'png' filesep filename  '.png']));
        if id > 87   % subtract black level
            I = max(I-BLACK,0);
        end
        input_im = I;
    end
 
    % mask out the colorchecker within the image scene
    cc_coord = load([DATA_DIR 'coordinates' filesep filename '_macbeth.txt']); 
    scale = cc_coord(1,[2 1])./[size(input_im,1) size(input_im,2)];
    MASK = repmat(roipoly(I, cc_coord([2 4 5 3],1)/scale(1), cc_coord([2 4 5 3],2)/scale(2)),[1 1 3]);
    input_im(find(MASK)) = 0;

    % do image processing on  input_im
    % ...   

end



