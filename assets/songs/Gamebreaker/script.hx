import flixel.math.FlxPoint;

var camLerping:Bool = true;
var angleLerp:Bool = false;
var cameraBop:Bool = false;

var autoZoom:Bool = true;
var zoomDad:Float = 0.7; // 0.7
var zoomBf:Float = 0.5; // 0.5

var sacrificialFlxPoint:FlxPoint;

function createPost() {
    sacrificialFlxPoint = FlxPoint.get();
    State.gfGroup.kill();
}

function startSong() {
    State.camZooming = false;
    State.notesGroup.inBotplay = true;
    Conductor.songPosition = 29320;
}

function stepHit(curStep:Int) {
    //State.notesGroup.inBotplay = getPref("botplay");
    switch(curStep) {
        case 302: {
            State.defaultCamZoom = 0.75;
            FlxTween.tween(State.camGame.scroll, {x: State.camGame.scroll.x - 50}, Conductor.stepCrochet * 0.002, {ease: FlxEase.quadOut});
        }
        case 304:
            State.camGame.zoom += 0.1;
        case 318: {
            FlxTween.tween(State.camGame, {zoom: 0.8, "scroll.x": State.camGame.scroll.x - 50}, Conductor.stepCrochet * 0.002, {ease: FlxEase.quadIn});
        }
        case 320: {
            FlxTween.tween(State.camGame, {"scroll.y": State.camGame.scroll.y - 50, zoom: 0.65}, Conductor.stepCrochet * 0.003, {ease: FlxEase.quadOut, onComplete:
                function(twn:FlxTween) {
                    FlxTween.tween(State.camGame, {"scroll.y": State.camGame.scroll.y + 50, zoom: 0.75}, Conductor.stepCrochet * 0.001, {ease: FlxEase.sineInOut});
                }
            });
        }
        case 352: {
            angleLerp = true;
            FlxTween.tween(State.camGame, {angle: -2.5}, Conductor.stepCrochet * 0.004, {ease: FlxEase.quadOut});
            FlxTween.tween(State.camGame, {zoom: 0.85}, Conductor.stepCrochet * 0.007, {ease: FlxEase.backOut, onComplete: 
                function() {
                    camLerping = false;
                }
            });
        }
        case 356: 
            FlxTween.tween(State.camGame, {angle: 2.5}, Conductor.stepCrochet * 0.004, {ease: FlxEase.quadOut});
        case 361: camLerping = true;
        case 366: {
            State.camMove = false;
            FlxTween.tween(State.camGame, {zoom: 0.85}, Conductor.crochet * 0.0015, {ease: FlxEase.sineInOut});
        }
        case 368: 
            FlxTween.tween(State.camGame.scroll, {x: State.camGame.scroll.x + 25}, Conductor.stepCrochet * 0.002, {ease: FlxEase.quadInOut});
        case 370: {
            FlxTween.tween(State.camGame.scroll, {y: State.camGame.scroll.y + 25, x: State.camGame.scroll.x - 50}, Conductor.stepCrochet * 0.002, {ease: FlxEase.quadOut, onComplete:
                function(twn:FlxTween) {
                    State.camMove = true;
                    State.cameraMovement();
                }
            });
        }
        case 406: {
            State.camGame.angle += 5;
            State.camGame.zoom += 0.15;
        }
        case 410: {
            State.camGame.angle += -5;
            State.camGame.zoom += 0.15;
        }
        case 414: {
            State.camGame.angle += 5;
            State.camGame.zoom += 0.15;
            FlxTween.tween(State.camGame, {angle: 0}, Conductor.crochet * 0.001, {ease: FlxEase.quadOut});
        }
        case 422: {
            State.camGame.angle -= 2.5;
            State.camGame.zoom += 0.075;
        }
        case 428: {
            FlxTween.tween(State.camGame, {zoom: 0.9}, Conductor.crochet * 0.001, {ease: FlxEase.circOut});
            FlxTween.tween(State.boyfriend, {alpha: 0.25}, Conductor.crochet * 0.001, {ease: FlxEase.circOut, onComplete: function() {
                FlxTween.tween(State.boyfriend, {alpha: 1}, Conductor.crochet * 0.001, {ease: FlxEase.sineInOut});
            }});
            State.dad.prepareCamPoint(sacrificialFlxPoint);
            FlxTween.tween(State.camFollow, {x: sacrificialFlxPoint.x, y: sacrificialFlxPoint.y}, Conductor.crochet * 0.001, {ease: FlxEase.circOut, onUpdate: function() {
                State.snapCamera();
                cameraMovement(0);
            }});
        }
        case 444: {

            FlxTween.tween(State.camGame, {"scroll.y": State.camGame.scroll.y + 25, zoom: 0.75} , Conductor.crochet * 0.001, {ease: FlxEase.quadOut, onComplete:
                function(twn:FlxTween) {
                    FlxTween.tween(State.camGame, {"scroll.y": State.camGame.scroll.y - 25, zoom: 0.725} , Conductor.stepCrochet * 0.001, {ease: FlxEase.sineInOut});
            }});
        }
        case 460: {
            FlxTween.tween(State.camGame, {"scroll.y": State.camGame.scroll.y - 50, zoom: 0.65}, Conductor.crochet * 0.001, {ease: FlxEase.quadOut, onComplete:
                function(twn:FlxTween) {
                    FlxTween.tween(State.camGame, {"scroll.y": State.camGame.scroll.y + 50, zoom: 0.75}, Conductor.stepCrochet * 0.001, {ease: FlxEase.sineInOut});
                }
            });
        }
        case 468: {
            getSpr("background").alpha = 0;
        }
        case 470: {
            getSpr("background").alpha = 1;
            State.camGame.flash(0xFFFFFFFF, Conductor.crochet * 0.002);
            State.camGame.zoom += 0.15;
            State.camGame.angle += 5;
            
            State.camGame.scroll.x += 125;
            State.camGame.scroll.y += 25;
            State.cameraMovement();
        }
        case 484: {
            getSpr("background").alpha = 0;
        }
        case 486: {
            getSpr("background").alpha = 1;
            State.camGame.flash(0xFFFFFFFF, Conductor.crochet * 0.002);
            State.camGame.zoom += 0.15;
            State.camGame.angle -= 5;

            State.camGame.scroll.x -= 125;
            State.camGame.scroll.y += 25;
            State.cameraMovement();
        }
        case 534: {
            State.camGame.zoom += 0.15;
            State.camGame.angle -= 5;
        }
        case 538: {
            State.camGame.zoom += 0.15;
            State.camGame.angle += 5;
        }
        case 542: {
            State.camGame.angle -= 5;
            State.camGame.zoom += 0.15;
            FlxTween.tween(State.camGame, {angle: 0}, Conductor.crochet * 0.001, {ease: FlxEase.quadOut});
        }
        case 550: {
            State.camGame.zoom += 0.075;
            State.camGame.angle += 2.5;
        }
        case 559:
            cameraBop = true;
        case 616: {
            State.defaultCamZoom = 0.85;
        }
        case 696:
            gameZooming = false;
            FlxTween.tween(State.camGame, {zoom: 0.85}, Conductor.crochet * 0.001, {ease: FlxEase.circOut, onComplete: function() {
                FlxTween.tween(State.camGame, {zoom: 0.65}, Conductor.crochet * 0.001, {ease: FlxEase.quartOut});
            }});
        case 703:
            gameZooming = true;
        case 800: {
            zoomDad = 0.425;
            cameraBop = angleLerp = false;
            FlxTween.tween(State.camHUD, {y: 0, zoom: 1, angle: 0}, Conductor.crochet * 0.004, {ease: FlxEase.sineInOut});
            FlxTween.tween(State.camGame, {zoom: 0.7, angle: 0}, Conductor.crochet * 0.004, {ease: FlxEase.sineInOut});
        }
    }
}

var bopUp:FlxTween;
var bopDown:FlxTween;

var angle:Float = 2.5;

var gameZooming:Bool = true;

function beatHit(curBeat:Int) {
    if (bopUp != null) bopUp.cancel();
    if (bopDown != null) bopDown.cancel();

    if (cameraBop) {

        bopDown = FlxTween.tween(State.camHUD, {y: 0, zoom: 1.1}, Conductor.crochet * 0.00025, {ease: FlxEase.circOut, onComplete: function() {
            bopUp = FlxTween.tween(State.camHUD, {y: -30, zoom: 0.95}, Conductor.crochet * 0.00075, {ease: FlxEase.circIn});
        }});

        if (gameZooming) {
            State.camGame.zoom += 0.05;
        }
        State.camGame.angle = angle;
        State.camHUD.angle = angle * 0.75;
        angle = -angle;
    }
}

function update(dt:Float) {
    if (camLerping) {
        State.camGame.zoom = CoolUtil.coolLerp(State.camGame.zoom, State.defaultCamZoom, 0.05);
        if (!cameraBop)
            State.camHUD.zoom = CoolUtil.coolLerp(State.camHUD.zoom, 1, 0.05);
    }
    if (angleLerp) {
        State.camGame.angle = CoolUtil.coolLerp(State.camGame.angle, 0, 0.05);
        State.camHUD.angle = CoolUtil.coolLerp(State.camHUD.angle, 0, 0.05);
    }
}

function cameraMovement(character:Int) {
    if (autoZoom) {
        if (character == 0)
            State.defaultCamZoom = zoomDad;
        else // boyfriend
            State.defaultCamZoom = zoomBf;
    }
}
