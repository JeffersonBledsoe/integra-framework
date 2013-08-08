 /* libIntegra multimedia module interface
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


#ifndef INTEGRA_CONTROLPOINT_LOGIC_PRIVATE
#define INTEGRA_CONTROLPOINT_LOGIC_PRIVATE

#include "logic.h"


namespace ntg_internal
{
	class CControlPointLogic : public CLogic
	{
		public:
			CControlPointLogic( const CNode &node );
			~CControlPointLogic();

			void handle_new( CServer &server, ntg_command_source source );
			void handle_set( CServer &server, const CNodeEndpoint &node_endpoint, const ntg_api::CValue *previous_value, ntg_command_source source );
			void handle_rename( CServer &server, const ntg_api::string &previous_name, ntg_command_source source );
			void handle_move( CServer &server, const ntg_api::CPath &previous_path, ntg_command_source source );
			void handle_delete( CServer &server, ntg_command_source source );
	};
}



#endif /*INTEGRA_NEW_COMMAND_PRIVATE*/