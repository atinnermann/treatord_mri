function PreExposure(t)


fprintf('\n=======PreExposure=======\n');

Screen('FillRect', t.disp.wHandle, t.disp.white, t.disp.fix1);
Screen('FillRect', t.disp.wHandle, t.disp.white, t.disp.fix2);
tITIStart = Screen('Flip',t.disp.wHandle);

fprintf('First ITI of %1.0f seconds\n',t.test.exp.ITI);
while GetSecs < tITIStart + t.test.exp.ITI
    [abort] = LoopBreaker(t.keys);
    if abort; return; end
end

%cue
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

fprintf('Remaining ITI %2.1f seconds...\n',t.test.exp.ITI);
while GetSecs < tITIStart + t.test.exp.ITI
    [abort] = LoopBreaker(t.keys);
    if abort; return; end
end

if abort
    QuickCleanup;
    return;
end


