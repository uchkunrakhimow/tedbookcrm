import { model, Model, Schema } from 'mongoose';
import { IWarehouseHistory } from '../types';
import mongooseAutoPopulate from 'mongoose-autopopulate';

const WarehouseHistorySchema: Schema<IWarehouseHistory> = new Schema(
  {
    product: {
      type: Schema.Types.ObjectId,
      ref: 'product',
      required: true,
      autopopulate: true,
    },
    user: {
      type: Schema.Types.ObjectId,
      ref: 'user',
      required: true,
      autopopulate: true,
    },
    changeType: {
      type: String,
      enum: ['add', 'update', 'remove'],
      required: true,
    },
    quantity: {
      type: Number,
      required: true,
    },
  },
  { timestamps: true, versionKey: false, collection: 'stock_history' },
);

const WarehouseHistory: Model<IWarehouseHistory> = model<IWarehouseHistory>(
  'warehouse_history',
  WarehouseHistorySchema,
);

WarehouseHistorySchema.plugin(mongooseAutoPopulate);

export default WarehouseHistory;
