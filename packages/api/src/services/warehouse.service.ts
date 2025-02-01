import { WarehouseHistoryService } from '.';
import { Warehouse } from '../models';
import { IWarehouse, IWarehouseHistory } from '../types';

class WarehouseService {
  private async logStockHistory(stockItem: IWarehouse, type: string) {
    const stockHistory: IWarehouseHistory = {
      product: stockItem?.product,
      user: stockItem?.user,
      changeType: type,
      quantity: stockItem?.quantity,
    } as IWarehouseHistory;

    await WarehouseHistoryService.create(stockHistory);
  }

  async store(body: IWarehouse) {
    const existingStockItem = await Warehouse.findOne({
      product: body.product,
      user: body.user,
    });

    if (existingStockItem) {
      existingStockItem.quantity += body.quantity;
      const updatedStockItem = await existingStockItem.save();

      this.logStockHistory(updatedStockItem, 'update');

      return updatedStockItem;
    }

    const stockItem = new Warehouse(body);
    const savedStockItem = await stockItem.save();

    this.logStockHistory(savedStockItem, 'add');

    return savedStockItem;
  }

  async update(id: string, quantity: number) {
    return await Warehouse.findByIdAndUpdate(
      id,
      { $set: { quantity } },
      {
        new: true,
        runValidators: true,
      },
    );
  }

  async index(page: number = 1, limit: number = 10, filters: any = {}) {
    const skip = (page - 1) * limit;

    const total = await Warehouse.countDocuments(filters);

    const stocks = await Warehouse.find(filters)
      .populate('product', '_id title price comment')
      .skip(skip)
      .limit(limit)
      .exec();

    return {
      stocks,
      total,
      page,
      totalPages: Math.ceil(total / limit),
    };
  }

  async show(productId: string) {
    return await Warehouse.findOne({ productId });
  }

  async getProductNamesWithQuantities() {
    const stocks = await Warehouse.find({}).populate('product', 'title').exec();

    return stocks.map((stock: any) => ({
      name: stock.productId?.title,
      quantity: stock.quantity,
    }));
  }

  async destroy(id: string) {
    return await Warehouse.findByIdAndDelete(id);
  }
}

export default new WarehouseService();
