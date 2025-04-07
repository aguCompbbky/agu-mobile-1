import 'package:home_page/notifications.dart';

class Events {
  String? kulup;
  String? etkinlik_adi;
  String? etkinlik_aciklamasi;
  String? etkinlik_tarihi;
  String? kulup_sayfasi;
  String? uygulama_ici_resim;
  String? etkinlik_afisi;
  String? sorumlu_uye;
  String? sorumlu_iletisim;

  Events.empty();

  Events(
      this.kulup,
      this.etkinlik_adi,
      this.etkinlik_aciklamasi,
      this.etkinlik_tarihi,
      this.kulup_sayfasi,
      this.uygulama_ici_resim,
      this.etkinlik_afisi,
      this.sorumlu_uye,
      this.sorumlu_iletisim);

  Events.fromJson(Map<String, dynamic> json) {
    kulup = json["kulup"];
    etkinlik_adi = json["etkinlik_adi"];
    etkinlik_aciklamasi = json["etkinlik_aciklamasi"];
    etkinlik_tarihi = json["etkinlik_tarihi"];
    // // Tarihi düzgün formatta alalım ve UTC'yi yerel zamana çevirelim
    // try {
    //   if (json["etkinlik_tarihi"] != null &&
    //       json["etkinlik_tarihi"].isNotEmpty) {
    //     // Z harfini temizle ve yerel saat dilimine dönüştür
    //     String cleanedDate =
    //         json["etkinlik_tarihi"].toString().replaceAll("Z", "");
    //     DateTime utcDate = DateTime.parse(cleanedDate);
    //     etkinlik_tarihi = utcDate.toLocal(); // Yerel saat dilimine dönüştür
    //   }
    // } catch (e) {
    //   print("Tarih dönüşüm hatası: $e"); // Hata mesajı logla
    //   etkinlik_tarihi = null; // Eğer hata olursa boş bırak
    // }
    kulup_sayfasi = json["kulup_sayfasi"];
    uygulama_ici_resim = json["uygulama_ici_resim"];
    etkinlik_afisi = json["etkinlik_afisi"];
    sorumlu_uye = json["sorumlu_uye"];
    sorumlu_iletisim = json["sorumlu_iletisim"];

    printColored("KULÜP: ${json["kulup"]}", "30");
    printColored("ETKİNLİK: ${json["etkinlik_adi"]}", "30");
    printColored("AÇIKLAMA: ${json["etkinlik_aciklamasi"]}", "30");
    printColored("TARİH: ${json["etkinlik_tarihi"]}", "30");
    printColored("INSTAGRAM: ${json["kulup_sayfasi"]}", "30");
    printColored("RESİM URL: ${json["uygulama_ici_resim"]}", "30");
    printColored("AFİŞ: ${json["etkinlik_afisi"]}", "30");
    printColored("SORUMLU: ${json["sorumlu_uye"]}", "30");
    printColored("SORUMLU İLETİŞİM: ${json["sorumlu_iletisim"]}", "30");
  }

  Map toJson() {
    return {
      "kulup": kulup,
      "etkinlik_adi": etkinlik_adi,
      "etkinlik_aciklamasi": etkinlik_aciklamasi,
      "etkinlik_tarihi": etkinlik_tarihi,
      //"etkinlik_tarihi": etkinlik_tarihi
      //     ?.toIso8601String(), // DateTime'ı ISO formatına çeviriyoruz
      // "etkinlik_tarihi": etkinlik_tarihi
      //     ?.toLocal()
      //     .toIso8601String(), // Yerel zamanı ISO formatına çeviriyoruz

      "kulup_sayfasi": kulup_sayfasi,
      "uygulama_ici_resim": uygulama_ici_resim,
      "etkinlik_afisi": etkinlik_afisi,
      "sorumlu_uye": sorumlu_uye,
      "sorumlu_iletisim": sorumlu_iletisim,
    };
  }
}
