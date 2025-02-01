import { Order, Product } from '../models';

class ProductService {
  async create(body: any) {
    return new Product(body).save();
  }

  async getAll(page: number = 1, limit: number = 10) {
    const skip = (page - 1) * limit;
    const products = await Product.find()
      .skip(skip)
      .limit(limit)
      .sort({ createdAt: -1 });

    const total = await Product.countDocuments();

    return {
      total,
      page,
      totalPages: Math.ceil(total / limit),
      products,
    };
  }

  async update(id: string, data: any) {
    return await Product.findByIdAndUpdate(id, data, {
      new: true,
    });
  }

  async delete(id: string) {
    return await Product.findByIdAndDelete(id);
  }

  async getMostCreatedProduct() {
    const result = await Order.aggregate([
      { $unwind: '$productIds' },
      {
        $group: {
          _id: '$productIds.productId',
          count: { $sum: 1 },
        },
      },
      { $sort: { count: -1 } },
      { $limit: 1 },
    ]);

    if (!result.length) {
      return;
    }

    const productId = result[0]._id;
    const productDetails = await Product.findById(productId).lean();

    return {
      productId,
      count: result[0].count,
      details: productDetails || null,
    };
  }
}

export default new ProductService();
