import { type Handler } from 'express';
import { LocationService } from '../services';

export default class LocationController {
  static index: Handler = async (req, res, next) => {
    try {
      const page = parseInt(req.query.page as string) || 1;
      const limit = parseInt(req.query.limit as string) || 10;

      const locations = await LocationService.getAll(page, limit);

      if (locations.locations.length === 0) {
        res.sendStatus(204);
      }

      res.json(locations);
    } catch (error: unknown) {
      next(error);
    }
  };
}
