import java.io.*;
import java.net.*;

class SrvStm {

	public static void main(String args[]) {

		DataInputStream in = null;
		DataOutputStream out = null;
		ServerSocket srvsoc = null;
		Socket soc = null;
		String msg = "";

		try {

			srvsoc = new ServerSocket(1250);

			System.out.println("Aguardando Conexoes ... ");
			soc = srvsoc.accept();

			in = new DataInputStream(soc.getInputStream());
			msg = in.readUTF();
			System.out.println("Stream Recebida: " + msg);

			out = new DataOutputStream(soc.getOutputStream());
			out.writeUTF(args[0]);

		} catch (Exception e) {
		}

	}
}
