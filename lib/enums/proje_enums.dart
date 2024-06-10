enum Device { android, ios, desktop, web }
enum Lang { az, en, ru, tr }


enum Role {
  Unknow(0), Merchandiser(23), Forwarder(17), BH(15), Operator(4), Admin(35), SuperAdmin(1000);

  const Role(this.value);
  final num value;
}
