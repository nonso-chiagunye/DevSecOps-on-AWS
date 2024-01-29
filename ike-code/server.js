const mongoose = require('mongoose');
const AWS = require('aws-sdk');

// Log event and exit in case of uncaught exception
process.on('uncaughtException', (err) => {
  console.log('UNCAUGHT EXCEPTION! 💥 Shutting down...');
  console.log(err.name, err.message);
  process.exit(1);
});

AWS.config.update({ region: 'your-region' });

async function fetchSecrets() {
  const secretsManager = new AWS.SecretsManager();
  const secretName = 'your-secret-name';

  try {
    const data = await secretsManager
      .getSecretValue({ SecretId: secretName })
      .promise();

    if ('SecretString' in data) {
      const secrets = JSON.parse(data.SecretString);

      // Return the secrets
      return secrets;
    }
  } catch (err) {
    console.error('Error retrieving secrets:', err);
    throw err; // Rethrow the error to be caught in the calling function
  }
}

const app = require('./app');

// Usage
(async () => {
  try {
    const secrets = await fetchSecrets();

    process.env.NODE_ENV = secrets.NODE_ENV;
    process.env.PORT = secrets.PORT;
    process.env.DATABASE = secrets.DATABASE;
    process.env.DATABASE_PASSWORD = secrets.DATABASE_PASSWORD;
    process.env.JWT_SECRET = secrets.JWT_SECRET;
    process.env.JWT_EXPIRES_IN = secrets.JWT_EXPIRES_IN;
    process.env.JWT_COOKIE_EXPIRES_IN = secrets.JWT_COOKIE_EXPIRES_IN;
    process.env.EMAIL_USERNAME = secrets.EMAIL_USERNAME;
    process.env.EMAIL_PASSWORD = secrets.EMAIL_PASSWORD;
    process.env.EMAIL_HOST = secrets.EMAIL_HOST;
    process.env.EMAIL_PORT = secrets.EMAIL_PORT;
    process.env.EMAIL_FROM = secrets.EMAIL_FROM;
    process.env.BREVO_HOST = secrets.BREVO_HOST;
    process.env.BREVO_PORT = secrets.BREVO_PORT;
    process.env.BREVO_USERNAME = secrets.BREVO_USERNAME;
    process.env.BREVO_PASSWORD = secrets.BREVO_PASSWORD;
    process.env.STRIPE_SECRET_KEY = secrets.STRIPE_SECRET_KEY;
    process.env.STRIPE_WEBHOOK_SECRET = secrets.STRIPE_WEBHOOK_SECRET;
    process.env.STRIPE_PUBLIC_KEY = secrets.STRIPE_PUBLIC_KEY;

    const DB = process.env.DATABASE.replace(
      '<PASSWORD>',
      process.env.DATABASE_PASSWORD,
    );

    mongoose
      .connect(DB, {
        // Connect to the db
        useNewUrlParser: true,
        useCreateIndex: true,
        useFindAndModify: false,
        useUnifiedTopology: true,
      })
      .then(() => console.log('Connection to DB was successful!'));

    const port = process.env.PORT || 3000;

    const server = app.listen(port, () => {
      console.log(`App running on port ${port}...`);

      process.on('unhandledRejection', (err) => {
        console.log('UNHANDLED REJECTION! 💥 Shutting down...');
        console.log(err.name, err.message);
        server.close(() => {
          process.exit(1);
        });
      });
    });
  } catch (error) {
    console.error('Error:', error);
    process.exit(1);
  }
})();
