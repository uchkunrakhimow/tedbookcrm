import admin from 'firebase-admin';

export default async function sendNotification(
  title: string,
  body: string,
  token: string,
) {
  const payload = {
    notification: { title, body },
    token,
  };
  return admin.messaging().send(payload);
}
