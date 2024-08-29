import java.net.*;
import java.io.*;

public class SrvDtg {
	public static void main(String args[]) {

		int porta = 1024; // Define porta
		byte[] buffer = new byte[1000]; // Cria um buffer local
		try {
			// Cria o socket
			DatagramSocket socket = new DatagramSocket(porta);
			// Cria um pacote para receber dados da rede no buffer local
			DatagramPacket pacote = new DatagramPacket(buffer, buffer.length);

			// La�o para receber pacotes e mostrar seus conte�dos na sa�da padr�o
			while (true) {
				socket.receive(pacote);
				String conteudo = new String(pacote.getData(), 0, pacote.getLength());
				System.out.println("End. Origem: " + pacote.getAddress());
				System.out.println("Conteudo Pacote: " + conteudo + "\n");
				// Redefine o tamanho do pacote
				pacote.setLength(buffer.length);
			}
		} catch (Exception e) {
		}
	}
}
