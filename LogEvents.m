%% Log all events
    function t = LogEvents(t,ptb_time, event_info)
        if isfield(t.log,'expStartTime') %when the REAL experiment starts / important for scanner
            counter = t.log.expStartTime;
        else
            counter = 0;
        end
        t.log.eventCount                    =  t.log.eventCount + 1;
        t.log.events(t.log.eventCount,1)    = {t.log.eventCount};
        t.log.events(t.log.eventCount,2)    = {ptb_time};
        t.log.events(t.log.eventCount,3)    = {ptb_time - counter};
        t.log.events(t.log.eventCount,4)    = {event_info};
    end