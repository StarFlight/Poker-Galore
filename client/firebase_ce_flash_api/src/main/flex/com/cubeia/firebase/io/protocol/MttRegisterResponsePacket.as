// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public class MttRegisterResponsePacket implements ProtocolObject {
        public static const CLASSID:int = 206;

        public function classId():int {
            return MttRegisterResponsePacket.CLASSID;
        }

        public var mttid:int;
        public var status:uint;

        public function save():ByteArray
        {
            var buffer:ByteArray = new ByteArray();
            var ps:PacketOutputStream = new PacketOutputStream(buffer);
            ps.saveInt(mttid);
            ps.saveUnsignedByte(status);
            return buffer;
        }

        public function load(buffer:ByteArray):void 
        {
            var ps:PacketInputStream = new PacketInputStream(buffer);
            mttid = ps.loadInt();
            status = TournamentRegisterResponseStatusEnum.makeTournamentRegisterResponseStatusEnum(ps.loadUnsignedByte());
        }
        

        public function toString():String
        {
            var result:String = "MttRegisterResponsePacket :";
            result += " mttid["+mttid+"]" ;
            result += " status["+status+"]" ;
            return result;
        }

    }
}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

