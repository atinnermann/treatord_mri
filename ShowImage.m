function t = ShowImage(t,type,nRun,nBlock,dur)

b = 0.25;
if type == 1
    fprintf('Visual stimulus presentation - Block %d image.\n',nRun);
    
    t.pics.runImage{nRun,1} = fullfile(t.pics.path,deblank(t.pics.block(nRun,:)));
    imgMatrix = imread(t.pics.runImage{nRun,1});
    img = Screen('MakeTexture', t.disp.wHandle, imgMatrix);
    dims = [0 0 t.disp.window(3)*b t.disp.window(3)*b*0.65];
elseif type == 2
    fprintf('Visual stimulus presentation - TENS Frequency (%d Hz).\n',t.test.freqOrder(nBlock));
    fprintf('For this block, temp is %2.1f °C and corresponds to %d VAS\n',t.test.tempOrder(nBlock),t.test.VASOrder(nBlock));
    
    if t.test.condOrder(nBlock) == 1
        img = t.pics.noTreat(t.test.colOrder(nBlock),:);
    elseif t.test.condOrder(nBlock) == 2
        img = t.pics.lowTreat(t.test.colOrder(nBlock),:);
    elseif t.test.condOrder(nBlock) == 3
        img = t.pics.medTreat(t.test.colOrder(nBlock),:);
    elseif t.test.condOrder(nBlock) == 4
        img = t.pics.highTreat(t.test.colOrder(nBlock),:);
    end
        
%     if mod(cond,2)   %in odd runs
%         ind = t.test.nRuns+t.test.colOrder(cond);
%     elseif cond == 8
%         ind = cond*runCond-t.test.nRuns+t.test.colOrder(cond);
%     else 
%         ind = cond*runCond+t.test.nRuns+t.test.colOrder(cond);
%     end
    t.pics.condImage{nBlock,1} = fullfile(t.pics.path,deblank(img));
    imgMatrix = imread(t.pics.condImage{nBlock,1});
    img = Screen('MakeTexture', t.disp.wHandle, imgMatrix);
    dims = [0 0 t.disp.window(3)*b t.disp.window(3)*b*0.45];
end

sizeImage = CenterRect(dims, t.disp.rect);

Screen('DrawTexture', t.disp.wHandle, img,[],sizeImage);
timeImgOn = Screen('Flip',t.disp.wHandle);

if type == 1
    t = LogEvents(t,timeImgOn,['BlockImage ',num2str(nRun)]);
elseif type == 2
    t = LogEvents(t,timeImgOn,['FreqImage ',num2str(t.test.freqOrder(nBlock))]);
end

while GetSecs < timeImgOn + dur; end

Screen('Flip',t.disp.wHandle);

end

