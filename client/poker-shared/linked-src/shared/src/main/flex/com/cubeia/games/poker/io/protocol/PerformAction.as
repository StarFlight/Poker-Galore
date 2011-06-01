// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.games.poker.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

    public class PerformAction implements ProtocolObject {
        public static const CLASSID:int = 15;

        public function classId():int {
            return PerformAction.CLASSID;
        }

        public var seq:int;
        public var player:int;
        public var action:PlayerAction;
        public var betAmount:int;
        public var raiseAmount:int;
        public var stackAmount:int;
        public var timeout:Boolean;
        public var balance:int;

        public function save():ByteArray
        {
            var buffer:ByteArray = new ByteArray();
            var ps:PacketOutputStream = new PacketOutputStream(buffer);
            ps.saveInt(seq);
            ps.saveInt(player);
            ps.saveArray(action.save());
            ps.saveInt(betAmount);
            ps.saveInt(raiseAmount);
            ps.saveInt(stackAmount);
            ps.saveBoolean(timeout);
            ps.saveInt(balance);
            return buffer;
        }

        public function load(buffer:ByteArray):void 
        {
            var ps:PacketInputStream = new PacketInputStream(buffer);
            seq = ps.loadInt();
            player = ps.loadInt();
            action = new PlayerAction();
            action.load(buffer);
            betAmount = ps.loadInt();
            raiseAmount = ps.loadInt();
            stackAmount = ps.loadInt();
            timeout = ps.loadBoolean();
            balance = ps.loadInt();
        }
        

        public function toString():String
        {
            var result:String = "PerformAction :";
            result += " seq["+seq+"]" ;
            result += " player["+player+"]" ;
            result += " action["+action+"]" ;
            result += " bet_amount["+betAmount+"]" ;
            result += " raise_amount["+raiseAmount+"]" ;
            result += " stack_amount["+stackAmount+"]" ;
            result += " timeout["+timeout+"]" ;
            result += " balance["+balance+"]" ;
            return result;
        }

    }
}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

