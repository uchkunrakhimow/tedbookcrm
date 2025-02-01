import { Model, model, Schema } from 'mongoose';
import { IUser } from '../types';
import mongoosePaginate from 'mongoose-paginate-v2';
import mongooseAutoPopulate from 'mongoose-autopopulate';

const UserSchema: Schema<IUser> = new Schema(
  {
    name: {
      type: String,
      required: true,
      trim: true,
    },
    username: {
      type: String,
      required: true,
      unique: true,
      trim: true,
    },
    salary: {
      type: Number,
    },
    password: {
      type: String,
      required: true,
    },
    role: {
      type: String,
      required: true,
      enum: [
        'admin',
        'operator',
        'logistician',
        'courier',
        'warehouse',
        'accountant',
      ],
    },
    isBoss: {
      type: Boolean,
      default: false,
    },
    shift: {
      type: Number,
    },
    assistants: [
      {
        type: Schema.Types.ObjectId,
        ref: 'user',
      },
    ],
    isActive: {
      type: Boolean,

      default: true,
    },
    profilePic: {
      type: String,
    },
  },
  { timestamps: true, versionKey: false, collection: 'users' },
);

UserSchema.methods.toJSON = function () {
  const obj = this.toObject();
  delete obj.password;
  return obj;
};

UserSchema.plugin(mongoosePaginate);
UserSchema.plugin(mongooseAutoPopulate);

const User: Model<IUser> = model<IUser>('user', UserSchema);
export default User;
