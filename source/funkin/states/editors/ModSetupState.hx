package funkin.states.editors;

/*
    The idea is to make a quick creator for mod templates
    just adding the essentials quickly with drag n drop and shit
*/

import sys.io.File;

class ModSetupState extends MusicBeatState {
    override function create() {
        var bg = new FunkinSprite("menuDesat");
        bg.setScale(1.1,false);
        bg.color = 0xff353535;
        add(bg);

        /*setOnDrop(function (path:String) {
            trace("DROPPED FILE FROM: " + Std.string(path));
            var newPath = "./" + "mods/test/images/crap.png";
            File.copy(path, newPath);
        });*/
        
        setupModFolder('sexMod');

        super.create();
    }

    static var modFolderDirs(default, never):Map<String, Array<String>> = [
        "images" => ["characters", "skins", "storymenu"],
        "data" => ["characters", "notetypes", "scripts", "stages", "weeks", "events", "skins"],
        "songs" => [],
        "music" => [],
        "sounds" => [],
        "fonts" => [],
        "videos" => []
    ];

    // Creates a mod folder template
    function setupModFolder(name:String) {
        for (k in modFolderDirs.keys()) {
            var keyArr = modFolderDirs.get(k);
            createFolderWithTxt('$name/$k');
            for (i in keyArr) createFolderWithTxt('$name/$k/$i');
        }
    }

    function createFolderWithTxt(path:String) {
        var pathParts = path.split("/");
        createFolder(path);
        File.saveContent('mods/$path/${pathParts[pathParts.length-1]}-go-here.txt', "");
    }

    function createFolder(path:String) {
        var dirs = path.split("/");
        var lastDir = "mods/";
        for (i in dirs) {
            if (i == null) continue;
            lastDir += '$i/';
            if (!FileSystem.exists(lastDir)) {  // Create subdirectories
                FileSystem.createDirectory(lastDir);
            }
        }
    }

    function setOnDrop(func:Dynamic) {
        FlxG.stage.window.onDropFile.removeAll();
        FlxG.stage.window.onDropFile.add(func);
    }

    override function destroy() {
        super.destroy();
        FlxG.stage.window.onDropFile.removeAll();
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (getKey('BACK-P')) {
            switchState(new MainMenuState());
        }
    }
}