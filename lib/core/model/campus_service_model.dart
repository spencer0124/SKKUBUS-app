enum ActionType {
  route,
  webview,
  external;

  static ActionType fromString(String value) {
    if (value == 'url') return ActionType.external;
    return ActionType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ActionType.external,
    );
  }
}
