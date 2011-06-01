package com.cubeia.games.poker.admin.jmx;

import java.io.InputStream;
import java.util.Properties;

import javax.management.JMX;
import javax.management.MBeanServerConnection;
import javax.management.ObjectName;
import javax.management.remote.JMXConnector;
import javax.management.remote.JMXConnectorFactory;
import javax.management.remote.JMXServiceURL;

import org.apache.log4j.Logger;

import com.cubeia.firebase.service.clientreg.state.StateClientRegistryMBean;

public class FirebaseJMXFactory {
    
    private static final transient Logger log = Logger.getLogger(FirebaseJMXFactory.class);
    
    private String serverurl;
    
    
    /**
     * Will read the property file everytime the factory is created.
     * This may not be optimum performance, but it also allows for 
     * runtime changes to the property file.
     * 
     */
    public FirebaseJMXFactory() {
        Properties properties = new Properties();
        try {
            InputStream resourceAsStream = this.getClass().getResourceAsStream("gameserver.properties");
            
            if (resourceAsStream == null) {
                resourceAsStream = this.getClass().getResourceAsStream("/gameserver.properties");
            }
            
            if (resourceAsStream != null) {
                properties.load(resourceAsStream);
                serverurl = properties.getProperty("firebase.gateway");
                log.debug("Loaded gameserver url, 'firebase.gateway', as: "+serverurl);
                
            } else {
                throw new RuntimeException("Could not find gameserver.properties in classpath");
            }
            
        } catch (Exception e) {
            throw new RuntimeException("Could not read gameserver.properties", e);
        }
    }
    
    /**
     * 
     * 
     * @return null if the connection failed.
     */
    public StateClientRegistryMBean createClientRegistryProxy() {
        try {
            JMXServiceURL url = new JMXServiceURL(serverurl);
            JMXConnector jmxc = JMXConnectorFactory.connect(url, null);
    
            // Get an MBeanServerConnection
            MBeanServerConnection mbsc = jmxc.getMBeanServerConnection();
    
            // Construct the ObjectName for the Hello MBean
            ObjectName mbeanName = new ObjectName("com.cubeia.firebase.clients:type=ClientRegistry");
    
            // Create a dedicated proxy for the MBean instead of going directly through the MBean server connection
            return JMX.newMBeanProxy(mbsc, mbeanName, StateClientRegistryMBean.class, true);
            
        } catch (Exception e) {
            log.error("Failed to create StateClientRegistryMBean JMX proxy", e);
            return null;
        }
        
    }
    
}
