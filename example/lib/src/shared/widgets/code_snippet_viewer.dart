import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Syntax-styled code viewer with an instant copy button.
class CodeSnippetViewer extends StatefulWidget {
  const CodeSnippetViewer({
    super.key,
    required this.code,
    this.title = 'Flutter Dart Snippet',
  });

  final String code;
  final String title;

  @override
  State<CodeSnippetViewer> createState() => _CodeSnippetViewerState();
}

class _CodeSnippetViewerState extends State<CodeSnippetViewer> {
  bool _copied = false;

  void _onCopy() {
    Clipboard.setData(ClipboardData(text: widget.code));
    setState(() => _copied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A), // Dark slate
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: const Color(0xFF334155),
          width: 1.0,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Toolbar header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
            color: const Color(0xFF1E293B),
            child: Row(
              children: [
                const Icon(Icons.terminal, size: 14.0, color: Color(0xFF94A3B8)),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      color: Color(0xFFCBD5E1),
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'monospace',
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton.icon(
                  onPressed: _onCopy,
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    foregroundColor: _copied ? const Color(0xFF10B981) : const Color(0xFF94A3B8),
                  ),
                  icon: Icon(_copied ? Icons.check : Icons.copy, size: 14.0),
                  label: Text(_copied ? 'Copied!' : 'Copy Code', style: const TextStyle(fontSize: 11.0)),
                ),
              ],
            ),
          ),

          // Code text display
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: SelectableText(
              widget.code,
              style: const TextStyle(
                color: Color(0xFFE2E8F0),
                fontSize: 12.0,
                fontFamily: 'monospace',
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
