# Mini Katalog Uygulaması

Mini Katalog, Flutter ile geliştirilmiş basit bir ürün listeleme uygulamasıdır.  
Uygulamada ürünler API üzerinden alınır, kart yapısında listelenir ve detay ekranında görüntülenir.

## Uygulama Özellikleri

- Ana sayfada ürünleri GridView ile kart şeklinde gösterme
- Ürün arama (isim ve kategoriye göre filtreleme)
- Hızlı filtre kartları (Yeni Ürünler, İndirimdekiler, Sepetim, Diğer)
- Ürün detay ekranına geçiş
- Sepete ürün ekleme/çıkarma ve toplam tutar hesaplama
- Sepet ekranında seçilen ürünleri listeleme ve silme

## Kullanılan Yapılar

- Flutter Material 3
- Named Route ve Route Arguments
- HTTP ile Fake Store API entegrasyonu
- Basit state yönetimi (`setState`)
- Asset kullanımı (etiket verileri)

## Çalıştırma

```bash
flutter pub get
flutter run
```

## Not

API erişiminde bir sorun olursa uygulama, yerel örnek verilerle çalışmaya devam eder.
