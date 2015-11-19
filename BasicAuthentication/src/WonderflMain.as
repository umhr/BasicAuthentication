package
{
	import com.bit101.components.InputText;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.TextArea;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	//import com.bit101.components.Style;
	
	/**
	 * Basic認証を越える方法
	 * http://blog.nipx.jp/archives/3167
	 * 
	 * crossdomain.xmlに
	 * <allow-http-request-headers-from domain="*.wonderfl.net" headers="Authorization" />
	 * を加えたらうまくいった。
	 * 
	 * 参考
	 * http://blog.nipx.jp/archives/3167
	 * http://www.flash-jp.com/modules/newbb/viewtopic.php?topic_id=605&forum=7&post_id=6065
	 * http://www.senocular.com/pub/adobe/crossdomain/policyfiles.html
	 * 
 * @class Base64
 * @author Abdul Qabiz (http://www.abdulqabiz.com)
 * @version 1.0
 * @requires ActionScript 3.0 and Flash Player 8.5 (atleast)
 * 
 * @credits Based on Aardwulf Systems'(www.aardwulf.com) Javascript implementation.
 *               (http://www.aardwulf.com/tutor/base64/base64.html)
	 * ...
	 * @author umhr
	 */
	public class WonderflMain extends Sprite 
	{
		
		private var _getLog:TextArea;
		private var _postLog:TextArea;
		private var _id:InputText;
		private var _pw:InputText;
		private var _url:InputText;
		public function WonderflMain() 
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
			
			//Security.loadPolicyFile("http://www.mztm.jp/crossdomain.xml");
			//Security.loadPolicyFile("http://mztm.heteml.jp/crossdomain.xml");
			
			addUI();
			
		}
		
		private function addUI():void 
		{
			graphics.beginFill(0x111111);
			graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			graphics.endFill();
			
			graphics.beginFill(0x333333);
			graphics.drawRect(2, 2, stage.stageWidth - 4, 54);
			graphics.endFill();
			
			graphics.beginFill(0x333333);
			graphics.drawRect(2, 58, (stage.stageWidth >> 1)-3, stage.stageHeight-60);
			graphics.endFill();
			
			graphics.beginFill(0x333333);
			graphics.drawRect((stage.stageWidth >> 1)+1, 58, (stage.stageWidth >> 1)-3, stage.stageHeight-60);
			graphics.endFill();
			
			//Style.setStyle(Style.DARK);
			
			//_url = new InputText(this, 8, 8, "http://mztm.heteml.jp/umhr/basic/test.txt");
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
			
			//var urlRequestHeader:URLRequestHeader = new URLRequestHeader("Authorization", "Basic " + Base64.encode(_id.text + ":" + _pw.text));
			
			var url:String = "http://" + _id.text + ":" + _pw.text + "@" + _url.text.split("//")[1];
			//var url:String = _url.text;
			var urlRequest:URLRequest = new URLRequest(url);
			//urlRequest.requestHeaders.push(urlRequestHeader);
			urlRequest.method = URLRequestMethod.GET;
			//urlRequest.data = { };
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
			
			var url:String = _url.text;
			var urlRequest:URLRequest = new URLRequest(url);
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

// HTTP Authentication for HTTP/GET requests using ActionScript 3 | Abdul Qabiz on Web Technologies, Open Source, Flash/Flex, India
// http://www.abdulqabiz.com/blog/archives/2006/03/03/http-authentication-for-httpget-requests-using-actionscript-3/

/**
 * @class Base64
 * @author Abdul Qabiz (http://www.abdulqabiz.com)
 * @version 1.0
 * @requires ActionScript 3.0 and Flash Player 8.5 (atleast)
 * 
 * @credits Based on Aardwulf Systems'(www.aardwulf.com) Javascript implementation.
 *               (http://www.aardwulf.com/tutor/base64/base64.html)
 * 
**/



    class Base64
    {
         
         private static const KEY_STR:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

        //Base64:encode(..) encodes a string to a base64 string
        public static function encode(input:String):String
        {
            var output:String = "";
            var chr1:uint, chr2:uint, chr3:uint;
            var enc1:uint, enc2:uint, enc3:uint, enc4:uint;
            var i:uint = 0;
            var length:uint = input.length;
            do{
                chr1 = input.charCodeAt(i++);
                chr2 = input.charCodeAt(i++);
                chr3 = input.charCodeAt(i++);
                enc1 = chr1 >> 2;
                enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
                enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
                enc4 = chr3 & 63;
                 if (isNaN(chr2)) 
                 {
                    enc3 = enc4 = 64;
                 } 
                 else if (isNaN(chr3)) 
                {
                    enc4 = 64;
                }
                output+= KEY_STR.charAt(enc1) + KEY_STR.charAt(enc2) + KEY_STR.charAt(enc3) + KEY_STR.charAt(enc4);
            }while (i < length);
            return output;
        }


        //Base64:decode(..) decodes a base64 string
   
        public static function decode(input:String):String
        {
            var output:String = "";
            var chr1:uint, chr2:uint, chr3:uint;
            var enc1:int, enc2:int, enc3:int, enc4:int;
            var i:uint = 0;
            var length:uint = input.length;

            // remove all characters that are not A-Z, a-z, 0-9, +, /, or =
            var base64test:RegExp = /[^A-Za-z0-9\+\/\=]/g;
            if (base64test.exec(input))
            {
             throw new Error("There were invalid base64 characters in the input text.\n" +
               "Valid base64 characters are A-Z, a-z, 0-9, '+', '/', and '='\n" +
               "Expect errors in decoding.");
            }
            input = input.replace(/[^A-Za-z0-9\+\/\=]/g, "");

            do{
                enc1 = input.indexOf(input.charAt(i++));
                enc2 = input.indexOf(input.charAt(i++));
                enc3 = input.indexOf(input.charAt(i++));
                enc4 = input.indexOf(input.charAt(i++));
                
                chr1 = (enc1 << 2) | (enc2 >> 4);
                chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
                chr3 = ((enc3 & 3) << 6) | enc4;
                output+= String.fromCharCode(chr1);

                if (enc3 != 64)
                {
                    output+= String.fromCharCode(chr2);
                }
                if (enc4 != 64) 
                {
                    output+= String.fromCharCode(chr3);
                }
    
            }while(i < length);

            return output;
        }
    }
