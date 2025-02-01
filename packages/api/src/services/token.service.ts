import { sign, verify } from 'jsonwebtoken';

class TokenService {
  generateToken(payload: any, secret: string, expiresIn: string): string {
    return sign(payload, secret, { expiresIn });
  }
  verifyToken(token: string, secret: string): any {
    return verify(token, secret);
  }
}

export default new TokenService();
