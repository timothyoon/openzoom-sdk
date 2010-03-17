////////////////////////////////////////////////////////////////////////////////
//
//  OpenZoom SDK
//
//  Version: MPL 1.1/GPL 3/LGPL 3
//
//  The contents of this file are subject to the Mozilla Public License Version
//  1.1 (the "License"); you may not use this file except in compliance with
//  the License. You may obtain a copy of the License at
//  http://www.mozilla.org/MPL/
//
//  Software distributed under the License is distributed on an "AS IS" basis,
//  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
//  for the specific language governing rights and limitations under the
//  License.
//
//  The Original Code is the OpenZoom SDK.
//
//  The Initial Developer of the Original Code is Daniel Gasienica.
//  Portions created by the Initial Developer are Copyright (c) 2007-2009
//  the Initial Developer. All Rights Reserved.
//
//  Contributor(s):
//    Timothy Oon <timothyoon@gmail.com>
//
//  Alternatively, the contents of this file may be used under the terms of
//  either the GNU General Public License Version 3 or later (the "GPL"), or
//  the GNU Lesser General Public License Version 3 or later (the "LGPL"),
//  in which case the provisions of the GPL or the LGPL are applicable instead
//  of those above. If you wish to allow use of your version of this file only
//  under the terms of either the GPL or the LGPL, and not to allow others to
//  use your version of this file under the terms of the MPL, indicate your
//  decision by deleting the provisions above and replace them with the notice
//  and other provisions required by the GPL or the LGPL. If you do not delete
//  the provisions above, a recipient may use your version of this file under
//  the terms of any one of the MPL, the GPL or the LGPL.
//
////////////////////////////////////////////////////////////////////////////////
package org.openzoom.flex.scene
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import mx.core.UIComponent;
	
	import org.openzoom.flash.scene.IMultiScaleScene;
	import org.openzoom.flash.scene.IReadonlyMultiScaleScene;
	import org.openzoom.flash.utils.IDisposable;
	import org.openzoom.flex.events.SceneProxyChangeEvent;

	public class UIMultiScaleScene extends UIComponent implements IMultiScaleScene, IReadonlyMultiScaleScene
	{
///******************************************************************
// Private Members
//*******************************************************************
		private var _sceneProxy:SceneProxy;
		private var _sceneContainer:UIComponent;

///******************************************************************
// Constructor
//*******************************************************************
		public function UIMultiScaleScene(w:Number,
                                    h:Number,
                                    backgroundColor:uint=0x000000,
                                    backgroundAlpha:Number=1)
		{
			super();
			
			// Setup the scene's target coordinate space sprite.
			createSceneProxy(w, h, backgroundColor, backgroundAlpha);
			
			// Create the UIComponent that will hold any children.
			_sceneContainer = new UIComponent();
			_sceneContainer.x = 0;
			_sceneContainer.y = 0;
			
			sceneWidth = w;
			sceneHeight = h;
		}

///******************************************************************
// Private Methods
//*******************************************************************
		/**
		 * Creates the SceneProxy. 
		 * @param w the width of the proxy.
		 * @param h the height of the proxy
		 * @param colour
		 * @param alpha
		 * 
		 */		
		private function createSceneProxy(w:Number, h:Number, colour:uint, alpha:Number):void
		{
			_sceneProxy = new SceneProxy();
			_sceneProxy.x = 0;
			_sceneProxy.y = 0;
			_sceneProxy.width = w;
			_sceneProxy.height = h;
			_sceneProxy.addEventListener(SceneProxyChangeEvent.SCENE_PROXY_PROPERTY_CHANGE, sceneProxyChange);
		}
		
		/**
		 * Handles any transforms applied to the SceneProxy and applies the
		 * exquuvalent transform to the sceneContainer 
		 * @param evt
		 * 
		 */		
		private function sceneProxyChange(evt:SceneProxyChangeEvent):void
		{
			_sceneContainer.x = evt.x;
			_sceneContainer.y = evt.y;
			if (evt.width != 0)
				_sceneContainer.scaleX = evt.width / sceneWidth;
			
			if (evt.height != 0)
				_sceneContainer.scaleY = evt.height / sceneHeight;
		}

///******************************************************************
// Public Methods
//*******************************************************************
		/**
		 * Cleanup method 
		 * 
		 */		
		public function dispose():void
		{
			var child:DisplayObject;
			while (_sceneContainer && _sceneContainer.numChildren > 0)
			{
				child = _sceneContainer.removeChildAt(0);
				if (child is IDisposable)
					IDisposable(child).dispose();
			}
			
			while (super.numChildren > 0)
			{
				super.removeChildAt(0);
				if (child is IDisposable)
					IDisposable(child).dispose();
			}
			
			_sceneProxy.removeEventListener(SceneProxyChangeEvent.SCENE_PROXY_PROPERTY_CHANGE, sceneProxyChange);
			
			_sceneContainer = null;
			_sceneProxy = null;
		}

///******************************************************************
// Getters & Setters
//*******************************************************************
		public function get sceneWidth():Number
		{
			return width;
		}
		
		public function set sceneWidth(value:Number):void
		{
			_sceneContainer.width = width = value;
		}
		
		public function get sceneHeight():Number
		{
			return height;
		}
		
		public function set sceneHeight(value:Number):void
		{
			_sceneContainer.height = height = value;
		}
		
		public function get targetCoordinateSpace():DisplayObject
		{
			return _sceneProxy;
		}
		
		public function get sceneContainer():DisplayObjectContainer
		{
			return _sceneContainer;
		}

///******************************************************************
// Override Methods
//*******************************************************************
		override protected function createChildren():void
		{
			super.createChildren();
			super.addChild(_sceneProxy);
			super.addChild(_sceneContainer);
		}
		
		override public function get numChildren():int
		{
			return _sceneContainer.numChildren;
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			return addChildAt(child, numChildren);
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			return _sceneContainer.addChildAt(child, index);
		}
		
		override public function getChildAt(index:int):DisplayObject
		{
			return _sceneContainer.getChildAt(index);
		}
		
		override public function getChildByName(name:String):DisplayObject
		{
			return _sceneContainer.getChildByName(name);
		}
		
		override public function getChildIndex(child:DisplayObject):int
		{
			return _sceneContainer.getChildIndex(child);
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			return _sceneContainer.removeChild(child);
		}
		
		override public function removeChildAt(index:int):DisplayObject
		{
			return _sceneContainer.removeChildAt(index);
		}
		
		override public function setChildIndex(child:DisplayObject, index:int):void
		{
			_sceneContainer.setChildIndex(child, index);
		}
		
		override public function swapChildren(child1:DisplayObject, child2:DisplayObject):void
		{
			_sceneContainer.swapChildren(child1, child2);
		}
		
		override public function swapChildrenAt(index1:int, index2:int):void
		{
			_sceneContainer.swapChildrenAt(index1, index2);
		}
	}
}