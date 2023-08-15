class MenuState {
  late Map<String, dynamic> menu;
  final List<String> validatedType = ["root", "folder", "class"];
  late List<String> expandedNodeIds;
  late bool loading;

  MenuState(
      {this.menu = const {},
      this.loading = false,
      this.expandedNodeIds = const []});

  MenuState copyWith({Map<String, dynamic>? menu, bool? loading, List<String>? expandedNodeIds}) {
    return MenuState(menu: menu ?? this.menu, loading: loading ?? this.loading, expandedNodeIds: expandedNodeIds ?? this.expandedNodeIds);
  }
}
