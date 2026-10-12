import 'package:bidart/core/enum/skill_level.dart';
import 'package:bidart/models/user.dart';

final mockCurrentUser = User(
  id: 'usr_001',
  name: 'Cơ Thủ Hoàng Nam',
  email: 'hoangnam.bida@gmail.com',
  phone: '0987654321',
  avatar: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=400',
  level: SkillLevel.e,
);

final List<User> mockOpponents = [
  const User(
    id: 'opp_001',
    name: 'Nguyễn Văn A',
    email: 'nva@gmail.com',
    phone: '0901112223',
    avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=600',
    level: SkillLevel.d, 
  ),
  const User(
    id: 'opp_002',
    name: 'Nguyễn Thị B',
    email: 'ntb@gmail.com',
    phone: '0902223334',
    avatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=600',
    level: SkillLevel.f,
  ),
  const User(
    id: 'opp_003',
    name: 'Nguyễn Văn C',
    email: 'nvc@gmail.com',
    phone: '0903334445',
    avatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=600',
    level: SkillLevel.c, 
  ),
  const User(
    id: 'opp_004',
    name: 'Nguyễn Thị D',
    email: 'ntd@gmail.com',
    phone: '0904445556',
    avatar: 'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?w=600',
    level: SkillLevel.e, 
  ),
];
