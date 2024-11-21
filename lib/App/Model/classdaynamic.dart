class Daynamic {
  Map<String, dynamic> _properties = {};

  // Set a property dynamically
  void setProperty(String key, dynamic value) {
    _properties[key] = value;
  }

  // Get a property dynamically
  dynamic getProperty(String key) {
    return _properties[key];
  }

  // Remove a property
  void removeProperty(String key) {
    _properties.remove(key);
  }

  // Get all properties
  Map<String, dynamic> get properties => _properties;

  @override
  String toString() {
    return _properties.toString();
  }
}

void main() {
  Daynamic obj = Daynamic();
  obj.setProperty('name', 'Flutter');
  obj.setProperty('version', 3.7);
  obj.setProperty('isAwesome', true);
  print(obj.getProperty('name')); // Output: Flutter
  print(obj); // Output: {name: Flutter, version: 3.7, isAwesome: true}

  obj.removeProperty('version');
  print(obj); // Output: {name: Flutter, isAwesome: true}
}
