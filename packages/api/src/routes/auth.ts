import { Router } from 'express';
import { AuthController } from '../controllers/';
import { limiter } from '../middleware/limiter.middleware';

const router = Router();

router.post('/register', limiter, AuthController.register);
router.post('/login', AuthController.login);
router.post('/refresh', AuthController.refresh);

export default router;
