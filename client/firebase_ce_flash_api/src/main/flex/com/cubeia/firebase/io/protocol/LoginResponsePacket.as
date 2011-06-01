// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public class LoginResponsePacket implements ProtocolObject {
        public static const CLASSID:int = 11;

        public function classId():int {
            return LoginResponsePacket.CLASSID;
        }

        public var screenname:String;
        public var pid:int;
        public var status:uint;
        public var code:int;
        public var message:String;
        public var credentials:ByteArray = new ByteArray();

        public function save():ByteArray
        {
            var buffer:ByteArray = new ByteArray();
            var ps:PacketOutputStream = new PacketOutputStream(buffer);
            ps.saveString(screenname);
            ps.saveInt(pid);
            ps.saveUnsignedByte(status);
            ps.saveInt(code);
            ps.saveString(message);
            ps.saveInt(credentials.length);
            ps.saveArray(credentials);
            return buffer;
        }

        public function load(buffer:ByteArray):void 
        {
            var ps:PacketInputStream = new PacketInputStream(buffer);
            screenname = ps.loadString();
            pid = ps.loadInt();
            status = ResponseStatusEnum.makeResponseStatusEnum(ps.loadUnsignedByte());
            code = ps.loadInt();
            message = ps.loadString();
            var credentialsCount:int = ps.loadInt();
            credentials = ps.loadByteArray(credentialsCount);
        }
        

        public function toString():String
        {
            var result:String = "LoginResponsePacket :";
            result += " screenname["+screenname+"]" ;
            result += " pid["+pid+"]" ;
            result += " status["+status+"]" ;
            result += " code["+code+"]" ;
            result += " message["+message+"]" ;
            result += " credentials["+credentials+"]" ;
            return result;
        }

    }
}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

