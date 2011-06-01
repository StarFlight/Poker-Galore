// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.firebase.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public class CreateTableRequestPacket implements ProtocolObject {
        public static const CLASSID:int = 40;

        public function classId():int {
            return CreateTableRequestPacket.CLASSID;
        }

        public var seq:int;
        public var gameid:int;
        public var seats:int;
        public var params:Array = new Array();
        public var invitees:Array = new Array();

        public function save():ByteArray
        {
            var buffer:ByteArray = new ByteArray();
            var ps:PacketOutputStream = new PacketOutputStream(buffer);
            ps.saveInt(seq);
            ps.saveInt(gameid);
            ps.saveByte(seats);
            ps.saveInt(params.length);
            var i:int;
            for( i = 0; i != params.length; i ++)
            {
                var _tmp_params:ByteArray? = params[i].save();
                ps.saveArray(_tmp_params);
            }
            ps.saveInt(invitees.length);
            for( i = 0; i != invitees.length; i ++)
            {
                ps.saveInt(invitees[i]);
            }
            return buffer;
        }

        public function load(buffer:ByteArray):void 
        {
            var ps:PacketInputStream = new PacketInputStream(buffer);
            seq = ps.loadInt();
            gameid = ps.loadInt();
            seats = ps.loadByte();
            var i:int;
            var paramsCount:int = ps.loadInt();
            params = new Array();
            for( i = 0; i < paramsCount; i ++) {
                var _tmp1:Param  = new Param();
                _tmp1.load(buffer);
                params[i] = _tmp1;
            }
            var inviteesCount:int = ps.loadInt();
            invitees = new Array();
            for (i = 0; i < inviteesCount; i ++)
            {
                invitees[i] = ps.loadInt();
            }
        }
        

        public function toString():String
        {
            var result:String = "CreateTableRequestPacket :";
            result += " seq["+seq+"]" ;
            result += " gameid["+gameid+"]" ;
            result += " seats["+seats+"]" ;
            result += " params["+params+"]" ;
            result += " invitees["+invitees+"]" ;
            return result;
        }

    }
}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

