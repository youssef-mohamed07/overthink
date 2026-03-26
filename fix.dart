import 'dart:io';

void main() {
  final file = File('lib/shared/layouts/main_layout.dart');
  var content = file.readAsStringSync();
  content = content.replaceFirst(
'''  @override
  void didUpdateWidget(covariant MainLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.navigationShell.currentIndex != _pageController.page?.round()) { 
      // Use jumpToPage to navigate instantly without swiping through intermedia
te screens                                                                            _pageController.jumpToPage(widget.navigationShell.currentIndex);
  @override
  void dispose() {''',
'''  @override
  void didUpdateWidget(covariant MainLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.navigationShell.currentIndex != _pageController.page?.round()) { 
      // Use jumpToPage to navigate instantly without swiping through intermediate screens
      _pageController.jumpToPage(widget.navigationShell.currentIndex);
    }
  }

  @override
  void dispose() {''');
  file.writeAsStringSync(content);
}
