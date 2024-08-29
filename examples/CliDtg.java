import java.net.*;
import java.io.*;
import java.util.Scanner;

public class CliDtg {

	public static void main(String args[]) {
		try {
			// Define um endere�o de destino (IP e porta)
			InetAddress servidor = InetAddress.getByName("localhost");
			int porta = 1024;
			// Cria o socket
			DatagramSocket socket = new DatagramSocket();
			// La�o para ler linhas do teclado e envi�-las ao endere�o de destino
			Scanner input = new Scanner(System.in);
			String linha = input.nextLine();

			while (!linha.equals(".")) {
				// Cria um pacote com os dados da linha
				byte[] dados = linha.getBytes();
				DatagramPacket pacote = new DatagramPacket(dados, dados.length, servidor, porta);
				// Envia o pacote ao endere�o de destino
				socket.send(pacote);
				// L� a pr�xima linha
				linha = input.nextLine();
			}
		} catch (Exception e) {
		}
	}
}
