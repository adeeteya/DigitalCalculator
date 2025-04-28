import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

@immutable
class InnerShadowBoxDecoration extends Decoration implements BoxDecoration {
  const InnerShadowBoxDecoration({
    this.color,
    this.image,
    this.border,
    this.borderRadius,
    this.boxShadow,
    this.innerBoxShadow,
    this.gradient,
    this.backgroundBlendMode,
    this.shape = BoxShape.rectangle,
  }) : assert(
         backgroundBlendMode == null || color != null || gradient != null,
         "backgroundBlendMode applies to BoxDecoration's background color or "
         'gradient, but no color or gradient was provided.',
       ),
       assert(
         innerBoxShadow != null ? shape != BoxShape.circle : true,
         "For now you cannot apply inner shadow to circular shapes",
       );

  @override
  bool debugAssertIsValid() {
    assert(
      shape != BoxShape.circle || borderRadius == null,
    ); // Can't have a border radius if you're a circle.
    return super.debugAssertIsValid();
  }

  @override
  final Color? color;
  @override
  final DecorationImage? image;
  @override
  final BoxBorder? border;
  @override
  final BorderRadiusGeometry? borderRadius;
  @override
  final List<BoxShadow>? boxShadow;
  final List<BoxShadow>? innerBoxShadow;
  @override
  final Gradient? gradient;
  @override
  final BlendMode? backgroundBlendMode;
  @override
  final BoxShape shape;

  /// Returns a new box decoration that is scaled by the given factor.
  @override
  InnerShadowBoxDecoration scale(double factor) {
    return InnerShadowBoxDecoration(
      color: Color.lerp(null, color, factor),
      image: image,
      border: BoxBorder.lerp(null, border, factor),
      borderRadius: BorderRadiusGeometry.lerp(null, borderRadius, factor),
      boxShadow: BoxShadow.lerpList(null, boxShadow, factor),
      innerBoxShadow: BoxShadow.lerpList(null, innerBoxShadow, factor),
      gradient: gradient?.scale(factor),
      shape: shape,
    );
  }

  @override
  bool get isComplex => boxShadow != null || innerBoxShadow != null;

  @override
  InnerShadowBoxDecoration? lerpFrom(Decoration? a, double t) {
    if (a == null) {
      return scale(t);
    }
    if (a is InnerShadowBoxDecoration) {
      return InnerShadowBoxDecoration.lerp(a, this, t);
    }
    return super.lerpFrom(a, t) as InnerShadowBoxDecoration?;
  }

  @override
  InnerShadowBoxDecoration? lerpTo(Decoration? b, double t) {
    if (b == null) {
      return scale(1.0 - t);
    }
    if (b is InnerShadowBoxDecoration) {
      return InnerShadowBoxDecoration.lerp(this, b, t);
    }
    return super.lerpTo(b, t) as InnerShadowBoxDecoration?;
  }

  static InnerShadowBoxDecoration? lerp(
    InnerShadowBoxDecoration? a,
    InnerShadowBoxDecoration? b,
    double t,
  ) {
    if (a == null && b == null) {
      return null;
    }
    if (a == null) {
      return b!.scale(t);
    }
    if (b == null) {
      return a.scale(1.0 - t);
    }
    if (t == 0.0) {
      return a;
    }
    if (t == 1.0) {
      return b;
    }
    return InnerShadowBoxDecoration(
      color: Color.lerp(a.color, b.color, t),
      image: t < 0.5 ? a.image : b.image,
      border: BoxBorder.lerp(a.border, b.border, t),
      borderRadius: BorderRadiusGeometry.lerp(
        a.borderRadius,
        b.borderRadius,
        t,
      ),
      boxShadow: BoxShadow.lerpList(a.boxShadow, b.boxShadow, t),
      innerBoxShadow: BoxShadow.lerpList(a.innerBoxShadow, b.innerBoxShadow, t),
      gradient: Gradient.lerp(a.gradient, b.gradient, t),
      shape: t < 0.5 ? a.shape : b.shape,
    );
  }

  @override
  EdgeInsetsGeometry get padding => border?.dimensions ?? EdgeInsets.zero;

  @override
  bool hitTest(Size size, Offset position, {TextDirection? textDirection}) {
    assert((Offset.zero & size).contains(position));
    switch (shape) {
      case BoxShape.rectangle:
        if (borderRadius != null) {
          final RRect bounds = borderRadius!
              .resolve(textDirection)
              .toRRect(Offset.zero & size);
          return bounds.contains(position);
        }
        return true;
      case BoxShape.circle:
        // Circles are inscribed into our smallest dimension.
        final Offset center = size.center(Offset.zero);
        final double distance = (position - center).distance;
        return distance <= math.min(size.width, size.height) / 2.0;
    }
  }

  @override
  Path getClipPath(Rect rect, TextDirection textDirection) {
    switch (shape) {
      case BoxShape.circle:
        final Offset center = rect.center;
        final double radius = rect.shortestSide / 2.0;
        final Rect square = Rect.fromCircle(center: center, radius: radius);
        return Path()..addOval(square);
      case BoxShape.rectangle:
        if (borderRadius != null) {
          return Path()
            ..addRRect(borderRadius!.resolve(textDirection).toRRect(rect));
        }
        return Path()..addRect(rect);
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is InnerShadowBoxDecoration &&
        other.color == color &&
        other.image == image &&
        other.border == border &&
        other.borderRadius == borderRadius &&
        listEquals<BoxShadow>(other.boxShadow, boxShadow) &&
        listEquals<BoxShadow>(other.innerBoxShadow, innerBoxShadow) &&
        other.gradient == gradient &&
        other.shape == shape;
  }

  @override
  int get hashCode {
    return Object.hash(
      color,
      image,
      border,
      borderRadius,
      boxShadow,
      innerBoxShadow,
      gradient,
      shape,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..defaultDiagnosticsTreeStyle = DiagnosticsTreeStyle.whitespace
      ..emptyBodyDescription = '<no decorations specified>';

    properties.add(ColorProperty('color', color, defaultValue: null));
    properties.add(
      DiagnosticsProperty<DecorationImage>('image', image, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty<BoxBorder>('border', border, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty<BorderRadiusGeometry>(
        'borderRadius',
        borderRadius,
        defaultValue: null,
      ),
    );
    properties.add(
      IterableProperty<BoxShadow>(
        'boxShadow',
        boxShadow,
        defaultValue: null,
        style: DiagnosticsTreeStyle.whitespace,
      ),
    );
    properties.add(
      IterableProperty<BoxShadow>(
        'innerBoxShadow',
        innerBoxShadow,
        defaultValue: null,
        style: DiagnosticsTreeStyle.whitespace,
      ),
    );
    properties.add(
      DiagnosticsProperty<Gradient>('gradient', gradient, defaultValue: null),
    );
    properties.add(
      EnumProperty<BoxShape>('shape', shape, defaultValue: BoxShape.rectangle),
    );
  }

  @override
  @factory
  BoxPainter createBoxPainter([VoidCallback? onChanged]) =>
      _InnerShadowBoxDecorationPainter(this, onChanged);

  @override
  InnerShadowBoxDecoration copyWith({
    Color? color,
    DecorationImage? image,
    BoxBorder? border,
    BorderRadiusGeometry? borderRadius,
    List<BoxShadow>? boxShadow,
    List<BoxShadow>? innerBoxShadow,
    Gradient? gradient,
    BlendMode? backgroundBlendMode,
    BoxShape? shape,
  }) {
    return InnerShadowBoxDecoration(
      color: color ?? this.color,
      image: image ?? this.image,
      border: border ?? this.border,
      borderRadius: borderRadius ?? this.borderRadius,
      boxShadow: boxShadow ?? this.boxShadow,
      innerBoxShadow: innerBoxShadow ?? this.innerBoxShadow,
      gradient: gradient ?? this.gradient,
      backgroundBlendMode: backgroundBlendMode ?? this.backgroundBlendMode,
      shape: shape ?? this.shape,
    );
  }
}

class _InnerShadowBoxDecorationPainter extends BoxPainter {
  _InnerShadowBoxDecorationPainter(this._decoration, VoidCallback? onChanged)
    : super(onChanged);

  final InnerShadowBoxDecoration _decoration;

  Paint? _cachedBackgroundPaint;
  Rect? _rectForCachedBackgroundPaint;

  Paint _getBackgroundPaint(Rect rect, TextDirection? textDirection) {
    assert(
      _decoration.gradient != null || _rectForCachedBackgroundPaint == null,
    );

    if (_cachedBackgroundPaint == null ||
        (_decoration.gradient != null &&
            _rectForCachedBackgroundPaint != rect)) {
      final Paint paint = Paint();
      if (_decoration.backgroundBlendMode != null) {
        paint.blendMode = _decoration.backgroundBlendMode!;
      }
      if (_decoration.color != null) {
        paint.color = _decoration.color!;
      }
      if (_decoration.gradient != null) {
        paint.shader = _decoration.gradient!.createShader(
          rect,
          textDirection: textDirection,
        );
        _rectForCachedBackgroundPaint = rect;
      }
      _cachedBackgroundPaint = paint;
    }

    return _cachedBackgroundPaint!;
  }

  void _paintBox(
    Canvas canvas,
    Rect rect,
    Paint paint,
    TextDirection? textDirection, {
    double addBorderRadius = 0,
  }) {
    switch (_decoration.shape) {
      case BoxShape.circle:
        assert(_decoration.borderRadius == null);
        final Offset center = rect.center;
        final double radius = rect.shortestSide / 2.0;
        canvas.drawCircle(center, radius, paint);
        break;
      case BoxShape.rectangle:
        if (_decoration.borderRadius == null) {
          canvas.drawRect(rect, paint);
        } else {
          final borderRadius = _decoration.borderRadius!.add(
            BorderRadius.circular(addBorderRadius),
          );
          canvas.drawRRect(
            borderRadius.resolve(textDirection).toRRect(rect),
            paint,
          );
        }
        break;
    }
  }

  void _paintShadows(Canvas canvas, Rect rect, TextDirection? textDirection) {
    if (_decoration.boxShadow == null) {
      return;
    }
    for (final BoxShadow boxShadow in _decoration.boxShadow!) {
      final Paint paint = boxShadow.toPaint();
      final Rect bounds = rect
          .shift(boxShadow.offset)
          .inflate(boxShadow.spreadRadius);
      _paintBox(
        canvas,
        bounds,
        paint,
        textDirection,
        addBorderRadius: boxShadow.spreadRadius,
      );
    }
  }

  void _paintInnerShadows(
    Canvas canvas,
    Rect rect,
    TextDirection? textDirection,
  ) {
    assert(_decoration.border == null || _decoration.border!.isUniform);
    if (_decoration.innerBoxShadow == null) {
      return;
    }

    if (_decoration.border != null) {
      // ignore: parameter_assignments
      rect = rect.deflate(_decoration.border!.top.width);
    }
    final borderWidth = _decoration.border?.bottom.width ?? 0.0;

    for (final BoxShadow shadow in _decoration.innerBoxShadow!) {
      canvas.save();
      final outerPaint = shadow.toPaint();

      if (_decoration.borderRadius != null) {
        final rrect = _decoration.borderRadius!
            .subtract(BorderRadius.circular(borderWidth))
            .resolve(textDirection)
            .toRRect(rect);

        canvas.clipRRect(rrect);

        final innerRect = rrect
            .shift(shadow.offset)
            .deflate(shadow.spreadRadius);
        final path = Path.combine(
          PathOperation.difference,
          Path()..addRRect(rrect),
          Path()..addRRect(innerRect),
        );

        canvas.drawPath(path, outerPaint);
      } else {
        canvas.clipRect(rect);

        final innerRect = rect
            .shift(shadow.offset)
            .deflate(shadow.spreadRadius);
        final path = Path.combine(
          PathOperation.difference,
          Path()..addRect(rect),
          Path()..addRect(innerRect),
        );

        canvas.drawPath(path, outerPaint);
      }
      canvas.restore();
    }
  }

  void _paintBackgroundColor(
    Canvas canvas,
    Rect rect,
    TextDirection? textDirection,
  ) {
    if (_decoration.color != null || _decoration.gradient != null) {
      _paintBox(
        canvas,
        rect,
        _getBackgroundPaint(rect, textDirection),
        textDirection,
      );
    }
  }

  DecorationImagePainter? _imagePainter;

  void _paintBackgroundImage(
    Canvas canvas,
    Rect rect,
    ImageConfiguration configuration,
  ) {
    if (_decoration.image == null) {
      return;
    }
    _imagePainter ??= _decoration.image!.createPainter(onChanged!);
    Path? clipPath;
    switch (_decoration.shape) {
      case BoxShape.circle:
        assert(_decoration.borderRadius == null);
        final Offset center = rect.center;
        final double radius = rect.shortestSide / 2.0;
        final Rect square = Rect.fromCircle(center: center, radius: radius);
        clipPath = Path()..addOval(square);
        break;
      case BoxShape.rectangle:
        if (_decoration.borderRadius != null) {
          clipPath =
              Path()..addRRect(
                _decoration.borderRadius!
                    .resolve(configuration.textDirection)
                    .toRRect(rect),
              );
        }
        break;
    }
    _imagePainter!.paint(canvas, rect, clipPath, configuration);
  }

  @override
  void dispose() {
    _imagePainter?.dispose();
    super.dispose();
  }

  /// Paint the box decoration into the given location on the given canvas.
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);
    final Rect rect = offset & configuration.size!;
    final TextDirection? textDirection = configuration.textDirection;
    _paintShadows(canvas, rect, textDirection);
    _paintBackgroundColor(canvas, rect, textDirection);
    _paintBackgroundImage(canvas, rect, configuration);
    _paintInnerShadows(canvas, rect, textDirection);
    _decoration.border?.paint(
      canvas,
      rect,
      shape: _decoration.shape,
      borderRadius: _decoration.borderRadius?.resolve(textDirection),
      textDirection: configuration.textDirection,
    );
  }

  @override
  String toString() {
    return 'InnerShadowBoxPainter for $_decoration';
  }
}
