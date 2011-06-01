// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public class ParamFilter implements ProtocolObject {
        public static const CLASSID:int = 6;

        public function classId():int {
            return ParamFilter.CLASSID;
        }

        public var param:Param;
        public var op:int;

        public function save():ByteArray
        {
            var buffer:ByteArray = new ByteArray();
            var ps:PacketOutputStream = new PacketOutputStream(buffer);
            ps.saveArray(param.save());
            ps.saveByte(op);
            return buffer;
        }

        public function load(buffer:ByteArray):void 
        {
            var ps:PacketInputStream = new PacketInputStream(buffer);
            param = new Param();
            param.load(buffer);
            op = ps.loadByte();
        }
        

        public function toString():String
        {
            var result:String = "ParamFilter :";
            result += " param["+param+"]" ;
            result += " op["+op+"]" ;
            return result;
        }

    }
}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

