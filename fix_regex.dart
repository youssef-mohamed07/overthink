import 'dart:io';

void main() {
  final file = File('lib/shared/layouts/main_layout.dart');
  var content = file.readAsStringSync();
  content = content.replaceAll(RegExp(r'super\.didUpdateWidget\(oldWidget\);\s+if \(widget\.navigationShell\.currentIndex != _pageController\.page\?\.round\(\)\) \{\s+// Use jumpToPage to navigate instantly without swiping through intermedia[ \r\n\t]*te screens\s+_pageController\.jumpToPage\(widget\.navigationShell\.currentIndex\);\s+@override'), '''super.didUpdateWidget(oldWidget);
    if (widget.navigationShell.currentIndex != _pageController.page?.round()) { 
      // Use jumpToPage to navigate instantly without swiping through intermediate screens
      _pageController.jumpToPage(widget.navigationShell.currentIndex);
    }
  }

  @override''');
  file.writeAsStringSync(content);
}
