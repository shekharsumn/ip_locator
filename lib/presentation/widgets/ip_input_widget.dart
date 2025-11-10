import 'package:flutter/material.dart';

/// Widget for IP address input with validation
class IpInputWidget extends StatefulWidget {
  final Function(String) onIpChanged;
  final VoidCallback onFetchPressed;
  final String? validationError;
  final bool isLoading;
  final bool canFetch;
  final String ipAddress; // Add current IP address from state

  const IpInputWidget({
    super.key,
    required this.onIpChanged,
    required this.onFetchPressed,
    this.validationError,
    this.isLoading = false,
    this.canFetch = false,
    required this.ipAddress,
  });

  @override
  State<IpInputWidget> createState() => _IpInputWidgetState();
}

class _IpInputWidgetState extends State<IpInputWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String _currentText = '';

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(IpInputWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update text controller when IP address changes externally (e.g., when cleared)
    if (widget.ipAddress != oldWidget.ipAddress && widget.ipAddress != _currentText) {
      _controller.text = widget.ipAddress;
      _currentText = widget.ipAddress;
    }
  }

  void _handleTextChange(String value) {
    setState(() {
      _currentText = value;
    });
    widget.onIpChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _controller,
          focusNode: _focusNode,
          onChanged: _handleTextChange,
          decoration: InputDecoration(
            labelText: 'IP Address',
            hintText: 'e.g., 192.168.1.1 or 2001:db8::1',
            prefixIcon: const Icon(Icons.language),
            suffixIcon: _currentText.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _controller.clear();
                      setState(() {
                        _currentText = '';
                      });
                      widget.onIpChanged('');
                    },
                  )
                : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            errorText: widget.validationError,
            errorMaxLines: 2,
          ),
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) {
            if (widget.canFetch) {
              widget.onFetchPressed();
            }
          },
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 48,
          child: ElevatedButton.icon(
            onPressed: widget.canFetch ? widget.onFetchPressed : null,
            icon: widget.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.search),
            label: Text(
              widget.isLoading ? 'Fetching...' : 'Get Location Details',
              style: const TextStyle(fontSize: 16),
            ),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
