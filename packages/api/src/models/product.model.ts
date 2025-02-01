import { Model, model, Schema } from 'mongoose';
import { IProduct } from '../types';
import mongoosePaginate from 'mongoose-paginate-v2';

const ProductScheme: Schema<IProduct> = new Schema(
  {
    name: {
      type: String,
      required: true,
      trim: true,
    },
    price: {
      type: String,
      required: true,
      trim: true,
    },
  },
  { timestamps: true, versionKey: false, collection: 'products' },
);

ProductScheme.plugin(mongoosePaginate);

const Product: Model<IProduct> = model<IProduct>('product', ProductScheme);
export default Product;
