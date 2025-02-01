import multer from 'multer';
import { randomBytes } from 'node:crypto';
import { extname } from 'node:path';
import { existsSync, mkdirSync } from 'node:fs';

const uploadsDir = 'uploads';
if (!existsSync(uploadsDir)) {
  mkdirSync(uploadsDir);
}

const storage = multer.diskStorage({
  destination: (_req, _file, cb) => {
    cb(null, uploadsDir);
  },
  filename: (_req, file, cb) => {
    const uniqueName = randomBytes(16).toString('hex');
    const fileExt = extname(file.originalname);
    cb(null, uniqueName + fileExt);
  },
});

export const upload = multer({ storage });
