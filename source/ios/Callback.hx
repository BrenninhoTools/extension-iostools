package ios;

#if ios
import cpp.ConstCharStar;
import haxe.Json;
import ios.internal.Native;

@:cppFileCode('#include <ios/CallbackBridge.h>')
class Callback
{
	static var initialized:Bool = false;
	static var nextId:Int = 1;
	static var listeners:Array<EventListener> = [];
	static var pending:Map<Int, Dynamic->Void> = [];

	public static function init():Void
	{
		if (initialized)
			return;

		initialized = true;
		Native.setEventCallback(untyped __cpp__('::cpp::Function<void (const char*)>(&::ios::CallbackBridge::receive)'));
	}

	public static function addListener(listener:EventListener):Void
	{
		init();

		if (listener != null && listeners.indexOf(listener) == -1)
			listeners.push(listener);
	}

	public static function removeListener(listener:EventListener):Void
	{
		listeners.remove(listener);
	}

	public static function clearListeners():Void
	{
		listeners = [];
	}

	@:allow(ios)
	static function register(handler:Null<Dynamic->Void>):Int
	{
		init();

		var id:Int = nextId++;

		if (handler != null)
			pending.set(id, handler);

		return id;
	}

	@:allow(ios.CallbackBridge)
	static function dispatch(payload:String):Void
	{
		var parsed:Dynamic = null;

		if (payload == null)
			return;

		try
		{
			parsed = Json.parse(payload);
		}
		catch (e:Dynamic)
		{
			return;
		}

		if (parsed == null)
			return;

		var event:String = Std.string(Reflect.field(parsed, "event"));
		var data:Dynamic = Reflect.field(parsed, "data");

		if (data != null && Reflect.hasField(data, "id"))
		{
			var id:Int = Std.int(Reflect.field(data, "id"));
			var handler:Null<Dynamic->Void> = pending.get(id);

			if (handler != null)
			{
				pending.remove(id);
				handler(data);
			}
		}

		for (listener in listeners.copy())
			listener(event, data);
	}
}

@:nativeGen
@:keep
class CallbackBridge
{
	public static function receive(payload:ConstCharStar):Void
	{
		Callback.dispatch(payload == null ? null : payload.toString());
	}
}
#end
