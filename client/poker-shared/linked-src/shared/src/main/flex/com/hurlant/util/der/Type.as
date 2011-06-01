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
	public class Type
	{
		public static const CERTIFICATE:Array = [
			{name:"tbsCertificate", value:[
				{name:"tag0", value:[
					{name:"version"}
				]},
				{name:"serialNumber"},
				{name:"signature"},
				{name:"issuer", value:[
					{name:"type"},
					{name:"value"}
				]},
				{name:"validity", value:[
					{name:"notBefore"},
					{name:"notAfter"}
				]},
				{name:"subject"},
				{name:"subjectPublicKeyInfo", value:[
					{name:"algorithm"},
					{name:"subjectPublicKey"}
				]},
				{name:"issuerUniqueID"},
				{name:"subjectUniqueID"},
				{name:"extensions"}
			]},
			{name:"signatureAlgorithm"},
			{name:"signatureValue"}
		];
		public static const RSA_PUBLIC_KEY:Array = [
			{name:"modulus"},
			{name:"publicExponent"}
		];
		
		
	}
}