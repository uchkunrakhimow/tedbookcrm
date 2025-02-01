import { type Handler } from 'express';
import { WarehouseService } from '../services';

export default class WarehouseController {
  static store: Handler = async (req, res, next) => {
    try {
      const warehouse = await WarehouseService.store(req.body);
      res.status(201).json({
        success: true,
        data: warehouse,
      });
    } catch (error: unknown) {
      next(error);
    }
  };

  static update: Handler = async (req, res, next) => {
    const { id } = req.params;
    const { quantity } = req.body;

    try {
      const warehouse = await WarehouseService.update(id, quantity);
      if (!warehouse) {
        res.status(404).json({
          success: false,
        });
      }

      res.json({
        success: true,
        data: warehouse,
      });
    } catch (error: unknown) {
      next(error);
    }
  };

  static index: Handler = async (req, res, next) => {
    try {
      const page = parseInt(req.query.page as string) || 1;
      const limit = parseInt(req.query.limit as string) || 10;
      const filter: any = {};

      if (req.query.productTitle) {
        filter['productId.title'] = {
          $regex: req.query.productTitle,
          $options: 'i',
        };
      }

      if (req.query.minPrice || req.query.maxPrice) {
        filter['productId.price'] = {};
        if (req.query.minPrice) {
          filter['productId.price'].$gte = parseFloat(
            req.query.minPrice as string,
          );
        }
        if (req.query.maxPrice) {
          filter['productId.price'].$lte = parseFloat(
            req.query.maxPrice as string,
          );
        }
      }

      const warehouses = await WarehouseService.index(page, limit, filter);

      res.json({
        success: true,
        data: warehouses,
      });
    } catch (error: unknown) {
      next(error);
    }
  };

  static destroy: Handler = async (req, res, next) => {
    const { id } = req.params;
    try {
      const deletedwarehouse = await WarehouseService.destroy(id);
      if (!deletedwarehouse) {
        res.sendStatus(404);
      }
      res.sendStatus(204);
    } catch (error: unknown) {
      next(error);
    }
  };
}
