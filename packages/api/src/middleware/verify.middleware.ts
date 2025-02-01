import { NextFunction, Request, Response } from 'express';
import { JwtPayload, verify } from 'jsonwebtoken';
import { TokenService } from '../services';
import { getRefreshToken } from '../helpers';

const jwtAccessSecret = process.env.JWT_ACCESS_SECRET_KEY!;
const jwtRefreshSecret = process.env.JWT_REFRESH_SECRET_KEY!;
const jwtAccessExpiresIn = process.env.JWT_ACCESS_EXPIRES_IN!;

export default function verifyToken(
  req: any,
  res: Response,
  next: NextFunction,
) {
  const accessToken = req.headers['authorization'];

  if (!accessToken) {
    if (!res.headersSent) {
      res
        .status(401)
        .json({ message: 'Access Denied. No access token provided.' });
    }
    return;
  }

  try {
    const decoded = verify(accessToken, jwtAccessSecret) as JwtPayload;
    req.user = decoded;
    next();
  } catch (error: unknown) {
    if ((error as any).name === 'TokenExpiredError') {
      handleExpiredAccessToken(req, res).then(() => next());
    } else {
      if (!res.headersSent) {
        res.status(401).json({ message: 'Invalid access token.' });
      }
    }
  }
}

const handleExpiredAccessToken = async (req: Request, res: Response) => {
  const headerRefreshToken = req.headers['cookie'];

  if (!headerRefreshToken) {
    if (!res.headersSent) {
      res
        .status(401)
        .json({ message: 'Session expired. Please log in again.' });
    }
    return;
  }

  const refreshToken: any = getRefreshToken(headerRefreshToken);

  try {
    const decoded = verify(refreshToken, jwtRefreshSecret) as JwtPayload;
    const newAccessToken = TokenService.generateToken(
      { user: decoded },
      jwtAccessSecret,
      jwtAccessExpiresIn,
    );

    res.json({
      message: 'Your access token has expired. Here is a new one.',
      user: decoded,
      tokens: {
        accessToken: newAccessToken,
        refreshToken,
      },
    });
  } catch (_error: unknown) {
    if (!res.headersSent) {
      res.status(401).json({
        message: 'Invalid refresh token.',
      });
    }
  }
};
