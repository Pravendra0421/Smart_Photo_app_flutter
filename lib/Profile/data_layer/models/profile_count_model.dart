class ProfileCounts {
  final int uploadPhoto;
  final int uploadVideo;

  ProfileCounts({
    required this.uploadPhoto,
    required this.uploadVideo,
  });

  factory ProfileCounts.fromJson(Map<String, dynamic> json) {
    return ProfileCounts(
      uploadPhoto: json['uploadPhoto'] ?? 0, // Default to 0 if null
      uploadVideo: json['uploadVideo'] ?? 0, // Default to 0 if null
    );
  }
}