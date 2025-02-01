import { LocationService, WarehouseService } from '.';
import { Order, User } from '../models';
import { IOrder } from '../types';

class OrderService {
  private async saveLocationData(orderData: IOrder) {
    const { region, district, city, address } = orderData;
    if (!region) return;

    const location = {
      region,
      district: district || null,
      city: city || null,
      address: address || null,
    };

    await LocationService.create(location);
  }

  private async saveStockData(
    productId: string,
    action: 'increment' | 'decrement',
  ) {
    const stockItem = await WarehouseService.getById(productId);

    if (action === 'decrement') {
      stockItem.quantity -= 1;
    } else if (action === 'increment') {
      stockItem.quantity += 1;
    }

    return stockItem.save();
  }

  private updateEditHistory(order: any, editorId: string) {
    const editEndTime = Date.now();
    const lastEdit = order?.editHistory?.[order.editHistory?.length - 1];
    const editStartTime = lastEdit?.editTime
      ? new Date(lastEdit.editTime).getTime()
      : order?.updatedAt?.getTime() || Date.now();
    const editDuration = (editEndTime - editStartTime) / 1000;

    if (lastEdit && lastEdit.editorId.toString() === editorId) {
      lastEdit.editTime = new Date();
      lastEdit.editDuration = editDuration;
    } else {
      order?.editHistory.push({
        editorId,
        editTime: new Date(),
        editDuration,
      });
    }
  }

  async create(orderData: IOrder) {
    await this.saveLocationData(orderData);

    for (const product of orderData.productIds) {
      await this.saveStockData(product.productId.toString(), 'decrement');
    }

    const paymentMethods: Array<'cash' | 'card' | 'payment-systems'> = [
      'cash',
      'card',
      'payment-systems',
    ];

    const normalizedPayments = paymentMethods.map((method) => {
      const payment = orderData.payments?.find((p) => p.method === method);
      return {
        method,
        amount: payment ? payment.amount : 0,
      };
    });

    orderData.payments = normalizedPayments;

    const newOrder = new Order(orderData);
    return await newOrder.save();
  }

  async getAll(options) {
    await Order.paginate({}, options);
  }

  async getByUserId(
    userId: string,
    page = 1,
    limit = 10,
    filters: object = {},
  ) {
    const skip = (page - 1) * limit;
    const user = await User.findById(userId).select('username');

    let query = {};
    if (user && user.username === 'admin') {
      query = { ...filters };
    } else {
      query = {
        $or: [
          { userId },
          { operatorId: userId },
          { logisticianId: userId },
          { courierId: userId },
        ],
        ...filters,
      };
    }

    const total = await Order.countDocuments(query);
    const ordersList = await Order.find(query)
      .populate('productIds.productId', '_id title price comment')
      .populate('editHistory.editorId', '_id name username')
      .populate('operatorId logisticianId courierId', '_id name username shift')
      .skip(skip)
      .sort({ updatedAt: -1 })
      .limit(limit);

    const orders = ordersList.map((order, index) => ({
      ...order.toObject(),
      orderCount: total - (skip + index),
    }));

    return {
      total,
      page,
      totalPages: Math.ceil(total / limit),
      orders,
    };
  }

  async getById(orderId: string) {
    return await Order.findById(orderId);
  }

  async update(orderId: string, orderData: any, editorId: string) {
    const order: any = await Order.findById(orderId);

    if (order && editorId) {
      this.updateEditHistory(order, editorId);
    }

    if (orderData?.status === 'Returned' && order.productIds) {
      if (order.status !== 'Returned') {
        for (const product of order.productIds) {
          await this.saveStockData(product.productId.toString(), 'increment');
        }
      }
    }

    Object.assign(order, orderData);

    await order.save();
    return order;
  }

  async delete(orderId: string) {
    return await Order.findByIdAndDelete(orderId);
  }

  async addComment(orderId: string, comment: any) {
    const order: IOrder | any = await Order.findById(orderId);

    const newComment = {
      commenterRole: comment.commenterRole,
      commentText: comment.commentText,
      createdAt: new Date(),
    };

    order.messages.push(newComment);
    await order.save();

    return newComment;
  }

  async getStatusCounts(userId: string) {}

  async getOrdersByStatus(
    status: string,
    page: number = 1,
    limit: number = 10,
  ) {
    const skip = (page - 1) * limit;

    const orders = await Order.find({ status })
      .populate('courierId', '_id name')
      .populate('productIds.productId', 'title')
      .sort({ createdAt: -1 })
      .skip(skip)
      .limit(limit)
      .lean()
      .select('courierId productIds');

    const total = await Order.countDocuments({ status });

    const orderDetails = orders.map((order: any) => ({
      count: orders.length,
      courierName: order.courierId?.name || null,
      products: order.productIds.map((product: any) => ({
        title: product.productId.title,
        quantity: 1,
      })),
    }));

    return {
      total,
      page,
      totalPages: Math.ceil(total / limit),
      orders: orderDetails,
    };
  }

  async getOrdersCountByStatus(status: string) {
    return await Order.countDocuments({ status });
  }
}

export default new OrderService();
