import { Schema } from 'mongoose';

const StaffSchema = new Schema(
  {
    operatorId: { type: Schema.Types.ObjectId, ref: 'user', required: true },
    courierId: { type: Schema.Types.ObjectId, ref: 'user' },
    logisticianId: { type: Schema.Types.ObjectId, ref: 'user' },
  },
  { _id: false },
);

export default StaffSchema;
