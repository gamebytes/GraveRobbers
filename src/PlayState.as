package
{
	import org.flixel.*;

	public class PlayState extends FlxState
	{
		[Embed(source="data/map.png")] protected var ImgMap:Class;
		
		//just temporary, will paint or hand-draw actual level once its finalized i think?
		[Embed(source="data/temp_tiles.png")] protected var ImgTempTiles:Class;
		
		public var map:FlxTilemap;
		public var crushers:FlxGroup;
		public var flameTraps:FlxGroup;
		public var arrowTraps:FlxGroup;
		public var trapDoors:FlxGroup;
		public var floodTraps:FlxGroup;
		
		override public function create():void
		{
			var l:int;
			
			//Processing the map data to get trap locations before making a simple collision/pathfinding hull		
			var solidColor:uint = 0xffffffff;
			var openColor:uint = 0xff000000;
			var crusherColor:uint = 0xffff0000;
			var flameColor:uint = 0xffffd400;
			var arrowColor:uint = 0xffff00f2;
			var trapColor:uint = 0xff15ff00;
			var floodColor:uint = 0xff2659ff;
			var mapSprite:FlxSprite = new FlxSprite(0,0,ImgMap);
			var crusherLocations:Array = mapSprite.replaceColor(crusherColor,solidColor,true);
			var flameLocations:Array = mapSprite.replaceColor(flameColor,solidColor,true);
			var arrowLocations:Array = mapSprite.replaceColor(arrowColor,solidColor,true);
			var trapLocations:Array = mapSprite.replaceColor(trapColor,openColor,true);
			var floodLocations:Array = mapSprite.replaceColor(floodColor,solidColor,true);
			map = new FlxTilemap().loadMap(FlxTilemap.bitmapToCSV(mapSprite.pixels,true),ImgTempTiles,0,0,FlxTilemap.OFF,0,0,1);
			map.ignoreDrawDebug = true;
			//map.active = map.visible = false;
			add(map);
			
			crushers = makeTraps(Crusher,crusherLocations);
			flameTraps = makeTraps(FlameTrap,flameLocations);
			arrowTraps = makeTraps(ArrowTrap,arrowLocations);
			trapDoors = makeTraps(TrapDoor,trapLocations);
			floodTraps = makeTraps(FloodTrap,floodLocations);
		}
		
		public function makeTraps(TrapType:Class,TrapLocations:Array):FlxGroup
		{
			var traps:FlxGroup = new FlxGroup();
			var l:int = TrapLocations.length;
			while(l--)
				traps.add(new TrapType(TrapLocations[l].x,TrapLocations[l].y));
			traps.sort();
			add(traps);
			return traps;
		}
	}
}
