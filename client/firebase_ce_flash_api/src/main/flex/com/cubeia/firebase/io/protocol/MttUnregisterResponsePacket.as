// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public class MttUnregisterResponsePacket implements ProtocolObject {
        public static const CLASSID:int = 208;

        public function classId():int {
            return MttUnregisterResponsePacket.CLASSID;
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
            var result:String = "MttUnregisterResponsePacket :";
            result += " mttid["+mttid+"]" ;
            result += " status["+status+"]" ;
            return result;
        }

    }
}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

