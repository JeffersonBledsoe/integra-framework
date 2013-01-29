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


package components.model.interfaceDefinitions
{
	public class InterfaceDefinition
	{
		public function InterfaceDefinition()
		{
		}

		public function get guid():String { return _guid; }
		public function get info():InterfaceInfo { return _info; }
		public function get endpoints():Vector.<EndpointDefinition> { return _endpoints; }
		public function get widgets():Vector.<WidgetDefinition> { return _widgets; }

		
		public function set guid( guid:String ):void { _guid = guid; }
		
		public function getEndpointDefinition( endpointName:String ):EndpointDefinition
		{
			for each( var endpoint:EndpointDefinition in _endpoints )
			{
				if( endpoint.name == endpointName ) 
				{
					return endpoint;
				}
			}
			
			return null;
		}

		
		public function getWidgetDefinition( widgetLabel:String ):WidgetDefinition
		{
			for each( var widget:WidgetDefinition in _widgets )
			{
				if( widget.label == widgetLabel ) 
				{
					return widget;
				}
			}
			
			return null;
		}
		
		
		public function countAudioEndpointsByDirection( streamDirection:String ):uint
		{
			var count:uint = 0;
			
			for each( var endpoint:EndpointDefinition in _endpoints )
			{
				if( endpoint.type == EndpointDefinition.STREAM )
				{
					var streamInfo:StreamInfo = endpoint.streamInfo;
					if( streamInfo.streamType == StreamInfo.TYPE_AUDIO )
					{
						if( streamInfo.streamDirection == streamDirection )
						{
							count++;
						}
					}
				}
			}
			
			return count;
		}

		
		public function get isCore():Boolean
		{
			for each( var tag:String in info.tags )
			{
				if( tag == "core" )
				{
					return true;
				}
			}
			
			return false;
		}
		
		
		public function get hasAudioEndpoints():Boolean
		{
			return ( countAudioEndpointsByDirection( StreamInfo.DIRECTION_INPUT ) > 0 || countAudioEndpointsByDirection( StreamInfo.DIRECTION_OUTPUT ) > 0 );
		}
		
		
		private var _guid:String;
		private var _info:InterfaceInfo = new InterfaceInfo;
		private var _endpoints:Vector.<EndpointDefinition> = new Vector.<EndpointDefinition>;
		private var _widgets:Vector.<WidgetDefinition> = new Vector.<WidgetDefinition>;
	}
}
