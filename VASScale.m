function t = VASScale(t,nTrial,nCond,nBlock)


%% Default values
nRatingSteps    = 101;
scaleWidth      = t.disp.window(3)*0.35; %700; 
textSize        = 18; 
lineWidth       = 6;

%% Calculate rects
activeAddon_width   = t.disp.widthCross/2;
activeAddon_height  = t.disp.sizeCross;
axesRect            = [t.disp.midpoint(1) - scaleWidth/2; t.disp.midpoint(2) - lineWidth/2; t.disp.midpoint(1) + scaleWidth/2; t.disp.midpoint(2) + lineWidth/2];
lowLabelRect        = [axesRect(1),t.disp.midpoint(2)-activeAddon_height,axesRect(1)+activeAddon_width*4,t.disp.midpoint(2)+activeAddon_height];
highLabelRect       = [axesRect(3)-activeAddon_width*4,t.disp.midpoint(2)-activeAddon_height,axesRect(3),t.disp.midpoint(2)+activeAddon_height];
ticPositions        = linspace(t.disp.midpoint(1) - scaleWidth/2,t.disp.midpoint(1) + scaleWidth/2-lineWidth,nRatingSteps);
activeTicRects      = [ticPositions-activeAddon_width;ones(1,nRatingSteps)*t.disp.midpoint(2)-activeAddon_height;ticPositions + lineWidth+activeAddon_width;ones(1,nRatingSteps)*t.disp.midpoint(2)+activeAddon_height];

currentRating   = t.tmp.scaleInitVAS(nTrial,nCond);
finalRating     = currentRating;
reactionTime    = 0;
response        = 0;
first_flip      = 1;
startTime       = GetSecs;
numberOfSecondsRemaining = t.test.ratingDur;
nrbuttonpresses = 0;


%%%%%%%%%%%%%%%%%%%%%%% loop while there is time %%%%%%%%%%%%%%%%%%%%%
% tic; % control if timing is as long as durRating
while numberOfSecondsRemaining  > 0
    Screen('FillRect',t.disp.wHandle,t.disp.backgr);
    Screen('FillRect',t.disp.wHandle,t.disp.white,axesRect);   
    Screen('FillRect',t.disp.wHandle,t.disp.white,lowLabelRect);
    Screen('FillRect',t.disp.wHandle,t.disp.white,highLabelRect);
    Screen('FillRect',t.disp.wHandle,t.disp.red,activeTicRects(:,currentRating));
    
    Screen('TextSize',t.disp.wHandle,t.disp.fontsize);
    DrawFormattedText(t.disp.wHandle, 'Wie bewerten Sie die Schmerzhaftigkeit', 'center',t.disp.midpoint(2)-t.disp.midpoint(2)*0.25, t.disp.white);
%     DrawFormattedText(t.disp.wHandle, 'Wie bewerten Sie die Schmerzhaftigkeit', 'center',t.disp.midpoint(2)-100, t.disp.white);
    DrawFormattedText(t.disp.wHandle, 'des Hitzereizes?', 'center',t.disp.midpoint(2)-t.disp.midpoint(2)*0.25+t.disp.lineheight, t.disp.white);
%     DrawFormattedText(t.disp.wHandle, 'des Hitzereizes?', 'center',t.disp.midpoint(2)-70, t.disp.white);
    
    Screen('TextSize',t.disp.wHandle,textSize);
    Screen('DrawText',t.disp.wHandle,'kein',axesRect(1)-17,t.disp.midpoint(2)+25,t.disp.white);
    Screen('DrawText',t.disp.wHandle,'Schmerz',axesRect(1)-40,t.disp.midpoint(2)+45,t.disp.white);
    
    Screen('DrawText',t.disp.wHandle,'unerträglicher',axesRect(3)-53,t.disp.midpoint(2)+25,t.disp.white);
    Screen('DrawText',t.disp.wHandle,'Schmerz',axesRect(3)-40,t.disp.midpoint(2)+45,t.disp.white);
    
    if response == 0
        
        % set time 0 (for reaction time)
        if first_flip   == 1
            secs0       = Screen(t.disp.wHandle,'Flip'); % output Flip -> starttime rating
            first_flip  = 0;
            % after 1st flip -> just flips without setting secs0 to null
        else
            Screen('Flip', t.disp.wHandle);
        end
        
        [ keyIsDown, secs, keyCode ] = KbCheck; % this checks the keyboard very, very briefly.
        if keyIsDown % only if a key was pressed we check which key it was
            response = 0; % predefine variable for confirmation button 'space'
            nrbuttonpresses = nrbuttonpresses + 1;
            if keyCode(t.keys.name.right) % if it was the key we named key1 at the top then...
                currentRating = currentRating + 1;
                finalRating = currentRating;
                response = 0;
                if currentRating > nRatingSteps
                    currentRating = nRatingSteps;
                end
            elseif keyCode(t.keys.name.left)
                currentRating = currentRating - 1;
                finalRating = currentRating;
                response = 0;                 
                if currentRating < 1
                    currentRating = 1;
                end
            elseif keyCode(t.keys.name.esc)
                reactionTime = 99; % to differentiate between ESCAPE and timeout in logfile
                VASoff = GetSecs-startTime;
                disp('***********');
                disp('Abgebrochen');
                disp('***********');
                break;
            elseif keyCode(t.keys.name.confirm)
                finalRating = currentRating-1;
                disp(['VAS Rating: ' num2str(finalRating)]);              
                response = 1;
                reactionTime = secs - secs0;
                break;
            end
        end
    end
    
    numberOfSecondsElapsed   = (GetSecs - startTime);
    numberOfSecondsRemaining = t.test.ratingDur - numberOfSecondsElapsed;
    
end

if nrbuttonpresses ~= 0 && response == 0
        finalRating = currentRating - 1;
        reactionTime = GetSecs - startTime;
        disp(['VAS Rating: ' num2str(finalRating)]);
        
elseif nrbuttonpresses == 0
        finalRating = NaN;
        reactionTime = GetSecs - startTime;
        disp(['VAS Rating: ' num2str(finalRating)]);      
end

% toc
t.log.data.trial(nTrial,nCond)         = nTrial;
t.log.data.cond(nTrial,nCond)          = t.test.condOrder(nBlock);
t.log.data.rating(nTrial,nCond)        = finalRating;
t.log.data.reactionTime(nTrial,nCond)  = reactionTime;
t.log.data.response(nTrial,nCond)      = response;

t.log.cond   = [t.log.cond t.test.condOrder(nBlock)];
t.log.rating = [t.log.rating finalRating];

