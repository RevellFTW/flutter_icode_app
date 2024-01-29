"use strict";
/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */
// Start writing functions
// https://firebase.google.com/docs/functions/typescript
Object.defineProperty(exports, "__esModule", {value: true});
exports.updateUserEmail = void 0;
// export const helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();
exports.updateUserEmail = functions.https.onCall((data, context) => {
  const uid = data.uid;
  const newEmail = data.newEmail;
  return admin.auth().updateUser(uid, {
    email: newEmail,
  })
      .then((userRecord) => {
        console.log(userRecord.newEmail);
        return {success: true};
      })
      .catch((error) => {
        throw new functions.https.HttpsError("unknown", error.message, error);
      });
});
// # sourceMappingURL=index.js.map
