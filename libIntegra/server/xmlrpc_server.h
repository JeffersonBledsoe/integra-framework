/** IntegraServer - console app to expose xmlrpc interface to libIntegra
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

#ifndef NTG_XMLRPC_SERVER_PRIVATE_H
#define NTG_XMLRPC_SERVER_PRIVATE_H

#include <semaphore.h>


namespace integra_api
{
	class CIntegraSession;
}

using namespace integra_api;

class CXmlRpcServerContext
{
	public:

		CXmlRpcServerContext() { m_integra_session = NULL; m_port = 0; m_sem_initialized = NULL; m_sem_shutdown = NULL; }

		CIntegraSession *m_integra_session;
		unsigned short m_port;

		sem_t *m_sem_initialized;
		sem_t *m_sem_shutdown;
};


void *ntg_xmlrpc_server_run( void *context );
void ntg_xmlrpc_server_terminate( sem_t *sem_initialized );


#endif
