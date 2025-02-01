import { Schema } from 'mongoose';

const EditHistorySchema = new Schema(
  {
    editorId: {
      type: Schema.Types.ObjectId,
      ref: 'user',
      required: true,
      autopopulate: true,
    },
    editTime: { type: Date, default: Date.now, required: true },
    editDuration: { type: Number, required: true },
  },
  { _id: false },
);

export default EditHistorySchema;
