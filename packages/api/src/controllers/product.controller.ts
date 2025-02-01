import { type Handler } from 'express';
import { ProductService } from '../services';

export default class ProductController {
  static store: Handler = async (req, res, next) => {
    try {
      const { title, price, comment } = req.body;
      const newProduct = await ProductService.create({
        title,
        price,
        comment,
      });

      res.status(201).json({
        success: true,
        product: newProduct,
      });
    } catch (error: unknown) {
      next(error);
    }
  };

  static index: Handler = async (req, res, next) => {
    try {
      const page = parseInt(req.query.page as string) || 1;
      const limit = parseInt(req.query.limit as string) || 10;

      const result = await ProductService.getAll(page, limit);

      if (result.products.length === 0) {
        res.sendStatus(204);
      }

      res.json(result);
    } catch (error: unknown) {
      next(error);
    }
  };

  static update: Handler = async (req, res, next) => {
    const { id } = req.params;
    try {
      const updatedProduct = await ProductService.update(id, req.body);

      if (!updatedProduct) {
        res.sendStatus(404);
      }

      res.json({
        success: true,
        product: updatedProduct,
      });
    } catch (error: unknown) {
      next(error);
    }
  };

  static destroy: Handler = async (req, res, next) => {
    const { id } = req.params;

    try {
      const deletedProduct = await ProductService.delete(id);

      if (!deletedProduct) {
        res.sendStatus(404);
      }

      res.sendStatus(204);
    } catch (error: unknown) {
      next(error);
    }
  };
}
