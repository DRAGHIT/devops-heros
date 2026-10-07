import com.sun.net.httpserver.HttpServer;
import java.net.InetSocketAddress;
import java.nio.charset.StandardCharsets;
public class Main {
 public static void main(String[] args) throws Exception {
  HttpServer server=HttpServer.create(new InetSocketAddress("0.0.0.0",Integer.parseInt(System.getenv().getOrDefault("PORT","8080"))),0);
  server.createContext("/", exchange -> {
   byte[] body="<h1>Hello World from Java</h1>".getBytes(StandardCharsets.UTF_8);
   exchange.getResponseHeaders().add("Content-Type","text/html");
   exchange.sendResponseHeaders(200,body.length);
   try(var output=exchange.getResponseBody()){output.write(body);}
  });
  server.start();
 }
}
