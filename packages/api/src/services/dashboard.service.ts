import { Order } from '../models';
import { getDateRange } from '../helpers';

class DashboardService {
  async getStats(
    userId: string | null,
    roleField?: string | null,
    timeRange?: string,
    startDate?: Date,
    endDate?: Date,
  ) {
    const matchCondition: any = {};
    if (startDate != null && endDate != null) {
      matchCondition.createdAt = { $gte: startDate, $lte: endDate };
    } else {
      const dateRange = getDateRange(timeRange as string);
      matchCondition.createdAt = {
        $gte: dateRange.startDate,
        $lte: dateRange.endDate,
      };
    }

    if (roleField !== 'admin' && roleField !== 'accountant') {
      if (userId) {
        matchCondition.$or = [
          { operatorId: userId },
          { courierId: userId },
          { logisticianId: userId },
        ];
      }
    }

    const statusCounts = await Order.aggregate([
      { $match: matchCondition },
      {
        $group: {
          _id: '$status',
          count: { $sum: 1 },
        },
      },
      {
        $project: {
          _id: 0,
          status: '$_id',
          count: 1,
        },
      },
    ]);

    const regionCounts = await Order.aggregate([
      { $match: matchCondition },
      {
        $group: {
          _id: '$region',
          count: { $sum: 1 },
        },
      },
      {
        $project: {
          _id: 0,
          region: '$_id',
          count: 1,
        },
      },
    ]);

    const productCounts = await Order.aggregate([
      { $match: matchCondition },
      { $unwind: '$productIds.product' },
      {
        $group: {
          _id: '$productIds.product',
          count: { $sum: 1 },
        },
      },
      {
        $lookup: {
          from: 'products',
          localField: '_id',
          foreignField: '_id',
          as: 'productDetails',
        },
      },
      {
        $unwind: {
          path: '$productDetails',
          preserveNullAndEmptyArrays: true,
        },
      },
      {
        $project: {
          _id: 0,
          title: '$productDetails.title',
          count: 1,
        },
      },
    ]);

    const orders = await Order.aggregate([
      { $match: matchCondition },
      {
        $group: {
          _id: {
            userId: '$operatorId',
            status: '$status',
            region: '$region',
          },
          productIds: { $push: '$productIds.product' },
          orderCount: { $sum: 1 },
        },
      },
      {
        $addFields: {
          productIds: {
            $reduce: {
              input: '$productIds',
              initialValue: [],
              in: { $concatArrays: ['$$value', '$$this'] },
            },
          },
        },
      },
      {
        $lookup: {
          from: 'users',
          localField: '_id.userId',
          foreignField: '_id',
          as: 'user',
        },
      },
      { $unwind: '$user' },
      {
        $lookup: {
          from: 'products',
          localField: 'productIds',
          foreignField: '_id',
          as: 'products',
        },
      },
      {
        $project: {
          userId: '$user._id',
          userName: '$user.name',
          orderCount: 1,
          status: '$_id.status',
          region: '$_id.region',
          products: {
            $map: {
              input: '$products',
              as: 'product',
              in: {
                _id: '$$product._id',
                title: '$$product.title',
                count: {
                  $size: {
                    $filter: {
                      input: '$productIds',
                      as: 'pid',
                      cond: { $eq: ['$$pid', '$$product._id'] },
                    },
                  },
                },
              },
            },
          },
        },
      },
    ]);

    const mostActiveUser = await Order.aggregate([
      { $match: matchCondition },
      { $group: { _id: '$operatorId', count: { $sum: 1 } } },
      {
        $lookup: {
          from: 'users',
          localField: '_id',
          foreignField: '_id',
          as: 'user',
        },
      },
      { $unwind: '$user' },
      { $sort: { count: -1 } },
      { $limit: 1 },
      { $project: { _id: '$user._id', count: 1, userName: '$user.name' } },
    ]);

    const mostActiveRegion = await Order.aggregate([
      { $match: matchCondition },
      { $group: { _id: '$region', count: { $sum: 1 } } },
      { $sort: { count: -1 } },
      { $limit: 1 },
      { $project: { _id: 1, count: 1, region: '$_id' } },
    ]);

    const bestSellingProduct = await Order.aggregate([
      { $match: matchCondition },
      { $unwind: '$productIds.product' },
      { $group: { _id: '$productIds.product', count: { $sum: 1 } } },
      {
        $lookup: {
          from: 'products',
          localField: '_id',
          foreignField: '_id',
          as: 'productDetails',
        },
      },
      { $unwind: '$productDetails' },
      { $sort: { count: -1 } },
      { $limit: 1 },
      {
        $project: {
          _id: '$productDetails._id',
          count: 1,
          productName: '$productDetails.title',
        },
      },
    ]);

    return {
      status: statusCounts,
      region: regionCounts,
      products: productCounts,
      orders: orders.map((order) => ({
        userId: order.userId,
        userName: order.userName,
        orderCount: order.orderCount,
        status: order.status,
        region: order.region,
        products: order.products.map((product: any) => ({
          _id: product._id,
          title: product.title,
          count: product.count,
        })),
      })),
      mostActiveUser: mostActiveUser[0] || null,
      mostActiveRegion: mostActiveRegion[0] || null,
      bestSellingProduct: bestSellingProduct[0] || null,
    };
  }

  async getOrderCountsByRoles() {
    const operatorOrders = await Order.aggregate([
      { $match: { operatorId: { $ne: null } } },
      {
        $group: {
          _id: '$operatorId',
          count: { $sum: 1 },
        },
      },
      {
        $lookup: {
          from: 'users',
          localField: '_id',
          foreignField: '_id',
          as: 'user',
        },
      },
      {
        $unwind: '$user',
      },
      {
        $project: {
          _id: 0,
          userId: '$_id',
          name: '$user.name',
          count: 1,
        },
      },
    ]);

    const courierOrders = await Order.aggregate([
      { $match: { courierId: { $ne: null } } },
      {
        $group: {
          _id: '$courierId',
          count: { $sum: 1 },
        },
      },
      {
        $lookup: {
          from: 'users',
          localField: '_id',
          foreignField: '_id',
          as: 'user',
        },
      },
      {
        $unwind: '$user',
      },
      {
        $project: {
          _id: 0,
          userId: '$_id',
          name: '$user.name',
          count: 1,
        },
      },
    ]);

    const logisticianOrders = await Order.aggregate([
      { $match: { logisticianId: { $ne: null } } },
      {
        $group: {
          _id: '$logisticianId',
          count: { $sum: 1 },
        },
      },
      {
        $lookup: {
          from: 'users',
          localField: '_id',
          foreignField: '_id',
          as: 'user',
        },
      },
      {
        $unwind: '$user',
      },
      {
        $project: {
          _id: 0,
          userId: '$_id',
          name: '$user.name',
          count: 1,
        },
      },
    ]);

    return {
      operatorOrders,
      courierOrders,
      logisticianOrders,
    };
  }
}

export default new DashboardService();
