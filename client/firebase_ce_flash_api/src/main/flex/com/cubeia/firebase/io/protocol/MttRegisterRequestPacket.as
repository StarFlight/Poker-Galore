// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public class MttRegisterRequestPacket implements ProtocolObject {
        public static const CLASSID:int = 205;

        public function classId():int {
            return MttRegisterRequestPacket.CLASSID;
        }

        public var mttid:int;
        public var params:Array = new Array();

        public function save():ByteArray
        {
            var buffer:ByteArray = new ByteArray();
            var ps:PacketOutputStream = new PacketOutputStream(buffer);
            ps.saveInt(mttid);
            ps.saveInt(params.length);
            var i:int;
            for( i = 0; i != params.length; i ++)
            {
                var _tmp_params:ByteArray? = params[i].save();
                ps.saveArray(_tmp_params);
            }
            return buffer;
        }

        public function load(buffer:ByteArray):void 
        {
            var ps:PacketInputStream = new PacketInputStream(buffer);
            mttid = ps.loadInt();
            var i:int;
            var paramsCount:int = ps.loadInt();
            params = new Array();
            for( i = 0; i < paramsCount; i ++) {
                var _tmp1:Param  = new Param();
                _tmp1.load(buffer);
                params[i] = _tmp1;
            }
        }
        

        public function toString():String
        {
            var result:String = "MttRegisterRequestPacket :";
            result += " mttid["+mttid+"]" ;
            result += " params["+params+"]" ;
            return result;
        }

    }
}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

