%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script visualizes the retrieval results
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath('../Libs/SubAxis');
addpath(genpath('../Libs/voc-dpm-master/'));
addpath('../Libs/tight_subplot');


%% assign the sketch you want to use as query
categoriesSketch = {'airplane', 'bicycle',	'standing bird',	'bus',	'car (sedan)',...
    'cat', 'chair', 'cow', 'table',	'dog', 'horse',	'motorbike', 'sheep',	'train'};

categoriesImage = {'aeroplane', 'bicycle', 'bird',	'bus', 'car',...
    'cat', 'chair', 'cow', 'diningtable', 'dog', 'horse', 'motorbike', 'sheep',	'train'};

numCate = length(categoriesSketch);
testPath = '../Data/Test/images/';
retrResultFolder = '../Results/Retrieval/';
imgDPMPath = '../Data/DPMs/Img/';
sketchDPMPath = '../Data/DPMs/Sketch/';
alignmentPath = '../Results/CompAlign/';
detPath = '../Results/Detection/';
skNum = 3;

for cateId = 1 : numCate
    clsImg = categoriesImage{cateId};
    clsSk = categoriesSketch{cateId};
    
    % image path
    imgPath = [testPath, clsSk,'/img/'];
    skPath = [testPath, clsSk,'/sketch/'];
    
    % retrieval result
    load([retrResultFolder, clsSk,'Result.mat']);
    
    % align result
    load([alignmentPath, clsSk, 'Rank.mat']);
    
    % ground truth rating
    load('../Data/Test/ratings/Ratings.mat');
    
    
    %% visualize
    figure; % plain vis

    for i = 1 : skNum
        fullPath = [skPath,retResult{i + 3, 3}];
        subaxis(skNum*2,6,(i-1)*12 + 1,'SpacingHoriz', 0, 'SpacingVert',0, 'Padding', 0, 'Margin', 0);
        imshow(fullPath);
    end
    
    for i = 1 : skNum
        imgList = retResult{i + 3,2};
        imgNum = size(imgList,1);
        for j = 1 : 5
            if j <= imgNum
                imgName = imgList{j,2};
                ind = imgList{j,1};
                fullPath = [imgPath,imgName];
                im = imread(fullPath);
                
                marking = rating{cateId}( ind,(i+3-1)*4 + 1:(i+3-1)*4 + 4);
            else
                im = zeros(100,100);
            end
            subaxis(skNum*2,6,(i-1)*12 + j+1,'SpacingHoriz', 0., 'SpacingVert',0, 'Padding', 0, 'Margin', 0);
            imshow(im);
            subaxis(skNum*2,6,(i-1)*12 + j+7,'SpacingHoriz', 0, 'SpacingVert',0, 'Padding', 0, 'Margin', 0);
            axis([0 0.1 0 0.1])
            text(0.03,0.08,sprintf('V:%d C:%d B:%d Z:%d', marking(1), marking(2), marking(3),marking(4)),'fontsize',15)
            axis off;
        end
    end
    set(gcf,'units','normalized','outerposition',[0 0 1 1]);
end

