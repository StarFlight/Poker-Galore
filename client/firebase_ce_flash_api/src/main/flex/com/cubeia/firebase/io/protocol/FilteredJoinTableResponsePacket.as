// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public class FilteredJoinTableResponsePacket implements ProtocolObject {
        public static const CLASSID:int = 171;

        public function classId():int {
            return FilteredJoinTableResponsePacket.CLASSID;
        }

        public var seq:int;
        public var gameid:int;
        public var address:String;
        public var status:uint;

        public function save():ByteArray
        {
            var buffer:ByteArray = new ByteArray();
            var ps:PacketOutputStream = new PacketOutputStream(buffer);
            ps.saveInt(seq);
            ps.saveInt(gameid);
            ps.saveString(address);
            ps.saveUnsignedByte(status);
            return buffer;
        }

        public function load(buffer:ByteArray):void 
        {
            var ps:PacketInputStream = new PacketInputStream(buffer);
            seq = ps.loadInt();
            gameid = ps.loadInt();
            address = ps.loadString();
            status = FilteredJoinResponseStatusEnum.makeFilteredJoinResponseStatusEnum(ps.loadUnsignedByte());
        }
        

        public function toString():String
        {
            var result:String = "FilteredJoinTableResponsePacket :";
            result += " seq["+seq+"]" ;
            result += " gameid["+gameid+"]" ;
            result += " address["+address+"]" ;
            result += " status["+status+"]" ;
            return result;
        }

    }
}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

