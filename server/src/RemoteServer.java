import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

import models.Client;

public class RemoteServer {

    private static Map<String, Client> clients = new HashMap<>();

    public static synchronized void createClient(Client client) {
        clients.put(client.getQueue(), client);
    }

    public static synchronized Collection<Client> listClients() {
        return clients.values();
    }

    public void connectToBroker() {
        
    }

    
}
