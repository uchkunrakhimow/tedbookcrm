import { type CorsOptions } from 'cors';
import { type ServerOptions } from 'socket.io';

export const socketOptions: Partial<ServerOptions> = {
  path: '/ws',
  cors: {
    origin: [
      process.env.URI!,
      'https://tedbookcrm.uz',
      'http://localhost:5173',
    ],
    methods: ['GET', 'POST'],
    credentials: true,
  },
  transports: ['websocket', 'polling'],
};

export const corsOptions: CorsOptions = {
  origin: [process.env.URI!, 'https://tedbookcrm.uz', 'http://localhost:5173'],
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Cookie', 'Set-Cookie', 'Authorization'],
  credentials: true,
};
