import java.io.IOException;
import java.net.*;

import java.util.Collection;
import java.util.HashSet;
import java.util.Set;

import models.Client;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class RemoteServer {

    private static final Logger logger = LogManager.getLogger();

    private static final Set<Client> clients = new HashSet<>();

    public static synchronized void createClient(Client client) {
        clients.add(client);
    }

    public static synchronized Collection<Client> getClients() {
        return clients;
    }

    public static void startServer() {
        try (ServerSocket serverSocket = new ServerSocket(1024)) {

            logger.info("Server started");

            while (true) {
                
                Socket socket = serverSocket.accept();

                logger.info("New client connected");

                (new ClientThread(socket)).start();;

            }
        } catch (IOException e) {
            logger.error(e.getMessage());
        }
    }
}
