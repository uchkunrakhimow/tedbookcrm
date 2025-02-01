import { type Handler } from 'express';
import { TokenService, UserService } from '../services';
import { IUser } from '../types';

export default class AuthController {
  private static jwtAccessSecret = process.env.JWT_ACCESS_SECRET_KEY!;
  private static jwtRefreshSecret = process.env.JWT_REFRESH_SECRET_KEY!;
  private static jwtAccessExpiresIn =
    process.env.JWT_ACCESS_EXPIRES_IN! || '10d';
  private static jwtRefreshExpiresIn =
    process.env.JWT_REFRESH_EXPIRES_IN! || '30d';

  static login: Handler = async (req, res, next) => {
    try {
      const { username, password } = req.body;

      const existingUser = await UserService.getByUsername(username);

      if (!existingUser) {
        res.status(404).json({ success: false, error: 'User not found' });
      }

      const user: IUser | any = await UserService.validateUserCredentials(
        username,
        password,
      );

      if (!user) {
        res.status(401).json({ success: false, error: 'Incorrect password' });
      }

      if (!user.isActive) {
        res
          .status(403)
          .json({ success: false, error: 'User account is inactive' });
      }

      const tokenPayload = {
        sub: user._id.toString(),
        username: user.username,
        role: user.role,
      };

      const accessToken = TokenService.generateToken(
        tokenPayload,
        AuthController.jwtAccessSecret,
        AuthController.jwtAccessExpiresIn,
      );

      const refreshToken = TokenService.generateToken(
        tokenPayload,
        AuthController.jwtRefreshSecret,
        AuthController.jwtRefreshExpiresIn,
      );

      res.json({
        success: true,
        user: { id: user._id, username: user.username, role: user.role },
        tokens: { accessToken, refreshToken },
      });
    } catch (error) {
      next(error);
    }
  };

  static register: Handler = async (req, res, next) => {
    try {
      const existingUser = await UserService.getByUsername(req.body.username);
      if (existingUser) {
        res.status(409).json({ success: false, error: 'User already exists' });
      }

      const newUser = await UserService.create(req.body);
      res.status(201).json({ success: true, userId: newUser._id });
    } catch (error) {
      next(error);
    }
  };

  static refresh: Handler = async (req, res, next) => {
    const refreshToken = req.body.refreshToken;

    if (!refreshToken) {
      res
        .status(400)
        .json({ success: false, error: 'Refresh token is missing' });
    }

    try {
      const decoded = TokenService.verifyToken(
        refreshToken,
        AuthController.jwtRefreshSecret,
      );

      const accessToken = TokenService.generateToken(
        { user: decoded },
        AuthController.jwtAccessSecret,
        AuthController.jwtAccessExpiresIn,
      );

      res.json({ success: true, user: decoded, accessToken });
    } catch (error) {
      next(error);
    }
  };
}
