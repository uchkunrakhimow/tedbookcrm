import crypto from 'node:crypto';
import { Telegraf } from 'telegraf';
import { infoLogger } from './logger';

const TELEGRAM_BOT_TOKEN = process.env['BOT_TOKEN']!;
const TELEGRAM_CHAT_ID = process.env['BOT_CHAT_ID']!;

const bot = new Telegraf(TELEGRAM_BOT_TOKEN);

export default async function errorNotifier(error: Error) {
  const errorID = crypto.randomBytes(3).toString('hex').slice(0, 5);
  const errorLog = {
    id: errorID,
    message: error.message || 'Unknown error',
    stack: error.stack || '',
  };

  const message = `
🚨 *Error Logged* 🚨

*ID*: #${errorLog.id}
*Message*: ${errorLog.message}
*Stack*: \`${errorLog.stack}\`
  `;
  try {
    await bot.telegram.sendMessage(TELEGRAM_CHAT_ID, message, {
      parse_mode: 'Markdown',
    });
  } catch (err) {
    infoLogger.warn('Failed to send error notification to Telegram:', err);
  }
}
