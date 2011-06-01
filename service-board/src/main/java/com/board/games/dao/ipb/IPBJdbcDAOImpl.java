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
package com.board.games.dao.ipb;



import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.ini4j.Ini;

import com.board.games.dao.GenericDAO;
import com.board.games.model.PlayerBalance;
import com.board.games.model.PlayerProfile;


public class IPBJdbcDAOImpl implements GenericDAO {

	private static transient Logger log = Logger
	.getLogger(IPBJdbcDAOImpl.class);
	
	private DataSource dataSource;
	private boolean useEMoney = false;
	
	public void setDataSource(DataSource dataSource) {
		this.dataSource = dataSource;
	}


	public PlayerProfile selectPlayerProfile(int id) throws Exception{
		
    	String siteUrl = "";
		String dbPrefix = "";
		try {
			Ini ini = new Ini(new File("JDBCConfig.ini"));
		    siteUrl = ini.get("JDBCConfig", "siteUrl");
			dbPrefix = ini.get("JDBCConfig", "dbPrefix");
		} catch(IOException ioe) {
			log.error("Exception in selectPlayerProfile " + ioe.toString());
		} catch (Exception e) {
			log.error("Exception in selectPlayerProfile " + e.toString());
			throw e;
		}
/*
select pp_member_id,  avatar_location, avatar_type, 
b.name
from ipb_profile_portal a
join ipb_members as b
on
a.pp_member_id=b.member_id
and b.member_id = 1
 *
		String query = "select pp_member_id,  avatar_location, avatar_type, " +
		" avatar_size from " + dbPrefix + "profile_portal " +
		" where pp_member_id =?";
 * */


		String query = "select pp_member_id,  avatar_location, avatar_type, " + 
		"name, member_group_id, posts from " + dbPrefix + "profile_portal a " + 
		" join " + dbPrefix + "members as b on a.pp_member_id=b.member_id " +
		" and b.member_id = ?";
		log.debug("Query " + query);
		/**
		 * Define the connection, preparedStatement and resultSet parameters
		 */
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try {
			/**
			 * Open the connection
			 */
			connection = dataSource.getConnection();
			/**
			 * Prepare the statement
			 */
			preparedStatement = connection.prepareStatement(query);
			/**
			 * Bind the parameters to the PreparedStatement
			 */
			preparedStatement.setInt(1, id);
			/**
			 * Execute the statement
			 */
			resultSet = preparedStatement.executeQuery();
			PlayerProfile playerProfile = null;
			/**
			 * Extract data from the result set
			 */
			if(resultSet.next())
			{
				playerProfile = new PlayerProfile();
				playerProfile.setId(resultSet.getInt("pp_member_id"));
				String avatar_location = "";
				String avatar_type = "";
				avatar_location = resultSet.getString("avatar_location");
				avatar_type = resultSet.getString("avatar_type");
				log.debug("avatar_location = "  + avatar_location);
				log.debug("avatar_type = "  + avatar_type);
				
				if (avatar_type.equals("upload")) {
					avatar_location = siteUrl + "/uploads/" + avatar_location;
				} else if (avatar_type.equals("url")) {
					// nothing to do
				}
				String name = resultSet.getString("name");
				
				playerProfile.setPosts(resultSet.getInt("posts"));
				playerProfile.setGroupId(resultSet.getInt("member_group_id"));
				playerProfile.setName(name);
				playerProfile.setAvatar_location(avatar_location);
				playerProfile.setAvatar_type(avatar_type);
			}
			return playerProfile;
		} catch (SQLException e) {
			e.printStackTrace();
			log.error("SQLException : " + e.toString());
		} catch (Exception e) {
			log.error("Exception in selectPlayerProfile " + e.toString());
			throw e;
		}
		finally {
			try {
				/**
				 * Close the resultSet
				 */
				if (resultSet != null) {
					resultSet.close();
				}
				/**
				 * Close the preparedStatement
				 */
				if (preparedStatement != null) {
					preparedStatement.close();
				}
				/**
				 * Close the connection
				 */
				if (connection != null) {
					connection.close();
				}
			} catch (SQLException e) {
				/**
				 * Handle any exception
				 */
				e.printStackTrace();
			}
		}
		return null;
	}

	@Override
	public PlayerBalance insertPlayerBalance(int id) throws Exception {
		String query = "insert into poker (id, cash) values (?,?)";
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		try {
			connection = dataSource.getConnection();
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setInt(1, id);
			preparedStatement.setInt(2, 1000000);
			preparedStatement.execute();
			PlayerBalance playerBalance = new PlayerBalance(id,1000000);
			return playerBalance;
			
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (Exception e) {
			log.error("Exception in insertPlayerBalance " + e.toString());
			throw e;
		}
		finally {
			try {
				if (preparedStatement != null) {
					preparedStatement.close();
				}
				if (connection != null) {
					connection.close();
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return null;
	}
	
	@Override
	public void updatePlayerBalance(PlayerBalance playerBalance) throws Exception {
		String query = "";
		
		if (!useEMoney)
			query = "update poker set cash=? where id=?";
		else 
			query = "update pfields_content set eco_points=? where member_id=?";
		
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		try {
			connection = dataSource.getConnection();
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setLong(1, playerBalance.getBalance());
			preparedStatement.setInt(2, playerBalance.getId());
			preparedStatement.execute();
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (Exception e) {
			log.error("Exception in updatePlayerBalance " + e.toString());
			throw e;
		}
		finally {
			try {
				if (preparedStatement != null) {
					preparedStatement.close();
				}
				if (connection != null) {
					connection.close();
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}


	@Override
	public PlayerBalance getPlayerBalance(int id) throws Exception{
		int balance = 0;
		
    	String eMoneySupport = "";
		try {
			Ini ini = new Ini(new File("JDBCConfig.ini"));
			eMoneySupport = ini.get("JDBCConfig", "eMoney");
			if (eMoneySupport != null && eMoneySupport.equals("1")) {
				useEMoney = true;
			}
		} catch(IOException ioe) {
			log.error("Exception in selectPlayerProfile " + ioe.toString());
		} catch (Exception e) {
			log.error("Exception in selectPlayerProfile " + e.toString());
			throw e;
		}
		
		//TODO: Handle dbPrefix
		String query = "";
		
		if (!useEMoney)
			query = "select cash from poker where id=?";
		else 
			query = "select eco_points from pfields_content where member_id=?";
		
		/**
		 * Define the connection, preparedStatement and resultSet parameters
		 */
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try {
			/**
			 * Open the connection
			 */
			connection = dataSource.getConnection();
			/**
			 * Prepare the statement
			 */
			preparedStatement = connection.prepareStatement(query);
			/**
			 * Bind the parameters to the PreparedStatement
			 */
			preparedStatement.setInt(1, id);
			/**
			 * Execute the statement
			 */
			resultSet = preparedStatement.executeQuery();
			/**
			 * Extract data from the result set
			 */
			
			if(resultSet.next())
			{
				balance = resultSet.getInt("cash");
				log.debug("balance = "  + balance);	
				PlayerBalance playerBalance = new PlayerBalance(id,balance);
				return playerBalance;
			}
		} catch (SQLException e) {
			e.printStackTrace();
			log.error("SQLException : " + e.toString());
		} catch (Exception e) {
			log.error("Exception in getPlayerBalance " + e.toString());
			throw e;
		} 
		finally {
			try {
				/**
				 * Close the resultSet
				 */
				if (resultSet != null) {
					resultSet.close();
				}
				/**
				 * Close the preparedStatement
				 */
				if (preparedStatement != null) {
					preparedStatement.close();
				}
				/**
				 * Close the connection
				 */
				if (connection != null) {
					connection.close();
				}
			} catch (SQLException e) {
				/**
				 * Handle any exception
				 */
				e.printStackTrace();
				log.error("SQLException e : " + e.toString());
			}
		}
		return null;
	}

}
