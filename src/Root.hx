import starling.display.Sprite;
import starling.utils.AssetManager;
import starling.display.Image;
import starling.core.Starling;
import starling.animation.Transitions;
import starling.events.KeyboardEvent;
import flash.ui.Keyboard;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.events.Event;
import starling.utils.RectangleUtil;
import flash.geom.Rectangle;

import Tilemap;

class Root extends Sprite {

    public static var assets:AssetManager;
    public var ninja:Image;
    
	//For the tilemap
	var tmx:Tilemap;

    public function new() {
        super();
    }

    public function start(startup:Startup) {
    
    	assets = new AssetManager();
    	
    	//tilemap
		assets.enqueue("assets/skyone.png");
		assets.enqueue("assets/skytwo.png");
		assets.enqueue("assets/skythree.png");
		assets.enqueue("assets/dirtBlock.png");
		assets.enqueue("assets/cloud.png");
		assets.enqueue("assets/Bricks.png");

        assets.enqueue("assets/ninja.png");
        assets.loadQueue(function onProgress(ratio:Float) {

            if (ratio == 1) {

                Starling.juggler.tween(startup.loadingBitmap, 2.0, {
                    transition: Transitions.EASE_OUT,
                        delay: 1.0,
                        alpha: 0,
                        onComplete: function() {
                        startup.removeChild(startup.loadingBitmap);
                        ninja = new Image(Root.assets.getTexture("ninja"));
                        ninja.x = 100;
                        ninja.y = 0;
                        addChild(ninja);
                        
                        // Load tilemap
						tmx = new Tilemap(Root.assets, "levelone");
						addChild(tmx);
                        
                        Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, 
                        	function(event:KeyboardEvent){
                        		trace(event.keyCode);
                        		if(event.keyCode == Keyboard.LEFT){
                        			ninja.x -= 10;
                        			}
                        		
                        		if(event.keyCode == Keyboard.RIGHT){
                        			ninja.x += 10;
                        			}
                        		if(event.keyCode == Keyboard.UP){
                        			ninja.y -= 10;
                        		}
                        		if(event.keyCode == Keyboard.DOWN){
                        			ninja.y += 10;
                        		}
                        	});
                        	
                        	ninja.addEventListener(TouchEvent.TOUCH, 
                        	function(e:TouchEvent){
                        		var touch = e.getTouch(stage, TouchPhase.BEGAN);
                        		trace("NINJA TOUCHED");
                        		
                        	});

                        Starling.juggler.tween(ninja, 1.0, {
                            transition: Transitions.EASE_OUT_BOUNCE,
                                delay: 2.0,
                                y: 250
                                });
                        stage.addEventListener(Event.ENTER_FRAME, movecam);

                    }

                });
            }

        });
        
    }
    private function movecam(event:Event){

		var ox = stage.stage.width/2;
		var oy = stage.stage.height/2;
	
		tmx.x = -(Math.min(Math.max((ninja.x), ox), tmx.width - ox) )+ (stage.stage.width/2);
		tmx.y = -(Math.min(Math.max((ninja.y), oy), tmx.height - oy))+(stage.stage.height/2);
		tmx.x = -(ninja.x - 40);
		tmx.y = -(ninja.y - 40);

}


}
