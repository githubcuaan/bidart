import 'package:bidart/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Illustration used by one onboarding page.
enum OnboardingVisual { welcome, scoring, recording, discovery, ready }

@immutable
class OnboardingPageContent {
  const OnboardingPageContent({
    required this.visual,
    required this.accent,
    required this.eyebrow,
    required this.title,
    required this.body,
    required this.ctaLabel,
    this.comingSoon = false,
  });

  final OnboardingVisual visual;
  final Color accent;
  final String eyebrow;
  final String title;
  final String body;
  final String ctaLabel;
  final bool comingSoon;
}

/// Copy and order of the first-run introduction.
const onboardingPages = <OnboardingPageContent>[
  OnboardingPageContent(
    visual: OnboardingVisual.welcome,
    accent: AppColors.primary,
    eyebrow: 'BIDART • TRỢ LÝ BÀN BIDA',
    title: 'Ghi điểm chuẩn.\nChơi hết mình.',
    body:
        'Trợ lý ghi điểm bắn đền cho bàn 2–5 người. Tự động chia điểm theo '
        'luật, lưu từng cú ngay trên máy — không cần mạng.',
    ctaLabel: 'Bắt đầu',
  ),
  OnboardingPageContent(
    visual: OnboardingVisual.scoring,
    accent: AppColors.secondary,
    eyebrow: '01 • CHIA ĐIỂM TỰ ĐỘNG',
    title: 'Không còn cãi nhau\nsau mỗi cú bi.',
    body:
        'Chọn hình bi vừa vào lỗ. BiDART tự tính người được cộng, người chịu '
        'đền và điểm của cả bàn theo đúng luật đề-pa.',
    ctaLabel: 'Tiếp tục',
  ),
  OnboardingPageContent(
    visual: OnboardingVisual.recording,
    accent: AppColors.primary,
    eyebrow: '02 • GHI CÚ TRONG 3 CHẠM',
    title: 'Chọn người. Chọn bi.\nXong.',
    body:
        'Chạm cơ thủ đang có cơ, chọn bi vừa ăn — điểm cập nhật ngay. Nhập '
        'nhầm? Hoàn tác từng cú, không giới hạn.',
    ctaLabel: 'Tiếp tục',
  ),
  OnboardingPageContent(
    visual: OnboardingVisual.discovery,
    accent: AppColors.secondary,
    eyebrow: '03 • RA NGOÀI BÀN',
    title: 'Tìm kèo. Tìm quán.\nNgay quanh bạn.',
    body:
        'Lướt tìm đối thủ cùng trình, xem quán còn bàn trống và chốt kèo '
        'trong vài chạm. Tính năng đang được hoàn thiện.',
    ctaLabel: 'Tiếp tục',
    comingSoon: true,
  ),
  OnboardingPageContent(
    visual: OnboardingVisual.ready,
    accent: AppColors.primary,
    eyebrow: '04 • SẴN SÀNG',
    title: 'Vào bàn thôi.',
    body:
        'Tạo phòng đầu tiên, chọn người đề-pa và người chịu đền. Mọi thứ còn '
        'lại để BiDART lo.',
    ctaLabel: 'Tạo phòng đầu tiên',
  ),
];
