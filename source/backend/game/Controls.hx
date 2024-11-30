package backend.game;

import flixel.input.gamepad.FlxGamepadInputID as FlxPad;
import flixel.input.keyboard.FlxKey;
import flixel.input.FlxInput.FlxInputState;
#if mobile
import mobile.flixel.FlxButton;
import mobile.flixel.FlxHitbox;
import mobile.flixel.FlxVirtualPad;
#end

using haxe.EnumTools;

enum DoidoKey
{
	// gameplay
	LEFT;
	DOWN;
	UP;
	RIGHT;
	RESET;
	// ui stuff
	UI_LEFT;
	UI_DOWN;
	UI_UP;
	UI_RIGHT;
	ACCEPT;
	BACK;
	PAUSE;
	TEXT_LOG;
	// none
	NONE;
}

class Controls
{
	public static function justPressed(bind:DoidoKey):Bool
	{
		return checkBind(bind, JUST_PRESSED);
	}

	public static function pressed(bind:DoidoKey):Bool
	{
		return checkBind(bind, PRESSED);
	}

	public static function released(bind:DoidoKey):Bool
	{
		return checkBind(bind, JUST_RELEASED);
	}

	public static function checkBind(rawBind:DoidoKey, inputState:FlxInputState):Bool
	{
		var bind = bindToString(rawBind);
		if(!allControls.exists(bind))
		{
			Logs.print('Bind $bind not found', WARNING);
			return false;
		}

		for(i in 0...allControls.get(bind)[0].length)
		{
			var key:FlxKey = allControls.get(bind)[0][i];
			if(FlxG.keys.checkStatus(key, inputState)
			&& key != FlxKey.NONE)
				return true;
		}

		// gamepads
		if(FlxG.gamepads.lastActive != null)
		for(i in 0...allControls.get(bind)[1].length)
		{
			var key:FlxPad = allControls.get(bind)[1][i];
			if(FlxG.gamepads.lastActive.checkStatus(key, inputState)
			&& key != FlxPad.NONE)
				return true;
		}

		return false;
	}

	inline public static function bindToString(bind:DoidoKey):String
	{
		var constructors = DoidoKey.getConstructors();
		return constructors[constructors.indexOf(Std.string(bind))];
	}

	//THIS IS A TEMP FIX!!!! CHANGE LATER!!!!
	inline public static function stringToBind(bind:String):DoidoKey
	{
		switch(bind) {
			case "LEFT":
				return LEFT;
			case "DOWN":
				return DOWN;
			case "UP":
				return UP;
			case "RIGHT":
				return RIGHT;
			case "RESET":
				return RESET;
			case "UI_LEFT":
				return UI_LEFT;
			case "UI_DOWN":
				return UI_DOWN;
			case "UI_UP":
				return UI_UP;
			case "UI_RIGHT":
				return UI_RIGHT;
			case "ACCEPT":
				return ACCEPT;
			case "BACK":
				return BACK;
			case "PAUSE":
				return PAUSE;
			case "TEXT_LOG":
				return TEXT_LOG;
			default:
				return NONE;
		}

		// NOTE: This does not work on Linux or macOS
		//return cast DoidoKey.getConstructors().indexOf(Std.string(bind));
	}
	
	#if mobile
	public var trackedInputsUI:Array<FlxActionInput> = [];
	public var trackedInputsNOTES:Array<FlxActionInput> = [];

	public function addButtonNOTES(action:FlxActionDigital, button:FlxButton, state:FlxInputState)
	{
		var input:FlxActionInputDigitalIFlxInput = new FlxActionInputDigitalIFlxInput(button, state);
		trackedInputsNOTES.push(input);
		action.add(input);
	}

	public function addButtonUI(action:FlxActionDigital, button:FlxButton, state:FlxInputState)
	{
		var input:FlxActionInputDigitalIFlxInput = new FlxActionInputDigitalIFlxInput(button, state);
		trackedInputsUI.push(input);
		action.add(input);
	}

	public function setHitBox(Hitbox:FlxHitbox)
	{
		inline forEachBound(Control.UP, (action, state) -> addButtonNOTES(action, Hitbox.buttonUp, state));
		inline forEachBound(Control.DOWN, (action, state) -> addButtonNOTES(action, Hitbox.buttonDown, state));
		inline forEachBound(Control.LEFT, (action, state) -> addButtonNOTES(action, Hitbox.buttonLeft, state));
		inline forEachBound(Control.RIGHT, (action, state) -> addButtonNOTES(action, Hitbox.buttonRight, state));
	}

	public function setVirtualPadUI(VirtualPad:FlxVirtualPad, DPad:FlxDPadMode, Action:FlxActionMode)
	{
		switch (DPad)
		{
			case UP_DOWN:
				inline forEachBound(Control.UP, (action, state) -> addButtonUI(action, VirtualPad.buttonUp, state));
				inline forEachBound(Control.DOWN, (action, state) -> addButtonUI(action, VirtualPad.buttonDown, state));
			case LEFT_RIGHT:
				inline forEachBound(Control.LEFT, (action, state) -> addButtonUI(action, VirtualPad.buttonLeft, state));
				inline forEachBound(Control.RIGHT, (action, state) -> addButtonUI(action, VirtualPad.buttonRight, state));
			case UP_LEFT_RIGHT:
				inline forEachBound(Control.UP, (action, state) -> addButtonUI(action, VirtualPad.buttonUp, state));
				inline forEachBound(Control.LEFT, (action, state) -> addButtonUI(action, VirtualPad.buttonLeft, state));
				inline forEachBound(Control.RIGHT, (action, state) -> addButtonUI(action, VirtualPad.buttonRight, state));
			case LEFT_FULL | RIGHT_FULL:
				inline forEachBound(Control.UP, (action, state) -> addButtonUI(action, VirtualPad.buttonUp, state));
				inline forEachBound(Control.DOWN, (action, state) -> addButtonUI(action, VirtualPad.buttonDown, state));
				inline forEachBound(Control.LEFT, (action, state) -> addButtonUI(action, VirtualPad.buttonLeft, state));
				inline forEachBound(Control.RIGHT, (action, state) -> addButtonUI(action, VirtualPad.buttonRight, state));
			case BOTH_FULL:
				inline forEachBound(Control.UP, (action, state) -> addButtonUI(action, VirtualPad.buttonUp, state));
				inline forEachBound(Control.DOWN, (action, state) -> addButtonUI(action, VirtualPad.buttonDown, state));
				inline forEachBound(Control.LEFT, (action, state) -> addButtonUI(action, VirtualPad.buttonLeft, state));
				inline forEachBound(Control.RIGHT, (action, state) -> addButtonUI(action, VirtualPad.buttonRight, state));
				inline forEachBound(Control.UP, (action, state) -> addButtonUI(action, VirtualPad.buttonUp2, state));
				inline forEachBound(Control.DOWN, (action, state) -> addButtonUI(action, VirtualPad.buttonDown2, state));
				inline forEachBound(Control.LEFT, (action, state) -> addButtonUI(action, VirtualPad.buttonLeft2, state));
				inline forEachBound(Control.RIGHT, (action, state) -> addButtonUI(action, VirtualPad.buttonRight2, state));
			case NONE: // do nothing
		}

		switch (Action)
		{
			case A:
				inline forEachBound(Control.ACCEPT, (action, state) -> addButtonUI(action, VirtualPad.buttonA, state));
			case B:
				inline forEachBound(Control.BACK, (action, state) -> addButtonUI(action, VirtualPad.buttonB, state));
			case A_B | A_B_C | A_B_E | A_B_X_Y | A_B_C_X_Y | A_B_C_X_Y_Z | A_B_C_D_V_X_Y_Z:
				inline forEachBound(Control.ACCEPT, (action, state) -> addButtonUI(action, VirtualPad.buttonA, state));
				inline forEachBound(Control.BACK, (action, state) -> addButtonUI(action, VirtualPad.buttonB, state));
			case NONE: // do nothing
		}
	}

	public function setVirtualPadNOTES(VirtualPad:FlxVirtualPad, DPad:FlxDPadMode, Action:FlxActionMode)
	{
		switch (DPad)
		{
			case UP_DOWN:
				inline forEachBound(Control.UP, (action, state) -> addButtonNOTES(action, VirtualPad.buttonUp, state));
				inline forEachBound(Control.DOWN, (action, state) -> addButtonNOTES(action, VirtualPad.buttonDown, state));
			case LEFT_RIGHT:
				inline forEachBound(Control.LEFT, (action, state) -> addButtonNOTES(action, VirtualPad.buttonLeft, state));
				inline forEachBound(Control.RIGHT, (action, state) -> addButtonNOTES(action, VirtualPad.buttonRight, state));
			case UP_LEFT_RIGHT:
				inline forEachBound(Control.UP, (action, state) -> addButtonNOTES(action, VirtualPad.buttonUp, state));
				inline forEachBound(Control.LEFT, (action, state) -> addButtonNOTES(action, VirtualPad.buttonLeft, state));
				inline forEachBound(Control.RIGHT, (action, state) -> addButtonNOTES(action, VirtualPad.buttonRight, state));
			case LEFT_FULL | RIGHT_FULL:
				inline forEachBound(Control.UP, (action, state) -> addButtonNOTES(action, VirtualPad.buttonUp, state));
				inline forEachBound(Control.DOWN, (action, state) -> addButtonNOTES(action, VirtualPad.buttonDown, state));
				inline forEachBound(Control.LEFT, (action, state) -> addButtonNOTES(action, VirtualPad.buttonLeft, state));
				inline forEachBound(Control.RIGHT, (action, state) -> addButtonNOTES(action, VirtualPad.buttonRight, state));
			case BOTH_FULL:
				inline forEachBound(Control.UP, (action, state) -> addButtonNOTES(action, VirtualPad.buttonUp, state));
				inline forEachBound(Control.DOWN, (action, state) -> addButtonNOTES(action, VirtualPad.buttonDown, state));
				inline forEachBound(Control.LEFT, (action, state) -> addButtonNOTES(action, VirtualPad.buttonLeft, state));
				inline forEachBound(Control.RIGHT, (action, state) -> addButtonNOTES(action, VirtualPad.buttonRight, state));
				inline forEachBound(Control.UP, (action, state) -> addButtonNOTES(action, VirtualPad.buttonUp2, state));
				inline forEachBound(Control.DOWN, (action, state) -> addButtonNOTES(action, VirtualPad.buttonDown2, state));
				inline forEachBound(Control.LEFT, (action, state) -> addButtonNOTES(action, VirtualPad.buttonLeft2, state));
				inline forEachBound(Control.RIGHT, (action, state) -> addButtonNOTES(action, VirtualPad.buttonRight2, state));
			case NONE: // do nothing
		}

		switch (Action)
		{
			case A:
				inline forEachBound(Control.ACCEPT, (action, state) -> addButtonNOTES(action, VirtualPad.buttonA, state));
			case B:
				inline forEachBound(Control.BACK, (action, state) -> addButtonNOTES(action, VirtualPad.buttonB, state));
			case A_B | A_B_C | A_B_E | A_B_X_Y | A_B_C_X_Y | A_B_C_X_Y_Z | A_B_C_D_V_X_Y_Z:
				inline forEachBound(Control.ACCEPT, (action, state) -> addButtonNOTES(action, VirtualPad.buttonA, state));
				inline forEachBound(Control.BACK, (action, state) -> addButtonNOTES(action, VirtualPad.buttonB, state));
			case NONE: // do nothing
		}
	}

	public function removeVirtualControlsInput(Tinputs:Array<FlxActionInput>)
	{
		for (action in this.digitalActions)
		{
			var i = action.inputs.length;
			while (i-- > 0)
			{
				var x = Tinputs.length;
				while (x-- > 0)
				{
					if (Tinputs[x] == action.inputs[i])
						action.remove(action.inputs[i]);
				}
			}
		}
	}
	#end
	
	public static function setSoundKeys(?empty:Bool = false)
	{
		if(empty)
		{
			FlxG.sound.muteKeys 		= [];
			FlxG.sound.volumeDownKeys 	= [];
			FlxG.sound.volumeUpKeys 	= [];
		}
		else
		{
			FlxG.sound.muteKeys 		= [ZERO,  NUMPADZERO];
			FlxG.sound.volumeDownKeys 	= [MINUS, NUMPADMINUS];
			FlxG.sound.volumeUpKeys 	= [PLUS,  NUMPADPLUS];
		}
	}
	
	// self explanatory (i think)
	public static final changeableControls:Array<String> = [
		'LEFT', 'DOWN', 'UP', 'RIGHT',
		'RESET',
	];
	
	/*
	** [0]: keyboard
	** [1]: gamepad
	*/
	public static var allControls:Map<String, Array<Dynamic>> = [
		// gameplay controls
		'LEFT' => [
			[FlxKey.A, FlxKey.LEFT],
			[FlxPad.LEFT_TRIGGER, FlxPad.DPAD_LEFT],
		],
		'DOWN' => [
			[FlxKey.S, FlxKey.DOWN],
			[FlxPad.LEFT_SHOULDER, FlxPad.DPAD_DOWN],
		],
		'UP' => [
			[FlxKey.W, FlxKey.UP],
			[FlxPad.RIGHT_SHOULDER, FlxPad.DPAD_UP],
		],
		'RIGHT' => [
			[FlxKey.D, FlxKey.RIGHT],
			[FlxPad.RIGHT_TRIGGER, FlxPad.DPAD_RIGHT],
		],
		'RESET' => [
			[FlxKey.R, FlxKey.NONE],
			[FlxPad.BACK, FlxPad.NONE],
		],

		// ui controls
		'UI_LEFT' => [
			[FlxKey.A, FlxKey.LEFT],
			[FlxPad.LEFT_STICK_DIGITAL_LEFT, FlxPad.DPAD_LEFT],
		],
		'UI_DOWN' => [
			[FlxKey.S, FlxKey.DOWN],
			[FlxPad.LEFT_STICK_DIGITAL_DOWN, FlxPad.DPAD_DOWN],
		],
		'UI_UP' => [
			[FlxKey.W, FlxKey.UP],
			[FlxPad.LEFT_STICK_DIGITAL_UP, FlxPad.DPAD_UP],
		],
		'UI_RIGHT' => [
			[FlxKey.D, FlxKey.RIGHT],
			[FlxPad.LEFT_STICK_DIGITAL_RIGHT, FlxPad.DPAD_RIGHT],
		],

		// ui buttons
		'ACCEPT' => [
			[FlxKey.SPACE, FlxKey.ENTER],
			[FlxPad.A, FlxPad.X, FlxPad.START],
		],
		'BACK' => [
			[FlxKey.BACKSPACE, FlxKey.ESCAPE],
			[FlxPad.B],
		],
		'PAUSE' => [
			[FlxKey.ENTER, FlxKey.ESCAPE],
			[FlxPad.START],
		],
		'TEXT_LOG' => [
			[FlxKey.TAB],
			[FlxPad.Y],
		],
	];

	public static function load()
	{
		if(SaveData.saveControls.data.allControls == null)
		{
			SaveData.saveControls.data.allControls = allControls;
		}

		if(Lambda.count(allControls) != Lambda.count(SaveData.saveControls.data.allControls))
		{
			var oldControls:Map<String, Array<Dynamic>> = SaveData.saveControls.data.allControls;
			
			for(key => values in allControls) {
				if(oldControls.get(key) == null)
					oldControls.set(key, values);
			}
			for(key => values in oldControls) {
				if(allControls.get(key) == null)
					oldControls.remove(key);
			}

			SaveData.saveControls.data.allControls = allControls = oldControls;
		}
		
		// allControls = SaveData.saveControls.data.allControls;
		var impControls:Map<String, Array<Dynamic>> = SaveData.saveControls.data.allControls;
		for(label => key in impControls)
		{
			if(changeableControls.contains(label))
				allControls.set(label, key);
		}

		save();
	}

	public static function save()
	{
		SaveData.saveControls.data.allControls = allControls;
		SaveData.save();
	}
}