import { Schema } from 'mongoose';

const AddressSchema = new Schema(
  {
    region: { type: String },
    district: { type: String },
    city: { type: String },
    landmark: { type: String },
  },
  { _id: false },
);

export default AddressSchema;
