////////////////////////////////////////////////////////////////////////////////
//
//  OpenZoom
//
//  Copyright (c) 2007–2008, Daniel Gasienica <daniel@gasienica.ch>
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
package org.openzoom.flex.components
{

import flash.events.Event;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.net.URLLoader;
import flash.net.URLRequest;

import mx.core.UIComponent;

import org.openzoom.flash.descriptors.IMultiScaleImageDescriptor;
import org.openzoom.flash.descriptors.MultiScaleImageDescriptorFactory;
import org.openzoom.flash.net.LoadingQueue;
import org.openzoom.flash.renderers.MultiScaleImageRenderer;
import org.openzoom.flash.viewport.INormalizedViewport;
import org.openzoom.flash.viewport.IViewportConstraint;
import org.openzoom.flash.viewport.IViewportTransformer;

/**
 * Component for displaying a single multi-scale image. Inspired by the Microsoft
 * Silverlight Deep Zoom MultiScaleImage component. This implementation has built-in
 * support for Zoomify, Deep Zoom and OpenZoom images.
 * Basic keyboard and mouse navigation can be added by specifying viewport controllers.
 * The animation can be customized by adding a viewport transformer through the
 * <code>transformer</code> property. 
 * Zoom, visibility or custom constraints can be added through
 * the <code>constraint</code> property.
 */
public final class MultiScaleImage extends UIComponent implements IMultiScaleImage
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
   
    private static const DEFAULT_MIN_ZOOM        : Number = 0.25
    private static const DEFAULT_MAX_ZOOM        : Number = 10000
    private static const DEFAULT_MIN_SCALE       : Number = 0
    private static const DEFAULT_MAX_SCALE       : Number = 4
    
    private static const DEFAULT_SCENE_DIMENSION : Number = 16384 // 2^14
    
    private static const DEFAULT_VIEWPORT_WIDTH  : Number = 800
    private static const DEFAULT_VIEWPORT_HEIGHT : Number = 600
    
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Constructor.
     */
	public function MultiScaleImage()
	{
	}
	
	//--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    private var sourceURL : String
    private var sourceLoader : URLLoader
    
    private var image : MultiScaleImageRenderer
    
   ;[Bindable(event="containerChanged")]
    private var container : MultiScaleContainer
    
	//--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  source
    //----------------------------------
    
    private var _source : IMultiScaleImageDescriptor
    
    [Bindable(event="sourceChanged")]
    
    /**
     * Source of this image. Either a URL as String or an
     * instance of IMultiScaleImageDescriptor.
     * 
     * @see org.openzoom.flash.descriptors.IMultiScaleImageDescriptor
     */ 
    public function get source() : Object
    {
    	return _source
    }
    
    public function set source( value : Object ) : void
    {    	
    	if( _source )
    	{
    		_source = null
	        container.removeChildAt( 0 )
	        viewport.showAll( true )
    	}
    	
    	if( value is String )
    	{
    		if( sourceURL == String( value ))
                return
    		  
    		sourceURL = String( value )
    		sourceLoader = new URLLoader( new URLRequest( sourceURL ))
    		sourceLoader.addEventListener( Event.COMPLETE, sourceLoader_completeHandler )
    	}
    	
    	if( value is IMultiScaleImageDescriptor )
    	{
            _source = IMultiScaleImageDescriptor( value )
            dispatchEvent( new Event( "sourceChanged" ))
            
            addImage( _source )
    	}
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties: Scene
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  sceneWidth
    //----------------------------------
    
    /**
     * @copy org.openzoom.flash.scene.IMultiScaleScene#sceneWidth
     */ 
    public function get sceneWidth() : Number
    {
    	if( container )
            return container.scene.sceneWidth
        else
            return NaN
    }
    
    //----------------------------------
    //  sceneHeight
    //----------------------------------
    
    /**
     * @copy org.openzoom.flash.scene.IMultiScaleScene#sceneHeight
     */ 
    public function get sceneHeight() : Number
    {
    	if( container )
            return container.scene.sceneHeight
        else
            return NaN
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties: Viewport
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  viewport
    //----------------------------------
    
   ;[Bindable(event="viewportChanged")]
    
    /**
     * Viewport of this image.
     */ 
    public function get viewport() : INormalizedViewport
    {
        return container.viewport
    }
    
    //----------------------------------
    //  transformer
    //----------------------------------
    
    private var _transformer : IViewportTransformer
    private var transformerChanged : Boolean = false
    
   ;[Bindable(event="transformerChanged")]
    
    /**
     * Viewport transformer. Transformers are used to create the transitions
     * between transformations of the viewport.
     * 
     * @see org.openzoom.flash.viewport.transformers.NullTransformer
     * @see org.openzoom.flash.viewport.transformers.TweenerTransformer
     */ 
    public function get transformer() : IViewportTransformer
    {
    	return _transformer
    }
    
    public function set transformer( value : IViewportTransformer ) : void
    {
    	if( _transformer !== value )
        {
	        _transformer = value    
	        transformerChanged = true
	        invalidateProperties()
	        
	        dispatchEvent( new Event( "transformerChanged" ))
        }
    }
    
    //----------------------------------
    //  constraint
    //----------------------------------
    
    private var _constraint : IViewportConstraint
    private var constraintChanged : Boolean = false
    
   ;[Bindable(event="constraintChanged")]
    
    /**
     * Viewport transformer constraint. Constraints are used to control
     * the positions and zoom levels the viewport can reach.
     * 
     * @see org.openzoom.flash.viewport.constraints.NullConstraint 
     * @see org.openzoom.flash.viewport.constraints.VisibilityConstraint
     * @see org.openzoom.flash.viewport.constraints.ZoomConstraint
     * @see org.openzoom.flash.viewport.constraints.CompositeConstraint
     */ 
    public function get constraint() : IViewportConstraint
    {
    	return _constraint
    }
    
    public function set constraint( value : IViewportConstraint ) : void
    {
        if( _constraint !== value )
        {
            _constraint = value    
            constraintChanged = true
            invalidateProperties()
            
            dispatchEvent( new Event( "constraintChanged" ))
        }
    }
    
    //----------------------------------
    //  controllers
    //----------------------------------
    
    private var _controllers : Array /* of IViewportController */ = []
    private var controllersChanged : Boolean = false
    
   ;[Bindable(event="controllersChanged")]
    
    /**
     * Controllers of type IViewportController applied to this MultiScaleImage.
     * For example, viewport controllers are used to navigate the MultiScaleImage
     * by mouse or keyboard.
     * 
     * @see org.openzoom.flash.viewport.controllers.MouseController
     * @see org.openzoom.flash.viewport.controllers.KeyboardController
     */
    public function get controllers() : Array
    {
    	// TODO: Return copy? Encapsulation!!
    	return _controllers
    }
    
    public function set controllers( value : Array ) : void
    {
        if( _controllers !== value )
        {
            _controllers = value    
            controllersChanged = true
            invalidateProperties()
            
            dispatchEvent( new Event( "controllersChanged" ))
        }
    }
    
	//--------------------------------------------------------------------------
    //
    //  Overridden methods: UIComponent
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     */ 
    override protected function createChildren() : void
    {
    	super.createChildren()
    	
    	if( !container )
    	{
	        container = new MultiScaleContainer()
	        addChild( container )
	        
	        dispatchEvent( new Event( "containerChanged" ))
	        dispatchEvent( new Event( "viewportChanged" ))
    	}
    }
    
    /**
     * @private
     */
    override protected function updateDisplayList( unscaledWidth : Number,
                                                   unscaledHeight : Number ) : void
    {
        container.width  = unscaledWidth
        container.height = unscaledHeight
    }
    
    /**
     * @private
     */
    override protected function commitProperties() : void
    {
    	super.commitProperties()
    	
    	if( controllersChanged )
    	{
    		container.controllers = _controllers
    		controllersChanged = false
    	}
    	
    	if( transformerChanged )
    	{
    		container.transformer = _transformer
    		transformerChanged = false
    	}
        
        if( constraintChanged )
        {
            container.constraint = _constraint
            constraintChanged = false
        }
    }
    
	//--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     */
    private function createImage( descriptor : IMultiScaleImageDescriptor,
                                  loader : LoadingQueue,
                                  width : Number,
                                  height : Number ) : MultiScaleImageRenderer
    {
        var image : MultiScaleImageRenderer =
                        new MultiScaleImageRenderer( descriptor, loader, width, height )
        image.viewport = viewport
        return image
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: Controllers
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     */
    private function addImage( descriptor : IMultiScaleImageDescriptor ) : void
    {
        var aspectRatio : Number = descriptor.width / descriptor.height 
        var sceneWidth : Number
        var sceneHeight : Number
        
        if( aspectRatio > 1 )
        {
            sceneWidth = DEFAULT_SCENE_DIMENSION
            sceneHeight = DEFAULT_SCENE_DIMENSION / aspectRatio
        }
        else
        {
            sceneWidth = DEFAULT_SCENE_DIMENSION * aspectRatio
            sceneHeight = DEFAULT_SCENE_DIMENSION
        }
        
        // resize scene
        container.sceneWidth  = sceneWidth
        container.sceneHeight = sceneHeight
        
        // create renderer
        image = createImage( descriptor, container.loader, sceneWidth, sceneHeight )
        container.addChild( image )
    }
    
	//--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     */
    private function sourceLoader_completeHandler( event : Event ) : void
    {
    	if( !sourceLoader.data )
    	   return
    	
        var data : XML = new XML( sourceLoader.data )
        var factory : MultiScaleImageDescriptorFactory =
                          MultiScaleImageDescriptorFactory.getInstance()
        var descriptor : IMultiScaleImageDescriptor =
                             factory.getDescriptor( sourceURL, data )
        
        _source = descriptor
        dispatchEvent( new Event( "sourceChanged" ))
        
        addImage( descriptor )
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties: IMultiScaleImage
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  zoom
    //----------------------------------
    
   ;[Bindable(event="transformUpdate")]
    
    /**
     * @copy org.openzoom.flash.viewport.IViewport#zoom
     */
    public function get zoom() : Number
    {
        return viewport.zoom    
    }
    
    public function set zoom( value : Number ) : void
    {
        viewport.zoom = value
    }
    
    //----------------------------------
    //  scale
    //----------------------------------
    
   ;[Bindable(event="transformUpdate")]
    
    /**
     * @copy org.openzoom.flash.viewport.IViewport#scale
     */
    public function get scale() : Number
    {
        return viewport.zoom    
    }
    
    public function set scale( value : Number ) : void
    {
        viewport.scale = value
    }
    
    //----------------------------------
    //  viewportX
    //----------------------------------
    
   ;[Bindable(event="transformUpdate")]
       
    /**
     * @copy org.openzoom.flash.viewport.IViewport#x
     */

    public function get viewportX() : Number
    {
        return viewport.x    
    }
    
    public function set viewportX( value : Number ) : void
    {
        viewport.x = value
    }
    
    //----------------------------------
    //  viewportY
    //----------------------------------
    
   ;[Bindable(event="transformUpdate")]
    
    /**
     * @copy org.openzoom.flash.viewport.IViewport#y
     */
    public function get viewportY() : Number
    {
        return viewport.y
    }
    
    public function set viewportY( value : Number ) : void
    {
        viewport.y = value
    }
    
    //----------------------------------
    //  viewportWidth
    //----------------------------------
    
   ;[Bindable(event="transformUpdate")]
    
    /**
     * @copy org.openzoom.flash.viewport.IViewport#width
     */
    public function get viewportWidth() : Number
    {
        return viewport.width   
    }
    
    public function set viewportWidth( value : Number ) : void
    {
        viewport.width = value
    }
    
    //----------------------------------
    //  viewportHeight
    //----------------------------------
    
   ;[Bindable(event="transformUpdate")]
    
    /**
     * @copy org.openzoom.flash.viewport.IViewport#height
     */
    public function get viewportHeight() : Number
    {
        return viewport.height
    }
    
    public function set viewportHeight( value : Number ) : void
    {
        viewport.height = value
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods: IMultiScaleImage
    //
    //--------------------------------------------------------------------------
    
    /**
     * @copy org.openzoom.flash.viewport.IViewport#zoomTo()
     */
    public function zoomTo( zoom : Number,
                            transformX : Number = 0.5,
                            transformY : Number = 0.5,
                            immediately : Boolean = false ) : void
    {
        viewport.zoomTo( zoom, transformX, transformY, immediately )
    }

    /**
     * @copy org.openzoom.flash.viewport.IViewport#zoomBy()
     */
    public function zoomBy( factor : Number,
                            transformX : Number = 0.5,
                            transformY : Number = 0.5,
                            immediately : Boolean = false ) : void
    {
        viewport.zoomBy( factor, transformX, transformY, immediately )
    }

    /**
     * @copy org.openzoom.flash.viewport.IViewport#panTo()
     */
    public function panTo( x : Number, y : Number,
                           immediately : Boolean = false ) : void
    {
        viewport.panTo( x, y, immediately )
    }
                    
    /**
     * @copy org.openzoom.flash.viewport.IViewport#panBy()
     */
    public function panBy( deltaX : Number, deltaY : Number,
                           immediately : Boolean = false ) : void
    {
        viewport.panBy( deltaX, deltaY, immediately )
    }

    /**
     * @copy org.openzoom.flash.viewport.IViewport#showRect()
     */
    public function showRect( rect : Rectangle,
                              scale : Number = 1.0,
                              immediately : Boolean = false ) : void
    {
        viewport.showRect( rect, scale, immediately )
    }

    /**
     * @copy org.openzoom.flash.viewport.IViewport#showAll()
     */
    public function showAll( immediately : Boolean = false ) : void
    {
        viewport.showAll( immediately )
    }
                    
    /**
     * @copy org.openzoom.flash.viewport.IViewport#localToScene()
     */
    public function localToScene( point : Point ) : Point
    {
        return viewport.localToScene( point )
    }
                    
    /**
     * @copy org.openzoom.flash.viewport.IViewport#sceneToLocal()
     */
    public function sceneToLocal( point : Point ) : Point
    {
        return viewport.sceneToLocal( point )
    }
}

}