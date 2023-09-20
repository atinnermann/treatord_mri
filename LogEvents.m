function t = LogEvents(t,ptbTime, eventInfo)
if isfield(t.log,'mriStartTime') %when the REAL experiment starts / important for scanner
    counter = t.log.tMRIStart;
else
    counter = 0;
end
t.log.eventCount                    =  t.log.eventCount + 1;
t.log.events(t.log.eventCount,1)    = {t.log.eventCount};
t.log.events(t.log.eventCount,2)    = {ptbTime};
t.log.events(t.log.eventCount,3)    = {ptbTime - counter};
t.log.events(t.log.eventCount,4)    = {eventInfo};
end