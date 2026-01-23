# Deploying MedExplain AI to Production

## Deploy n8n to Render

### Prerequisites
- Free Render account: https://render.com
- Groq API key: https://console.groq.com

### Step 1: Create Render Web Service

1. **Go to Render Dashboard**
   - Visit https://dashboard.render.com
   - Click **"New +"** → **"Web Service"**

2. **Deploy from Docker Image**
   - Choose **"Deploy an existing image from a registry"**
   - Image URL: `n8nio/n8n:latest`
   - Click **"Next"**

3. **Configure Service**
   - **Name**: `medexplain-n8n` (or your choice)
   - **Region**: Choose closest to your users
   - **Instance Type**: **Free** (or Starter for better performance)
   - **Environment Variables**: Click **"Add Environment Variable"**
     
     Add these:
     ```
     N8N_BASIC_AUTH_ACTIVE=true
     N8N_BASIC_AUTH_USER=admin
     N8N_BASIC_AUTH_PASSWORD=YourSecurePassword123
     WEBHOOK_URL=https://medexplain-n8n.onrender.com
     N8N_HOST=medexplain-n8n.onrender.com
     N8N_PROTOCOL=https
     N8N_PORT=5678
     ```

4. **Click "Create Web Service"**
   - Wait 5-10 minutes for deployment
   - Note your service URL: `https://medexplain-n8n.onrender.com`

### Step 2: Access n8n and Import Workflow

1. **Open Your n8n Instance**
   - Go to: `https://medexplain-n8n.onrender.com`
   - Login with credentials from environment variables

2. **Import Workflow**
   - Click **"+"** → **"Import from File"**
   - Upload: `d:\projects\ignite\medexplain_ai\n8n_workflow.json`
   - Click **"Import"**

3. **Configure Groq API Credentials**
   - Click on **"Groq API Call"** node
   - In **Authentication** section:
     - Name: `Authorization`
     - Value: `Bearer YOUR_GROQ_API_KEY`
   - **Save** the workflow

4. **Activate Workflow**
   - Toggle the switch at top to **"Active"** (green)
   - **Save** the workflow

5. **Note Webhook URL**
   - Your production webhook: `https://medexplain-n8n.onrender.com/webhook/medexplain-analyze`

### Step 3: Update Flutter App

1. **Update Webhook URL in Flutter**
   
   Edit `lib/config/constants.dart` line 13:
   ```dart
   static const String webhookUrl = 
       String.fromEnvironment('WEBHOOK_URL', 
         defaultValue: 'https://medexplain-n8n.onrender.com/webhook/medexplain-analyze');
   ```

2. **Rebuild the App**
   ```bash
   flutter clean
   flutter pub get
   flutter build apk --release
   ```

3. **Test Production**
   - Run the app
   - Analyze a medical report
   - Verify it connects to Render n8n

### Step 4: Production Checklist

- [ ] n8n deployed and accessible at Render URL
- [ ] Workflow imported and active
- [ ] Groq API key configured
- [ ] Flutter app updated with production webhook URL
- [ ] End-to-end test successful
- [ ] APK built for Android distribution

## Important Notes

### Free Tier Limitations
- **Render Free Tier**: Service sleeps after 15 min inactivity
- **First request after sleep**: Takes 30-60 seconds to wake up
- **Upgrade to Starter** ($7/month) for always-on service

### Security
- Change default n8n password immediately
- Use strong Groq API key
- HTTPS is automatically enabled by Render
- No patient data is stored permanently

### Monitoring
- Render dashboard shows logs and metrics
- n8n execution history available in web UI
- Monitor Groq API usage at console.groq.com

## Troubleshooting

**Deployment Failed**
- Check Render build logs
- Verify environment variables are set correctly

**Webhook Not Responding**
- Ensure workflow is "Active" (green toggle)
- Check n8n execution history for errors
- Verify Groq API key is valid

**Cold Start Delays**
- Normal on free tier (first request after 15 min)
- Upgrade to Starter tier for instant responses
- Or implement a cron job to ping the service every 10 min

## Next Steps

After successful deployment:
1. Test with real medical reports
2. Build production APK for Android
3. Submit to Google Play Store (optional)
4. Set up monitoring and alerts
5. Consider upgrading Render tier for production use
