// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public class LoginRequestPacket implements ProtocolObject {
        public static const CLASSID:int = 10;

        public function classId():int {
            return LoginRequestPacket.CLASSID;
        }

        public var user:String;
        public var password:String;
        public var operatorid:int;
        public var credentials:ByteArray = new ByteArray();

        public function save():ByteArray
        {
            var buffer:ByteArray = new ByteArray();
            var ps:PacketOutputStream = new PacketOutputStream(buffer);
            ps.saveString(user);
            ps.saveString(password);
            ps.saveInt(operatorid);
            ps.saveInt(credentials.length);
            ps.saveArray(credentials);
            return buffer;
        }

        public function load(buffer:ByteArray):void 
        {
            var ps:PacketInputStream = new PacketInputStream(buffer);
            user = ps.loadString();
            password = ps.loadString();
            operatorid = ps.loadInt();
            var credentialsCount:int = ps.loadInt();
            credentials = ps.loadByteArray(credentialsCount);
        }
        

        public function toString():String
        {
            var result:String = "LoginRequestPacket :";
            result += " user["+user+"]" ;
            result += " password["+password+"]" ;
            result += " operatorid["+operatorid+"]" ;
            result += " credentials["+credentials+"]" ;
            return result;
        }

    }
}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

