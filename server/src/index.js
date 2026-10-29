import 'dotenv/config';
import fs from 'node:fs';
import cors from 'cors';
import express from 'express';
import admin from 'firebase-admin';
import multer from 'multer';
import {
  CreateBucketCommand,
  PutBucketPolicyCommand,
  PutObjectCommand,
  S3Client,
} from '@aws-sdk/client-s3';

const app = express();
const upload = multer({
  storage: multer.memoryStorage(),
  limits: { fileSize: 5 * 1024 * 1024 },
});

const serviceAccount = JSON.parse(
  fs.readFileSync(process.env.FIREBASE_SERVICE_ACCOUNT_PATH, 'utf8'),
);
admin.initializeApp({ credential: admin.credential.cert(serviceAccount) });

const minio = new S3Client({
  endpoint: process.env.MINIO_ENDPOINT,
  region: 'us-east-1',
  forcePathStyle: true,
  credentials: {
    accessKeyId: process.env.MINIO_ACCESS_KEY,
    secretAccessKey: process.env.MINIO_SECRET_KEY,
  },
});

app.use(cors());

async function ensureBucket() {
  try {
    await minio.send(new CreateBucketCommand({ Bucket: process.env.MINIO_BUCKET }));
  } catch (error) {
    if (error.name !== 'BucketAlreadyOwnedByYou') throw error;
  }
  await minio.send(new PutBucketPolicyCommand({
    Bucket: process.env.MINIO_BUCKET,
    Policy: JSON.stringify({
      Version: '2012-10-17',
      Statement: [{
        Effect: 'Allow',
        Principal: '*',
        Action: ['s3:GetObject'],
        Resource: `arn:aws:s3:::${process.env.MINIO_BUCKET}/avatars/*`,
      }],
    }),
  }));
}

async function authenticate(req, res, next) {
  const header = req.header('Authorization');
  if (!header?.startsWith('Bearer ')) {
    return res.status(401).json({ error: 'Thiếu Firebase ID token.' });
  }
  try {
    req.user = await admin.auth().verifyIdToken(header.substring(7));
    next();
  } catch {
    return res.status(401).json({ error: 'Firebase ID token không hợp lệ.' });
  }
}

app.post('/upload-avatar', authenticate, upload.single('avatar'), async (req, res) => {
  if (!req.file) {
    return res.status(400).json({
      error: 'Vui lòng gửi một file ảnh với field "avatar".',
    });
  }
  if (!req.file.mimetype?.startsWith('image/')) {
    return res.status(400).json({ error: 'File gửi lên không phải ảnh.' });
  }

  const key = `avatars/${req.user.uid}/profile-${Date.now()}`;
  try {
    await minio.send(new PutObjectCommand({
      Bucket: process.env.MINIO_BUCKET,
      Key: key,
      Body: req.file.buffer,
      ContentType: req.file.mimetype,
    }));
    const publicEndpoint = process.env.MINIO_PUBLIC_ENDPOINT.replace(/\/$/, '');
    return res.json({
      avatarUrl: `${publicEndpoint}/${process.env.MINIO_BUCKET}/${key}`,
    });
  } catch (error) {
    console.error('MinIO upload failed:', error);
    return res.status(502).json({ error: 'Không thể lưu ảnh vào MinIO.' });
  }
});

ensureBucket()
  .then(() => {
    app.listen(process.env.PORT || 3000, () => {
      console.log(`Avatar API listening on port ${process.env.PORT || 3000}`);
    });
  })
  .catch((error) => {
    console.error('MinIO initialization failed:', error);
    process.exitCode = 1;
  });
