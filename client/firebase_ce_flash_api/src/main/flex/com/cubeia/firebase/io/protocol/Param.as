// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public class Param implements ProtocolObject {
        public static const CLASSID:int = 5;

        public function classId():int {
            return Param.CLASSID;
        }

        public var key:String;
        public var type:int;
        public var value:ByteArray = new ByteArray();

        public function save():ByteArray
        {
            var buffer:ByteArray = new ByteArray();
            var ps:PacketOutputStream = new PacketOutputStream(buffer);
            ps.saveString(key);
            ps.saveByte(type);
            ps.saveInt(value.length);
            ps.saveArray(value);
            return buffer;
        }

        public function load(buffer:ByteArray):void 
        {
            var ps:PacketInputStream = new PacketInputStream(buffer);
            key = ps.loadString();
            type = ps.loadByte();
            var valueCount:int = ps.loadInt();
            value = ps.loadByteArray(valueCount);
        }
        

        public function toString():String
        {
            var result:String = "Param :";
            result += " key["+key+"]" ;
            result += " type["+type+"]" ;
            result += " value["+value+"]" ;
            return result;
        }

    }
}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

