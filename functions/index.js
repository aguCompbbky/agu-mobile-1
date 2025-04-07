const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.resetIsSelect = functions.pubsub.schedule("every 24 hours").onRun(async (context) => {
  console.log("Bu işlem her gün saat 00:00’da çalışacak.");
  const usersSnapshot = await admin.firestore().collection("users").get();

  usersSnapshot.forEach(async (userDoc) => {
    const classesSnapshot = await userDoc.ref.collection("classes").get();

    classesSnapshot.forEach(async (classDoc) => {
      const schedule = classDoc.data().schedule || [];
      const updatedSchedule = schedule.map(entry => {
        // Her dersin schedule kısmındaki isSelect değerini false yapıyoruz
        return {
          ...entry,
          isSelect: false
        };
      });

      // Dersin schedule kısmını güncelliyoruz
      await classDoc.ref.update({
        schedule: updatedSchedule
      });

      console.log(`Kullanıcı ${userDoc.id} için ders ${classDoc.id} güncellendi.`);
    });
  });
});
