import { connection, connect, disconnect } from 'mongoose';
import { hash } from 'bcryptjs';
import { config } from 'dotenv';
config({ path: '.env' });

async function seedDefaultUser() {
  try {
    if (!connection.readyState) {
      await connect(process.env['MONGO_URL']!);
      console.log('✅ Connected to MongoDB');
    }

    const usersCollection = connection.collection('users');

    const existingAdmin = await usersCollection.findOne({
      username: process.env['DEFAULT_USER_USERNAME']!,
      role: process.env['DEFAULT_USER_ROLE']!,
    });

    if (existingAdmin) {
      console.log('👌 Default user already exists');
      process.exit(0);
    }

    const hashedPassword = await hash(
      process.env['DEFAULT_USER_PASSWORD']!,
      10,
    );

    const defaultUser = {
      name: process.env['DEFAULT_USER_NAME']!,
      username: process.env['DEFAULT_USER_USERNAME']!,
      password: hashedPassword,
      role: process.env['DEFAULT_USER_ROLE']!,
      createdAt: new Date(),
      updatedAt: new Date(),
    };

    await usersCollection.insertOne(defaultUser);

    console.log('✅ Default user created successfully');
    process.exit(0);
  } catch (error) {
    console.error('❌ Error seeding user:', error);
    process.exit(1);
  } finally {
    if (connection.readyState) {
      await disconnect();
      console.log('🔒 Disconnected from MongoDB');
    }
  }
}

void seedDefaultUser();
