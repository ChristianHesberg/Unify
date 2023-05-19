class AppImage{
  String url;
  String name;

  AppImage(this.url, this.name);

  AppImage.fromMap(Map<String, dynamic> data)
    : url = data['url'],
      name = data['name'];

}