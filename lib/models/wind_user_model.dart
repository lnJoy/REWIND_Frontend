class User {
  final String id;
  final String name;
  final String? profile;

  List<User> users = [];

  User({
    required this.id,
    required this.name,
    this.profile,
  });

  User.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      name = json['name'],
      profile = json['profile'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'profile': profile
  };
}