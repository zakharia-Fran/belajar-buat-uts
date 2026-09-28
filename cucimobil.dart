import 'dart:io';

void main() {
  // Pos pencucian (A, B, C) dengan batas maksimum 3 pos
  List<Map<String, String?>> posPencucian = [
    {'pos': 'A', 'plat': null},
    {'pos': 'B', 'plat': null},
    {'pos': 'C', 'plat': null},
  ];

  // Waiting list kendaraan (menggunakan FIFO)
  List<String> waitingList = [];

  bool berjalan = true;

  while (berjalan) {
    print('\n=== SISTEM ANTRIAN CUCI KENDARAAN ===');
    print('1. Tambah Antrian');
    print('2. Lihat Waiting List');
    print('3. Lihat Pos');
    print('4. Selesaikan Antrian');
    print('5. Keluar');
    stdout.write('Pilih menu [1-5]: ');
    
    String? pilihan = stdin.readLineSync();

    switch (pilihan) {
      case '1':
        stdout.write('Masukkan nomor Plat (contoh: XX 9999 XXX): ');
        String? plat = stdin.readLineSync();

        if (plat == null || plat.trim().isEmpty) {
          print('Plat nomor tidak boleh kosong!');
          break;
        }

        plat = plat.trim().toUpperCase();

        // Cek apakah ada pos yang kosong
        int indexKosong = posPencucian.indexWhere((element) => element['plat'] == null);

        if (indexKosong != -1) {
          // Isi pos yang kosong
          posPencucian[indexKosong]['plat'] = plat;
          String namaPos = posPencucian[indexKosong]['pos']!;
          print('Plat nomor $plat masuk di pos $namaPos');
        } else {
          // Jika semua pos penuh, masuk waiting list
          waitingList.add(plat);
          int nomorUrut = waitingList.length;
          print('Plat Nomor $plat berada di waiting list nomor $nomorUrut');
        }
        break;

      case '2':
        print('\n--- DAFTAR WAITING LIST ---');
        if (waitingList.isEmpty) {
          print('Waiting list saat ini kosong.');
        } else {
          for (int i = 0; i < waitingList.length; i++) {
            print('${i + 1}. Plat Nomor: ${waitingList[i]}');
          }
        }
        break;

      case '3':
        print('\n--- STATUS POS PENCUCIAN ---');
        for (var pos in posPencucian) {
          String status = pos['plat'] != null 
              ? 'Diisi oleh Plat Nomor: ${pos['plat']}' 
              : 'KOSONG';
          print('Pos ${pos['pos']}: $status');
        }
        break;

      case '4':
        stdout.write('Masukkan pilihan Pos yang ingin diselesaikan [A/B/C]: ');
        String? inputPos = stdin.readLineSync();

        if (inputPos == null || inputPos.trim().isEmpty) {
          print('Pilihan pos tidak valid!');
          break;
        }

        inputPos = inputPos.trim().toUpperCase();

        // Cari pos sesuai input pengguna
        int indexPos = posPencucian.indexWhere((element) => element['pos'] == inputPos);

        if (indexPos == -1) {
          print('Pos $inputPos tidak ditemukan. Pilih antara A, B, atau C.');
        } else if (posPencucian[indexPos]['plat'] == null) {
          print('Pos $inputPos saat ini sedang kosong, tidak ada antrian yang diselesaikan.');
        } else {
          String platSelesai = posPencucian[indexPos]['plat']!;
          print('Pencucian untuk Plat Nomor $platSelesai di Pos $inputPos telah selesai.');

          // Cek apakah ada kendaraan di waiting list
          if (waitingList.isNotEmpty) {
            // Ambil kendaraan paling depan (urutan pertama)
            String platBerikutnya = waitingList.removeAt(0);
            posPencucian[indexPos]['plat'] = platBerikutnya;
            print('Plat Nomor $platBerikutnya dari waiting list (urutan 1) otomatis masuk ke Pos $inputPos');
          } else {
            // Jika waiting list kosong, kosongkan pos
            posPencucian[indexPos]['plat'] = null;
            print('Pos $inputPos sekarang KOSONG.');
          }
        }
        break;

      case '5':
        print('Terima kasih! Program selesai.');
        berjalan = false;
        break;

      default:
        print('Pilihan tidak valid. Silakan masukkan angka 1-5.');
        break;
    }
  }
}