class Post {
  String?
      id; // O id é opcional e será atribuído automaticamente pelo banco de dados
  late final String title;
  final String description; // Descrição do post
  final String content; // Texto principal do post
  final String photoUrl; // URL da foto (pode ser um link ou caminho local)
  final String author;
  final String userId; // ID do usuário associado ao post
  final DateTime date; // Data de criação do post

  // Construtor
  Post({
    this.id, // O id pode ser nulo no momento da criação
    required this.title,
    required this.description,
    required this.content,
    required this.photoUrl,
    required this.author,
    required this.userId,
    required this.date,
  });

  // Converte um JSON para um objeto Post
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      title: json["title"],
      id: json['id'], // O id será atribuído automaticamente pelo banco
      description: json['description'],
      content: json['content'],
      photoUrl: json['photoUrl'],
      author: json['author'],
      date: DateTime.parse(json['date']),
      userId: json['userId'],
    );
  }

  // Converte o objeto Post para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id, // O id pode ser nulo ou atribuído depois
      'title': title,
      'description': description,
      'content': content,
      'photoUrl': photoUrl,
      'author': author,
      'userId': userId,
      'date': date.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Post{id: $id, title: $title, description: $description, content: $content, photoUrl: $photoUrl, author: $author, date: $date}';
  }
}
