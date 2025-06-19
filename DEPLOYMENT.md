# Deployment Guide for Render

This guide will walk you through deploying your Django application to Render.

## Prerequisites

1. A Render account (sign up at [render.com](https://render.com/))
2. A GitHub/GitLab account with your code in a repository
3. Python 3.10.x installed locally

## Environment Variables

Create a `.env` file in your project root with the following variables:

```bash
# Copy the content from env.example and update with your actual values
cp env.example .env
```

## Deployment Steps

1. **Push your code to a Git repository**
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git remote add origin <your-repository-url>
   git push -u origin main
   ```

2. **Deploy to Render**
   - Go to [Render Dashboard](https://dashboard.render.com/)
   - Click "New +" and select "Web Service"
   - Connect your GitHub/GitLab repository
   - Configure your service:
     - Name: `your-service-name`
     - Region: Choose the one closest to your users
     - Branch: `main` (or your preferred branch)
     - Build Command: `chmod +x build.sh && ./build.sh`
     - Start Command: `chmod +x start.sh && ./start.sh`
   - Add environment variables from your `.env` file
   - Click "Create Web Service"

## Required Environment Variables

Make sure to set these environment variables in your Render dashboard:

- `DJANGO_SETTINGS_MODULE`: `myproject.production_settings`
- `PYTHON_VERSION`: `3.10.12`
- `DEBUG`: `False` (for production)
- `SECRET_KEY`: A secure secret key
- `ALLOWED_HOSTS`: Your Render URL (e.g., `your-service.onrender.com`)
- `DATABASE_URL`: Your database connection string (if using external database)
- `CSRF_TRUSTED_ORIGINS`: `https://your-service.onrender.com`

## Database Setup

For production, it's recommended to use Render's PostgreSQL database:

1. In the Render Dashboard, go to "New +" and select "PostgreSQL"
2. Configure your database
3. Copy the external database URL and set it as `DATABASE_URL` in your environment variables

## Custom Domains (Optional)

To use a custom domain:

1. Go to your web service in the Render Dashboard
2. Click on "Settings" > "Custom Domains"
3. Add your domain and follow the DNS configuration instructions

## Monitoring

- View logs in the Render Dashboard under your web service
- Set up alerts for errors and performance issues

## Troubleshooting

- **Build fails**: Check the build logs in the Render Dashboard
- **Application not starting**: Check the application logs
- **Static files not loading**: Ensure `whitenoise` is properly configured
- **Database connection issues**: Verify your `DATABASE_URL` is correct

## Security Considerations

- Never commit `.env` or any sensitive information to version control
- Use strong, unique passwords for all services
- Enable two-factor authentication on your Render account
- Regularly update your dependencies

## Support

For additional help, refer to:
- [Render Documentation](https://render.com/docs)
- [Django Deployment Checklist](https://docs.djangoproject.com/en/4.2/howto/deployment/checklist/)
