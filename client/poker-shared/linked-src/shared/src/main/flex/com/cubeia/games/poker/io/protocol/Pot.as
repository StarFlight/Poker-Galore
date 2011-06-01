// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.games.poker.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public class Pot implements ProtocolObject {
        public static const CLASSID:int = 18;

        public function classId():int {
            return Pot.CLASSID;
        }

        public var id:int;
        public var type:uint;
        public var amount:int;

        public function save():ByteArray
        {
            var buffer:ByteArray = new ByteArray();
            var ps:PacketOutputStream = new PacketOutputStream(buffer);
            ps.saveByte(id);
            ps.saveUnsignedByte(type);
            ps.saveInt(amount);
            return buffer;
        }

        public function load(buffer:ByteArray):void 
        {
            var ps:PacketInputStream = new PacketInputStream(buffer);
            id = ps.loadByte();
            type = PotTypeEnum.makePotTypeEnum(ps.loadUnsignedByte());
            amount = ps.loadInt();
        }
        

        public function toString():String
        {
            var result:String = "Pot :";
            result += " id["+id+"]" ;
            result += " type["+type+"]" ;
            result += " amount["+amount+"]" ;
            return result;
        }

    }
}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

