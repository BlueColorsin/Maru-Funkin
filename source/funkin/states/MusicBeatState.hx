package funkin.states;

import flixel.addons.ui.FlxUIState;

class MusicBeatState extends FlxUIState {
	public static var game:MusicBeatState;
	public static var curState:String;
	public var scriptConsole:ScriptConsole;

	private var curStep:Int = 0;
	private var curBeat:Int = 0;
	private var curSection:Int = 0;

	override function create():Void {
		game = this;
		curState = CoolUtil.formatClass(this, false);

		super.create();
		scriptConsole = new ScriptConsole();
		add(scriptConsole);

		//State Scripts
		ModdingUtil.clearScripts(true);
		var globalStateScripts:Array<String> = ModdingUtil.getScriptList('data/scripts/state');
		var curStateScripts:Array<String> = ModdingUtil.getScriptList('data/scripts/state/${CoolUtil.formatClass(this).split('funkin/states/')[1]}');
		for (script in globalStateScripts.concat(curStateScripts)) ModdingUtil.addScript(script, true);
		ModdingUtil.addCall('stateCreate', null, true);
	}

	override function update(elapsed:Float):Void {
		handleSteps();
		ModdingUtil.addCall('stateUpdate', [elapsed], true);
		if (FlxG.keys.justPressed.F1) scriptConsole.show = !scriptConsole.show;
		super.update(elapsed);
	}

	private function handleSteps():Void {
		var oldStep:Int = curStep;
		updateCurStep();
		updateBeat();
		updateSection();
		if (oldStep != curStep && curStep >= 0) {
			stepHit();
		}
	}

	private function updateSection():Void {
		curSection = Math.floor(curBeat / Conductor.BEATS_LENGTH);
	}

	private function updateBeat():Void {
		curBeat = Math.floor(curStep / Conductor.BEATS_LENGTH);
	}

	private function updateCurStep():Void {
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: 0
		}
		for (i in 0...Conductor.bpmChangeMap.length) {
			if (Conductor.songPosition - Conductor.settingOffset >= Conductor.bpmChangeMap[i].songTime) {
				lastChange = Conductor.bpmChangeMap[i];
			}
		}
		curStep = lastChange.stepTime + Math.floor((Conductor.songPosition - Conductor.settingOffset - lastChange.songTime) / Conductor.stepCrochet);
	}

	public function stepHit():Void {
		ModdingUtil.addCall('stateStepHit', [curStep], true);
		if (curStep % Conductor.BEATS_LENGTH == 0) {
			beatHit();
		}
	}

	public function beatHit():Void {
		ModdingUtil.addCall('stateBeatHit', [curBeat], true);
		if (curBeat % Conductor.BEATS_LENGTH == 0) {
			sectionHit();
		}
	}

	public function sectionHit():Void {
		ModdingUtil.addCall('stateSectionHit', [curSection], true);
	}

	//Just a quicker way to get settings
	public function getPref(pref:String):Dynamic		return Preferences.getPref(pref);
	public function getKey(key:String):Dynamic			return Controls.getKey(key);
	
	// Fix broken transitions
	override function transitionIn() {
		if (transIn != null && transIn.type != NONE)
		{
			var _trans = createTransition(transIn);
			_trans.setStatus(FULL);
			_trans.cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
			openSubState(_trans);
			_trans.finishCallback = finishTransIn;
			_trans.start(OUT);
		}
	}

	override function transitionOut(?OnExit:() -> Void) {
		_onExit = OnExit;
		if (hasTransOut) {
			var _trans = createTransition(transOut);
			_trans.setStatus(EMPTY);
			_trans.cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
			openSubState(_trans);
			_trans.finishCallback = finishTransOut;
			_trans.start(IN);
		}
		else _onExit();
	}
}