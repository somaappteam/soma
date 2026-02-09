import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:soma/l10n/gen/app_localizations.dart';

import '../../core/widgets/glass.dart';
import '../../core/theme/tokens.dart';
import 'legal_data.dart';

enum AboutView {
  version,
  termsAndPrivacy,
}

class AboutScreen extends StatelessWidget {
  final AboutView view;

  const AboutScreen({super.key, required this.view});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    // Determine title based on view
    final String title = view == AboutView.version 
        ? l10n.settingsVersion 
        : l10n.settingsTermsPrivacy;

    return Scaffold(
      body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(12),
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 30),
              
              if (view == AboutView.version)
                Glass(
                  radius: T.r20,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "SOMA",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        l10n.aboutVersion("1.0.0"),
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        l10n.aboutDescription,
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.9), height: 1.5),
                      ),
                    ],
                  ),
                ),

              if (view == AboutView.termsAndPrivacy)
                Glass(
                  radius: T.r20,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _InfoRow(
                        label: l10n.aboutTerms,
                        onTap: () => _openLegalDoc(context, l10n.aboutTerms, LegalData.termsOfService),
                      ),
                      const Divider(color: Colors.white12),
                      _InfoRow(
                        label: l10n.aboutPrivacy,
                        onTap: () => _openLegalDoc(context, l10n.aboutPrivacy, LegalData.privacyPolicy),
                      ),
                      const Divider(color: Colors.white12),
                      _InfoRow(
                        label: l10n.aboutOpenSource,
                        onTap: () => showLicensePage(
                          context: context,
                          applicationName: "SOMA",
                          applicationVersion: "1.0.0",
                          applicationLegalese: LegalData.attributions,
                          useRootNavigator: true,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
    );
  }

  void _openLegalDoc(BuildContext context, String title, String content) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _LegalDetailScreen(title: title, content: content),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _InfoRow({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: Colors.white.withValues(alpha: 0.5)),
          ],
        ),
      ),
    );
  }
}

class _LegalDetailScreen extends StatelessWidget {
  final String title;
  final String content;

  const _LegalDetailScreen({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Markdown(
        data: content,
        styleSheet: MarkdownStyleSheet(
          p: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 15, height: 1.5),
          h1: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          h2: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, height: 2),
          listBullet: const TextStyle(color: Colors.white),
          blockSpacing: 16,
        ),
      ),
    );
  }
}
