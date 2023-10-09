function [t,abort] = ApplyTemp(t,temp,dur)

abort = 0;
t = CalcStimDuration(temp,dur,t);

fprintf('Stimulus initiated %1.1f°C...\n',temp);
tHeatOn = GetSecs;
countedDown = 1;

if t.com.thermoino == 0
    while GetSecs < tHeatOn + sum(t.tmp.stimDuration) 
    end
elseif t.com.thermoino == 1
    UseThermoino('Trigger'); % start next stimulus
    WaitSecs(0.1);
    UseThermoino('Set',temp); % open channel for arduino to ramp up
    
    while GetSecs < tHeatOn + sum(t.tmp.stimDuration(1:2))
        [countedDown] = CountDown(GetSecs-tHeatOn,countedDown,'.');
        [abort] = LoopBreaker(t.keys);
        if abort; break; end
    end
    
    fprintf('\n');
    UseThermoino('Set',t.test.baseTemp); % open channel for arduino to ramp down
    
    if ~abort
        while GetSecs < tHeatOn + sum(t.tmp.stimDuration)
            [countedDown] = CountDown(GetSecs-tHeatOn,countedDown,'.');
            [abort] = LoopBreaker(t.keys);
            if abort; return; end
        end
    else
        return;
    end
elseif t.com.thermoino == 2
    % Send trigger via cogent
    SendTrigger(t.com.CEDaddress,t.com.CEDport,t.com.CEDduration) %%% caution this part is not verified!!
    
    while GetSecs < tHeatOn + sum(t.tmp.stimDuration)
        [countedDown] = CountDown(GetSecs-tHeatOn,countedDown,'.');
        [abort] = LoopBreaker(t.keys);
        if abort; return; end
    end

end

fprintf('Stimulus concluded...\n');

end