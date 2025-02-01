import { type Handler } from 'express';
import { OrderService, ProductService, WarehouseService } from '../services';

export default class WarehouseDashboardController {
  static getingOrders: Handler = async (req, res, next) => {
    try {
      const page = parseInt(req.query.page as string) || 1;
      const limit = parseInt(req.query.limit as string) || 10;

      const orders = await OrderService.getOrdersByStatus('ing', page, limit);

      res.json({
        success: true,
        data: orders,
      });
    } catch (error: unknown) {
      next(error);
    }
  };

  static getOrderStatusCounts: Handler = async (req, res, next) => {
    try {
      const edCount = await OrderService.getOrdersCountByStatus('ed');
      const pendingInCourierCount = await OrderService.getOrdersCountByStatus(
        'Pending (In the courier)',
      );

      const mostUsedProduct = await ProductService.getMostCreatedProduct();

      const productNamesWithQuantities =
        await WarehouseService.getProductNamesWithQuantities();

      if (
        !edCount &&
        !pendingInCourierCount &&
        !mostUsedProduct &&
        (!productNamesWithQuantities || productNamesWithQuantities.length === 0)
      ) {
        res.sendStatus(204);
      }

      res.json({
        success: true,
        data: [
          {
            edCount,
            pendingInCourierCount,
            mostUsedProduct,
            productNamesWithQuantities,
          },
        ],
      });
    } catch (error: unknown) {
      next(error);
    }
  };
}
