import bcrypt from 'bcryptjs';
import { User } from '../models';
import { IUser } from '../types/';

class UserService {
  async validateUserCredentials(username: string, password: string) {
    const user = await User.findOne({ username }).lean();
    if (!user) return null;

    const isPasswordValid = await bcrypt.compare(password, user.password);
    return isPasswordValid ? user : null;
  }

  async create(userData: IUser, file?: any) {
    if (userData.password) {
      userData.password = await bcrypt.hash(userData.password, 10);
    }

    if (file) {
      userData.profilePic = file.path;
    }

    const newUser = new User(userData);
    return await newUser.save();
  }

  async getAll() {
    return await User.find().lean().sort({ createdAt: -1 });
  }

  async getById(userId: string) {
    return await User.findById(userId).lean();
  }

  async getUsers(
    filter: Record<string, any>,
    page: number = 1,
    limit: number = 10,
    search: string = '',
  ) {
    const skip = (page - 1) * limit;
    if (search) {
      filter.$or = [
        { name: { $regex: search, $options: 'i' } },
        { username: { $regex: search, $options: 'i' } },
      ];
    }

    return await User.find(filter)
      .skip(skip)
      .limit(limit)
      .populate({
        path: 'assistants',
      })
      .sort({ createdAt: -1 })
      .lean();
  }

  async getCount(filter: Record<string, any>) {
    return await User.countDocuments(filter);
  }

  async getByUsername(username: string) {
    return await User.findOne({ username }).lean();
  }

  async update(userId: string, userData: Partial<IUser>) {
    if (userData.password) {
      userData.password = await bcrypt.hash(userData.password, 10);
    }

    return await User.findByIdAndUpdate(userId, userData, {
      new: true,
      lean: true,
    });
  }

  async updateProfile(userId: string, file?: any) {
    const updateData = file ? { profilePic: file.path } : {};
    return await User.findByIdAndUpdate(userId, updateData, {
      new: true,
      lean: true,
    });
  }

  async delete(userId: string) {
    return await User.findByIdAndDelete(userId).lean();
  }
}

export default new UserService();
