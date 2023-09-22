function t = ImportKeys(t)

if strcmp(t.log.hostname,'stimpc1') % curdes button box single diamond (HID NAR 12345)
    %KbName('UnifyKeyNames');
    t.keys.keyList                  = KbName('KeyNames');
    t.keys.name.painful             = KbName('4$');
    t.keys.name.notPainful          = KbName('2@');
    t.keys.name.abort               = KbName('esc');
    t.keys.name.pause               = KbName('space');
    t.keys.name.resume              = KbName('return');
    t.keys.name.left                = KbName('2@'); % yellow button
    t.keys.name.right               = KbName('4$'); % red button
    t.keys.name.confirm             = KbName('3#'); % green button
    t.keys.name.esc                 = KbName('esc');
    t.keys.name.trigger             = KbName('5%');
    %keys.esc                 = KbName('Escape');
else
    KbName('UnifyKeyNames');
    t.keys.keyList                  = KbName('KeyNames');
    t.keys.name.painful             = KbName('j');
    t.keys.name.notPainful          = KbName('n');
    t.keys.name.abort               = KbName('Escape');
    t.keys.name.pause               = KbName('Space');
    t.keys.name.confirm             = KbName('Return');
    t.keys.name.resume              = KbName('return');
    t.keys.name.right               = KbName('RightArrow');
    t.keys.name.left                = KbName('LeftArrow');
    t.keys.name.down                = KbName('DownArrow');
    t.keys.name.esc                 = KbName('Escape');
    t.keys.name.trigger             = KbName('5%');
end