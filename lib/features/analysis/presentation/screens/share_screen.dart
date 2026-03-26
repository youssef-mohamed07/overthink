import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/theme/app_colors.dart';

class ShareScreen extends StatefulWidget {
  const ShareScreen({super.key});

  @override
  State<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  int _selectedStyle = 0;
  final GlobalKey _globalKey = GlobalKey();
  bool _isSharing = false;

  final String query = "He didn't use an emoji in the last text. Is he bored or just busy?";

  Future<void> _shareImage() async {
    if (_isSharing) return;
    setState(() => _isSharing = true);
    
    await Future.delayed(const Duration(milliseconds: 100));

    try {
      RenderRepaintBoundary boundary = _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final directory = await getTemporaryDirectory();
      final targetPath = '${directory.path}/overthink_share_${DateTime.now().millisecondsSinceEpoch}.png';
      final imagePath = await File(targetPath).create(recursive: true);
      await imagePath.writeAsBytes(pngBytes);

      await Share.shareXFiles(
        [XFile(imagePath.path)], 
        text: "I might be overthinking this... 🤔💭 #OverthinkApp",
      );
    } catch (e) {
      debugPrint('Error sharing image: $e');
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                    onPressed: () => context.pop(),
                  ),
                  const Text('SHARE FORMAT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.5, fontSize: 12)),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            
            // Format Selector
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  _FormatChip(
                    label: 'Aesthetic',
                    icon: Icons.auto_awesome,
                    isSelected: _selectedStyle == 0,
                    onTap: () => setState(() => _selectedStyle = 0),
                  ),
                  const SizedBox(width: 12),
                  _FormatChip(
                    label: 'Chat',
                    icon: Icons.chat_bubble_outline,
                    isSelected: _selectedStyle == 1,
                    onTap: () => setState(() => _selectedStyle = 1),
                  ),
                  const SizedBox(width: 12),
                  _FormatChip(
                    label: 'Meme',
                    icon: Icons.tag_faces,
                    isSelected: _selectedStyle == 2,
                    onTap: () => setState(() => _selectedStyle = 2),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),

            // Canvas
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: RepaintBoundary(
                      key: _globalKey,
                      child: Container(
                        // Add an opaque background for the shared image so it doesn't have transparency issues
                        color: AppColors.backgroundDark, 
                        child: _buildShareCard(),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Share Action
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: _shareImage,
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, Color(0xFFE0B0FF)],
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(color: AppColors.primary.withValues(alpha: 0.4), blurRadius: 20, offset: const Offset(0, 5)),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_isSharing) 
                              const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                            else
                              const Icon(Icons.auto_awesome_mosaic, color: Colors.black, size: 22),
                            const SizedBox(width: 8),
                            Text(_isSharing ? 'GENERATING...' : 'SHARE NOW', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.black, letterSpacing: 1)),
                          ],
                        ),
                      ),
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

  Widget _buildShareCard() {
    switch (_selectedStyle) {
      case 1:
        return _buildChatFormat();
      case 2:
        return _buildMemeFormat();
      case 0:
      default:
        return _buildAestheticFormat();
    }
  }

  Widget _buildAestheticFormat() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.psychology, color: AppColors.primary, size: 28),
              ),
              const SizedBox(width: 12),
              const Text('Overthink', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white)),
            ],
          ),
          const SizedBox(height: 32),
          Text('THE OVERSIGHT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white.withValues(alpha: 0.4), letterSpacing: 1.5)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.backgroundDark,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text('"$query"', style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic, color: Colors.white, height: 1.4)),
          ),
          const SizedBox(height: 24),
          const Text('THE ANALYSIS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary, letterSpacing: 1.5)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.backgroundDark,
              borderRadius: BorderRadius.circular(20),
              border: const Border(left: BorderSide(color: AppColors.primary, width: 4)),
            ),
            child: const Text(
              'The lack of a "sparkle" emoji indicates an 84% decay in conversational dopamine. This is likely the beginning of a digital ice age.', 
              style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5)
            ),
          ),
          const SizedBox(height: 24),
          const _Watermark(),
        ],
      ),
    );
  }

  Widget _buildChatFormat() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40, height: 40,
                decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                child: const Icon(Icons.psychology, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              const Text('Overthink AI', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
          const SizedBox(height: 32),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              margin: const EdgeInsets.only(left: 40),
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFF2A2A2A),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomLeft: Radius.circular(20)),
              ),
              child: Text(query, style: const TextStyle(color: Colors.white, fontSize: 15)),
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.only(right: 40),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
              ),
              child: const Text(
                'Bruh. He is literally just drinking coffee and has one hand free. Stop making scenarios up. 😌☕', 
                style: TextStyle(color: Colors.white, fontSize: 15, height: 1.4)
              ),
            ),
          ),
          const SizedBox(height: 32),
          const _Watermark(),
        ],
      ),
    );
  }

  Widget _buildMemeFormat() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24, width: 4),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            color: Colors.white,
            width: double.infinity,
            child: Column(
              children: [
                const Text("ME: *Provides perfectly logical evidence*", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Impact')),
                const SizedBox(height: 12),
                Text(query, style: const TextStyle(color: Colors.black87, fontSize: 14)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(32),
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [AppColors.error, AppColors.tertiary], begin: Alignment.topLeft, end: Alignment.bottomRight),
            ),
            child: const Center(
              child: Text(
                "MY BRAIN:\nHE HATES YOU NOW",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 24,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: _Watermark(isDark: false),
          ),
        ],
      ),
    );
  }
}

class _FormatChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _FormatChip({required this.label, required this.icon, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: isSelected ? AppColors.primary : Colors.white24),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? Colors.black : Colors.white70, size: 16),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(color: isSelected ? Colors.black : Colors.white70, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class _Watermark extends StatelessWidget {
  final bool isDark;
  const _Watermark({this.isDark = true});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.psychology, size: 14, color: isDark ? Colors.white38 : Colors.white70),
          const SizedBox(width: 4),
          Text(
            'Made with Overthink App', 
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isDark ? Colors.white38 : Colors.white70, letterSpacing: 1),
          ),
        ],
      ),
    );
  }
}
