package
{
	import com.bit101.components.InputText;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.TextArea;
	import com.hurlant.util.Base64;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	
	/**
	 * Basic認証を越える方法
	 * 
	 * ＊サーバーが分かれている場合にはcrossdomain.xmlのことも忘れないこと。
	 * 
	 * 参考
	 * http://blog.nipx.jp/archives/3167
	 * http://www.flash-jp.com/modules/newbb/viewtopic.php?topic_id=605&forum=7&post_id=6065
	 * ...
	 * @author umhr
	 */
	public class Main extends Sprite 
	{
		
		private var _getLog:TextArea;
		private var _postLog:TextArea;
		private var _id:InputText;
		private var _pw:InputText;
		private var _url:InputText;
		public function Main() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			stage.scaleMode = "noScale";
			stage.align = "TL";
			
			addUI();
			
		}
		
		private function addUI():void 
		{
			_url = new InputText(this, 8, 8, "http://www.mztm.jp/wp/swf/20151118/BasicAuthenticationedDirectory/text.txt");
			_url.width = stage.stageWidth - 16;
			
			new Label(this, 8, 30, "ID:");
			_id = new InputText(this, 30, 30, "basic");
			_id.width = 150;
			new Label(this, 200, 30, "pw:");
			_pw = new InputText(this, 230, 30, "auth1234");
			_pw.width = 150;
			
			
			// GetのUI
			new PushButton(this, (stage.stageWidth >> 2) - 50, 70, "loadfile by GET", onLoadByGET);
			_getLog = new TextArea(this, 8, 100);
			_getLog.width = (stage.stageWidth >> 1) - 12;
			_getLog.height = stage.stageHeight - _getLog.y - 8;
			addChild(_getLog);
			
			// PostのUI
			new PushButton(this, (stage.stageWidth >> 2)*3 - 50, 70, "loadfile by POST", onLoadByPOST);
			_postLog = new TextArea(this, _getLog.x + _getLog.width + 8, 100);
			_postLog.width = _getLog.width;
			_postLog.height = _getLog.height;
			addChild(_postLog);
			
		}
		
		// GET
		private function onLoadByGET(e:Event):void 
		{
			// DebugPlayerでは認証されません。
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, getURLLoader_complete);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, getURLLoader_ioError);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, getURLLoader_securityError);
			
			var url:String = "http://" + _id.text + ":" + _pw.text + "@" + _url.text.split("//")[1];
			var urlRequest:URLRequest = new URLRequest(url);
			urlRequest.method = URLRequestMethod.GET;
			urlLoader.load(urlRequest);
			
			_getLog.text = url + "\n\n";
		}
		
		private function getURLLoader_securityError(e:SecurityErrorEvent):void 
		{
			_getLog.text += "\n" + e.errorID + ":" + e.type + ":" + e.text;
		}
		
		private function getURLLoader_ioError(e:IOErrorEvent):void 
		{
			trace((e.target as URLLoader).data);
			_getLog.text += "\n" + (e.target as URLLoader).data;
		}
		
		private function getURLLoader_complete(e:Event):void 
		{
			var txt:String = (e.target as URLLoader).data;
			_getLog.text += txt;
		}
		
		
		// Post
		private function onLoadByPOST(e:Event):void 
		{
			// Google ChromeでPCのローカル上で開くとセキュリティエラーが返されます。
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, postURLLoader_complete);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, postURLLoader_ioError);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, postURLLoader_securityError);
			
			var urlRequestHeader:URLRequestHeader = new URLRequestHeader("Authorization", "Basic " + Base64.encode(_id.text + ":" + _pw.text));
			
			var urlRequest:URLRequest = new URLRequest(_url.text);
			urlRequest.requestHeaders.push(urlRequestHeader);
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.data = { };
			urlLoader.load(urlRequest);
			
			_postLog.text = "";
		}
		
		private function postURLLoader_securityError(e:SecurityErrorEvent):void 
		{
			_postLog.text += "\n" + e.errorID + ":" + e.type + ":" + e.text;
		}
		
		private function postURLLoader_ioError(e:IOErrorEvent):void 
		{
			_postLog.text += "\n" + (e.target as URLLoader).data;
		}
		
		private function postURLLoader_complete(e:Event):void 
		{
			var txt:String = (e.target as URLLoader).data;
			_postLog.text += txt;
		}
	}
	
}