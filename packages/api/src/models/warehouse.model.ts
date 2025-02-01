import { Model, model, Schema } from 'mongoose';
import { IWarehouse } from '../types';
import mongoosePaginate from 'mongoose-paginate-v2';
import mongooseAutoPopulate from 'mongoose-autopopulate';

const WarehouseSchema: Schema<IWarehouse> = new Schema(
  {
    user: {
      type: Schema.Types.ObjectId,
      ref: 'user',
      required: true,
      autopopulate: true,
    },
    product: {
      type: Schema.Types.ObjectId,
      ref: 'product',
      required: true,
      autopopulate: true,
    },
    quantity: {
      type: Number,
      required: true,
      min: 1,
    },
    price: {
      type: String,
    },
  },
  { timestamps: true, versionKey: false, collection: 'stock' },
);

const Warehouse: Model<IWarehouse> = model<IWarehouse>(
  'warehouse',
  WarehouseSchema,
);

WarehouseSchema.plugin(mongoosePaginate);
WarehouseSchema.plugin(mongooseAutoPopulate);

export default Warehouse;
