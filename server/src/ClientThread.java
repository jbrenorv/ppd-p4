import java.io.*;
import java.net.*;
import java.util.Collection;

import javax.jms.*;
import javax.json.*;

import org.apache.activemq.ActiveMQConnection;
import org.apache.activemq.ActiveMQConnectionFactory;

import models.Client;
import models.ClientMessageType;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class ClientThread extends Thread {

    private static final Logger logger = LogManager.getLogger();

    private final String brokerUrl = ActiveMQConnection.DEFAULT_BROKER_URL;

    private final DataOutputStream outputStream;
    private final DataInputStream inputStream;

    private Client ownerClient = null;

    private Connection connection = null;

    private Thread consumerThread = null;

    public ClientThread(Socket socket) throws IOException {
        this.outputStream = new DataOutputStream(socket.getOutputStream());
        this.inputStream = new DataInputStream(socket.getInputStream());
    }

    public void run() {

        logger.info("Client thread started!");

        // Notifies the client that the channel is available
        try {
            outputStream.writeUTF("available");
            outputStream.flush();
        } catch (IOException e) {
            logger.error(e.getMessage());
            return;
        }

        logger.info("Waiting for client messages...");

        while (true) {
            try {

                // Wait for messages
                String message = inputStream.readUTF();

                logger.info("Message received from socket: {}", message);

                handleClientMessage(message);

            } catch (IOException e) {
                logger.error(e.getMessage());
                break;
            }
        }

        try {
            consumerThread.interrupt();
            connection.close();
        } catch (Exception e) {
            logger.error(e.getMessage());
        }

        logger.info("Client thread stopped!");
    }

    private void handleClientMessage(String message) {
        JsonObject jsonObject = Json.createReader(new StringReader(message)).readObject();

        ClientMessageType messageType = ClientMessageType.values()[jsonObject.getInt("messageType")];

        switch (messageType) {
            case createClient:
                createClient(jsonObject.getJsonObject("client"));
                break;
            
            case sendMessage:
                Client recipient = Client.createClientFromJsonObject(jsonObject.getJsonObject("recipient"));
                sendMessage(recipient, message);
                break;

            default:
                break;
        }
    }

    private void createClient(JsonObject jsonObject) {
        try {
            ownerClient = Client.createClientFromJsonObject(jsonObject);

            logger.info("Creating client: {}", ownerClient.getName());

            ConnectionFactory connectionFactory = new ActiveMQConnectionFactory(brokerUrl);
            connection = connectionFactory.createConnection();
            connection.start();

            // Listen to broker messages
            createConsumerThread();

            // Add client to the client server list
            RemoteServer.createClient(ownerClient);

            logger.info("Successfully created client: {}", ownerClient.getName());

            // Send the new clients set to update all clients
            sendClientList();
            
        } catch (JMSException e) {
            logger.error(e.getMessage());
        }
    }

    private void createConsumerThread() {
        consumerThread = new Thread(() -> {
            try {
                Session session = connection.createSession(false, Session.CLIENT_ACKNOWLEDGE);
                Destination destination = session.createQueue(ownerClient.getQueue());
                MessageConsumer consumer = session.createConsumer(destination);

                while (true) {
                    Message message = consumer.receive();

                    if (Thread.currentThread().isInterrupted()) {
                        break;
                    }

                    message.acknowledge();

                    if (message instanceof TextMessage) {
                        TextMessage textMessage = (TextMessage)message;
                        String jsonsString = textMessage.getText();

                        logger.info("New message from broker, forwarding to {}", ownerClient.getName());

                        outputStream.writeUTF(jsonsString);
                        outputStream.flush();
                    }
                }

                consumer.close();
                session.close();

            } catch (JMSException | IOException e) {
                logger.error(e.getMessage());
            }
        });

        consumerThread.start();
    }

    private String getClientsJsonString(Collection<Client> clients) {
        JsonObjectBuilder builder = Json.createObjectBuilder();

        builder.add("messageType", ClientMessageType.clientList.ordinal());

        JsonArrayBuilder jsonArrayBuilder = Json.createArrayBuilder();

        for (Client client : clients) {
            JsonObject clientJsonObject = client.toJsonObject();
            jsonArrayBuilder.add(clientJsonObject);
        }

        builder.add("clients", jsonArrayBuilder.build());

        return builder.build().toString();
    }

    private void sendClientList() {
        logger.info("Sending client list to all clients");

        Collection<Client> clients = RemoteServer.getClients();

        String clientsJsonString = getClientsJsonString(clients);

        for (Client client : clients) {
            sendMessage(client, clientsJsonString);
        }
    }

    private void sendMessage(Client client, String jsonString) {
        try {
            logger.info("Sending message from {} to queue of {}", client.getName(), client.getName());

            Session session = connection.createSession(false, Session.AUTO_ACKNOWLEDGE);
            Destination destination = session.createQueue(client.getQueue());
            MessageProducer producer = session.createProducer(destination);

            TextMessage textMessage = session.createTextMessage(jsonString);

            producer.send(textMessage);

            producer.close();
            session.close();
        } catch (JMSException e) {
            logger.error(e.getMessage());
        }
    }
}
