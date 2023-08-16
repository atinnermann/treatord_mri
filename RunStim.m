function t = RunStim(t,temp,timings,nBlock)

t.tmp.scaleInitVAS(:,nBlock) = round(26+(76-26).*rand(t.test.nTrials,1));

for nTrial = 1:t.test.nTrials
    
    KbQueueStart;
    
    fprintf('\n----- TRIAL %d of %d -----\n',nTrial,t.test.nTrials);
    
    %first ITI
    if nTrial == 1
        Screen('FillRect', t.disp.wHandle, t.disp.white, t.disp.Fix1);
        Screen('FillRect', t.disp.wHandle, t.disp.white, t.disp.Fix2);
        tITIStart = Screen('Flip',t.disp.wHandle);
        t = LogEvents(t,tITIStart, 'FirstITI');
        
        %fprintf('ITI start at %1.1fs\n',GetSecs-tStartScript);
        fprintf('First ITI of %2.1f seconds\n',t.test.firstITI);
        while GetSecs < tITIStart + t.test.firstITI
            [abort] = LoopBreaker(t.keys);
            if abort; return; end
        end
    end
    
    %cue
    if t.test.cueing == 1 % else we don't want the red cross
        Screen('FillRect', t.disp.wHandle, t.disp.red, t.disp.Fix1);
        Screen('FillRect', t.disp.wHandle, t.disp.red, t.disp.Fix2);
        tCueOn = Screen('Flip',t.disp.wHandle);
        t = LogEvents(t,tCueOn, 'CueOnset');

        fprintf('Cue %2.1f seconds\n',timings.Cue(nTrial,nBlock));
        while GetSecs < tCueOn + timings.Cue(nTrial,nBlock)
            [abort] = LoopBreaker(t.keys);
            if abort; return; end
        end
    end
    
    %pain
    Screen('FillRect', t.disp.wHandle, t.disp.red, t.disp.Fix1);
    Screen('FillRect', t.disp.wHandle, t.disp.red, t.disp.Fix2);
    tHeatOn = Screen('Flip',t.disp.wHandle);
    t = LogEvents(t,tHeatOn, 'HeatOnset');
    if t.com.SCR == 1
        SendTrigger(t.com.SCRaddress,t.com.lpt.Heat,t.com.SCRduration);
    end
    
    [abort] = ApplyTemp(t,temp,t.test.stimDur);
    if abort; break; end
    
    % brief blank screen prior to rating
    tBlankOn = Screen('Flip',t.disp.wHandle);
    while GetSecs < tBlankOn + t.test.ratDelay; end
    
    % VAS rating
    fprintf('VAS...\n');
    tVASOn = GetSecs;
    t = LogEvents(t,tVASOn, 'VASOnset');
    t = VASScale(t,nTrial,nBlock);
    
    %save results
    save(t.save.fileName, 't')
    
    rateDur = t.log.data.reactionTime(nTrial,nBlock);
    
    %ITI
    Screen('FillRect', t.disp.wHandle, t.disp.white, t.disp.Fix1);
    Screen('FillRect', t.disp.wHandle, t.disp.white, t.disp.Fix2);
    tITIOn = Screen('Flip',t.disp.wHandle);
    t = LogEvents(t,tITIOn, 'ITIOnset');
    
    if nTrial == t.test.nTrials
        sITIRemaining = t.test.lastITI;
    elseif t.test.debug == 1
        sITIRemaining = t.test.Timings.ITI(nTrial,nBlock);
    else
        sITIRemaining = t.test.Timings.ITI(nTrial,nBlock)-rateDur;
    end
    
    %fprintf('ITI start at %1.1fs\n',GetSecs-tStartScript);
    fprintf('Remaining ITI %2.1f seconds...\n',sITIRemaining);
    while GetSecs < tITIOn + sITIRemaining
        [abort] = LoopBreaker(t.keys);
        if abort; return; end
    end
    
   !!!!!!!! [keycode, secs] = KbQueueDump; %this contains both the pulses and keypresses.
    pulses = (keycode == t.keys.name.trigger);
    if any(pulses) %log trigger only if there was one
        pulses = pulses(pulses==1);
        secs = secs(pulses==1);
        for p = 1:length(pulses)
            t.mri.log.pulses(end+1) = t.mri.log.pulses(end) + 1;
            t.mri.log.times(end) = secs(pulses(p));
        end
    end
    KbQueueFlush;
            
    if abort
        QuickCleanup;
        return;
    end
    
end
