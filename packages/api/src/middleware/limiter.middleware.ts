import rateLimit from 'express-rate-limit';

export const limiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 10,
  statusCode: 429,
  message: 'Too many requests from this IP, please try again later.',
});
