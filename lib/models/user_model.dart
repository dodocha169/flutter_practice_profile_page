class User {
  final int id;
  final String name;
  final String email;
  Profile? profile;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.profile,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      profile:
          json['profile'] != null ? Profile.fromJson(json['profile']) : null,
    );
  }
}

class Profile {
  final int id;
  final int userId;
  String? twitterUrl;
  String? githubUrl;
  String profileImage;

  Profile({
    required this.id,
    required this.userId,
    this.twitterUrl,
    this.githubUrl,
    required this.profileImage,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      userId: json['user_id'],
      twitterUrl: json['twitter_url'],
      githubUrl: json['github_url'],
      profileImage: json['profile_image'],
    );
  }
}
