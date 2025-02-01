import { Schema } from 'mongoose';

const PaymentSchema = new Schema(
  {
    method: { type: String, enum: ['cash', 'card'], required: true },
    amount: { type: Number, required: true, min: 0 },
  },
  { _id: false },
);

export default PaymentSchema;
