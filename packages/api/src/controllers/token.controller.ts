import { type Handler } from 'express';
import { client } from '../database/redisClient';

export default class TokenController {
  static store: Handler = async (req, res, next) => {
    const { token, userId } = req.body;

    try {
      await client.set(`token:${userId}`, token);
      res.status(200).json({ success: true, userId, token });
    } catch (error) {
      next(error);
    }
  };
}
