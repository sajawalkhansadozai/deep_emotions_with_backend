const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendVideoUploadNotification = functions.firestore
  .document("Videos/{videoId}")
  .onCreate(async (snapshot, context) => {
    const videoData = snapshot.data();
    const videoTitle = videoData.title || "New Video";

    // Fetch all device tokens
    const tokensSnapshot = await admin.firestore().collection("DeviceTokens").get();
    const tokens = tokensSnapshot.docs.map(doc => doc.data().token);

    if (tokens.length === 0) {
      console.log("No tokens found.");
      return null;
    }

    // Send notification
    const payload = {
      notification: {
        title: "New Video Uploaded",
        body: `Check out the new video: ${videoTitle}`,
      },
    };

    try {
      await admin.messaging().sendToDevice(tokens, payload);
      console.log("Notification sent successfully.");
    } catch (error) {
      console.error("Error sending notification:", error);
    }
  });
