import { type Handler } from 'express';
import { UserService } from '../services';

export default class UserController {
  static store: Handler = async (req, res, next) => {
    try {
      const { username } = req.body;
      const existingUser = await UserService.getByUsername(username);

      if (existingUser) {
        res.status(409).json({ error: 'User already exists' });
      }

      const newUser: any = await UserService.create(
        req.body,
        req.file ? req.file : '',
      );

      res.status(201).json({ success: true, userId: newUser._id });
    } catch (error: unknown) {
      next(error);
    }
  };

  static show: Handler = async (req, res, next) => {
    try {
      const { id } = req.params;

      const user: any = await UserService.getById(id);

      if (!user) {
        res.sendStatus(404);
      }

      const userProfile = {
        id: user._id,
        name: user.name,
        username: user.username,
        role: user.role,
        isBoss: user.isBoss,
        profilePic: user.profilePic,
      };

      res.json(userProfile);
    } catch (error: unknown) {
      next(error);
    }
  };

  static index: Handler = async (req: any, res, next) => {
    try {
      const {
        page = '1',
        limit = '10',
        role = 'all',
        bossId,
        search,
      } = req.query;

      const pageNumber = Number.isNaN(parseInt(page as string, 10))
        ? 1
        : parseInt(page as string, 10);
      const limitNumber = Number.isNaN(parseInt(limit as string, 10))
        ? 10
        : parseInt(limit as string, 10);

      if (bossId) {
        const user: any = await UserService.getById(bossId as string);

        if (!user) {
          res.sendStatus(404);
        }

        res.json({
          success: true,
          bossId: user._id,
          assistants: user.assistants ?? [],
        });
      }

      const filter = role !== 'all' ? { role } : {};

      const totalUsers = await UserService.getCount(filter);
      const totalPages = Math.ceil(totalUsers / limitNumber);

      const users = await UserService.getUsers(
        filter,
        pageNumber,
        limitNumber,
        search,
      );

      res.json({
        currentPage: pageNumber,
        totalPages,
        totalUsers,
        users,
      });
    } catch (error: unknown) {
      next(error);
    }
  };

  static update: Handler = async (req, res, next) => {
    try {
      const { id } = req.params;

      const updatedUser: any = await UserService.update(id, req.body);

      if (!updatedUser) {
        res.sendStatus(404);
      }

      res.json({
        success: true,
        user: updatedUser,
      });
    } catch (error: unknown) {
      next(error);
    }
  };

  static updateProfile: Handler = async (req, res, next) => {
    try {
      const { id } = req.params;

      const updatedUser: any = await UserService.updateProfile(
        id,
        req.file ? req.file : '',
      );

      const { password, ...userWithoutPassword } = updatedUser;

      res.json({
        success: true,
        user: userWithoutPassword,
      });
    } catch (error: unknown) {
      next(error);
    }
  };

  static destroy: Handler = async (req, res, next) => {
    try {
      const { id } = req.params;
      const deletedUser = await UserService.delete(id);

      if (!deletedUser) {
        res.sendStatus(404);
      }

      res.sendStatus(204);
    } catch (error: unknown) {
      next(error);
    }
  };
}
