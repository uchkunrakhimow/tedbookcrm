import { type Handler } from 'express';
import { DashboardService, UserService } from '../services';
import { IUser } from '../types';

export default class DashboardController {
  static index: Handler = async (req, res, next) => {
    const { userId, userRole, timeRange, startDateString, endDateString } =
      req.query;

    const startDate = startDateString
      ? new Date(startDateString as string)
      : undefined;
    const endDate = endDateString
      ? new Date(endDateString as string)
      : undefined;

    try {
      const user: IUser | any = await UserService.getById(userId as string);

      if (!user) {
        res.status(404).json({ message: 'User not found' });
      }

      if (user.role !== userRole) {
        res.status(403).json({ message: 'User role mismatch' });
      }

      const orderStats = await DashboardService.getStats(
        user._id,
        user.role,
        timeRange as string,
        startDate as any,
        endDate as any,
      );

      if (
        !orderStats ||
        !Object.values(orderStats).some((val) =>
          Array.isArray(val) ? val.length : val,
        )
      ) {
        res.sendStatus(204);
      }

      res.json({
        success: true,
        data: orderStats,
      });
    } catch (error: unknown) {
      next(error);
    }
  };
}
