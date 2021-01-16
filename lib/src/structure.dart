class ICalStructure {
  final String type;
  final List<ICalRow> rows;
  final List<ICalStructure> children;

  ICalRow operator [](String key) {
    return rows.firstWhere((row) => row.key == key, orElse: () => null);
  }

  const ICalStructure(this.type, this.rows, this.children);

  factory ICalStructure.fromRows(List<ICalRow> rows) {
    final beginRow = rows.removeAt(0);
    if(beginRow == null) throw Exception("No begin row found");
    final type = beginRow.value;
    final List<ICalStructure> children = [];

    var beginIndex = rows.indexWhere((element) => element.key == "BEGIN");
    while(beginIndex != -1) {
      final subType = rows[beginIndex].value;
      final endIndex = rows.indexWhere((element) => element.key == "END" && element.value == subType) + 1;
      if(endIndex == 0) throw Exception("No END row found for type $subType");
      final subStructure = rows.getRange(beginIndex, endIndex);
      children.add(ICalStructure.fromRows(subStructure.toList()));
      rows.removeRange(beginIndex, endIndex);
      beginIndex = rows.indexWhere((element) => element.key == "BEGIN");
    }
    // remove END row
    // TODO check if end row is valid
    final endRow = rows.removeLast();
    if(endRow.key != "END" || endRow.value != type) throw Exception("Invalid END row");
    return ICalStructure(type, rows, children);
  }
}

class ICalRow {
  final String key;
  final String value;
  final Map<String, String> properties;

  const ICalRow(this.key, this.value, {this.properties = const {}});
}