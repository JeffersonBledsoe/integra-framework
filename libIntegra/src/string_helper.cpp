/** libIntegra multimedia module interface
 *  
 * Copyright (C) 2007 Birmingham City University
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
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, 
 * USA.
 */


#include "platform_specifics.h"

#include "string_helper.h"
#include "trace.h"

#include <assert.h>
#ifdef _WINDOWS
#include <time.h>
#else
#include <sys/time.h>
#endif


namespace ntg_internal
{
	const string CStringHelper::node_name_character_set = "0123456789_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";


	string CStringHelper::date_to_string( const struct tm &date )
	{
		char string[ 20 ];
		sprintf( string, "%04i-%02i-%02iT%02i:%02i:%02i", date.tm_year + 1900, date.tm_mon + 1, date.tm_mday, date.tm_hour, date.tm_min, date.tm_sec );
		return string;
	}


	CError CStringHelper::string_to_date( const string &string, struct tm &output )
	{
		if( string.length() < 16 )
		{
			NTG_TRACE_ERROR << "Unexpected date/time format: " << string.c_str();
			return CError::INPUT_ERROR;
		}

		output.tm_year = atoi( string.c_str() ) - 1900;
		output.tm_mon = atoi( string.substr( 5 ).c_str() ) - 1;
		output.tm_mday = atoi( string.substr( 8 ).c_str() );
		output.tm_hour = atoi( string.substr( 11 ).c_str() );
		output.tm_min = atoi( string.substr( 14 ).c_str() );
		output.tm_sec = atoi( string.substr( 17 ).c_str() );
		output.tm_isdst = -1;
		if( mktime( &output ) == -1 )
		{
			return CError::INPUT_ERROR;
		}
		else
		{
			return CError::SUCCESS;
		}	
	}


	bool CStringHelper::validate_node_name( const string &name )
	{
		int length = name.length();

		if( length == 0 ) return false;
	
		for( int i = 0; i < length; i++ )
		{
			if( node_name_character_set.find_first_of( name[ i ] ) == string::npos )
			{
				return false;
			}
		}

		return true;	
	}
}


