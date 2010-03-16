package org.openzoom.flex.scene
{
	import flash.display.Sprite;
	
	import org.openzoom.flex.events.SceneProxyChangeEvent;

	[Event(name="sceneProxyPropertyChange", type="org.openzoom.flex.events.SceneProxyChangeEvent")]
	public class SceneProxy extends Sprite
	{
		public function SceneProxy()
		{
			super();
		}
		
		override public function set x(value:Number):void
		{
			var sceneChange:SceneProxyChangeEvent = new SceneProxyChangeEvent(x, y, width, height);
			sceneChange.newX = super.x = value;
			dispatchEvent(sceneChange);
		}
		
		override public function set y(value:Number):void
		{
			var sceneChange:SceneProxyChangeEvent = new SceneProxyChangeEvent(x, y, width, height);
			sceneChange.newY = super.y = value;
			dispatchEvent(sceneChange);
		} 
		
		override public function set width(value:Number):void
		{
			var sceneChange:SceneProxyChangeEvent = new SceneProxyChangeEvent(x, y, width, height);
			sceneChange.newWidth = super.width = value;
			dispatchEvent(sceneChange);
		}
		
		override public function set height(value:Number):void
		{
			var sceneChange:SceneProxyChangeEvent = new SceneProxyChangeEvent(x, y, width, height);
			sceneChange.newHeight = super.height = value;
			dispatchEvent(sceneChange);
		}
	}
}