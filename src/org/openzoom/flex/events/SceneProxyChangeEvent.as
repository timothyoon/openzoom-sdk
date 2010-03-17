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
package org.openzoom.flex.events
{
	import flash.events.Event;

	public class SceneProxyChangeEvent extends Event
	{
///******************************************************************
// Constants
//*******************************************************************
		public static const SCENE_PROXY_PROPERTY_CHANGE:String= "sceneProxyPropertyChange";

///******************************************************************
// Private Members
//*******************************************************************
		private var _x:Number;
		private var _y:Number;
		private var _width:Number;
		private var _height:Number;

///******************************************************************
// Constructor
//*******************************************************************
		public function SceneProxyChangeEvent(x:Number, y:Number, width:Number, height:Number)
		{
			super(SCENE_PROXY_PROPERTY_CHANGE);
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
		}

///******************************************************************
// Getters & Setters
//*******************************************************************
		public function set x(value:Number):void
		{
			_x = value;
		}
		
		public function get x():Number
		{
			return _x;
		}
		
		public function set y(value:Number):void
		{
			_y = value;
		}
		
		public function get y():Number
		{
			return _y;
		} 
		
		public function set width(value:Number):void
		{
			_width = value;
		}
		
		public function get width():Number
		{
			return _width;
		}
		
		public function set height(value:Number):void
		{
			_height = value;
		}
		
		public function get height():Number
		{
			return _height;
		}

///******************************************************************
// Override Methods
//*******************************************************************
		override public function clone():Event
		{
			return new SceneProxyChangeEvent(x, y, width, height)
		}
		
		override public function toString():String
		{
			var buff:String = super.toString()
				+ "x: " + x + "y: " + y + "width: " + width + "height: " + height;
			return buff;
		}
	}
}