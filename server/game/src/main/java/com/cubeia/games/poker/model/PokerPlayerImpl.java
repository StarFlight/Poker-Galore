/**
 * Copyright (C) 2010 Cubeia Ltd <info@cubeia.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

package com.cubeia.games.poker.model;

import java.io.Serializable;
import java.util.ArrayList;

import com.cubeia.firebase.api.game.player.GenericPlayer;
import com.cubeia.games.poker.PokerTableListener;
import com.cubeia.poker.player.DefaultPokerPlayer;
import org.apache.log4j.Logger;
/**
 * Models a player that is active in the game.
 * 
 * Part of replicated game state
 *
 * @author Fredrik Johansson, Cubeia Ltd
 */
public class PokerPlayerImpl extends DefaultPokerPlayer implements Serializable {

	private static transient Logger log = Logger.getLogger(PokerPlayerImpl.class);
	
	private static final long serialVersionUID = 1L;

	private GenericPlayer placeholder;

	private Long sessionId;

	
//	private static int counter = 0 ;
	private static String[] pics = {"http://stripgamepoker.info/img/hmax/78.jpg",
	                				"http://stripgamepoker.info/img/vmidi/20.jpg",
	                				"http://www.kadra.pl/luba/dane/pliki/bank_zdj/poker9.jpg",
	                				"http://pokerworks.com/gallery/Image/fulltilt/play-now.jpg",
	                				"http://www.crystal-lonnquist.com/FWThumbnails/wild%20poker%20avatar.jpg",
	                				"http://www.pokerblueprint.com/images/poker-graphic.jpg",
	                				"http://www.kadra.pl/luba/dane/pliki/bank_zdj/poker9.jpg",
	                				"http://avatar.hq-picture.com/avatars/img16/poker_girl_avatar_picture_76435.gif",
	                				"http://img2.cardschat.com/customavatars/avatar62674_11.gif"
	};
	
	
	public PokerPlayerImpl (GenericPlayer placeholder, String avatarUrl ) { //int counter
		super(placeholder.getPlayerId(),(avatarUrl.equals("")?pics[0]:avatarUrl));
		this.placeholder = placeholder;
		log.debug("Retrieving avatar and use as " + avatarUrl + " for player # " + placeholder.getPlayerId()); // pics[counter]
	}

	@Override
	public int getSeatId() {
		return placeholder.getSeatId();
	}
	
	/**
	 * Sets a session id for this player. 
	 * @param sessionId the session id, or null to leave the session
	 */
	public void setSessionId(Long sessionId) {
		this.sessionId = sessionId;
	}	

	/**
	 * Returns the session id for this player.
	 * @return the session id, null if not in a session
	 */
	public Long getSessionId() {
		return sessionId;
	}
	
	@Override
	public String toString() {
		return String.format("<playerId[%d] seatId[%d] hasFolded[%b] hasActed[%b] isSittingOut[%b]>", playerId, seatId, hasFolded, hasActed, isSittingOut);
	}
}
