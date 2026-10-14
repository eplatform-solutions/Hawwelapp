import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hawwel/constans/app_branding.dart';
import 'package:hawwel/constans/token.dart';
import 'package:hawwel/main.dart' show navigatorKey;
import 'package:hawwel/featue/support_chat/support_chat_view.dart';
import 'package:hawwel/featue/support_chat/data/unread_chat_state.dart';

// Tracks the currently visible route by name so the floating chat button
// can hide itself while the user is already on the chat screen - kept as
// its own observer (rather than reusing Navigator.of in the button's own
// context) because the button lives in MaterialApp.builder, above the
// Navigator, where Navigator.of(context) would not reliably resolve to it.
class CurrentRouteObserver extends NavigatorObserver {
  static final ValueNotifier<String?> currentRouteName =
      ValueNotifier<String?>(null);

  void _update(Route<dynamic>? route) {
    currentRouteName.value = route?.settings.name;
    ChatUnreadState.refreshFromServer();
  }

  @override
  void didPush(Route route, Route? previousRoute) => _update(route);

  @override
  void didPop(Route route, Route? previousRoute) => _update(previousRoute);

  @override
  void didRemove(Route route, Route? previousRoute) => _update(previousRoute);

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) => _update(newRoute);
}

// A draggable "chat head" that floats above every screen once the user is
// logged in, matching the same overlay pattern used by Messenger/WhatsApp
// support widgets. Position is remembered per device across app restarts.
class FloatingChatButton extends StatefulWidget {
  const FloatingChatButton({super.key});

  @override
  State<FloatingChatButton> createState() => _FloatingChatButtonState();
}

class _FloatingChatButtonState extends State<FloatingChatButton> {
  static const double _size = 58;
  static const String _prefKeyDx = 'chat_fab_dx';
  static const String _prefKeyDy = 'chat_fab_dy';
  static const double _dragTapThreshold = 6;

  Offset? _position;
  Offset _dragAccum = Offset.zero;
  bool _dragging = false;

  @override
  void initState() {
    super.initState();
    _restorePosition();
  }

  Future<void> _restorePosition() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dx = prefs.getDouble(_prefKeyDx);
      final dy = prefs.getDouble(_prefKeyDy);
      if (!mounted || dx == null || dy == null) return;
      setState(() => _position = Offset(dx, dy));
    } catch (_) {
      // No saved position yet - the computed default in build() is fine.
    }
  }

  Future<void> _savePosition(Offset offset) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_prefKeyDx, offset.dx);
      await prefs.setDouble(_prefKeyDy, offset.dy);
    } catch (_) {}
  }

  Offset _clamp(Offset offset, Size screenSize, EdgeInsets viewPadding) {
    final maxX = screenSize.width - _size - 8;
    final maxY = screenSize.height - _size - viewPadding.bottom - 8;
    final minY = viewPadding.top + 8;
    return Offset(
      offset.dx.clamp(8, maxX < 8 ? 8 : maxX),
      offset.dy.clamp(minY, maxY < minY ? minY : maxY),
    );
  }

  void _openChat() {
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        settings: const RouteSettings(name: SupportChatView.routeName),
        builder: (_) => const SupportChatView(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: Functions.loginStateNotifier,
      builder: (context, isLoggedIn, _) {
        if (!isLoggedIn) return const SizedBox.shrink();

        return ValueListenableBuilder<String?>(
          valueListenable: CurrentRouteObserver.currentRouteName,
          builder: (context, routeName, __) {
            if (routeName == SupportChatView.routeName) {
              return const SizedBox.shrink();
            }

            final mq = MediaQuery.of(context);
            final position = _position ??
                Offset(
                  mq.size.width - _size - 16,
                  mq.size.height - _size - 140,
                );

            return Positioned(
              left: position.dx,
              top: position.dy,
              child: GestureDetector(
                onPanDown: (_) => _dragAccum = Offset.zero,
                onPanStart: (_) => setState(() => _dragging = true),
                onPanUpdate: (details) {
                  _dragAccum += details.delta;
                  setState(() {
                    _position = _clamp(
                      position + details.delta,
                      mq.size,
                      mq.viewPadding,
                    );
                  });
                },
                onPanEnd: (_) {
                  setState(() => _dragging = false);
                  final moved = _dragAccum.distance > _dragTapThreshold;
                  if (_position != null) _savePosition(_position!);
                  if (!moved) _openChat();
                },
                child: AnimatedScale(
                  scale: _dragging ? 1.08 : 1.0,
                  duration: const Duration(milliseconds: 120),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: _size,
                        height: _size,
                        decoration: BoxDecoration(
                          gradient:
                              appBrandingNotifier.value.buildHeaderGradient(),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.28),
                              blurRadius: 12,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.chat_bubble_rounded,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                      Positioned(
                        top: -4,
                        right: -4,
                        child: ValueListenableBuilder<int>(
                          valueListenable: ChatUnreadState.count,
                          builder: (context, unread, __) {
                            if (unread <= 0) return const SizedBox.shrink();
                            return Container(
                              constraints: const BoxConstraints(minWidth: 22),
                              height: 22,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE53935),
                                borderRadius: BorderRadius.circular(11),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  unread > 99 ? '99+' : '$unread',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    height: 1,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
