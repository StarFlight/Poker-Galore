// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public class PlayerInfoPacket implements ProtocolObject {
        public static const CLASSID:int = 13;

        public function classId():int {
            return PlayerInfoPacket.CLASSID;
        }

        public var pid:int;
        public var nick:String;
        public var details:Array = new Array();

		
        public function save():ByteArray
        {
            var buffer:ByteArray = new ByteArray();
            var ps:PacketOutputStream = new PacketOutputStream(buffer);
            ps.saveInt(pid);
            ps.saveString(nick);
            ps.saveInt(details.length);
            var i:int;
            for( i = 0; i != details.length; i ++)
            {
                var _tmp_details:ByteArray? = details[i].save();
                ps.saveArray(_tmp_details);
            }
            return buffer;
        }

        public function load(buffer:ByteArray):void 
        {
            var ps:PacketInputStream = new PacketInputStream(buffer);
            pid = ps.loadInt();
            nick = ps.loadString();
            var i:int;
            var detailsCount:int = ps.loadInt();
            details = new Array();
            for( i = 0; i < detailsCount; i ++) {
                var _tmp1:Param  = new Param();
                _tmp1.load(buffer);
                details[i] = _tmp1;
            }
        }
        

        public function toString():String
        {
            var result:String = "PlayerInfoPacket :";
            result += " pid["+pid+"]" ;
            result += " nick["+nick+"]" ;
            result += " details["+details+"]" ;
            return result;
        }

    }
}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

