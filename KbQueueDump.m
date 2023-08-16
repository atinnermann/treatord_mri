function [keycode, secs] = KbQueueDump
   
        keycode = [];
        secs    = [];
        pressed = [];    
        while KbEventAvail(p.ptb.device)
            [evt, n]   = KbEventGet(p.ptb.device);
            n          = n + 1;
            keycode(n) = evt.Keycode;
            pressed(n) = evt.Pressed;
            secs(n)    = evt.Time;      
        end
        i           = pressed == 1;
        keycode(~i) = [];
        secs(~i)    = [];
      
end