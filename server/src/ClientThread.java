import java.io.*;
import java.net.*;

import javax.jms.*;
import javax.json.*;

import org.apache.activemq.ActiveMQConnection;
import org.apache.activemq.ActiveMQConnectionFactory;

import models.Client;
import models.ClientMessageType;

public class ClientThread extends Thread {

    private final String brokerUrl = ActiveMQConnection.DEFAULT_BROKER_URL;

    private final DataOutputStream outputStream;
    private final DataInputStream inputStream;

    private Client client = null;

    private Connection connection = null;

    private Thread consumerThread = null;

    public ClientThread(Socket socket) throws IOException {
        this.outputStream = new DataOutputStream(socket.getOutputStream());
        this.inputStream = new DataInputStream(socket.getInputStream());
    }

    public void run() {
        while (true) {
            try {

                // Wait for messages
                String message = inputStream.readUTF();

                handleClientMessage(message);

            
            } catch (IOException e) {
                e.printStackTrace();

                break;
            }
        }

        try {
            consumerThread.interrupt();
            connection.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void handleClientMessage(String message) {
        JsonObject jsonObject = Json.createReader(new StringReader(message)).readObject();

        ClientMessageType messageType = ClientMessageType.values()[jsonObject.getInt("type")];

        switch (messageType) {
            case createClient:
                createClient(jsonObject);
                break;
            
            case sendMessage:
                sendMessage(message, jsonObject);
                break;
            
            case clientList:
                break;
        
            default:
                break;
        }
    }

    private void createClient(JsonObject jsonObject) {
        try {
            client = Client.createClientFromJsonObject(jsonObject);

            ConnectionFactory connectionFactory = new ActiveMQConnectionFactory(brokerUrl);
            connection = connectionFactory.createConnection();
            connection.start();
            
            session = connection.createSession(false, Session.AUTO_ACKNOWLEDGE);
            
            createConsumerThread();

            RemoteServer.createClient(client);
        } catch (JMSException e) {
            e.printStackTrace();
        }
    }

    private void createConsumerThread() {
        consumerThread = new Thread() {
            @Override
            public void run() {
                try {
                    Session session = connection.createSession(false, Session.CLIENT_ACKNOWLEDGE);
                    Destination destination = session.createQueue(client.getQueue());
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
    
                            outputStream.writeUTF(jsonsString);
                            outputStream.flush();
                        }
                    }

                    consumer.close();
                    session.close();

                } catch (JMSException e) {
                    e.printStackTrace();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        };

        consumerThread.start();
    }

    private void sendMessage(String jsonString, JsonObject jsonObject) {
        try {
            Client recipient = Client.createClientFromJsonObject(jsonObject.getJsonObject("recipient"));
            Session session = connection.createSession(false, Session.AUTO_ACKNOWLEDGE);
            Destination destination = session.createQueue(recipient.getQueue());
            MessageProducer producer = session.createProducer(destination);

            TextMessage textMessage = session.createTextMessage(jsonString);

            producer.send(textMessage);

            producer.close();
            session.close();
        } catch (JMSException e) {
            e.printStackTrace();
        }
    }
}
