package funkin.graphics;

class Rating extends FlxTypedSpriteGroup<RatingSprite> {
    public var targetSpr:FlxSprite = null;

    public function new():Void {
        super();
        screenCenter();
    }

    var lastComboSpr:RatingSprite = null;
    var lastSickSpr:RatingSprite = null;

    public function ratingDisplay(rating:String, combo:Int, comboStart:Int = 10):Void {
        sickRating(rating);
        if (combo >= comboStart)
            comboNumRating(combo);
    }

    public function sickRating(daRating:String = 'sick'):Void {
        var ratingSpr:RatingSprite = getRatingSpr();
        ratingSpr.setupRating(daRating);
        ratingSpr.tweenDissapear(1);
        lastSickSpr = ratingSpr;
        addOnTop(ratingSpr);
    }

    public function comboRating():Void {
        var comboSpr:RatingSprite = getRatingSpr();
        comboSpr.setupRating('combo');
        comboSpr.tweenDissapear(1.5);

        comboSpr.y += lastSickSpr.height;
        comboSpr.x += lastSickSpr.width/3;
        comboSpr.acceleration.y = FlxG.random.int(200, 300);
        comboSpr.velocity.y = FlxG.random.int(-140, -160);
        comboSpr.velocity.x = FlxG.random.int(-5, 5);
        comboSpr.visible = !Preferences.getPref('vanilla-ui');
        addOnTop(comboSpr);

        lastComboSpr = comboSpr;
        comboHeight = comboSpr.height;
    }

    var comboHeight:Float = 50;

    public function comboNumRating(combo:Int):Void {
        var numSplit:Array<String> = Std.string(combo).split('');
        numSplit.reverse();
        for (i in 0...numSplit.length) {
            if (combo >= 10) {
                if (i == 0) comboRating();
                var numSpr:RatingSprite = getRatingSpr();
                numSpr.setupRating('nums');

                var numScale:Float = comboHeight / numSpr.frameHeight;// * 0.8;
                numSpr.scale.set(numScale,numScale);
                numSpr.animation.play(numSplit[i], true);
                numSpr.updateHitbox();
                numSpr.tweenDissapear(1.5);

                numSpr.x -= (numSpr.width * (i+1)) - lastSickSpr.width/3;
                numSpr.y += (lastComboSpr.height/2 - numSpr.height/2) + lastSickSpr.height;
                numSpr.acceleration.y = FlxG.random.int(200, 300);
                numSpr.velocity.y = FlxG.random.int(-140, -160);
                numSpr.velocity.x = FlxG.random.float(-5, 5);
                addOnTop(numSpr);
            }
        }
    }

    function getRatingSpr():RatingSprite {
        return recycle(RatingSprite);
    }

    function addOnTop(spr:RatingSprite) {
        add(spr);
        remove(spr, true);
        insert(members.length, spr);
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        if (targetSpr != null) setPosition(targetSpr.x - 400, targetSpr.y - 200);//targetSpr.x - targetSpr.width/2, targetSpr.y - targetSpr.width/4);
    }
}

class RatingSprite extends FlxSpriteUtil {
    public function setupRating(path:String) {
        var imagePath = 'skins/${SkinUtil.curSkin}/ratings/$path';
        var scaleMult:Float = 1;
        loadImage(imagePath);
        switch(path) {
            case 'nums':
                loadImageAnimated(imagePath, Std.int(width / 10), Std.int(height));
                for (i in 0...10) animation.add(Std.string(i), [i], 1);
            case 'combo': scaleMult = 0.9;
        }
        setPosition(0,0);
        offset.set(0,0);
        acceleration.y = 550;
		velocity.y = FlxG.random.int(-140, -175);
		velocity.x = FlxG.random.int(0, -10);
        FlxTween.cancelTweensOf(this);

        var skinData = SkinUtil.getSkinData(SkinUtil.curSkin);
        setScale(skinData.scale * scaleMult);
        antialiasing = skinData.antialiasing ? Preferences.getPref('antialiasing') : false;
    }

    public function tweenDissapear(crochetMult:Float = 1):Void {
        alpha = 1;
        FlxTween.tween(this, {alpha: 0}, Conductor.stepCrochet/400, {
            onComplete: function(tween:FlxTween) {
                kill();
            },
            startDelay: Conductor.crochet * (0.001*crochetMult)
        });
    }
}