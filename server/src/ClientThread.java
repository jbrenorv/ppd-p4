import java.io.*;
import java.net.*;
import javax.json.*;

import models.Client;
import models.ClientMessageType;

public class ClientThread extends Thread {

    private final Socket socket;
    private final DataOutputStream outputStream;
    private final DataInputStream inputStream;

    private Client client = null;

    public ClientThread(Socket socket) throws IOException {
        this.socket = socket;
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
            }
        }
    }

    private void handleClientMessage(String message) {
        JsonObject jsonObject = Json.createReader(new StringReader(message)).readObject();

        ClientMessageType messageType = ClientMessageType.values()[jsonObject.getInt("type")];

        switch (messageType) {
            case identificationMessage:
                client = Client.createClientFromJsonObject(jsonObject);
                RemoteServer.addClient(this);
                break;
            
            case messageToOtherClient:
                break;
        
            default:
                break;
        }
    }

    public Client getClient() {
        return this.client;
    }

    public void sendMessage(String message) {

    }
}
