abstract class DataAccessInterface {
  /// Get id for indexing
  String getId();

  /// Get examples (which will be used as keys) for indexing
  List<String> getExamples();

  String getDescription();

  String getImagePath();
}
