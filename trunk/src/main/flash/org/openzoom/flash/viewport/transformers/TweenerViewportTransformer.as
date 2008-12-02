////////////////////////////////////////////////////////////////////////////////
//
//  OpenZoom
//
//  Copyright (c) 2008, Daniel Gasienica <daniel@gasienica.ch>
//
//  OpenZoom is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  OpenZoom is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with OpenZoom. If not, see <http://www.gnu.org/licenses/>.
//
////////////////////////////////////////////////////////////////////////////////
package org.openzoom.flash.viewport.transformers
{

import caurina.transitions.Tweener;

import org.openzoom.flash.viewport.ITransformerViewport;
import org.openzoom.flash.viewport.IViewportTransform;
import org.openzoom.flash.viewport.IViewportTransformer;
import org.openzoom.flash.viewport.ViewportTransform2;

public class TweenerViewportTransformer implements IViewportTransformer
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
    
    private static const DEFAULT_DURATION : Number = 2.0
    private static const DEFAULT_EASING : String = "easeOutExpo"
//    private static const NULL_CONSTRAINT : IViewportConstraint = new NullViewportConstraint()
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     * Constructor.
     */
    public function TweenerViewportTransformer()
    {
//    	TransformShortcuts.init()
    }
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    private var _transform : IViewportTransform
    
    //--------------------------------------------------------------------------
    //
    //  Properties: IViewportTransformer
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  viewport
    //----------------------------------
    
    private var _viewport : ITransformerViewport
    
    public function get viewport() : ITransformerViewport
    {
        return _viewport
    }
    
    public function set viewport( value : ITransformerViewport ) : void
    {
        _viewport = value
        _target    = viewport.transform
        _transform = viewport.transform
    }
    
    //----------------------------------
    //  constraint
    //----------------------------------
//    
//    private var _constraint : IViewportConstraint
//    
//    public function get constraint() : IViewportConstraint
//    {
//        return _constraint
//    }
//    
//    public function set constraint( value : IViewportConstraint ) : void
//    {
//        _constraint = value
//    }
    
    //----------------------------------
    //  target
    //----------------------------------
    
    private var _target : IViewportTransform
    
    public function get target() : IViewportTransform
    {
        return _target.clone()
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: IViewportTransformer
    //
    //--------------------------------------------------------------------------
    
    public function stop() : void
    {
//    	if( Tweener.isTweening( viewport ))
//    	{
//    	    Tweener.removeTweens( viewport )
//	        viewport.endTransform()
//    	}
    	if( Tweener.isTweening( _transform ))
    	{
    	    Tweener.removeTweens( _transform )
	        viewport.endTransform()
    	}
    }
    
    public function transform( targetTransform : IViewportTransform,
                               immediately : Boolean = false ) : void
    {
    	var duration : Number = DEFAULT_DURATION
	    _transform.copy(ViewportTransform2(viewport.transform))
        
        if( immediately )
        {
        	stop()
        	viewport.beginTransform()
        	viewport.transform = targetTransform
        	viewport.endTransform()
        }
    	else
        {
//	        if( !Tweener.isTweening( viewport ))
//	            viewport.beginTransform()

	        if( !Tweener.isTweening( _transform ))
	            viewport.beginTransform()
	        
	        _target = targetTransform.clone()
	            
	        Tweener.addTween( 
//	                          viewport,
	                          _transform,
	                          {
//	                              _transform_x: targetTransform.x,
//	                              _transform_y: targetTransform.y,
//	                              _transform_width: targetTransform.width,
//                                _transform_height: targetTransform.height,
                                  x: targetTransform.x,
                                  y: targetTransform.y,
                                  width: targetTransform.width,
                                  height: targetTransform.height,
	                              time: duration,
	                              transition: DEFAULT_EASING,
	                              onUpdate:
		                              function() : void
		                              {
	                                      viewport.transform = _transform
	                                  },
	                              onComplete: viewport.endTransform
	                          }
	                        )
        }
    }
}

}