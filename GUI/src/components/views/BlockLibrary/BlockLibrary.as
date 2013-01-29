/* Integra Live graphical user interface
 *
 * Copyright (C) 2009 Birmingham City University
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA   02110-1301,
 * USA.
 */


package components.views.BlockLibrary
{
	import components.model.Block;
	import components.model.userData.ColorScheme;
	import components.utils.Utilities;
	import components.utils.LibraryRenderer;
	import components.views.IntegraView;
	
	import flash.filesystem.File;
	
	import flexunit.framework.Assert;
	
	import mx.controls.List;
	import mx.core.ClassFactory;
	import mx.core.DragSource;
	import mx.core.IFlexDisplayObject;
	import mx.core.ScrollPolicy;
	import mx.core.UIComponent;
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	import mx.utils.ObjectProxy;


	public class BlockLibrary extends IntegraView
	{
		public function BlockLibrary()
		{
			horizontalScrollPolicy = ScrollPolicy.OFF;
			verticalScrollPolicy = ScrollPolicy.OFF;
			
			width = 200;
			minWidth = 100;
			maxWidth = 400;
			 
			_blockList = new List;
			_blockList.opaqueBackground = null;
			_blockList.percentWidth = 100;
			_blockList.percentHeight = 100;
			_blockList.dragEnabled = true;
			_blockList.dragMoveEnabled = false;
			_blockList.setStyle( "backgroundAlpha", 0 );
			_blockList.setStyle( "borderStyle", "none" );			
			_blockList.itemRenderer = new ClassFactory( LibraryRenderer );
			_blockList.addEventListener( DragEvent.DRAG_START, onDragStart );

			addElement( _blockList );
			
			contextMenuDataProvider = contextMenuData;
		}


		override public function get title():String { return "Block Library"; }

		override public function get isSidebarColours():Boolean { return true; }

		override public function styleChanged( style:String ):void
		{
			if( !style || style == ColorScheme.STYLENAME )
			{
				switch( getStyle( ColorScheme.STYLENAME ) )
				{
					default:
					case ColorScheme.LIGHT:
						_blockList.setStyle( "rollOverColor", 0xd0d0d0 );
						_blockList.setStyle( "selectionColor", 0xb0b0b0 );
						_blockList.setStyle( "color", 0x808080 );
						break;
						
					case ColorScheme.DARK:
						_blockList.setStyle( "rollOverColor", 0x303030 );
						_blockList.setStyle( "selectionColor", 0x505050 );
						_blockList.setStyle( "color", 0x808080 );
						break;
				}
			}			
		}


		override protected function onAllDataChanged():void
		{
			var listData:Array = new Array;
			
			var systemBlockLibraryDirectory:File = new File( Utilities.getSystemBlockLibraryDirectory() );
			if( systemBlockLibraryDirectory.exists )
			{
				addBlockLibraryDirectory( listData, systemBlockLibraryDirectory.getDirectoryListing(), false );
			}

			var userBlockLibraryDirectory:File = new File( Utilities.getUserBlockLibraryDirectory() );
			if( userBlockLibraryDirectory.exists )
			{
				addBlockLibraryDirectory( listData, userBlockLibraryDirectory.getDirectoryListing(), true );
			}
			
			_blockList.dataProvider = listData;
		}
		
		
		private function addBlockLibraryDirectory( listData:Array, directoryListing:Array, isUserDirectory:Boolean ):void
		{
			for each( var file:File in directoryListing )
			{
				if( file.isDirectory )
				{
					continue;
				}
				
				listData.push( new ObjectProxy( new BlockLibraryListEntry( file, isUserDirectory ) ) );
			}
		}

		
		private function onDragStart( event:DragEvent ):void
		{
			var objectProxy:ObjectProxy = _blockList.selectedItem as ObjectProxy;
			Assert.assertNotNull( objectProxy );
			
			var item:BlockLibraryListEntry = objectProxy.valueOf() as BlockLibraryListEntry;
			Assert.assertNotNull( item );
			 
			var draggedFile:File = item.file;
			Assert.assertTrue( draggedFile.exists );
			
			var dragSource:DragSource = new DragSource();
			dragSource.addData( draggedFile, Utilities.getClassNameFromClass( File ) );
			
			DragManager.doDrag( _blockList, dragSource, event, getDragImage(), 0, ( _blockList.selectedIndex - _blockList.verticalScrollPosition ) * _blockList.rowHeight );
		}
		
		
		private function getDragImage():IFlexDisplayObject
		{
			var dragImage:UIComponent = new UIComponent;
			//dragImage.width = _moduleList.width;
			//dragImage.height = _moduleList.rowHeight;
			//dragImage.graphics.beginFill( 0xffffff, 0.4 );
			//dragImage.graphics.drawRect( 0, 0, dragImage.width, dragImage.height );
			//dragImage.graphics.endFill();
			
			return dragImage;
		}
		
		
		private function onUpdateRemove( menuItem:Object ):void
		{
			selectItemUnderMouse();
			
			if( !_blockList.selectedItem )
			{
				menuItem.enabled = false;
				return;
			}

			var objectProxy:ObjectProxy = _blockList.selectedItem as ObjectProxy;
			Assert.assertNotNull( objectProxy );
			
			var item:BlockLibraryListEntry = objectProxy.valueOf() as BlockLibraryListEntry;
			Assert.assertNotNull( item );
			
			menuItem.enabled = item.isUserItem;
		}
		
		
		private function remove():void
		{
			var objectProxy:ObjectProxy = _blockList.selectedItem as ObjectProxy;
			Assert.assertNotNull( objectProxy );
			
			var item:BlockLibraryListEntry = objectProxy.valueOf() as BlockLibraryListEntry;
			Assert.assertNotNull( item );
			Assert.assertTrue( item.isUserItem );
			
			var file:File = item.file;
			Assert.assertNotNull( file );
			Assert.assertTrue( file.exists );
			
			file.deleteFile();
			
			onAllDataChanged();
		}
		
		
		private function selectItemUnderMouse():void
		{
			var index:int = ( _blockList.mouseY + _blockList.verticalScrollPosition ) / _blockList.rowHeight;
			if( index < _blockList.dataProvider.length )
			{
				_blockList.selectedIndex = index;
			} 
		}

				
		private var _blockList:List;

		[Bindable] 
        private var contextMenuData:Array = 
        [
            { label: "Remove from Block Library", handler: remove, updater: onUpdateRemove } 
        ];
	}
}

