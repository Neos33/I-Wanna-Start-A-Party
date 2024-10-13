event_inherited();
network_mode = PlayerDataMode.Kart;
z = 0;
resetFloor = 0;
    
drawTex = 3;
maxSpeed = 4;
baseMaxSpeed = 4;
offTrackSpeed = 1;
engineMaxSpeed = 2.5;
normalTurnRate = 1;
onGround = 1;
zSpeed = 0;
jumpSpeed = 0.75;
steerAnimDelay = 2;
steerAnimTime = steerAnimDelay;
steerAnimCount = 0;
drift = 0;
driftTurnRate = 1.5;
driftSpeed = 3.25;
driftSkid = 0;
minTex = 2;
maxTex = 4;
direction = 90;
engineSound = audio_play_sound(sndMinigame4vs_Karts_PlayerEngineIdle, 0, true);
prevEngineSound = noone;
driftSound = noone;
rev = 0;
lapCheckPoint = 0;
lap = 0;
startX = x;
startY = y;
checkX = x;
checkY = y;
checkDir = 90;
drawMode = 1;
minFallHeight = -10;
roughTerrainSpeed = 1.5;