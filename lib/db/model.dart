const String table = 'receipt';

const int kVersion = 1;

class Receipt {
  int? id;
  int? errorCode;
  String? fpdm;
  String? fphm;
  String? gfmc;
  String? je;
  String? kprq;
  String? filePath;

  Receipt(
      {this.id,
      this.errorCode,
      this.fpdm,
      this.fphm,
      this.gfmc,
      this.je,
      this.kprq,
      this.filePath});

  Receipt.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    errorCode = json['ErrorCode'];
    fpdm = json['fpdm'];
    fphm = json['fphm'];
    gfmc = json['gfmc'];
    je = json['je'];
    kprq = json['kprq'];
    filePath = json['filePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ErrorCode'] = this.errorCode;
    data['fpdm'] = this.fpdm;
    data['fphm'] = this.fphm;
    data['gfmc'] = this.gfmc;
    data['je'] = this.je;
    data['kprq'] = this.kprq;
    data['filePath'] = this.filePath;
    return data;
  }
}
