class FetchMenuAction {}

class FetchMenuSuccessAction {
  Map<String, dynamic> menu;
  FetchMenuSuccessAction({required this.menu});
}

class UpdateExpandedNodeIds {
  String nodeId;
  bool expanded;
  UpdateExpandedNodeIds({required this.nodeId, required this.expanded});
}
