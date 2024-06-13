package funkin.util.frontend.modifiers;

import funkin.util.frontend.modifiers.BasicModifier.Modifiers;

class TipsyModifier extends BasicModifier
{
    public function new() {
        super(TIPSY, false);
    }

    override function manageStrumUpdate(strum:NoteStrum, elapsed:Float, timeElapsed:Float) {
        var size:Float = data[0];
        if (FunkMath.isZero(size))
            return;
        
        var speed:Float = data[1];
        var period:Float = data[2] * speed;

        strum.yModchart += FunkMath.sin((timeElapsed + (strum.noteData * period)) * scale(speed)) * scaleHeight(size);
    }

    // [size, speed, period]
    override function getDefaultValues() {
        return [0.5, 0.5, 0.1];
    }
}