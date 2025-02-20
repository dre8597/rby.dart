import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

// Copied and modified from https://github.com/mchome/flutter_colorpicker

class ColorPicker extends StatefulWidget {
  const ColorPicker({
    super.key,
    required this.initialColor,
    required this.onColorChanged,
    this.paletteType = PaletteType.hsvWithHue,
    this.enableAlpha = true,
    this.colorPickerWidth = 300.0,
    this.pickerAreaBorderRadius = BorderRadius.zero,
    this.contentPadding = 16,
  });

  final Color initialColor;
  final ValueChanged<Color> onColorChanged;
  final PaletteType paletteType;
  final bool enableAlpha;
  final double colorPickerWidth;
  final BorderRadius pickerAreaBorderRadius;
  final double contentPadding;

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  late HSVColor _currentHsvColor = HSVColor.fromColor(widget.initialColor);

  Widget _colorPickerSlider(TrackType trackType) {
    return ColorPickerSlider(trackType, _currentHsvColor, (color) {
      setState(() => _currentHsvColor = color);
      widget.onColorChanged(_currentHsvColor.toColor());
    }, displayThumbColor: true);
  }

  void _onColorChanging(HSVColor color) {
    setState(() => _currentHsvColor = color);
    widget.onColorChanged(_currentHsvColor.toColor());
  }

  Widget _sliderByPaletteType() {
    switch (widget.paletteType) {
      case PaletteType.hsv:
      case PaletteType.hsvWithHue:
      case PaletteType.hsl:
      case PaletteType.hslWithHue:
        return _colorPickerSlider(TrackType.hue);
      case PaletteType.hsvWithValue:
      case PaletteType.hueWheel:
        return _colorPickerSlider(TrackType.value);
      case PaletteType.hsvWithSaturation:
        return _colorPickerSlider(TrackType.saturation);
      case PaletteType.hslWithLightness:
        return _colorPickerSlider(TrackType.lightness);
      case PaletteType.hslWithSaturation:
        return _colorPickerSlider(TrackType.saturationForHSL);
      case PaletteType.rgbWithBlue:
        return _colorPickerSlider(TrackType.blue);
      case PaletteType.rgbWithGreen:
        return _colorPickerSlider(TrackType.green);
      case PaletteType.rgbWithRed:
        return _colorPickerSlider(TrackType.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final colorPicker = SizedBox(
      width: widget.colorPickerWidth,
      height: widget.colorPickerWidth,
      child: ClipRRect(
        borderRadius: widget.pickerAreaBorderRadius,
        child: ColorPickerArea(
          _currentHsvColor,
          _onColorChanging,
          widget.paletteType,
        ),
      ),
    );

    final input = _ColorPickerInput(
      color: _currentHsvColor.toColor(),
      enableAlpha: widget.enableAlpha,
      padding: EdgeInsets.all(widget.contentPadding / 2),
      onColorChanged: (color) {
        setState(() => _currentHsvColor = HSVColor.fromColor(color));
        widget.onColorChanged(_currentHsvColor.toColor());
      },
    );

    return mediaQuery.orientation == Orientation.portrait
        ? Column(
          children: [
            colorPicker,
            SizedBox(height: widget.contentPadding),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: widget.contentPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ColorIndicator(_currentHsvColor),
                  SizedBox(width: widget.contentPadding),
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(height: 40, child: _sliderByPaletteType()),
                        if (widget.enableAlpha)
                          SizedBox(
                            height: 40,
                            child: _colorPickerSlider(TrackType.alpha),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: widget.contentPadding),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: widget.contentPadding),
              child: input,
            ),
            SizedBox(height: widget.contentPadding),
          ],
        )
        : Column(
          children: [
            Row(
              children: [
                colorPicker,
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(height: widget.contentPadding),
                      Row(
                        children: [
                          SizedBox(width: widget.contentPadding),
                          ColorIndicator(_currentHsvColor),
                          Expanded(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 40,
                                  child: _sliderByPaletteType(),
                                ),
                                if (widget.enableAlpha)
                                  SizedBox(
                                    height: 40,
                                    child: _colorPickerSlider(TrackType.alpha),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(width: widget.contentPadding),
                        ],
                      ),
                      SizedBox(height: widget.contentPadding),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: widget.contentPadding,
                        ),
                        child: input,
                      ),
                      SizedBox(height: widget.contentPadding),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: widget.contentPadding),
          ],
        );
  }
}

class _ColorPickerInput extends StatefulWidget {
  const _ColorPickerInput({
    required this.color,
    required this.onColorChanged,
    this.enableAlpha = true,
    this.padding = const EdgeInsets.all(8),
  });

  final Color color;
  final ValueChanged<Color> onColorChanged;
  final bool enableAlpha;
  final EdgeInsets padding;

  @override
  _ColorPickerInputState createState() => _ColorPickerInputState();
}

class _ColorPickerInputState extends State<_ColorPickerInput> {
  final _textEditingController = TextEditingController();
  int _inputColor = -1;

  @override
  void dispose() {
    _textEditingController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorValue =
        widget.color.r.toInt() << 24 |
        widget.color.g.toInt() << 16 |
        widget.color.b.toInt() << 8 |
        widget.color.a.toInt();
    if (_inputColor != colorValue) {
      _textEditingController.text = _colorToHex(
        widget.color,
        enableAlpha: widget.enableAlpha,
      );
    }

    return TextField(
      controller: _textEditingController,
      inputFormatters: [
        LowerCaseTextFormatter(),
        FilteringTextInputFormatter.allow(_validHexColorCharactersRegex),
      ],
      decoration: const InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.all(8),
      ),
      onChanged: (value) {
        var input = value;
        if (value.length == 9) {
          input =
              value.split('').getRange(7, 9).join() +
              value.split('').getRange(1, 7).join();
        }
        final color = colorFromHex(input);
        if (color != null) {
          widget.onColorChanged(color);
          _inputColor =
              color.r.toInt() << 24 |
              color.g.toInt() << 16 |
              color.b.toInt() << 8 |
              color.a.toInt();
        }
      },
    );
  }
}

String _colorToHex(Color color, {bool enableAlpha = true}) {
  final alpha =
      enableAlpha
          ? color.a.toInt().toRadixString(16).toLowerCase().padLeft(2, '0')
          : '';

  return '#'
      '${color.r.toInt().toRadixString(16).toLowerCase().padLeft(2, '0')}'
      '${color.g.toInt().toRadixString(16).toLowerCase().padLeft(2, '0')}'
      '${color.b.toInt().toRadixString(16).toLowerCase().padLeft(2, '0')}'
      '$alpha';
}

class LowerCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) => TextEditingValue(
    text: newValue.text.toLowerCase(),
    selection: newValue.selection,
  );
}

/// Matches a string that can form a valid hex color string.
///
/// * Starting with an optional `#`
/// * 1 to 8 digits in base 16
final _validHexColorCharactersRegex = RegExp('^#?[0-9a-fA-F]{0,8}');
