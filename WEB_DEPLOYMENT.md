# Deploying MedExplain AI as a Website

You can deploy your Flutter web app to **Firebase Hosting** (recommended since you already use Firebase) or other static hosting providers like Vercel, Netlify, or GitHub Pages.

## Option 1: Firebase Hosting (Recommended)

Since your project is already set up with Firebase, this is the easiest integration.

### Prerequisites
- Node.js installed on your computer.
- Firebase CLI installed: `npm install -g firebase-tools`

### Steps

1.  **Login to Firebase**
    Open a terminal in your project folder (`d:\projects\ignite\medexplain_ai`) and run:
    ```bash
    firebase login
    ```

2.  **Initialize Firebase Hosting**
    Run the following command:
    ```bash
    firebase init hosting
    ```
    - **Select your project**: Choose `medexplain-ai` (or your specific Firebase project ID).
    - **Public directory**: Type `build/web` (This is where Flutter builds your website).
    - **Configure as a single-page app**: Type `Yes` (Important for Flutter routing).
    - **Set up automatic builds and deploys with GitHub?**: Type `No` (for now).
    - **File build/web/index.html already exists. Overwrite?**: Type `No` (Keep the one Flutter generated).

3.  **Deploy**
    Run:
    ```bash
    firebase deploy
    ```

Once finished, Firebase will give you a URL (e.g., `https://your-project.web.app`) where your app is live!

---

## Option 2: Vercel (Fast & Easy)

1.  Create an account at [vercel.com](https://vercel.com).
2.  Install Vercel CLI: `npm i -g vercel`
3.  Run `vercel` inside your project folder.
4.  Follow the prompts. When asked for the output directory, make sure to set it to `build/web`.

---

## Important Notes for Web

- **CORS Issues**: If your app makes API calls to external servers (like your n8n instance), ensure those servers allow requests from your web domain. You may need to update your n8n CORS settings to allow your Firebase app URL.
- **Splash Screen**: The splash screen has been configured for web. You should see the logo while the app loads.
- **PWA**: Your app is also a Progressive Web App (PWA). Users can "install" it to their desktop or home screen for a native-like experience.
