import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/course_data.dart';
import '../services/storage_service.dart';

class AboutInstructorScreen extends StatelessWidget {
  const AboutInstructorScreen({super.key});

  Future<void> _openUrlWithFallback(
    BuildContext context,
    String url,
    String copyText,
    String copyLabel,
  ) async {
    final launched = await StorageService.instance.launchExternalUrl(url);
    if (!launched && context.mounted) {
      Clipboard.setData(ClipboardData(text: copyText));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$copyLabel ($copyText) copied to clipboard!'),
        ),
      );
    }
  }

  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied: $text'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Profile Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF071629),
                  Color(0xFF0E395E),
                  Color(0xFF0B4F6C),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0E395E).withValues(alpha: 0.25),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 86,
                  height: 86,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00E5FF), Color(0xFF00B0FF)],
                    ),
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: const Text(
                    'RZ',
                    style: TextStyle(
                      color: Color(0xFF071527),
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  CourseData.instructorName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFC400).withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFFFC400).withValues(alpha: 0.7),
                    ),
                  ),
                  child: const Text(
                    'Full Stack Developer • Python, Java, C++, AI',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFFFD54F),
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  CourseData.instructorBio,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13.5,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: CourseData.instructorSkills
                      .map(
                        (skill) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 11,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: Text(
                            skill,
                            style: const TextStyle(
                              color: Color(0xFF80DEEA),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Easy Student Contact & Support',
            style: TextStyle(
              color: Color(0xFF0D233A),
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Tap any button below to contact Sir Rashid Zada directly on WhatsApp, Email, or Phone:',
            style: TextStyle(
              color: Color(0xFF475569),
              fontSize: 13.5,
            ),
          ),
          const SizedBox(height: 12),

          // WhatsApp Card
          _ContactCard(
            icon: Icons.chat_rounded,
            accentColor: const Color(0xFF16A34A),
            title: 'WhatsApp Direct Chat',
            value: CourseData.instructorWhatsappDisplay,
            subtitle: 'Tap to message on WhatsApp (+92 347 0983567)',
            primaryActionLabel: 'Open WhatsApp',
            onPrimaryTap: () => _openUrlWithFallback(
              context,
              'https://wa.me/${CourseData.instructorWhatsappIntl}?text=Assalam-o-Alaikum%20Sir%20Rashid%20Zada,%20I%20have%20a%20question%20about%20Programming%20Fundamentals.',
              CourseData.instructorWhatsappDisplay,
              'WhatsApp Number',
            ),
            onCopyTap: () => _copyToClipboard(
              context,
              CourseData.instructorWhatsappDisplay,
              'WhatsApp Number',
            ),
          ),

          const SizedBox(height: 12),

          // Email Card
          _ContactCard(
            icon: Icons.email_rounded,
            accentColor: const Color(0xFF0284C7),
            title: 'Email Address',
            value: CourseData.instructorEmail,
            subtitle: 'Send your code questions or assignment queries via email',
            primaryActionLabel: 'Send Email',
            onPrimaryTap: () => _openUrlWithFallback(
              context,
              'mailto:${CourseData.instructorEmail}?subject=Programming%20Fundamentals%20Student%20Question',
              CourseData.instructorEmail,
              'Email Address',
            ),
            onCopyTap: () => _copyToClipboard(
              context,
              CourseData.instructorEmail,
              'Email Address',
            ),
          ),

          const SizedBox(height: 12),

          // Direct Phone Call Card
          _ContactCard(
            icon: Icons.phone_in_talk_rounded,
            accentColor: const Color(0xFF0E395E),
            title: 'Phone / Call',
            value: CourseData.instructorWhatsappDisplay,
            subtitle: 'Open phone dialer with 03470983567',
            primaryActionLabel: 'Call Now',
            onPrimaryTap: () => _openUrlWithFallback(
              context,
              'tel:${CourseData.instructorWhatsappDisplay}',
              CourseData.instructorWhatsappDisplay,
              'Phone Number',
            ),
            onCopyTap: () => _copyToClipboard(
              context,
              CourseData.instructorWhatsappDisplay,
              'Phone Number',
            ),
          ),

          const SizedBox(height: 20),

          // About This Booklet Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.menu_book_rounded, color: Color(0xFF0E395E)),
                    SizedBox(width: 8),
                    Text(
                      'About This Course & Booklet',
                      style: TextStyle(
                        color: Color(0xFF0E395E),
                        fontSize: 16.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  CourseData.aboutBooklet,
                  style: TextStyle(
                    color: Color(0xFF334155),
                    fontSize: 14,
                    height: 1.45,
                  ),
                ),
                const Divider(height: 24),
                const _CourseDetailRow(
                  label: 'Subject',
                  value: CourseData.courseTitle,
                ),
                const _CourseDetailRow(
                  label: 'Credit Hours',
                  value: CourseData.creditHours,
                ),
                const _CourseDetailRow(
                  label: 'Instructor',
                  value: CourseData.instructorName,
                ),
                const _CourseDetailRow(
                  label: 'Tech Stack',
                  value: 'Python • Java • C++ • AI • Full Stack',
                ),
                const _CourseDetailRow(
                  label: 'Coverage',
                  value: CourseData.coverage,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Back Cover Motto Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF0F2942),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF00E5FF)),
            ),
            child: const Column(
              children: [
                Text(
                  CourseData.backCoverMotto,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    height: 1.35,
                    letterSpacing: 0.8,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  CourseData.backCoverQuote,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFB2EBF2),
                    fontSize: 13.5,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final IconData icon;
  final Color accentColor;
  final String title;
  final String value;
  final String subtitle;
  final String primaryActionLabel;
  final VoidCallback onPrimaryTap;
  final VoidCallback onCopyTap;

  const _ContactCard({
    required this.icon,
    required this.accentColor,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.primaryActionLabel,
    required this.onPrimaryTap,
    required this.onCopyTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accentColor.withValues(alpha: 0.35), width: 1.4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: accentColor, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    SelectableText(
                      value,
                      style: const TextStyle(
                        color: Color(0xFF0F172A),
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Copy',
                onPressed: onCopyTap,
                icon: const Icon(Icons.copy_rounded, color: Color(0xFF64748B)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFF475569),
              fontSize: 12.5,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onPrimaryTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 11),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: Icon(icon, size: 18),
              label: Text(
                primaryActionLabel,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CourseDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _CourseDetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w700,
                fontSize: 13.5,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF0F172A),
                fontWeight: FontWeight.w800,
                fontSize: 13.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
