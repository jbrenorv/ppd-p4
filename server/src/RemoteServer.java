import java.util.HashMap;
import java.util.Map;

public class RemoteServer {

    private static Map<String, ClientThread> clients = new HashMap<>();

    public static synchronized void addClient(ClientThread clientThread) {
        clients.put(clientThread.getClient().getQueue(), clientThread);
    }

    public void connectToBroker() {
        
    }

    
}
