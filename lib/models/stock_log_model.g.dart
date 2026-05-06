// ============================================================
// GENERATED CODE – Hive Type Adapters for StockLogModel
// ============================================================

part of 'stock_log_model.dart';

class StockLogModelAdapter extends TypeAdapter<StockLogModel> {
  @override
  final int typeId = 1;

  @override
  StockLogModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StockLogModel(
      id: fields[0] as String,
      productId: fields[1] as String,
      productName: fields[2] as String,
      action: fields[3] as StockAction,
      quantity: fields[4] as int,
      previousQuantity: fields[5] as int,
      newQuantity: fields[6] as int,
      timestamp: fields[7] as DateTime,
      notes: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, StockLogModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.productId)
      ..writeByte(2)
      ..write(obj.productName)
      ..writeByte(3)
      ..write(obj.action)
      ..writeByte(4)
      ..write(obj.quantity)
      ..writeByte(5)
      ..write(obj.previousQuantity)
      ..writeByte(6)
      ..write(obj.newQuantity)
      ..writeByte(7)
      ..write(obj.timestamp)
      ..writeByte(8)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StockLogModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StockActionAdapter extends TypeAdapter<StockAction> {
  @override
  final int typeId = 2;

  @override
  StockAction read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return StockAction.stockIn;
      case 1:
        return StockAction.stockOut;
      default:
        return StockAction.stockIn;
    }
  }

  @override
  void write(BinaryWriter writer, StockAction obj) {
    switch (obj) {
      case StockAction.stockIn:
        writer.writeByte(0);
        break;
      case StockAction.stockOut:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StockActionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
