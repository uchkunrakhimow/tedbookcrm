import { type Handler } from 'express';
import { WarehouseHistoryService } from '../services';

export default class StockHistoryController {
  static index: Handler = async (req, res, next) => {
    try {
      const page = parseInt(req.query.page as string) || 1;
      const limit = parseInt(req.query.limit as string) || 10;

      const stockHistory = await WarehouseHistoryService.getAll(page, limit);

      res.json({
        success: true,
        data: stockHistory,
      });
    } catch (error: unknown) {
      next(error);
    }
  };
}
