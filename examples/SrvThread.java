import java.net.*;
import java.io.*;
import java.util.Scanner;

class SrvThread extends Thread {
    ServerSocket serverSocket = null;
    Socket socket = null;
    static DataOutputStream ostream = null;
    static int port = 9090;
    DataInputStream istream = null;
    String MRcv = "";
    static String MSnd = "";

    SrvThread() {
        try {
            serverSocket = new ServerSocket(port);
            System.out.println("Aguardando conexão...");
            socket = serverSocket.accept();
            System.out.println("Conexão Estabelecida.");
            ostream = new DataOutputStream(socket.getOutputStream());
            istream = new DataInputStream(socket.getInputStream());

            this.start();

            Scanner console = new Scanner(System.in);
            while (true) {
                System.out.println("Mensagem: ");
                String MSnd = console.nextLine();
                ostream.writeUTF(MSnd);
                ostream.flush();
            }
        } catch (Exception e) {
            System.out.println(e);
        }
    }

    public void run() {
        try {
            while (true) {
                MRcv = istream.readUTF();
                System.out.println("Remoto: " + MRcv);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
    }

    public static void main(String args[]) {
        new SrvThread();
    }
}
