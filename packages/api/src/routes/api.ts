import { Router } from 'express';

import {
  AccountantController,
  DashboardController,
  OrderController,
  LocationController,
  ProductController,
  WarehouseController,
  WarehouseDashboardController,
  WarehouseHistoryController,
  UserController,
  TokenController,
} from '../controllers/';

import { upload } from '../middleware/upload.middleware';

const router = Router();

// User routes
router
  .route('/user')
  .get(UserController.index)
  .post(upload.single('profilePic'), UserController.store);

router
  .route('/user/:id')
  .get(UserController.show)
  .put(upload.none(), UserController.update)
  .post(upload.single('profilePic'), UserController.updateProfile)
  .delete(UserController.destroy);

// Order routes
router.route('/order').get(OrderController.index).post(OrderController.store);

router
  .route('/order/:id')
  .get(OrderController.show)
  .put(OrderController.update)
  .delete(OrderController.destroy);

router.get('/order/user/:userId', OrderController.getByUserId);
router
  .route('/order/comments/:id')
  .post(OrderController.addMessage)
  .get(OrderController.getComments);
router.get('/order/status/:userId', OrderController.getStatusCounts);

// Product routes
router
  .route('/product')
  .get(ProductController.index)
  .post(ProductController.store);

router
  .route('/product/:id')
  .put(ProductController.update)
  .delete(ProductController.destroy);

// Location routes
router.get('/location', LocationController.index);

// Dashboard routes
router.get('/dashboard', DashboardController.index);

// Accountant routes
router.get('/accountant', AccountantController.index);

// Token route
router.post('/set-token', TokenController.store);

// Warehouse routes
router
  .route('/warehouse')
  .get(WarehouseController.index)
  .post(WarehouseController.store);

router
  .route('/warehouse/:id')
  .put(WarehouseController.update)
  .delete(WarehouseController.destroy);

router.get('/warehouse/dashboard', WarehouseDashboardController.index);
router.get('/warehouse/history', WarehouseHistoryController.index);

export default router;
