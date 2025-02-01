import { connection, connect, disconnect } from 'mongoose';
import { config } from 'dotenv';
config({ path: '.env' });

async function drop() {
  try {
    if (!connection.readyState) {
      await connect(process.env['MONGO_URL']!);
      console.log('✅ Connected to MongoDB');
    }

    const db = connection.db;
    if (!db) {
      throw new Error('❌ Failed to get the database connection');
    }

    const collections = await db.listCollections().toArray();
    console.log(
      '✅ Collections found:',
      collections.map((c) => c.name),
    );

    for (const collection of collections) {
      if (collection.name !== 'users') {
        await db.collection(collection.name).drop();
        console.log(`✅ Collection ${collection.name} has been dropped.`);
      }
    }

    console.log('✅ All collections except "users" have been cleared.');
    process.exit(0);
  } catch (error) {
    console.error('❌ Error clearing the database:', error);
    process.exit(1);
  } finally {
    if (connection.readyState) {
      await disconnect();
      console.log('🔒 Disconnected from MongoDB');
    }
  }
}

void drop();
