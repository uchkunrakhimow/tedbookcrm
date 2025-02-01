import cors from 'cors';
import { config } from 'dotenv';
import express, {
  type Application,
  type NextFunction,
  type Request,
  type Response,
  json,
  static as static_,
  urlencoded,
} from 'express';
import helmet from 'helmet';
import { createServer } from 'node:http';
import admin from 'firebase-admin';
import { connect } from 'mongoose';
import { Server as SocketIOServer } from 'socket.io';

import { corsOptions, socketOptions } from './config/options';
import api from './routes/api';
import auth from './routes/auth';

import verifyToken from './middleware/verify.middleware';
import { OrderService } from './services';

import { client } from './database/redisClient';
import { errorLogger, infoLogger, errorNotifier } from './helpers';

config();

const app: Application = express();
const server = createServer(app);
const io = new SocketIOServer(server, socketOptions);

app.use(cors(corsOptions));
app.use(json());
app.use(urlencoded({ extended: true }));
app.use(
  helmet({
    crossOriginResourcePolicy: false,
    contentSecurityPolicy: true,
  }),
);
app.use('/uploads', static_('uploads'));

io.on('connection', (socket) => {
  infoLogger.info({
    event: 'socket_connected',
    socketId: socket.id,
    timestamp: new Date().toISOString(),
    message: `Socket ${socket.id} connected`,
  });

  socket.on('join_room', (orderId) => {
    socket.join(orderId);
    infoLogger.info({
      event: 'join_room',
      socketId: socket.id,
      timestamp: new Date().toISOString(),
      message: `User ${socket.id} joined room: ${orderId}`,
    });
  });

  socket.on('exit_room', (orderId) => {
    socket.leave(orderId);
    infoLogger.info({
      event: 'exit_room',
      socketId: socket.id,
      timestamp: new Date().toISOString(),
      message: `User ${socket.id} left room: ${orderId}`,
    });
  });

  socket.on('sendMessage', async ({ orderId, commenterRole, commentText }) => {
    const newComment: any = await OrderService.addComment(orderId, {
      commenterRole,
      commentText,
    });

    newComment.orderId = orderId;
    io.emit('newComment', newComment);
  });

  socket.on('disconnect', (reason) => {
    infoLogger.info({
      event: 'disconnect',
      socketId: socket.id,
      timestamp: new Date().toISOString(),
      message: `Socket ${socket.id} disconnected due to ${reason}`,
    });
  });
});

app.use(
  (
    req: Request & { io?: SocketIOServer },
    _res: Response,
    next: NextFunction,
  ) => {
    req.io = io;
    next();
  },
);

app.use('/auth', auth);
app.use('/api/v1', verifyToken, api);

app.get('/', (_req, res) => {
  res.send('Hello world');
});

app.use(
  async (err: Error, req: Request, res: Response, _next: NextFunction) => {
    errorLogger.error({
      message: err.message,
      stack: err.stack,
      method: req.method,
      url: req.url,
      timestamp: new Date().toISOString(),
    });

    await errorNotifier(err);
    res.status(500).send({
      success: false,
      error: {
        message: 'Something went wrong',
      },
    });
  },
);

app.use((req, res) => {
  res.status(404).send({
    success: false,
    error: {
      message: `Cannot ${req.method} ${req.path}`,
    },
  });
});

const port = process.env['PORT']!;
const mongoURI = process.env['MONGO_URL']!;
const serviceAccount = process.env['GOOGLE_APPLICATION_CREDENTIALS']!;

async function startServer() {
  try {
    await connect(mongoURI);
    console.log('✅ Connected to MongoDB');
    await client.connect();
    console.log('✅ Connected to Redis');

    admin.initializeApp({
      credential: admin.credential.cert(serviceAccount),
    });
    console.log('✅ Firebase Admin Initialized');

    server.listen(port, () => {
      console.log(`🚀 Server is running at http://127.0.0.1:${port}`);
    });
  } catch (error) {
    console.error('❌ Failed to start the server:', error);
    process.exit(1);
  }
}

void startServer();
