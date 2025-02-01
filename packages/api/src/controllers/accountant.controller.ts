import { type Handler } from 'express';
import { OrderService } from '../services';
import { IOrder } from '../types';

export default class AccountantController {
  static index: Handler = async (req, res, next) => {
    try {
      const page = parseInt(req.query.page as string) || 1;
      const limit = parseInt(req.query.limit as string) || 10;

      const orders = await OrderService.getAll();
      const deliveredOrders = orders.filter(
        (order: any) => order.status === 'Delivered',
      );

      const productSummary: Record<
        string,
        { totalPrice: number; quantity: number }
      > = {};

      deliveredOrders.forEach((order: IOrder) => {
        order.productIds.forEach((product: any) => {
          const { title, price } = product.productId;
          const discountPrice = product.discountPrice;

          if (!productSummary[title]) {
            productSummary[title] = { totalPrice: 0, quantity: 0 };
          }

          const effectivePrice =
            discountPrice != null
              ? parseFloat(discountPrice)
              : parseFloat(price);
          productSummary[title].totalPrice += effectivePrice;
          productSummary[title].quantity += 1;
        });
      });

      if (Object.keys(productSummary).length === 0) {
        res.sendStatus(204);
      }

      const formattedProductSummary = Object.entries(productSummary).map(
        ([title, { totalPrice, quantity }]) => ({
          title,
          totalPrice: totalPrice.toFixed(2),
          quantity,
        }),
      );

      const totalProducts = formattedProductSummary.length;
      const totalPages = Math.ceil(totalProducts / limit);
      const offset = (page - 1) * limit;

      const paginatedProducts = formattedProductSummary.slice(
        offset,
        offset + limit,
      );

      res.json({
        data: paginatedProducts,
        totalProducts,
        totalPages,
        currentPage: page,
      });
    } catch (error: unknown) {
      next(error);
    }
  };
}
