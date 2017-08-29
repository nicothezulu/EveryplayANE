package 
{
    import com.playcolorpeas.everyplay.EveryPlayANE;
    
    import flash.events.EventDispatcher;
    import flash.utils.getDefinitionByName;
    
    import everyplay.Everyplay;
    
    import starling.animation.Transitions;
    import starling.core.Starling;
    import starling.display.Image;
    import starling.events.Event;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.utils.deg2rad;
    
    import utils.MenuButton;
 
    /** The Game class represents the actual game. In this scaffold, it just displays a
     *  Starling that moves around fast. When the user touches the Starling, the game ends. */ 
    public class Game extends Scene
    {
        public static const GAME_OVER:String = "gameOver";
        
        private var _bird:Image;
		
		private var _startButton:MenuButton;
		private var _stopButton:MenuButton;
		private var _watchButton:MenuButton;
		private var _everyplayButton:MenuButton;
		private var _everyplayANE:Everyplay;
		
        public function Game()
        { 
			_everyplayANE = Everyplay.getInstance();
			if(_everyplayANE.isSupported){
				_everyplayANE.configureEveryplay(
					'',											//Client ID
					'',											//Client Secret
					'https://m.everyplay.com/auth'				//Redirect URI
				);

				_everyplayANE.setupEveryplay();
			}
		}
        override public function dispose():void{
			if(_everyplayANE.isSupported){
				_everyplayANE.stopRecording();
				var nativeAppClass:Object = getDefinitionByName("flash.desktop::NativeApplication");
				var nativeApp:EventDispatcher = nativeAppClass["nativeApplication"] as EventDispatcher;
				nativeApp.removeEventListener(flash.events.Event.ACTIVATE, nativeActivate);
				nativeApp.removeEventListener(flash.events.Event.DEACTIVATE, nativeDeActivate);
				
			}
			super.dispose();
		}
        override public function init(width:Number, height:Number):void
        {
            super.init(width, height);

            _bird = new Image(Root.assets.getTexture("starling_rocket"));
            _bird.pivotX = _bird.width / 2;
            _bird.pivotY = _bird.height / 2;
            _bird.x = width / 2;
            _bird.y = height / 2;
            _bird.addEventListener(TouchEvent.TOUCH, onBirdTouched);
            addChild(_bird);
            
			if(_everyplayANE.isSupported){
				
				var nativeAppClass:Object = getDefinitionByName("flash.desktop::NativeApplication");
				var nativeApp:EventDispatcher = nativeAppClass["nativeApplication"] as EventDispatcher;
				nativeApp.addEventListener(flash.events.Event.ACTIVATE, nativeActivate);
				nativeApp.addEventListener(flash.events.Event.DEACTIVATE, nativeDeActivate);
				
				_startButton = new MenuButton("Start Recording", 150, 40);
	            _startButton.textFormat.setTo("Ubuntu", 16);
	            _startButton.addEventListener(Event.TRIGGERED, onStartButtonTriggered);
	            addChild(_startButton);
				
				_stopButton = new MenuButton("Stop Recording", 150, 40);
	            _stopButton.textFormat.setTo("Ubuntu", 16);
	            _stopButton.addEventListener(Event.TRIGGERED, onStopButtonTriggered);
	            _stopButton.visible = false;
				addChild(_stopButton);
				
				_watchButton = new MenuButton("Watch Replay", 150, 40);
	            _watchButton.textFormat.setTo("Ubuntu", 16);
	            _watchButton.addEventListener(Event.TRIGGERED, onWatchButtonTriggered);
	            _watchButton.visible = false;
				addChild(_watchButton);
				
				_everyplayButton = new MenuButton("Everyplay Page", 150, 40);
	            _everyplayButton.textFormat.setTo("Ubuntu", 16);
	            _everyplayButton.addEventListener(Event.TRIGGERED, onEveryButtonTriggered);
	            addChild(_everyplayButton);
			}
			updatePositions();
			 
            moveBird();
			
        }
		private function nativeActivate(e:flash.events.Event):void{
			_everyplayANE.resumeRecording();
		}
		private function nativeDeActivate(e:flash.events.Event):void{
			_everyplayANE.pauseRecording();	
		}
		
		private function onStartButtonTriggered():void
        {
             _watchButton.visible = _startButton.visible = false;
             _stopButton.visible = true;
			 _everyplayANE.startRecording();
        }
		
        private function onStopButtonTriggered():void
        {
			_watchButton.visible = _startButton.visible = true;
			_stopButton.visible = false;
			_everyplayANE.stopRecording();
			/*_everyplayANE.setReplayData(
				{
					playername:		'test',
					playerscore:	100,
					gamemode:		1
				}
			);*/
        }
		
		private function onWatchButtonTriggered():void
		{
			_everyplayANE.watchRecording();
		}
		
        private function onEveryButtonTriggered():void
        {
			_everyplayANE.goToEveryplayPage();
        }
		
		override public function resizeTo(width:Number, height:Number):void
        {
            super.resizeTo(width, height);
            updatePositions();
        }
		
		private function updatePositions():void
        {
			if(_everyplayANE.isSupported){ 
				_watchButton.x = _stopButton.x = _startButton.x = 10;
	            _stopButton.y = _startButton.y = _height * 0.86 - _startButton.height;
				_watchButton.y = _stopButton.y + _stopButton.height + 10; 
				_everyplayButton.x = _width - _everyplayButton.width - 10;
	            _everyplayButton.y = _height * 0.86 - _everyplayButton.height;
			}
        }
        
		
        private function moveBird():void
        {
            var scale:Number = Math.random() * 0.8 + 0.2;
            
            Starling.juggler.tween(_bird, Math.random() * 0.5 + 0.5, {
                x: Math.random() * _width,
                y: Math.random() * _height,
                scaleX: scale,
                scaleY: scale,
                rotation: Math.random() * deg2rad(180) - deg2rad(90),
                transition: Transitions.EASE_IN_OUT,
                onComplete: moveBird
            });
        }
        
        private function onBirdTouched(event:TouchEvent):void
        {
            if (event.getTouch(_bird, TouchPhase.BEGAN))
            {
                Root.assets.playSound("click");
                Starling.juggler.removeTweens(_bird);
                dispatchEventWith(GAME_OVER, true, 100);
            }
        }
    }
}