class DropDownOption<T> {
  final String id;
  final String label;
  final T? value;

  DropDownOption({required this.id, required this.label, this.value});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DropDownOption &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  T? get getValue => value;
}
