import { Schema } from 'mongoose';

const MessageSchema = new Schema(
  {
    commenterRole: {
      type: String,
      enum: ['operator', 'courier', 'logistician'],
      required: true,
    },
    commentText: { type: String, required: true },
    createdAt: { type: Date, default: Date.now },
  },
  { _id: false },
);

export default MessageSchema;
