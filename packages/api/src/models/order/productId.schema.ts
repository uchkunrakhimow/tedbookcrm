import { Schema } from 'mongoose';

const ProductIdSchema = new Schema(
  {
    productId: {
      type: Schema.Types.ObjectId,
      ref: 'product',
      required: true,
      autopopulate: true,
    },
    discount: Number,
    price: Number,
  },
  { _id: false },
);

export default ProductIdSchema;
