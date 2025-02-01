import type { Document, Schema, Types } from 'mongoose';

export interface OrderStats {
  newOrders: number;
  inReviewOrders: number;
  canceledOrders: number;
  orderList: OrderDetail[];
}

export interface OrderDetail {
  orderId: string;
  products: string[];
  customerName: string;
  customerPhone: string;
}

export interface LogisticStats {
  pendingOrders: number;
  confirmedOrders: number;
  canceledOrders: number;
  deliveredOrders: OrderDetail[];
}

export interface CourierStats {
  pendingDeliveries: number;
  successfulDeliveries: number;
  canceledDeliveries: number;
}

export interface AdminStats {
  totalOrders: number;
  orderStatuses: Record<string, number>;
  userActivity: UserActivity[];
}

export interface UserActivity {
  userId: string;
  role: string;
  orderCount: number;
  efficiency: number;
}

export interface DashboardData {
  operatorStats?: OrderStats;
  logisticStats?: LogisticStats;
  courierStats?: CourierStats;
  adminStats?: AdminStats;
}

export interface IOrder extends Document {
  staff: {
    operatorId: Types.ObjectId;
    courierId?: Types.ObjectId;
    logisticianId?: Types.ObjectId;
  };
  fullName: string;
  phone: {
    number: string;
    number2: string;
  };
  status?: 'pending' | 'pending_courier' | 'delivered' | 'canceled';
  productIds: {
    productId: Types.ObjectId;
    discount?: number;
    price?: number;
  }[];
  address?: {
    region?: string;
    district?: string;
    city?: string;
    landmark?: string;
  };
  payments?: {
    method: 'cash' | 'card';
    price: number;
  }[];
  messages?: {
    commenterRole: 'operator' | 'courier' | 'logistician';
    commentText: string;
    createdAt?: Date;
  }[];
  editHistory?: {
    editorId: Types.ObjectId;
    editTime: Date;
    editDuration: number;
  }[];
  createdAt?: Date;
  updatedAt?: Date;
}

export interface IUser extends Document {
  _id: string;
  name: string;
  username: string;
  salary?: number;
  password: string;
  role: 'admin' | 'logistician' | 'courier' | 'accountant' | 'operator';
  isBoss?: boolean;
  shift?: number;
  assistants?: Types.ObjectId[];
  isActive?: boolean;
  profilePic: string;
  createdAt?: Date;
  updatedAt?: Date;
}

export interface IProduct extends Document {
  _id: string;
  name: string;
  price: string;
  comment?: string;
  createdAt?: Date;
  updatedAt?: Date;
}

export interface IWarehouse extends Document {
  _id: string;
  user: Schema.Types.ObjectId;
  product: Schema.Types.ObjectId;
  quantity: number;
  price: string;
  createdAt?: Date;
  updatedAt?: Date;
}

export interface IWarehouseHistory extends Document {
  _id: string;
  product: Schema.Types.ObjectId;
  user: Schema.Types.ObjectId;
  changeType: 'add' | 'update' | 'remove';
  quantity: number;
  createdAt?: Date;
  updatedAt?: Date;
}
