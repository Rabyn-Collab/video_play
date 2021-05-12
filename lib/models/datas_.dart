class Data{

  final String title;
  final String imageUrl;
  final String duration;
  final String videoUrl;


  Data({
    this.title,
    this.duration,
    this.imageUrl,
    this.videoUrl
});

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      title: json['title'],
      imageUrl: json['imageUrl'],
      duration: json['duration'],
      videoUrl: json['videoUrl']
    );
  }


}