import { Model, model, Schema } from 'mongoose';
import EditHistorySchema from './order/editHistory.schema';
import MessageSchema from './order/messages.schema';
import PaymentSchema from './order/payments.schema';
import ProductIdSchema from './order/productId.schema';
import StaffSchema from './order/staff.schema';
import AddressSchema from './order/address.schema';
import type { IOrder } from '../types';
import mongoosePaginate from 'mongoose-paginate-v2';
import mongooseAutoPopulate from 'mongoose-autopopulate';

const OrderSchema: Schema<IOrder> = new Schema(
  {
    staff: { type: StaffSchema, required: true, autopopulate: true },
    fullName: { type: String, required: true, trim: true },
    phone: { number: { type: String, required: true }, number2: String },
    status: {
      type: String,
      enum: ['pending', 'pending_courier', 'delivered', 'canceled'],
      default: 'pending',
    },
    productIds: [ProductIdSchema],
    address: {
      type: AddressSchema,
    },
    payments: [PaymentSchema],
    messages: [MessageSchema],
    editHistory: [EditHistorySchema],
  },
  { timestamps: true, versionKey: false, collection: 'orders' },
);

OrderSchema.plugin(mongoosePaginate);
OrderSchema.plugin(mongooseAutoPopulate);

const Order: Model<IOrder> = model<IOrder>('order', OrderSchema);
export default Order;
