class RenewableEnergy {
  final int? keyID;
  final String energyType;
  final double houseSize;
  final int numberOfResidents;
  final double averageEnergyUsage;
  final String location;
  final double roofArea;
  final String roofDirection;
  final String appliances;
  final double installationBudget;


  RenewableEnergy({
    this.keyID,
    required this.energyType,
    required this.houseSize,
    required this.numberOfResidents,
    required this.averageEnergyUsage,
    required this.location,
    required this.roofArea,
    required this.roofDirection,
    required this.appliances,
    required this.installationBudget, // เพิ่มฟิลด์งบประมาณ
  });

  Map<String, dynamic> toMap() {
    return {
      'keyID': keyID,
      'energyType': energyType,
      'houseSize': houseSize,
      'numberOfResidents': numberOfResidents,
      'averageEnergyUsage': averageEnergyUsage,
      'location': location,
      'roofArea': roofArea,
      'roofDirection': roofDirection,
      'appliances': appliances,
      'installationBudget': installationBudget, // บันทึกงบประมาณลงในแผนที่
    };
  }
}
