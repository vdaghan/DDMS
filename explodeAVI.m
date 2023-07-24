[file, path] = uigetfile('*.avi');
[filepath, filename, fileext] = fileparts([path, file]);
vidObj = VideoReader([path, file]);
numFrames = vidObj.NumFrames;

mkdir([filepath, '\avi\']);
i = 0;
vidFrames = {};
while hasFrame(vidObj)
    vidFrame = readFrame(vidObj);
    imFilename = [filepath, '\avi\', filename, '_', char(string(i)), '.jpg'];
    vidFrames{i+1} = vidFrame;
    %imwrite(vidFrame, imFilename);
    i = i + 1;
end

figure
t = tiledlayout(6, 3);
stepSize = floor(numFrames/17);
duration = vidObj.Duration;
timeStep = duration / numFrames;
steps = [1,stepSize:stepSize:16*stepSize,numFrames];
for i = steps
    nexttile;
    imshow(vidFrames{i});
    title(string(timeStep*i)+" sn")
end
t.TileSpacing = "none";
%t.Padding = "tight";