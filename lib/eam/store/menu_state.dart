class MenuState {
  late Map<String, dynamic> menu;
  final List<String> validatedType = ["root", "folder", "class"];
  late bool loading;

  MenuState({this.menu = const {}, this.loading = false});

  MenuState copyWith({Map<String, dynamic>? menu, bool? loading}) {
    return MenuState(menu: menu ?? this.menu, loading: loading ?? this.loading);
  }
}
