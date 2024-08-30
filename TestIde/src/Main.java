import javax.jms.*;
import org.apache.activemq.ActiveMQConnection;
import org.apache.activemq.ActiveMQConnectionFactory;

public class Main {

    private static String url = ActiveMQConnection.DEFAULT_BROKER_URL;

    private static String queueName = "FILA_EXEMPLO";

    public static void main(String[] args) throws JMSException {

        try {
            ConnectionFactory connectionFactory = new ActiveMQConnectionFactory(url);
            Connection connection = connectionFactory.createConnection();
            connection.start();

            Session session = connection.createSession(false, Session.AUTO_ACKNOWLEDGE);

            Destination destination = session.createQueue(queueName);

            MessageProducer producer = session.createProducer(destination);
            TextMessage message = session.createTextMessage("Mensagem do Produtor.");

            producer.send(message);

            producer.close();
            session.close();
            connection.close();
        } catch (Exception e) {
            System.out.println(e);;
        }
    }
}