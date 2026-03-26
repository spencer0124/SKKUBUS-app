import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:skkumap/design/sds_design.dart';

/// SdsButton 컴포넌트 테스트 페이지
///
/// 캠퍼스 탭 → 'SDS Button 테스트' 버튼으로 진입.
/// 모든 variant/color/size/display 조합을 실물 확인 가능.
class SdsButtonTestScreen extends StatelessWidget {
  const SdsButtonTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('SdsButton 테스트',
            style: SdsTypo.t5(weight: FontWeight.w700)),
        backgroundColor: Colors.white,
        foregroundColor: SdsColors.grey900,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(SdsSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle('Fill Variants'),
              _fillVariants(),
              _divider(),
              _sectionTitle('Weak Variants'),
              _weakVariants(),
              _divider(),
              _sectionTitle('Sizes'),
              _sizes(),
              _divider(),
              _sectionTitle('With Icon'),
              _withIcon(),
              _divider(),
              _sectionTitle('Display Modes'),
              _displayModes(),
              _divider(),
              _sectionTitle('States'),
              _states(),
              _divider(),
              _sectionTitle('Pressed Feedback (탭해서 확인)'),
              _pressedFeedback(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // ── Sections ──

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: SdsSpacing.md),
      child: Text(title,
          style: SdsTypo.t5(weight: FontWeight.w700)
              .copyWith(color: SdsColors.grey900)),
    );
  }

  Widget _divider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: SdsSpacing.lg),
      child: Divider(color: SdsColors.grey100, height: 1),
    );
  }

  Widget _fillVariants() {
    return Wrap(
      spacing: SdsSpacing.sm,
      runSpacing: SdsSpacing.sm,
      children: [
        SdsButton(
            text: 'Primary', color: SdsButtonColor.primary, onPressed: () {}),
        SdsButton(
            text: 'Dark', color: SdsButtonColor.dark, onPressed: () {}),
        SdsButton(
            text: 'Danger', color: SdsButtonColor.danger, onPressed: () {}),
        SdsButton(
            text: 'Light', color: SdsButtonColor.light, onPressed: () {}),
      ],
    );
  }

  Widget _weakVariants() {
    return Wrap(
      spacing: SdsSpacing.sm,
      runSpacing: SdsSpacing.sm,
      children: [
        SdsButton(
            text: 'Primary',
            variant: SdsButtonVariant.weak,
            color: SdsButtonColor.primary,
            onPressed: () {}),
        SdsButton(
            text: 'Dark',
            variant: SdsButtonVariant.weak,
            color: SdsButtonColor.dark,
            onPressed: () {}),
        SdsButton(
            text: 'Danger',
            variant: SdsButtonVariant.weak,
            color: SdsButtonColor.danger,
            onPressed: () {}),
        SdsButton(
            text: 'Light',
            variant: SdsButtonVariant.weak,
            color: SdsButtonColor.light,
            onPressed: () {}),
      ],
    );
  }

  Widget _sizes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _labeled('small (32px)',
            SdsButton(text: '버튼', size: SdsButtonSize.small, onPressed: () {})),
        const SizedBox(height: SdsSpacing.sm),
        _labeled('medium (40px)',
            SdsButton(text: '버튼', size: SdsButtonSize.medium, onPressed: () {})),
        const SizedBox(height: SdsSpacing.sm),
        _labeled('large (48px)',
            SdsButton(text: '버튼', size: SdsButtonSize.large, onPressed: () {})),
        const SizedBox(height: SdsSpacing.sm),
        _labeled('xlarge (56px)',
            SdsButton(text: '버튼', size: SdsButtonSize.xlarge, onPressed: () {})),
      ],
    );
  }

  Widget _withIcon() {
    return Wrap(
      spacing: SdsSpacing.sm,
      runSpacing: SdsSpacing.sm,
      children: [
        SdsButton(
            text: '검색',
            icon: const Icon(Icons.search),
            onPressed: () {}),
        SdsButton(
            text: '위치',
            icon: const Icon(Icons.location_on),
            color: SdsButtonColor.dark,
            onPressed: () {}),
        SdsButton(
            text: '삭제',
            icon: const Icon(Icons.delete_outline),
            color: SdsButtonColor.danger,
            onPressed: () {}),
        SdsButton(
            text: '새로고침',
            icon: const Icon(Icons.refresh),
            variant: SdsButtonVariant.weak,
            onPressed: () {}),
        SdsButton(
            text: '공유',
            icon: const Icon(Icons.share),
            variant: SdsButtonVariant.weak,
            color: SdsButtonColor.dark,
            size: SdsButtonSize.small,
            onPressed: () {}),
      ],
    );
  }

  Widget _displayModes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _labeled(
          'inline (내용 크기)',
          SdsButton(
              text: '인라인 버튼',
              display: SdsButtonDisplay.inline,
              onPressed: () {}),
        ),
        const SizedBox(height: SdsSpacing.base),
        _labeled(
          'full (전체 너비)',
          SdsButton(
              text: '전체 너비 버튼',
              display: SdsButtonDisplay.full,
              onPressed: () {}),
        ),
        const SizedBox(height: SdsSpacing.base),
        _labeled(
          'full + xlarge (CTA 패턴)',
          SdsButton(
              text: '다음으로',
              display: SdsButtonDisplay.full,
              size: SdsButtonSize.xlarge,
              onPressed: () {}),
        ),
        const SizedBox(height: SdsSpacing.base),
        _labeled('block (Row + Expanded 다이얼로그 패턴)', const SizedBox()),
        const SizedBox(height: SdsSpacing.xs),
        Row(
          children: [
            Expanded(
              child: SdsButton(
                  text: '닫기',
                  variant: SdsButtonVariant.weak,
                  color: SdsButtonColor.dark,
                  size: SdsButtonSize.large,
                  display: SdsButtonDisplay.block,
                  onPressed: () {}),
            ),
            const SizedBox(width: SdsSpacing.sm),
            Expanded(
              child: SdsButton(
                  text: '확인',
                  size: SdsButtonSize.large,
                  display: SdsButtonDisplay.block,
                  onPressed: () {}),
            ),
          ],
        ),
      ],
    );
  }

  Widget _states() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _labeled('normal',
            SdsButton(text: '확인하기', onPressed: () {})),
        const SizedBox(height: SdsSpacing.sm),
        _labeled('loading',
            SdsButton(text: '확인하기', isLoading: true, onPressed: () {})),
        const SizedBox(height: SdsSpacing.sm),
        _labeled('disabled',
            SdsButton(text: '확인하기', disabled: true, onPressed: () {})),
        const SizedBox(height: SdsSpacing.sm),
        _labeled('loading + disabled',
            SdsButton(text: '확인하기', isLoading: true, disabled: true, onPressed: () {})),
      ],
    );
  }

  Widget _pressedFeedback() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _labeled(
          'fill 색상별 pressed bg 비교',
          const SizedBox(),
        ),
        const SizedBox(height: SdsSpacing.xs),
        Wrap(
          spacing: SdsSpacing.sm,
          runSpacing: SdsSpacing.sm,
          children: [
            SdsButton(text: 'Primary', onPressed: () {}),
            SdsButton(text: 'Dark', color: SdsButtonColor.dark, onPressed: () {}),
            SdsButton(text: 'Danger', color: SdsButtonColor.danger, onPressed: () {}),
            SdsButton(text: 'Light', color: SdsButtonColor.light, onPressed: () {}),
          ],
        ),
        const SizedBox(height: SdsSpacing.md),
        _labeled(
          'weak 색상별 pressed bg 비교',
          const SizedBox(),
        ),
        const SizedBox(height: SdsSpacing.xs),
        Wrap(
          spacing: SdsSpacing.sm,
          runSpacing: SdsSpacing.sm,
          children: [
            SdsButton(text: 'Primary', variant: SdsButtonVariant.weak, onPressed: () {}),
            SdsButton(text: 'Dark', variant: SdsButtonVariant.weak, color: SdsButtonColor.dark, onPressed: () {}),
            SdsButton(text: 'Danger', variant: SdsButtonVariant.weak, color: SdsButtonColor.danger, onPressed: () {}),
            SdsButton(text: 'Light', variant: SdsButtonVariant.weak, color: SdsButtonColor.light, onPressed: () {}),
          ],
        ),
      ],
    );
  }

  // ── Helpers ──

  Widget _labeled(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: SdsTypo.t7().copyWith(color: SdsColors.grey500)),
        const SizedBox(height: SdsSpacing.xs),
        child,
      ],
    );
  }
}
