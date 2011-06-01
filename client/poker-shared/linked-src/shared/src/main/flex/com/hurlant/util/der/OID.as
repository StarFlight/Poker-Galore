/**
 * Copyright (C) 2010 Cubeia Ltd <info@cubeia.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

package com.hurlant.util.der
{
	public class OID
	{

		public static const RSA_ENCRYPTION:String           = "1.2.840.113549.1.1.1";
		public static const MD2_WITH_RSA_ENCRYPTION:String  = "1.2.840.113549.1.1.2";
		public static const MD5_WITH_RSA_ENCRYPTION:String  = "1.2.840.113549.1.1.4";
		public static const SHA1_WITH_RSA_ENCRYPTION:String = "1.2.840.113549.1.1.5";
		public static const DSA:String = "1.2.840.10040.4.1";
		public static const DSA_WITH_SHA1:String = "1.2.840.10040.4.3";
		public static const DH_PUBLIC_NUMBER:String = "1.2.840.10046.2.1";
		
		public static const COMMON_NAME:String = "2.5.4.3";
		public static const SURNAME:String = "2.5.4.4";
		public static const COUNTRY_NAME:String = "2.5.4.6";
		public static const LOCALITY_NAME:String = "2.5.4.7";
		public static const STATE_NAME:String = "2.5.4.8";
		public static const ORGANIZATION_NAME:String = "2.5.4.10";
		public static const ORG_UNIT_NAME:String = "2.5.4.11";
		public static const TITLE:String = "2.5.4.12";

	}
}