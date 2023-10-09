%% returns a vector with riseTime, sPlateau and fallTime for the target stimulus
function t = CalcStimDuration(temp,dur,t)
    diff        = abs(temp-t.test.baseTemp);
    riseTime    = diff/t.test.riseSpeed;
    fallTime    = diff/t.test.fallSpeed;

    t.tmp.stimDuration = [riseTime dur fallTime];
    t.tmp.rampDuration = riseTime + fallTime;
end