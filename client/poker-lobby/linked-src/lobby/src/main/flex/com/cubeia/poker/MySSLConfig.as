package com.cubeia.poker
{
	import com.hurlant.crypto.cert.X509CertificateCollection;
	import com.hurlant.crypto.rsa.RSAKey;
	import com.hurlant.crypto.tls.TLSConfig;
	
	import flash.utils.ByteArray;
	
	public class MySSLConfig extends TLSConfig
	{
		public function MySSLConfig(entity:uint, cipherSuites:Array=null, compressions:Array=null, certificate:ByteArray=null, privateKey:RSAKey=null, CAStore:X509CertificateCollection=null, ver:uint=0)
		{
			super(entity, cipherSuites, compressions, certificate, privateKey, CAStore, ver);
			this.ignoreCommonNameMismatch = true;
			this.promptUserForAcceptCert = true;
			this.trustAllCertificates = true;
		}
	}
}