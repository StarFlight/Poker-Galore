// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)
package com.cubeia.games.poker.io.protocol {

    import com.cubeia.firebase.io.PacketInputStream;
    import com.cubeia.firebase.io.PacketOutputStream;
    import com.cubeia.firebase.io.ProtocolObject;
  
    import flash.utils.ByteArray;

import com.cubeia.firebase.io.ObjectFactory;

public class ProtocolObjectFactory implements com.cubeia.firebase.io.ObjectFactory {
    public static function version():int {
        return 1;
    }

    public function create(classId:int):ProtocolObject {
        switch(classId) {
            case 1:
                return new PlayerAction();
            case 2:
                return new GameCard();
            case 3:
                return new BestHand();
            case 4:
                return new PlayerState();
            case 5:
                return new RequestAction();
            case 6:
                return new StartNewHand();
            case 7:
                return new DealerButton();
            case 8:
                return new DealPublicCards();
            case 9:
                return new DealPrivateCards();
            case 10:
                return new DealHiddenCards();
            case 11:
                return new ExposePrivateCards();
            case 12:
                return new HandEnd();
            case 13:
                return new StartHandHistory();
            case 14:
                return new StopHandHistory();
            case 15:
                return new PerformAction();
            case 16:
                return new TournamentOut();
            case 17:
                return new PlayerBalance();
            case 18:
                return new Pot();
            case 19:
                return new PlayerPokerStatus();
            case 20:
                return new PlayerSitinRequest();
            case 21:
                return new PlayerSitoutRequest();
        }
        return null;
    }
}
}

// I AM AUTO-GENERATED, DON'T CHECK ME INTO SUBVERSION (or else...)

