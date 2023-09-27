function PreExposure(t)


fprintf('\n=======PreExposure=======\n');

Screen('FillRect', t.disp.wHandle, t.disp.white, t.disp.fix1);
Screen('FillRect', t.disp.wHandle, t.disp.white, t.disp.fix2);
tITIStart = Screen('Flip',t.disp.wHandle);

fprintf('First ITI of %1.0f seconds\n',t.test.exp.wrapITI);
while GetSecs < tITIStart + t.test.exp.wrapITI
    [abort] = LoopBreaker(t.keys);
    if abort; return; end
end

%cue
for nTrial = 1:t.test.exp.trials
    
    if t.test.cueing == 1 % else we don't want the red cross
        Screen('FillRect', t.disp.wHandle, t.disp.red, t.disp.fix1);
        Screen('FillRect', t.disp.wHandle, t.disp.red, t.disp.fix2);
        tCrossOn = Screen('Flip',t.disp.wHandle);
        fprintf('Cue %1.0f seconds\n',t.test.exp.cue);
        while GetSecs < tCrossOn + t.test.exp.cue
            [abort] = LoopBreaker(t.keys);
            if abort; return; end
        end
    end
    
    %pain
    Screen('FillRect', t.disp.wHandle, t.disp.red, t.disp.fix1);
    Screen('FillRect', t.disp.wHandle, t.disp.red, t.disp.fix2);
    Screen('Flip',t.disp.wHandle);
    
    [abort] = ApplyTemp(t,t.test.exp.temp,t.test.exp.dur);
    
    %ITI
    Screen('FillRect', t.disp.wHandle, t.disp.white, t.disp.fix1);
    Screen('FillRect', t.disp.wHandle, t.disp.white, t.disp.fix2);
    tITIStart = Screen('Flip',t.disp.wHandle);
    
    if nTrial == t.test.exp.trials
        cITI = t.test.exp.wrapITI;
    else
        cITI = t.test.exp.iti;
    end
    
    fprintf('Remaining ITI %2.1f seconds...\n',cITI);
    while GetSecs < tITIStart + cITI
        [abort] = LoopBreaker(t.keys);
        if abort; return; end
    end
    
    if abort
        QuickCleanup;
        return;
    end
end

