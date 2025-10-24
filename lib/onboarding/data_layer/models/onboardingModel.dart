class OnboardingModel{
  final String id;
  final int order;
  final String title;
  final String subTitle;
  final String mainTitle;
  final String imageUrl;
  final String bgUrl;
  final String buttonText;
  final bool isEnabled;
  OnboardingModel({
    required this.id,
    required this.order,
    required this.title,
    required this.subTitle,
    required this.mainTitle,
    required this.imageUrl,
    required this.bgUrl,
    required this.buttonText,
    required this.isEnabled,
  });
  factory OnboardingModel.fromJson(Map<String, dynamic> json) {
    return OnboardingModel(
      id: json['id'] ?? '',
      order: json['order'] ?? 0,
      title: json['title'] ?? 'No Title',
      subTitle: json['subTitle'] ?? '',
      mainTitle: json['MainTitle'] ?? 'KwikPic',
      imageUrl: json['imageUrl'] ?? '',
      bgUrl: json['bgUrl'] ?? '',
      buttonText: json['buttonText'] ?? 'Next',
      isEnabled: json['isEnabled'] ?? false,
    );
  }
}