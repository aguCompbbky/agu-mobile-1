import 'package:easy_localization/easy_localization.dart';

class LocalText {
  /// add_class_screen
  static String get add_class_title                 => "add_class_title".tr();                  
  static String get add_class_section_schedule      => "add_class_section_schedule".tr();       
  static String get add_class_section_hours         => "add_class_section_hours".tr();          
  static String get add_class_label_name            => "add_class_label_name".tr();             
  static String get add_class_label_location        => "add_class_label_location".tr();         
  static String get add_class_hint_select_day       => "add_class_hint_select_day".tr();        
  static String get add_class_btn_confirm_selection => "add_class_btn_confirm_selection".tr();  
  static String get add_class_btn_save_class        => "add_class_btn_save_class".tr();         
  static String get add_class_warn_select_day_time  => "add_class_warn_select_day_time".tr();   
  static String get add_class_warn_day_not_selected => "add_class_warn_day_not_selected".tr();  
  static String get monday                          => "monday".tr();       
  static String get tuesday                         => "tuesday".tr();      
  static String get wednesday                       => "wednesday".tr();    
  static String get thursday                        => "thursday".tr();     
  static String get friday                          => "friday".tr();       
  static String get saturday                        => "saturday".tr();     
  static String get sunday                          => "sunday".tr();       

  /// attendance
  static String get daily_attendance_title                   => "daily_attendance_title".tr();                 
  static String get daily_attendance_empty                   => "daily_attendance_empty".tr();                 
  static String get daily_attendance_lesson_name_missing     => "daily_attendance_lesson_name_missing".tr();   
  static String get daily_attendance_hours_label             => "daily_attendance_hours_label".tr();           
  static String get daily_attendance_teacher_label           => "daily_attendance_teacher_label".tr();         
  static String get daily_attendance_teacher_missing         => "daily_attendance_teacher_missing".tr();       
  static String get daily_attendance_classroom_label         => "daily_attendance_classroom_label".tr();       
  static String get daily_attendance_classroom_missing       => "daily_attendance_classroom_missing".tr();     
  static String get daily_attendance_btn_attended            => "daily_attendance_btn_attended".tr();          
  static String get daily_attendance_btn_not_attended        => "daily_attendance_btn_not_attended".tr();      
  static String get daily_attendance_msg_attended            => "daily_attendance_msg_attended".tr();          
  static String get daily_attendance_msg_not_attended        => "daily_attendance_msg_not_attended".tr();      

  /// attendance2.dart texts
  static String get attendance_appbar_title        => "Günlük Devamsızlık Kontrolü".tr();
  static String get attendance_empty_today         => "Bugün için ders bulunamadı".tr();
  static String get attendance_absence_label       => "Devamsızlık:".tr();
  static String get attendance_btn_not_attended    => "Katılmadım".tr();
  static String get attendance_btn_attended        => "Katıldım".tr();
  static String get attendance_snack_attended      => "Katıldınız!".tr();
  static String get attendance_snack_absence_added => "Devamsızlık sayınız 1 arttırıldı!".tr();


   // ClassScheduleScreen için görünen metinler
  static String get schedule_appbar_title      => "Haftalık Ders Programı".tr();
  static String get schedule_no_class_suffix   => "günü için dersiniz yok".tr();
  static String get schedule_absence_label     => "Devamsızlık:".tr();

  // GuidePage (üst çerçeve)
static String get guide_appbar_title         => "Rehber".tr();
static String get guide_sem_prev             => "Önceki sayfa".tr();
static String get guide_sem_next             => "Sonraki sayfa".tr();
static String get guide_swipe_hint           => "Kaydırınız".tr();


// 1) ŞEHRİ TANI – KAYSERİ
static String get city_title                 => "Kayseri – Şehri Tanı".tr();
static String get city_subtitle              => "Erciyes eteklerinde sanayi & öğrenci şehri. Talas–Merkez hattı, uygun yaşam ve zengin mutfak.".tr();
static String get city_qaction_card          => "Ulaşım Kartı".tr();
static String get city_qaction_tram          => "Tramvay Saatleri".tr();
static String get city_qaction_agu_loc       => "AGÜ Konum".tr();

static String get city_section_overview      => "Genel Bakış".tr();
static String get city_bullet_overview_1     => "Kayseri, Anadolu’nun ortasında, İç Anadolu’nun önemli şehirlerinden biridir.".tr();
static String get city_bullet_overview_2     => "Erciyes Dağı şehrin simgesidir; kışın kayak, yazın doğa yürüyüşleri için popülerdir.".tr();
static String get city_bullet_overview_3     => "Öğrenci dostu fiyatlar; ulaşım kolay.".tr();
static String get city_tag_altitude          => "Rakım 1000m+".tr();
static String get city_tag_dry               => "Kuru iklim".tr();
static String get city_tag_erciyes           => "Erciyes".tr();

static String get city_section_culture       => "Tarih ve Kültür".tr();
static String get city_bullet_culture_1      => "Kültepe (Kaniş Karum): Anadolu’nun en eski yazılı tabletleri burada bulundu.".tr();
static String get city_bullet_culture_2      => "Hunat Hatun Külliyesi, Gevher Nesibe Şifahanesi ve Kayseri Kalesi mutlaka görülmeli.".tr();
static String get city_bullet_culture_3      => "Meşhur Kapalı Çarşı ve tarihi hanlar, şehri tanımak için iyi başlangıç noktalarıdır.".tr();

static String get city_section_places        => "Gezilecek Noktalar".tr();
static String get city_bullet_places_1       => "Cumhuriyet Meydanı, Saat Kulesi, Kayseri Kalesi".tr();
static String get city_bullet_places_2       => "Hunat Hatun Külliyesi, Gevher Nesibe Şifahanesi".tr();
static String get city_bullet_places_3       => "Talas eski sokakları, Ağırnas (Mimar Sinan)".tr();
static String get city_bullet_places_4       => "Erciyes Kayak Merkezi, Sultan Sazlığı".tr();

// 2) ÜNİVERSİTEYE GENEL BAKIŞ
static String get univ_title                 => "Üniversiteye Genel Bakış".tr();
static String get univ_subtitle              => "Kampüs haritası, kütüphane, öğrenci işleri ve en çok kullanılan bağlantılar.".tr();
static String get univ_qaction_map           => "Kampüs Haritası".tr();
static String get univ_qaction_library       => "Kütüphane".tr();
static String get univ_qaction_student_aff   => "Öğrenci İşleri".tr();

static String get univ_section_favorites     => "Sık Kullanılanlar".tr();
static String get univ_bullet_favorites      => "Akademik Takvim • SIS • LMS (Canvas) • E-posta (Zimbra)".tr();
static String get univ_chip_sis              => "SIS".tr();
static String get univ_chip_canvas_prep      => "Canvas/Hazırlık".tr();
static String get univ_chip_canvas_dept      => "Canvas/Bölüm".tr();
static String get univ_chip_email            => "E-posta".tr();

static String get univ_section_facilities    => "Eğitim ve Kampüs Olanakları".tr();
static String get univ_bullet_fac_1          => "Nitelikli eğitim: Mühendislik, Yaşam ve Doğa Bilimleri, Mimarlık, İktisadi ve Sosyal Bilimler fakülteleri,".tr();
static String get univ_bullet_fac_2          => "Zengin kütüphane ve 7/24 açık çalışma salonları,".tr();
static String get univ_bullet_fac_3          => "Modern laboratuvarlar ve araştırma merkezleri,".tr();
static String get univ_bullet_fac_4          => "Spor kompleksi, yemekhane ve sosyal yaşam alanları,".tr();
static String get univ_bullet_fac_5          => "Öğrenci kulüpleri, etkinlikler ve kültürel aktiviteler.".tr();

// 3) YEMEK & KAFELER
static String get food_title                 => "Yemek & Kafeler".tr();
static String get food_subtitle              => "Yemekhane saatleri, kampüs çevresi ve bütçe dostu öneriler.".tr();
static String get food_qaction_daily_menu    => "Günlük Menü".tr();
static String get food_qaction_near_cafes    => "Yakın Kafeler".tr();

static String get food_section_hours         => "Yemekhane Saatleri".tr();
static String get food_bullet_hours_1        => "Öğle servisi: 11:00 – 14:00".tr();
static String get food_bullet_hours_2        => "Yoğun saatlerde erken git; menüyü uygulamadan kontrol et.".tr();
static String get food_bullet_hours_3        => "Yemekhaneler, Fabrika Binası ve Ambar Binasında yer almaktadır.".tr();
static String get food_tag_daily_menu        => "Günlük Menü".tr();
static String get food_tag_monthly_menu      => "Aylık Menü".tr();

static String get food_section_campus        => "Kampüs & Çevresi".tr();
static String get food_bullet_campus_1       => "Starbucks--> Çelik Bina A Blok karşısı".tr();
static String get food_bullet_campus_2       => "Elif Cafe--> Çelik Bina B Blok 2. kat".tr();
static String get food_bullet_campus_3       => "Vivoli Cafe--> Çelik Bina C Blok".tr();
static String get food_bullet_campus_4       => "Mobil Kafe(Karavan)--> Fabrika Binası-Erkilet Giriş arası".tr();
static String get food_bullet_campus_5       => "Fabrika Binası Kantin".tr();
static String get food_bullet_campus_6       => "The House Cafe Müze".tr();

// 4) ULAŞIM REHBERİ
static String get transport_title            => "Ulaşım Rehberi".tr();
static String get transport_subtitle         => "Kayseray + otobüs hatları, güzergâh sorgu, yoğun saat ipuçları ve güvenli dönüş önerileri.".tr();
static String get transport_qaction_route    => "Güzergâh Sorgu".tr();
static String get transport_qaction_bus      => "Otobüs Hatları".tr();
static String get transport_qaction_tram     => "Tramvay Hatları".tr();
static String get transport_qaction_card38   => "Kart38 Bakiye".tr();

static String get transport_section_bus      => "Otobüs".tr();
static String get transport_bullet_bus_1     => "Çok sayıda hattın Talas–Merkez bağlantısı var.".tr();
static String get transport_bullet_bus_2     => "Yoğun saatlerde alternatif durakları tercih et.".tr();
static String get transport_bullet_bus_3     => "Hat ve saatleri web sitesinden anlık kontrol et.".tr();

static String get transport_section_tram     => "Tramvay".tr();
static String get transport_bullet_tram_1    => "Talas ↔ Merkez hattı özellikle sınav/iş çıkışında kalabalık.".tr();
static String get transport_bullet_tram_2    => "Durak yoğunluğuna göre otobüs alternatiflerini bil.".tr();
static String get transport_bullet_tram_3    => "Tramvay saatlerini uygulama veya web sitesinden takip et.".tr();

static String get transport_section_night    => "Gece Dönüş Güvenliği".tr();
static String get transport_bullet_night_1   => "Mümkünse arkadaşlarınla birlikte dön, tenha sokaklardan kaçın.".tr();
static String get transport_bullet_night_2   => "Duraklara yakın ve aydınlık güzergâhları seç.".tr();
static String get transport_bullet_night_3   => "Telefon şarjını ve ulaşım kartı bakiyeni önceden kontrol et.".tr();
static String get transport_bullet_night_4   => "Acil durumda 155/112 numaralarını aramaktan çekinme.".tr();

// 5) KAYIT & EVRAK İŞLERİ
static String get reg_title                  => "Kayıt & Evrak İşleri".tr();
static String get reg_subtitle               => "SIS, danışman onayı ve e-Devlet belgeleri için kısa yol.".tr();
static String get reg_qaction_student_doc    => "Öğrenci Belgesi".tr();
static String get reg_qaction_transcript     => "Transkript".tr();

static String get reg_section_steps          => "Adım Adım".tr();
static String get reg_step_title_docs        => "Kayıt Belgeleri".tr();
static String get reg_step_desc_docs         => "Kimlik, fotoğraf, yerleştirme belgesi, varsa muafiyet.".tr();
static String get reg_step_title_sis         => "SIS Hesabı".tr();
static String get reg_step_desc_sis          => "Bilgilerini güncelle; danışmanını ve bölümünü kontrol et.".tr();
static String get reg_step_title_enroll      => "Ders Kayıt".tr();
static String get reg_step_desc_enroll       => "Danışman onayı olmadan kayıt tamamlanmaz.".tr();
static String get reg_step_title_fee         => "Ücret/Harç".tr();
static String get reg_step_desc_fee          => "Varsa ödeme planını kontrol et.".tr();

static String get reg_section_tips           => "İpuçları".tr();
static String get reg_bullet_tips_1          => "Belgeleri PDF olarak sakla; e-Devlet şifrelerini güvenli tut.".tr();
static String get reg_bullet_tips_2          => "Kayıt günlerinde yoğunluk olur, işlemleri erken tamamla.".tr();

// 6) AKADEMİK HAYATTA KALMA
static String get acad_title                 => "Akademik Hayatta Kalma".tr();
static String get acad_subtitle              => "Ders seçimi, not sistemi, kütüphane ve sınav haftası taktikleri.".tr();
static String get acad_qaction_sis           => "SIS".tr();
static String get acad_qaction_canvas_prep   => "Canvas/Hazırlık".tr();
static String get acad_qaction_canvas_dept   => "Canvas/Bölüm".tr();
static String get acad_qaction_library       => "Kütüphane".tr();

static String get acad_section_grades        => "Not Sistemi & Devamsızlık".tr();
static String get acad_bullet_grades_1       => "Ders planındaki % ağırlıkları ve barajları öğren.".tr();
static String get acad_bullet_grades_2       => "Devamsızlık limitlerini kaçırma; derslere düzenli git.".tr();

static String get acad_section_tactics       => "Çalışma Taktikleri".tr();
static String get acad_bullet_tactics_1      => "Kütüphanede sessiz alan + grup çalışma odaları.".tr();
static String get acad_bullet_tactics_2      => "Haftalık plan: ders sonrası 20–30 dk tekrar.".tr();
static String get acad_bullet_tactics_3      => "Sınav haftası: eski sorular, özet defter, küçük molalar.".tr();

// 7) SOSYAL YAŞAM
static String get social_title               => "Sosyal Yaşam".tr();
static String get social_subtitle            => "Kulüpler, etkinlikler ve spor alanları ile sosyalleş.".tr();
static String get social_qaction_clubs       => "Kulüpler".tr();
static String get social_qaction_events      => "Etkinlikler".tr();
static String get social_qaction_sports      => "Spor".tr();

static String get social_section_start       => "Nereden Başlamalı?".tr();
static String get social_bullet_start_1      => "Tanıtım haftasında kulüp stantlarını gez.".tr();
static String get social_bullet_start_2      => "Deneme toplantılarına katıl, ilgi alanına uygun 1–2 kulüp seç.".tr();
static String get social_bullet_start_3      => "Gönüllülük programlarını takip et.".tr();

static String get social_section_places      => "Buluşma & Çalışma Mekânları".tr();
static String get social_bullet_places_1     => "Kampüs içi sessiz/yarı sessiz alanlar.".tr();
static String get social_bullet_places_2     => "Talas ve merkezde uygun fiyatlı kafeler.".tr();

// 8) YURT & BARINMA
static String get housing_title              => "Yurt ve Barınma".tr();
static String get housing_subtitle           => "Yurt ipuçları, ev kiralama checklist ve taşınma tüyoları.".tr();
static String get housing_qaction_dorm_app   => "Yurt Başvurusu".tr();
static String get housing_qaction_rent       => "Ev Kiralama".tr();

static String get housing_section_dorm_tips  => "Yurt İpuçları".tr();
static String get housing_bullet_dorm_1      => "Sessiz saatler ve ortak alan kurallarını öğren.".tr();
static String get housing_bullet_dorm_2      => "Dolap kilidi, priz çoklayıcı ve kulaklık kurtarıcı olur.".tr();

static String get housing_section_rent_check => "Ev Kiralama Checklist".tr();
static String get housing_check_1            => "Isınma türü (doğalgaz/merkezi) ve fatura durumu".tr();
static String get housing_check_2            => "Tramvaya yürüme mesafesi, market/eczane yakınlığı".tr();
static String get housing_check_3            => "Depozito & sözleşme; dairede nem/ısı yalıtımı".tr();

// ======= MenuPage =======
static String get menu_appbar_title                              => "Menü".tr();
static String get menu_item_notification_prefs                   => "Bildirim Tercihleri".tr();
static String get menu_item_passwords_signin                     => "Şifreler ve Giriş".tr();
static String get menu_item_academic_calendar                    => "Akademik Takvim".tr();
static String get menu_item_send_feedback                        => "Geri Bildirim Gönder".tr();
static String get menu_item_developers                           => "Geliştiriciler".tr();
static String get menu_item_guide                                => "Rehber".tr();

// ======= AcademicCalendarScreen =======
static String get acadcal_appbar_title                           => "Akademik Takvim".tr();
static String get acadcal_error_prefix                           => "Bir hata oluştu:".tr();
static String get acadcal_empty_category                         => "Bu kategoriye ait veri bulunamadı.".tr();

// ======= PasswordScreen =======
static String get pw_appbar_title                                => "Giriş Bilgileri".tr();
static String get pw_canvas_info_title                           => "Canvas Bilgileri".tr();
static String get pw_canvas_mail                                 => "Canvas Mail".tr();
static String get pw_canvas_password                             => "Canvas Şifre".tr();
static String get pw_prep_canvas_info_title                      => "Hazırlık Canvas Bilgileri".tr();
static String get pw_zimbra_info_title                           => "Zimbra Bilgileri".tr();
static String get pw_zimbra_mail                                 => "Zimbra Mail".tr();
static String get pw_zimbra_password                             => "Zimbra Şifre".tr();
static String get pw_sis_info_title                              => "SIS Bilgileri".tr();
static String get pw_sis_id                                      => "Öğrenci ID numarası".tr();
static String get pw_sis_password                                => "SIS Şifre".tr();
static String get pw_save_button                                 => "Kaydet".tr();
static String get pw_saved_snack                                 => "Bilgiler başarıyla kaydedildi!".tr();

// Gizlilik diyalogu
static String get pw_privacy_title                               => "Gizlilik Bildirimi".tr();
static String get pw_privacy_body                                => "Merak etmeyin, girdiğiniz bilgiler yalnızca sizin erişiminiz için güvenli bir şekilde saklanmaktadır ve üçüncü taraflarla kesinlikle paylaşılmamaktadır. Bu veriler, yalnızca uygulama içerisindeki öğrenci giriş işlemlerinizi kolaylaştırmak amacıyla tutulmaktadır. Güvenliğiniz bizim önceliğimizdir.".tr();
static String get pw_privacy_dont_show_again                     => "Bir daha gösterme".tr();
static String get pw_privacy_understood                          => "Anladım".tr();

// ======= NotificationScreen =======
static String get notif_appbar_title                             => "Bildirim Ayarları".tr();

static String get notif_section_general                          => "Genel Bildirimler".tr();
static String get notif_item_notifications                       => "Bildirimler".tr();
static String get notif_general_on_subtitle                      => "Bildirimler açık. Alt bildirimleri düzenleyebilirsiniz.".tr();
static String get notif_general_off_subtitle                     => "Bildirimler kapalı.".tr();

static String get notif_section_refectory                        => "Yemekhane Bildirimleri".tr();
static String get notif_item_refectory                           => "Yemekhane Bildirimi".tr();
static String get notif_refectory_on_subtitle                    => "Yemekhane bildirimleri açık.".tr();
static String get notif_refectory_off_subtitle                   => "Yemekhane bildirimleri kapalı.".tr();

static String get notif_section_attendance                       => "Devamsızlık Bildirimleri".tr();
static String get notif_item_attendance                          => "Devamsızlık Bildirimleri".tr();
static String get notif_attendance_on_subtitle                   => "Devamsızlık bildirimleri açık".tr();
static String get notif_attendance_off_subtitle                  => "Devamsızlık bildirimleri kapalı".tr();

static String get notif_section_lessons                          => "Ders Bildirimleri".tr();
static String get notif_item_lessons                             => "Ders Bildirimleri".tr();
static String get notif_lessons_on_subtitle                      => "Ders bildirimleri açık. Bildirim ayarlarını düzenleyebilirsiniz.".tr();
static String get notif_lessons_off_subtitle                     => "Ders bildirimleri kapalı.".tr();

static String get notif_lessons_settings_title                   => "Ders Bildirim Ayarları".tr();
static String get notif_minutes_label                             => "Bildirim Süresi (dk)".tr();
static String get notif_minutes_hint                              => "Örneğin: 10 dakika önce (Sadece sayı giriniz.)".tr();
static String get notif_minutes_saved_snack_prefix               => "Değer kaydedildi:".tr();
static String get notif_minutes_invalid_snack                    => "Lütfen geçerli bir değer giriniz".tr();

// Bildirim izin diyaloğu
static String get notif_perm_body                                => "AGU Mobile uygulamasının size bildirim göndermesini ister misiniz?".tr();
static String get common_no                                       => "Hayır".tr();
static String get common_yes                                      => "Evet".tr();

// (Bildirim içerikleri – NotificationService’de kullanılan başlık/metinler)
static String get notif_refectory_title                          => "Yemekhane Bildirimi".tr();
static String get notif_refectory_body                           => "Yemek servisi başladı. Bugünün menüsünü görmek için tıkla.".tr();
static String get notif_attendance_title                         => "Devamsızlık Bildirimi".tr();
static String get notif_attendance_body                          => "Günlük devamsızlık kaydınızı girmeyi unutmayın.".tr();

// ======= Developers (Geliştiriciler) =======
static String get dev_appbar_title                               => "Geliştiriciler".tr();

static String get dev_name_mustafa_bicer                         => "Mustafa Biçer".tr();
static String get dev_bio_mustafa_bicer                          => "Bilgisayar Mühendisliği 3. sınıf öğrencisi".tr();

static String get dev_name_mustafa_ugur_karakose                 => "Mustafa Uğur Karaköse".tr();
static String get dev_bio_mustafa_ugur_karakose                  => "Ben bilgisayar mühendisliği 3.sınıf öğrencisiyim mobil geliştiricilik ve backende ilgi duyuyorum".tr();

static String get dev_name_yunus_baskan                          => "Yunus Başkan".tr();
static String get dev_bio_yunus_baskan                           => "Bilgisayar Mühendisliği 3. sınıf öğrencisiyim ve yapay zeka, veri bilimi ve blockchain teknolojilerine ilgi duyuyorum. Bu alanlarda kendimi geliştirmek için araştırmalar yapıyor, projeler üretiyor ve yeni teknolojileri yakından takip ediyorum.".tr();

static String get dev_name_turgut_alp_yesil                      => "Turgut Alp Yeşil".tr();
static String get dev_bio_turgut_alp_yesil                       => "Bilgisayar Mühendisliği 3. sınıf öğrencisi olarak, yazılım geliştirme, veri yapıları ve problem çözme becerilerimi projelerle güçlendiriyorum. Gelecekte yazılım mühendisliği, yapay zeka, veri bilimi veya siber güvenlik alanlarında başarılı olmayı hedefliyorum.".tr();

// ===== RefectoryScreen: AppBar toggle =====
static String get ref_appbar_daily                  => "Günlük Menü".tr();
static String get ref_appbar_monthly                => "Aylık Menü".tr();

// ===== RefectoryScreen: boş/uyarı metinleri =====
static String get ref_empty_daily_list              => "Yemek kaydı bulunamadı. Lütfen sorumlulara bildirin.".tr();
static String get ref_empty_monthly_list            => "Yemek bilgisi bulunamadı. Lütfen sorumlulara bildirin.".tr();

// ===== RefectoryScreen: günlük liste kart içi başlıklar/etiketler =====
static String get ref_day_missing                   => "Gün Belirtilmemiş".tr();
static String get ref_label_soup                    => "Çorba".tr();
static String get ref_label_main                    => "Ana Yemek".tr();
static String get ref_label_veg                     => "Vejetaryen".tr();
static String get ref_label_veg_meal                => "Vejetaryen Yemek".tr();
static String get ref_label_helper                  => "Yardımcı Yemek".tr();
static String get ref_label_extra                   => "Ekstra".tr();

// (Aşağıdaki varyant ekranda başka bir yerde geçiyor; yazım farkı var)
static String get ref_label_veg_alt                 => "Vejeteryan".tr();

// ===== MealText: değeri yoksa =====
static String get ref_value_not_specified           => "Belirtilmemiş".tr();

// ===== RefectoryCard (anasayfa kart) =====
static String get ref_card_title_today_menu         => "Günün Menüsü".tr();
static String get ref_weekend_no_meal               => "Hafta sonu için yemek bilgisi bulunmamaktadır.".tr();
static String get ref_today_no_meal                 => "Bugün için yemek bilgisi bulunamadı.".tr();

// ===== MealCard: puanlama / snackbar / butonlar =====
static String get ref_rate_not_started              => "puan verme işlemi saat 11.20 de başlar!".tr();
static String get ref_username_not_found            => "Kullanıcı adı bulunamadı!".tr();
static String get ref_already_rated                 => "Bu yemeği zaten puanladınız!".tr();
static String get ref_vote_saved                    => "Oyunuz başarıyla kaydedildi!".tr();

static String get ref_btn_cancel                    => "Vazgeç".tr();
static String get ref_btn_send                      => "Gönder".tr();

// ===== MealCard: alt sayfa (bottom sheet) =====
static String get ref_user_ratings_suffix           => " - Kullanıcı Puanları".tr();
static String get ref_no_ratings_yet                => "Henüz bu yemek için puan verilmemiş.".tr();
static String get ref_no_one_voted_yet              => "Henüz kimse oy vermemiş.".tr();
static String get common_close                      => "Kapat".tr();


// ===== sisAddLessonsPage / AppBar =====
static String get sis_add_title                         => "Ders Ekleme".tr();

// ===== Ana CTA / Kaydet =====
static String get sis_cta_open_dialog                   => "DERS EKLEMEK İÇİN TIKLAYIN".tr();
static String get sis_save_btn                          => "Kaydet".tr();

// ===== Ders seçim diyaloğu =====
static String get sis_dialog_hint_dept_select           => "Bölüm seç".tr();
static String get sis_search_hint                       => "Ders ara...".tr();
static String get sis_dialog_btn_ok                     => "Tamam".tr();

// ===== Başarı diyaloğu =====
static String get sis_success_title                     => "Kaydedildi".tr();
static String get sis_success_body                      => "Dersleriniz başarıyla kaydedildi.".tr();
static String get common_ok                             => "Tamam".tr();

// ===== LessonCard içinde görünenler =====
static String get sis_hours_per_week_suffix             => "saat/hafta".tr();
static String get sis_dash_placeholder                  => "-".tr();

// ===== Departman adları (listede ve başlangıç seçiminde görünüyor) =====
static String get dept_comp_engineering                 => "Bilgisayar Mühendisliği".tr();
static String get dept_industrial_engineering           => "Endüstri Mühendisliği".tr();
static String get dept_eee_engineering                  => "Elektrik-Elektronik Mühendisliği".tr();
static String get dept_mechanical_engineering           => "Makine Mühendisliği".tr();
static String get dept_civil_engineering                => "İnşaat Mühendisliği".tr();
static String get dept_materials_nanotech_engineering   => "Malzeme Bilimi ve NanoTeknoloji Mühendisliği".tr();
static String get dept_bioengineering                   => "Biyomühendislik".tr();
static String get dept_molecular_bio_genetics           => "Moleküler Biyoloji ve Genetik".tr();
static String get dept_architecture                     => "Mimarlık".tr();
static String get dept_business                         => "İşletme".tr();
static String get dept_economics                        => "Ekonomi".tr();
static String get dept_psychology                       => "Psikoloji".tr();
static String get dept_political_science_ir             => "Siyaset Bilimi ve Uluslararası İlişkiler".tr();

// ===== SIS Login Page =====
static String get sislogin_appbar_title           => "Otomatik Ders Yükleme".tr();
static String get sislogin_section_sis_info       => "SIS Bilgileri".tr();
static String get sislogin_input_student_number   => "Öğrenci Numaranız".tr();
static String get sislogin_input_password         => "Şifreniz".tr();
static String get sislogin_input_captcha_sum      => "Sayıların Toplamı".tr();
static String get sislogin_btn_submit             => "Gönder".tr();

// Snackbar / Hata
static String get common_error_prefix             => "Hata:".tr();

// (olasılık amaçlı, veri boşsa gün adı)
static String get sislogin_unknown_day            => "Bilinmeyen Gün".tr();

// ===== sisWeeklyProgram =====
static String get sisweekly_body_title => "Firebase den alınan veriler: ".tr();

// ===== Timetabledetail: AppBar =====
static String get tt_appbar_title                       => "Ders Programı".tr();

// ===== Timetabledetail: Popup menü ve diyaloglar =====
static String get tt_menu_delete_lessons                => "Dersleri Sil".tr();
static String get tt_alert_title_warning                => "Uyarı".tr();
static String get tt_alert_delete_confirm               => "Dersleri gerçekten silmek istediğinize emin misiniz?".tr();


static String get tt_info_title                         => "Bilgilendirme".tr();
static String get tt_info_body_refresh_screen           => "İşleminiz gerçekleştirilmiştir, ekranı yenileyiniz.".tr();


// ===== Timetabledetail: boş durum =====
static String get tt_empty_lessons                      => "Henüz ders eklenmedi.".tr();

// ===== Floating Action Menu =====
static String get tt_fab_manual_dept                    => "Manuel Ekle (Bölüm)".tr();
static String get tt_fab_manual_prep                    => "Manuel Ekle (Hazırlık)".tr();
static String get tt_fab_auto_fetch                     => "Otomatik Al".tr();

// ===== Gün isimleri (kart başlıklarında kullanılıyor) =====
static String get monday_tr                             => "Pazartesi".tr();
static String get tuesday_tr                            => "Salı".tr();
static String get wednesday_tr                          => "Çarşamba".tr();
static String get thursday_tr                           => "Perşembe".tr();
static String get friday_tr                             => "Cuma".tr();
static String get saturday_tr                           => "Cumartesi".tr();
static String get sunday_tr                             => "Pazar".tr();

// ===== Ders kartı içi fallback metinler =====
static String get tt_lesson_name_missing                => "Ders Adı Yok".tr();
static String get tt_teacher_missing                    => "Öğretmen adı yok".tr();
static String get tt_place_missing                      => "Yer Yok".tr();
static String get tt_hour_missing                       => "Saat Yok".tr();

// ===== Ders kartı: devamsızlık satırı =====
// İstersen şu sabiti kullanıp değeri yanında string birleştir: "${LocalText.tt_absence_label} ${lesson.attendance}"
static String get tt_absence_label                      => "Devamsızlık =".tr();
// Ya da doğrudan şablon tercih edersen (namedArgs ile):
static String get tt_absence_with_count                 => "Devamsızlık = {count}".tr();

}
