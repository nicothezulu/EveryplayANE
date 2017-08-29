package everyplay
{
	import com.playcolorpeas.everyplay.EveryPlayANE;
	
	public class Everyplay
	{
		public static var instance:Everyplay;
		
		public var isSupported:Boolean = false;
		public var isRecording:Boolean = false;
		
		private var everyPlayANE:EveryPlayANE;
		
		public static function getInstance():Everyplay
		{
			if( instance == null ) instance = new Everyplay( new SingletonEnforcer() );
			return instance;
		}
		
		public function Everyplay( pvt:SingletonEnforcer )
		{
			try{
				if(EveryPlayANE.isSupported()){
					everyPlayANE = EveryPlayANE.instance;
					isSupported = true;
				}else{
					isSupported = false;
				}
			}catch(e:Error){
				isSupported = false;
			}
		}
		
		public function configureEveryplay(p1:String, p2:String, p3:String):void
		{
			if(!isSupported){
				return
			}
			everyPlayANE.configureEveryplay(p1, p2, p3);
		}
		
		public function setupEveryplay():void
		{
			if(!isSupported){
				return
			}
			everyPlayANE.setupEveryplay();
		}
		
		public function startRecording():void
		{
			if(!isSupported){
				return
			}
			everyPlayANE.startRecording();
			isRecording = true;
		}
		
		public function pauseRecording():void
		{
			if(!isSupported){
				return
			}
			if(isRecording){
				everyPlayANE.pauseRecording();
			}
		}
		
		public function resumeRecording():void
		{
			if(!isSupported){
				return
			}
			if(isRecording){
				everyPlayANE.resumeRecording();
			}
		}
		
		public function stopRecording():void
		{
			if(!isSupported){
				return
			}
			if(isRecording){
				everyPlayANE.stopRecording();
				isRecording = false;
			}
		}
		
		public function watchRecording():void
		{
			if(!isSupported){
				return
			}
			stopRecording();
			everyPlayANE.playLastRecord();
		}
		
		public function setReplayData(_data:Object):void
		{
			if(!isSupported){
				return
			}
			var str:String = JSON.stringify({
				playername:		'',		//_data.playername
				playerscore:	'',		//_data.playerscore
				gamemode:		''		//_data.gamemode
			});
					
					
			everyPlayANE.mergeJSONData(str);
		}
		
		public function goToEveryplayPage():void
		{
			if(!isSupported){
				return
			}
			stopRecording();
			everyPlayANE.showEveryPlay();
		}
	}
}
internal class SingletonEnforcer{}