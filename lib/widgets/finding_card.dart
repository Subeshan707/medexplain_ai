import 'package:flutter/material.dart';
import '../config/theme.dart';

/// Card widget for displaying findings and information
class FindingCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final String? content; // For single paragraph content
  final List<String>? items; // For bullet point list
  final Color? iconColor;
  
  const FindingCard({
    super.key,
    required this.title,
    required this.icon,
    this.content,
    this.items,
    this.iconColor,
  }) : assert(content != null || items != null, 
         'Either content or items must be provided');

  @override
  State<FindingCard> createState() => _FindingCardState();
}

class _FindingCardState extends State<FindingCard> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final effectiveIconColor = widget.iconColor ?? AppTheme.primaryBlue;
    
    // Converted Card to Container with no decoration
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              // No decoration (border/background) as requested
              child: Row(
                children: [
                  Icon(
                    widget.icon,
                    color: effectiveIconColor,
                    size: 28,
                  ),
                  
                  const SizedBox(width: 12),
                  
                  Expanded(
                    child: Text(
                      widget.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  
                  Icon(
                    _isExpanded 
                        ? Icons.expand_less 
                        : Icons.expand_more,
                    color: AppTheme.black
                  ),
                ],
              ),
            ),
          ),
          
          AnimatedCrossFade(
            firstChild: Container(),
            secondChild: Padding(
              padding: const EdgeInsets.all(16),
              child: widget.content != null
                  ? _buildContentView()
                  : _buildItemsView(),
            ),
            crossFadeState: _isExpanded 
                ? CrossFadeState.showSecond 
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
  
  Widget _buildContentView() {
    return SelectableText(
      widget.content!,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        height: 1.6,
      ),
    );
  }
  
  Widget _buildItemsView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.items!.asMap().entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 6),
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppTheme.primaryBlue,
                  shape: BoxShape.circle,
                ),
              ),
              
              const SizedBox(width: 12),
              
              Expanded(
                child: SelectableText(
                  entry.value,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.6,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
