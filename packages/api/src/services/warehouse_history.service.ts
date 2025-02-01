import { WarehouseHistory } from '../models';
import { IWarehouseHistory } from '../types';

class WarehouseHistoryService {
  async create(body: IWarehouseHistory) {
    return await new WarehouseHistory(body).save();
  }

  async getAll(page: number = 1, limit: number = 10) {
    const skip = (page - 1) * limit;
    const total = await WarehouseHistory.countDocuments();
    const result = await WarehouseHistory.find()
      .populate('productId', '_id title price comment')
      .skip(skip)
      .limit(limit)
      .exec();

    return {
      result,
      total,
      page,
      totalPages: Math.ceil(total / limit),
    };
  }
}

export default new WarehouseHistoryService();
