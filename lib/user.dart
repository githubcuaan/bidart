enum SkillLevel {
  beginner,
  intermediate,
  advanced
}

class User {
  String id;
  String phone;
  String name;
  String? avatarUrl;
  SkillLevel selfDeclaredLevel;
  DateTime createdAt;

  User({
    required this.id,
    required this.phone,
    required this.name,
    this.avatarUrl,
    required this.selfDeclaredLevel,
    required this.createdAt,
  });

  void register() {
    print("Dang ky thanh cong");
  }

  void login() {
    print("$name dang nhap thanh cong");
  }

  void updateProfile(String newName, String newPhone) {
    name = newName;
    phone = newPhone;
    print("Cap nhat thong tin thanh cong");
  }
}

void main() {
  User user1 = User(
    id: "USER001",
    phone: "0123456789",
    name: "Nguyen Van A",
    avatarUrl: null,
    selfDeclaredLevel: SkillLevel.beginner,
    createdAt: DateTime.now(),
  );

  user1.register();
  user1.login();

  user1.updateProfile("Nguyen Van B", "0987654321");

  print("ID: ${user1.id}");
  print("Ten: ${user1.name}");
  print("SDT: ${user1.phone}");
  print("Trinh do: ${user1.selfDeclaredLevel}");
  print("Ngay tao: ${user1.createdAt}");
}