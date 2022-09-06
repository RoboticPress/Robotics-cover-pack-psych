local staticamente = false;

function onCreate()
  --background
  makeAnimatedLuaSprite('static', 'malediction/STATIC', -590, -120);
  setLuaSpriteScrollFactor('static', 1, 1);
  scaleObject('static', 1.5, 1.5);
  
  addLuaSprite('static', false)
  addAnimationByPrefix('static', 'idle', 'staticBackground', 24, true);

  setProperty('static.alpha', 0)
end

function onStepHit()
  if curStep == 144 then
    setProperty('static.alpha', 0.5)
  end
  if curStep == 270 then
    doTweenAlpha('fadeInn', 'static', 0, 0.5, 'linear')
  end
  if curStep == 711 then
    setProperty('static.alpha', 0.5)
  end
  if curStep == 976 then
    setProperty('static.color', 0xff0000)
    doTweenAlpha('fadeInn', 'static', 1, 0.5, 'linear')
  end
  if curStep == 1104 then
    doTweenAlpha('fadeInn', 'static', 0, 1, 'linear')
  end
end