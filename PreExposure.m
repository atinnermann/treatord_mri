function PreExposure(t)


fprintf('\n=======PreExposure=======\n');

Screen('FillRect', t.disp.wHandle, t.disp.white, t.disp.Fix1);
Screen('FillRect', t.disp.wHandle, t.disp.white, t.disp.Fix2);
tITIStart = Screen('Flip',t.disp.wHandle);

fprintf('First ITI of %1.0f seconds\n',t.exp.ITI);
while GetSecs < tITIStart + t.exp.ITI
    [abort] = LoopBreaker(t.keys);
    if abort; return; end
end

%cue
if t.test.cueing == 1 % else we don't want the red cross
    Screen('FillRect', t.disp.wHandle, t.disp.red, t.disp.Fix1);
    Screen('FillRect', t.disp.wHandle, t.disp.red, t.disp.Fix2);
    tCrossOn = Screen('Flip',t.disp.wHandle);
    fprintf('Cue %1.0f seconds\n',t.exp.Cue);
    while GetSecs < tCrossOn + t.exp.Cue
        [abort] = LoopBreaker(t.keys);
        if abort; return; end
    end
end

%pain
Screen('FillRect', t.disp.wHandle, t.disp.red, t.disp.Fix1);
Screen('FillRect', t.disp.wHandle, t.disp.red, t.disp.Fix2);
Screen('Flip',t.disp.wHandle);

[abort] = ApplyTemp(t,t.exp.Temp,t.exp.Dur);

%ITI
Screen('FillRect', t.disp.wHandle, t.disp.white, t.disp.Fix1);
Screen('FillRect', t.disp.wHandle, t.disp.white, t.disp.Fix2);
tITIStart = Screen('Flip',t.disp.wHandle);

fprintf('Remaining ITI %2.1f seconds...\n',t.exp.ITI);
while GetSecs < tITIStart + t.exp.ITI
    [abort] = LoopBreaker(t.keys);
    if abort; return; end
end

if abort
    QuickCleanup;
    return;
end


