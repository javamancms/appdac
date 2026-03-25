import 'package:appdac/a_presentacion/tema/tema.dart';
import 'package:flutter/material.dart';

class PanelIconoInfo extends StatefulWidget {
  final IconData icon;
  final String info;
  final String? infoAlterna;
  final Color? iconColor;
  final Color? cardColor;
  final Color? textColor;
  final double? iconSize;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const PanelIconoInfo({
    Key? key,
    required this.icon,
    required this.info,
    this.infoAlterna,
    required this.iconColor,
    required this.cardColor,
    required this.textColor,
    this.iconSize = 60.0,
    this.padding = const EdgeInsets.all(16.0),
    this.onTap,
  }) : super(key: key);

  @override
  _PanelIconoInfoState createState() => _PanelIconoInfoState();
}

class _PanelIconoInfoState extends State<PanelIconoInfo> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    
    final iconColor = _isPressed ? widget.cardColor : widget.iconColor;

    final cardColor = _isPressed ? widget.iconColor : widget.cardColor;

    final textColor = _isPressed ? widget.cardColor : widget.textColor;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Card(
          color: cardColor,
          elevation: _isPressed ? 6 : 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: _isPressed ? BorderSide(color: Colors.yellow.shade500, width: 2) : BorderSide.none,
          ),
          child: Padding(
            padding: widget.padding!,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icono
                Icon(
                  widget.icon,
                  size: widget.iconSize,
                  color: iconColor,
                ),
                const SizedBox(height: 16),

                // Texto info en negrita
                Text(
                  widget.info,
                  textAlign: TextAlign.left,
                  style: AppColors.textosubtituloblanco
                ),

                // Texto infoAlterna sin negrita (solo si existe)
                if (widget.infoAlterna != null && widget.infoAlterna!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      widget.infoAlterna!,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: textColor,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
