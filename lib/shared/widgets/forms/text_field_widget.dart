import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/styles/app_colors.dart';

class FloatLabelInput extends StatefulWidget {
  final String label;
  final String? hintText;
  final String? initialValue;
  final String? errorText;
  final TextInputType keyboardType;
  final bool obscureText;
  final int? maxLines;
  final int? maxLength;
  final bool enabled;
  final bool readOnly;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? activeColor;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final VoidCallback? onTap;
  final VoidCallback? onEditingComplete;
  final FocusNode? focusNode;
  final bool autofocus;

  const FloatLabelInput({
    super.key,
    required this.label,
    this.hintText,
    this.initialValue,
    this.errorText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.readOnly = false,
    this.inputFormatters,
    this.textInputAction,
    this.prefixIcon,
    this.suffixIcon,
    this.activeColor,
    this.onChanged,
    this.onFieldSubmitted,
    this.onTap,
    this.onEditingComplete,
    this.focusNode,
    this.autofocus = false,
  });

  @override
  State<FloatLabelInput> createState() => _FloatLabelInputState();
}

class _FloatLabelInputState extends State<FloatLabelInput> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _labelAnimation;
  late FocusNode _focusNode;
  late TextEditingController _controller;

  bool _hasFocus = false;

  bool get _hasText => _controller.text.isNotEmpty;
  bool get _hasError => widget.errorText != null;
  bool get _shouldFloatLabel => _hasFocus || _hasText;

  @override
  void initState() {
    super.initState();
    _initializeComponents();
    _setupListeners();
    _updateAnimationState();
  }

  void _initializeComponents() {
    _controller = TextEditingController(text: widget.initialValue ?? '');
    _focusNode = widget.focusNode ?? FocusNode();

    _animationController = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);

    _labelAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));
  }

  void _setupListeners() {
    _focusNode.addListener(_handleFocusChange);
    _controller.addListener(_handleTextChange);
  }

  void _updateAnimationState() {
    if (_shouldFloatLabel) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  void didUpdateWidget(FloatLabelInput oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.initialValue != oldWidget.initialValue) {
      _controller.text = widget.initialValue ?? '';
      _updateAnimationState();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _focusNode.removeListener(_handleFocusChange);
    _controller.removeListener(_handleTextChange);

    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _controller.dispose();

    super.dispose();
  }

  void _handleFocusChange() {
    if (_hasFocus != _focusNode.hasFocus) {
      setState(() {
        _hasFocus = _focusNode.hasFocus;
      });
      _updateAnimationState();
    }
  }

  void _handleTextChange() {
    _updateAnimationState();
    widget.onChanged?.call(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: GestureDetector(
        onTap: () => _focusNode.requestFocus(),
        child: Stack(children: [_buildTextField(), _buildFloatingLabel(context)]),
      ),
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      inputFormatters: widget.inputFormatters,
      textInputAction: widget.textInputAction,
      autofocus: widget.autofocus,
      onTap: widget.onTap,
      onEditingComplete: widget.onEditingComplete,
      onSubmitted: widget.onFieldSubmitted,
      style: _buildTextStyle(),
      decoration: _buildInputDecoration(context),
    );
  }

  TextStyle _buildTextStyle() {
    return TextStyle(
      color: widget.enabled ? AppColors.primaryText : AppColors.secondaryText.withValues(alpha: 0.6),
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      height: 1.2,
    );
  }

  InputDecoration _buildInputDecoration(BuildContext context) {
    return InputDecoration(
      hintText: _shouldFloatLabel ? widget.hintText : null,
      hintStyle: TextStyle(
        color: AppColors.hintColor.withValues(alpha: 0.7),
        fontSize: 15.0,
        fontWeight: FontWeight.w400,
      ),
      prefixIcon: widget.prefixIcon != null ? _buildPrefixIcon() : null,
      suffixIcon: widget.suffixIcon,
      filled: true,
      fillColor: _buildFillColor(),
      contentPadding: _buildContentPadding(),
      border: _buildBorder(),
      enabledBorder: _buildBorder(_getEnabledBorderColor(), 1.0),
      focusedBorder: _buildBorder(_getFocusedBorderColor(), 2.0),
      errorBorder: _buildBorder(AppColors.errorColor, 1.0),
      focusedErrorBorder: _buildBorder(AppColors.errorColor, 2.0),
      errorText: widget.errorText,
      errorStyle: const TextStyle(fontSize: 12.0, height: 1.2),
      counterText: '',
    );
  }

  Color _buildFillColor() {
    if (!widget.enabled) return AppColors.greyColor.withValues(alpha: 0.3);
    if (_hasFocus) return AppColors.whiteColor;
    return AppColors.defaultColor.withValues(alpha: 0.3);
  }

  EdgeInsets _buildContentPadding() {
    return EdgeInsets.fromLTRB(widget.prefixIcon != null ? 12.0 : 18.0, 20.0, 18.0, 16.0);
  }

  OutlineInputBorder _buildBorder([Color? color, double? width]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: color != null && width != null ? BorderSide(color: color, width: width) : BorderSide.none,
    );
  }

  Color _getEnabledBorderColor() {
    return AppColors.divider.withValues(alpha: 0.4);
  }

  Color _getFocusedBorderColor() {
    if (_hasError) return AppColors.errorColor;
    return widget.activeColor ?? AppColors.primaryColor;
  }

  Color _getLabelColor() {
    if (_hasError) return AppColors.errorColor;
    if (_hasFocus) return widget.activeColor ?? AppColors.primaryColor;
    return AppColors.secondaryText;
  }

  Widget _buildPrefixIcon() {
    return Container(
      margin: const EdgeInsets.only(right: 8.0),
      child: IconTheme(
        data: IconThemeData(
          color: _hasFocus
              ? (widget.activeColor ?? AppColors.primaryColor)
              : AppColors.secondaryText.withValues(alpha: 0.8),
          size: 22.0,
        ),
        child: widget.prefixIcon!,
      ),
    );
  }

  Widget _buildFloatingLabel(BuildContext context) {
    return Positioned(
      left: widget.prefixIcon != null ? 30.0 : 18.0,
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: _labelAnimation,
          builder: (context, child) {
            final progress = _labelAnimation.value;

            return Transform.translate(
              offset: Offset(0, 16.5 - (25.0 * progress)),
              child: Transform.scale(
                scale: 1.0 - (0.25 * progress),
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                  decoration: BoxDecoration(
                    color: progress > 0.5 ? Theme.of(context).scaffoldBackgroundColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Text(
                    widget.label,
                    style: TextStyle(
                      color: _getLabelColor(),
                      fontSize: 15.0,
                      fontWeight: _hasFocus ? FontWeight.w500 : FontWeight.w400,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
