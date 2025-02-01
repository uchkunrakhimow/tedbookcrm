import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:tedbook/persistance/remote/api_provider.dart';
import 'package:tedbook/utils/utils.dart';

class SocketService {
  late IO.Socket socket;

  void connect() {
    // Configure the socket connection
    socket = IO.io(
        ApiProvider.baseUrl,
        IO.OptionBuilder()
            .setTransports(['websocket']) // use web socket transport
            .setPath('/ws') // Ensure this matches your server configuration
            .enableAutoConnect() // Auto-connect when the service is initialized
            .build());

    // Handle connection events
    socket.onConnect((_) {
      debugLog('Connected to Socket.IO server with ID: ${socket.id}');
    });

    socket.onDisconnect((_) {
      debugLog('Disconnected from server');
    });

    socket.onConnectError((error) {
      debugLog('Connection error: $error');
    });

    // Listen for new comments from the server
    socket.on('newComment', (data) {
      debugLog('New comment received: $data');
      // Handle the received comment data (you might want to parse it)
    });
  }

  void joinRoom({required String orderId}) {
    socket.emit('join_room', orderId);
    debugLog('Joined room: $orderId');
  }

  void sendMessage({
    required String orderId,
    required String commenterRole,
    required String commentText,
  }) {
    final message = {
      'orderId': orderId,
      'commenterRole': commenterRole,
      'commentText': commentText,
    };
    socket.emit('sendMessage', message);
    debugLog('Message sent: $message');
  }

  void disconnect() {
    socket.disconnect();
  }
}
