class ModelRegions{
  int? regionId;
  String? regionAdi;
  double? uzunluq;
  double? eynilik;

  ModelRegions({this.regionId, this.regionAdi, this.uzunluq, this.eynilik});

  List<ModelRegions> listRegions(){
    return [
      ModelRegions(regionId:1, regionAdi:"BAKI",uzunluq: 49.451155,eynilik: 40.152562),
      ModelRegions(regionId:2, regionAdi:"GENCE",uzunluq: 50.451155,eynilik: 42.152562),
      ModelRegions(regionId:3, regionAdi:"MINGECEVIR",uzunluq: 50.481555,eynilik: 42.152562),
    ];
  }

}