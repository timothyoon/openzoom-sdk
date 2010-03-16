package org.openzoom.flex.events
{
	import flash.events.Event;

	public class SceneProxyChangeEvent extends Event
	{
		public static const SCENE_PROXY_PROPERTY_CHANGE:String= "sceneProxyPropertyChange";
		
		private var _oldX:Number;
		private var _oldY:Number;
		private var _oldWidth:Number;
		private var _oldHeight:Number;
		
		private var _newX:Number;
		private var _newY:Number;
		private var _newWidth:Number;
		private var _newHeight:Number;
		
		public function SceneProxyChangeEvent(x:Number, y:Number, width:Number, height:Number)
		{
			super(SCENE_PROXY_PROPERTY_CHANGE);
			oldX = newX = x;
			oldY = newY = y;
			oldWidth = newWidth = width;
			oldHeight = newHeight = height;
		}
		
		public function set oldX(value:Number):void
		{
			_oldX = value;
		}
		
		public function get oldX():Number
		{
			return _oldX;
		}
		
		public function set oldY(value:Number):void
		{
			_oldY = value;
		}
		
		public function get oldY():Number
		{
			return _oldY;
		} 
		
		public function set oldWidth(value:Number):void
		{
			_oldWidth = value;
		}
		
		public function get oldWidth():Number
		{
			return _oldWidth;
		}
		
		public function set oldHeight(value:Number):void
		{
			_oldHeight = value;
		}
		
		public function get oldHeight():Number
		{
			return _oldHeight;
		}
		
		public function set newX(value:Number):void
		{
			_newX = value;
		}
		
		public function get newX():Number
		{
			return _newX;
		}
		
		public function set newY(value:Number):void
		{
			_newY = value;
		}
		
		public function get newY():Number
		{
			return _newY;
		}
		
		public function set newWidth(value:Number):void
		{
			_newWidth = value;
		}
		
		public function get newWidth():Number
		{
			return _newWidth;
		}
		
		public function set newHeight(value:Number):void
		{
			_newHeight = value;
		}
		
		public function get newHeight():Number
		{
			return _newHeight;
		}
		
		override public function toString():String
		{
			var buff:String = super.toString() + "\n";
			buff += "x: " + oldX + "|" + newX + "\n";
			buff += "y: " + oldY + "|" + newY + "\n";
			buff += "width: " + oldWidth + "|" + newWidth + "\n";
			buff += "height: " + oldHeight + "|" + newHeight;
			return buff;
		}
	}
}