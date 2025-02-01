import { type Handler } from 'express';
import { client } from '../database/redisClient';
import { OrderService } from '../services';
import { sendNotification } from '../helpers';

export default class OrderController {
  static index: Handler = async (req, res, next) => {
    const { page = 1, limit = 10 } = req.query;
    try {
      const options = {
        page: Number(page),
        limit: Number(limit),
      };

      const orders = await OrderService.getAll(options);

      res.json({
        success: true,
        data: orders,
      });
    } catch (error: unknown) {
      next(error);
    }
  };

  static store: Handler = async (req: any, res, next) => {
    const orderData = req.body;
    const io = req.io;

    try {
      const newOrder = await OrderService.create(orderData);

      io.emit('orderUpdated', {
        type: 'create',
        orderId: newOrder._id,
        message: 'Order has been created',
      });

      res.status(201).json({
        success: true,
        data: {
          message: newOrder._id,
        },
      });
    } catch (error: unknown) {
      next(error);
    }
  };

  static show: Handler = async (req, res, next) => {
    const { id } = req.params;

    try {
      const order = await OrderService.getById(id);

      if (!order) {
        res.sendStatus(404);
      }

      res.json({
        success: true,
        data: order,
      });
    } catch (error: unknown) {
      next(error);
    }
  };

  static update: Handler = async (req: any, res, next) => {
    const { id } = req.params;
    const io = req.io;

    try {
      const updatedOrder = await OrderService.update(
        id,
        req.body,
        req.user.sub,
      );

      if (!updatedOrder) {
        res.sendStatus(404);
      }

      io.emit('orderUpdated', {
        type: 'update',
        orderId: id,
        message: 'Order has been updated',
      });

      const token: string | null = await client.get(
        `token:${req.body.courierId}`,
      );

      if (token) {
        const title = 'Tedbook CRM';
        const body = `Sizda yangi buyurtma bor`;
        await sendNotification(title, body, token);
      }

      res.sendStatus(204);
    } catch (error: unknown) {
      next(error);
    }
  };

  static destroy: Handler = async (req, res, next) => {
    const { id } = req.params;

    try {
      const deletedOrder = await OrderService.delete(id);

      if (!deletedOrder) {
        res.sendStatus(404);
      }

      res.sendStatus(204);
    } catch (error: unknown) {
      next(error);
    }
  };

  static getByUserId: Handler = async (req, res, next) => {
    const { userId } = req.params;
    const { page = '1', limit = '10', filter } = req.query;

    const pageNumber = parseInt(page as string, 10);
    const limitNumber = parseInt(limit as string, 10);

    try {
      const parsedFilter = filter ? JSON.parse(filter as string) : {};
      const order = await OrderService.getByUserId(
        userId,
        pageNumber,
        limitNumber,
        parsedFilter,
      );

      if (!order) {
        res.sendStatus(404);
      }

      if (order.orders.length === 0) {
        res.sendStatus(204);
      }

      res.json({
        success: true,
        data: order,
      });
    } catch (error: unknown) {
      next(error);
    }
  };

  static addMessage: Handler = async (req: any, res, next) => {
    const { id } = req.params;
    const { commenterRole, commentText } = req.body;
    const io = req.io;

    try {
      const newComment = await OrderService.addComment(id, {
        commenterRole,
        commentText,
      });

      io.emit('newComment', newComment);

      res.json({
        success: true,
        data: newComment,
      });
    } catch (error: unknown) {
      next(error);
    }
  };

  static getComments: Handler = async (req, res, next) => {
    const { id } = req.params;
    try {
      const order = await OrderService.getById(id);

      if (!order) {
        res.sendStatus(404);
      }

      res.json({
        success: true,
        data: order.messages,
      });
    } catch (error: unknown) {
      next(error);
    }
  };

  static getStatusCounts: Handler = async (req, res, next) => {
    try {
      const { userId } = req.params;
      const result = await OrderService.getStatusCounts(userId);
      res.json({
        success: true,
        data: result,
      });
    } catch (error: unknown) {
      next(error);
    }
  };
}
