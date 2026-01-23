# Railway Deployment Guide for MedExplain AI

Deploy your n8n workflow with RAG chatbot to Railway for production use.

## Prerequisites

- [Railway account](https://railway.app) (free tier available)
- [Groq API key](https://console.groq.com) (free tier: 30 req/min)

---

## Step 1: Deploy n8n to Railway

### 1.1 Create New Project

1. Go to [railway.app](https://railway.app) → Login
2. Click **"New Project"** → **"Deploy a Template"**
3. Search for **"n8n"** → Click `n8n`
4. Click **"Deploy Now"**

### 1.2 Configure Environment Variables

After deployment, go to your n8n service → **Variables** tab and add:

```env
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=YourSecurePassword123!
N8N_ENCRYPTION_KEY=your-random-32-char-encryption-key
GENERIC_TIMEZONE=Asia/Kolkata
```

### 1.3 Add Persistent Storage (Important!)

1. Click on your n8n service
2. Go to **Settings** → **Volumes**
3. Click **"Add Volume"**
4. Mount Path: `/home/node/.n8n`
5. Save

### 1.4 Get Your Public URL

1. Go to **Settings** → **Networking**
2. Click **"Generate Domain"**
3. Copy your URL: `https://your-app.up.railway.app`

---

## Step 2: Import Workflow

### 2.1 Access n8n Dashboard

1. Open your Railway URL: `https://your-app.up.railway.app`
2. Login with credentials from Step 1.2

### 2.2 Import the Workflow

1. Click **"..."** menu → **"Import from File"**
2. Select: `MedExplain-AI-Complete.json` from your project folder
3. Click **"Import"**

### 2.3 Configure Groq API Credentials

1. Click on **"Chat AI Call"** node
2. Under **Authentication** → Click **"Create New Credential"**
3. Credential Type: **Header Auth**
4. Configure:
   - **Name**: `Groq API Key`
   - **Header Name**: `Authorization`
   - **Header Value**: `Bearer YOUR_GROQ_API_KEY`
5. Click **"Save"**

6. **Repeat for "Analysis AI Call" node** (use same credential)

### 2.4 Activate Workflow

1. Toggle the switch at top-right to **Active** (green)
2. Click **"Save"**

---

## Step 3: Update Flutter App

### 3.1 Update Webhook URL

Edit `lib/config/constants.dart`:

```dart
static const String webhookUrl = String.fromEnvironment(
  'WEBHOOK_URL',
  defaultValue: 'https://YOUR-APP.up.railway.app/webhook/medexplain-analyze');
```

Replace `YOUR-APP` with your actual Railway subdomain.

### 3.2 Hot Restart App

```bash
# In Flutter terminal, press 'R' for hot restart
# Or run:
flutter run
```

---

## Step 4: Test Everything

### Test Analysis Mode
1. Open the app
2. Analyze a medical report
3. Verify results display correctly

### Test Chat Mode
1. After analysis, expand "Ask Questions" section
2. Type a question about the report
3. Verify you get an AI response (not empty)

### Test History
1. Go to History screen
2. Verify your analysis appears

---

## Troubleshooting

### "Empty response from server"
- Ensure workflow is **Active** (green toggle)
- Check n8n execution history for errors
- Verify Groq API key is valid

### "Connection timeout"
- Railway free tier sleeps after 5 min inactivity
- First request after sleep takes ~30 seconds
- Upgrade to Hobby tier ($5/month) for always-on

### "Credential errors"
- Re-create Header Auth credential
- Ensure format: `Bearer sk-...` (with space after Bearer)

---

## Railway Pricing

| Tier | Price | Features |
|------|-------|----------|
| Free | $0 | 500 hrs/month, sleeps after 5 min |
| Hobby | $5/mo | Always-on, 8GB RAM |
| Pro | $20/mo | Team features, priority support |

For production apps, **Hobby tier** is recommended.

---

## Your Webhook URL

After deployment, your production webhook will be:

```
https://YOUR-APP.up.railway.app/webhook/medexplain-analyze
```

Use this URL in your Flutter app's `constants.dart`.
