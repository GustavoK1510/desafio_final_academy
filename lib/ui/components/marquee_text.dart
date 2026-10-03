import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../presentation/home/providers/home_page_provider.dart';

/// Displays text that scrolls when it does not fit.
class MarqueeText extends StatefulWidget {
  /// Class constructor.
  const MarqueeText({
    required this.id,
    required this.text,
    required this.style,
    this.speed = 20,
    super.key,
  });

  /// Identifies the marquee animation.
  final String id;

  /// Text displayed by the marquee.
  final String text;

  /// Style applied to the text.
  final TextStyle? style;

  /// Scrolling speed in pixels per second.
  final double speed;

  @override
  State<MarqueeText> createState() => _MarqueeTextState();
}

/// Manages the marquee text measurement.
class _MarqueeTextState extends State<MarqueeText> {
  late HomePageProvider _provider;

  /// Gets the provider before the widget is disposed.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _provider = context.read<HomePageProvider>();
  }

  /// Measures the text after it has been rendered.
  void _initializeMarquee(double availableWidth) {
    if (!mounted || availableWidth <= 0) {
      return;
    }

    final textPainter = TextPainter(
      text: TextSpan(
        text: widget.text,
        style: widget.style,
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    _provider.initializeMarquee(
      id: widget.id,
      textWidth: textPainter.width,
      availableWidth: availableWidth,
      speed: widget.speed,
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
          (_) {
        if (!mounted) {
          return;
        }

        final width = context.size?.width ?? 0;

        _initializeMarquee(width);
      },
    );
  }

  @override
  void didUpdateWidget(MarqueeText oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.text != widget.text ||
        oldWidget.style != widget.style) {
      WidgetsBinding.instance.addPostFrameCallback(
            (_) {
          if (!mounted) {
            return;
          }

          final width = context.size?.width ?? 0;

          _initializeMarquee(width);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomePageProvider>();
    final offset = provider.getOffset(widget.id);

    return LayoutBuilder(
      builder: (context, constraints) {
        return ClipRect(
          child: SizedBox(
            width: constraints.maxWidth,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Transform.translate(
                offset: Offset(-offset, 0),
                child: IntrinsicWidth(
                  child: Text(
                    widget.text,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.visible,
                    style: widget.style,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _provider.stopMarquee(widget.id);
    super.dispose();
  }
}