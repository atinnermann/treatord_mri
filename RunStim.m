function t = RunStim(t,temp,nCond,nBlock)

t.log.scaleInitVAS(:,nCond) = round(26+(76-26).*rand(t.test.nTrials,1));
t.log.timings.cue(:,nCond) = t.test.cue(randperm(length(t.test.cue)));
t.log.timings.iti(:,nCond) = t.test.iti(randperm(length(t.test.iti)));
t.log.timings.jit(:,nCond) = t.test.jit(randperm(length(t.test.jit)));

for nTrial = 1:t.test.nTrials
    
%     KbQueueStart;
    
    fprintf('\n----- TRIAL %d of %d -----\n',nTrial,t.test.nTrials);
    
    %first ITI
    if nTrial == 1
        Screen('FillRect', t.disp.wHandle, t.disp.white, t.disp.fix1);
        Screen('FillRect', t.disp.wHandle, t.disp.white, t.disp.fix2);
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
        Screen('FillRect', t.disp.wHandle, t.disp.red, t.disp.fix1);
        Screen('FillRect', t.disp.wHandle, t.disp.red, t.disp.fix2);
        tCueOn = Screen('Flip',t.disp.wHandle);
        t = LogEvents(t,tCueOn, 'CueOnset');

        fprintf('Cue %2.1f seconds\n',t.log.timings.cue(nTrial,nCond));
        while GetSecs < tCueOn + t.log.timings.cue(nTrial,nCond)
            [abort] = LoopBreaker(t.keys);
            if abort; return; end
        end
    end
    
    %pain
    Screen('FillRect', t.disp.wHandle, t.disp.red, t.disp.fix1);
    Screen('FillRect', t.disp.wHandle, t.disp.red, t.disp.fix2);
    tHeatOn = Screen('Flip',t.disp.wHandle);
    SendTrigger(t.com.CEDaddress,t.com.lpt.heat,t.com.CEDduration);
    t = LogEvents(t,tHeatOn, 'HeatOnset');
    [t,abort] = ApplyTemp(t,temp,t.test.stimDur);
    if abort; break; end
    t.log.timings.painDuration(nTrial,nCond) = sum(t.tmp.stimDuration);
    t.log.timings.riseDuration(nTrial,nCond) = t.tmp.riseDuration;
    t.log.onset.painSecs(nTrial,nCond) = tHeatOn - t.log.tMRIStart;
    t.log.onset.painScan(nTrial,nCond) = (tHeatOn - t.log.tMRIStart)/t.mri.tr;
    
%     % brief blank screen prior to rating
%     tBlankOn = Screen('Flip',t.disp.wHandle);
%     while GetSecs < tBlankOn + t.test.ratDelay; end
    
    % jitter between pain and rating
    Screen('FillRect', t.disp.wHandle, t.disp.white, t.disp.fix1);
    Screen('FillRect', t.disp.wHandle, t.disp.white, t.disp.fix2);
    tJitOn = Screen('Flip',t.disp.wHandle);
    fprintf('Jitter %2.1f seconds\n',t.log.timings.jit(nTrial,nCond));
    t = LogEvents(t,tJitOn, 'ITIOnset');
    while GetSecs < tJitOn + t.log.timings.jit(nTrial,nCond); end
    
    % VAS rating
    fprintf('VAS...\n');
    tVASOn = GetSecs;
    t = LogEvents(t,tVASOn, 'VASOnset');
    t = VASScale(t,nTrial,nCond,nBlock);
    
    rateDur = t.log.data.reactionTime(nTrial,nCond);
    
    %ITI
    Screen('FillRect', t.disp.wHandle, t.disp.white, t.disp.fix1);
    Screen('FillRect', t.disp.wHandle, t.disp.white, t.disp.fix2);
    tITIOn = Screen('Flip',t.disp.wHandle);
    t = LogEvents(t,tITIOn, 'ITIOnset');
    
    if t.test.debug == 1
        realITI = t.log.timings.iti(nTrial,nCond);
    else
        realITI = t.log.timings.iti(nTrial,nCond) + (t.test.ratingDur-rateDur) + (t.test.maxRampDur-t.tmp.riseDuration*2);
    end
    
    %fprintf('ITI start at %1.1fs\n',GetSecs-tStartScript);
    fprintf('Remaining ITI %2.1f seconds...\n',realITI);
    while GetSecs < tITIOn + realITI
        [abort] = LoopBreaker(t.keys);
        if abort; return; end
    end
    t.log.timings.realITI(nTrial,nCond) = realITI;
    
    [keycode, secs] = KbQueueDump; %this contains both the pulses and keypresses.
    pulses = (keycode == t.keys.name.trigger);
    if any(pulses) %log trigger only if there was one
        pulses = pulses(pulses==1);
        secs = fliplr(secs(pulses==1));
        for p = 1:length(pulses)
            t.mri.pulses(end+1) = t.mri.pulses(end) + 1;
            t.mri.times(end+1)  = secs(p) - t.log.tMRIStart;
        end
    end
    KbQueueFlush;
    
    %save results
    save(t.save.fileName, 't')
    
    if abort
        QuickCleanup;
        return;
    end
    
end
