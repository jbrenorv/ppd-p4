import java.net.*;
import java.io.*;

class CliStm {

	public static void main(String args[]) {

		DataOutputStream out = null;
		DataInputStream in = null;
		Socket soc = null;
		String host = args[0];
		String msg = "";

		try {

			soc = new Socket(host, 1250);

			out = new DataOutputStream(soc.getOutputStream());
			out.writeUTF(args[1]);

			in = new DataInputStream(soc.getInputStream());
			msg = in.readUTF();
			System.out.println("Stream Recebida: " + msg);

		} catch (Exception e) {
		}
	}
}
