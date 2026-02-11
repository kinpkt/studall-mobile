String getInitials(String name) {
  if (name.isEmpty) return "";

  String cleanName = name.trim();
  return cleanName.length >= 2
      ? cleanName.substring(0, 2).toUpperCase()
      : cleanName.toUpperCase();
}
