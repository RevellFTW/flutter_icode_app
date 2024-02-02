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
  console.log("Receive request to update email for UID: ${uid} to ${newEmail}");
  return admin.auth().getUser(uid)
      .then((userRecord) => {
        return admin.auth().updateUser(userRecord.uid, {
          email: newEmail,
        })
            .then((updatedUserRecord) => {
              console.log(updatedUserRecord.email);
              return {success: true};
            });
      })
      .catch((error) => {
        throw new functions.https.HttpsError("unknown", error.message, error);
      });
});
exports.updateUserPassword = functions.https.onCall((data, context) => {
  const uid = data.uid;
  const newPassword = data.newPassword;
  console.log("Receive request to update pw for UID: ${uid} to ${newPassword}");
  return admin.auth().getUser(uid)
      .then((userRecord) => {
        return admin.auth().updateUser(userRecord.uid, {
          password: newPassword,
        })
            .then((updatedUserRecord) => {
              console.log(updatedUserRecord.password);
              return {success: true};
            });
      })
      .catch((error) => {
        throw new functions.https.HttpsError("unknown", error.message, error);
      });
});
// # sourceMappingURL=index.js.map
