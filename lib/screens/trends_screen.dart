import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'dart:math';
import '../config/theme.dart';
import '../models/analysis_history.dart';
import '../models/analysis_stats.dart';
import '../providers/history_provider.dart';

class TrendsScreen extends ConsumerStatefulWidget {
  const TrendsScreen({super.key});

  @override
  ConsumerState<TrendsScreen> createState() => _TrendsScreenState();
}

class _TrendsScreenState extends ConsumerState<TrendsScreen> {
  String? _selectedMetric;
  
  // Available metrics found in history
  List<String> _availableMetrics = [];

  @override
  void initState() {
    super.initState();
  }

  void _extractAvailableMetrics(List<AnalysisHistory> history) {
    final Set<String> metrics = {};
    for (var item in history) {
      final stats = AnalysisStats.fromText(item.reportText);
      metrics.addAll(stats.metrics.keys);
    }
    _availableMetrics = metrics.toList()..sort();
    
    // Default to Cholesterol if available, else first one
    if (_selectedMetric == null && _availableMetrics.isNotEmpty) {
      if (_availableMetrics.contains('Total Cholesterol')) {
        _selectedMetric = 'Total Cholesterol';
      } else {
        _selectedMetric = _availableMetrics.first;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final historyState = ref.watch(historyProvider);
    final history = historyState.items;
    
    // Re-extract in case history changed
    _extractAvailableMetrics(history);

    return Scaffold(
      backgroundColor: AppTheme.lightSurface,
      appBar: AppBar(
        title: const Text('Trend Analysis'),
        backgroundColor: AppTheme.darkBlue,
        foregroundColor: AppTheme.white,
      ),
      body: _availableMetrics.isEmpty
          ? _buildEmptyState()
          : _buildDashboard(history),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.show_chart, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'No trend data available',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'Upload more reports with recognizable values (e.g., Cholesterol, Glucose) to see trends.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboard(List<AnalysisHistory> history) {
    if (_selectedMetric == null) return const SizedBox();

    // Prepare data for the selected metric
    final dataPoints = <_DataPoint>[];
    for (var item in history) {
      final stats = AnalysisStats.fromText(item.reportText);
      final value = stats.getValue(_selectedMetric!);
      if (value != null) {
        dataPoints.add(_DataPoint(item.timestamp, value));
      }
    }
    
    // Sort by date
    dataPoints.sort((a, b) => a.date.compareTo(b.date));

    // Calculate insights
    String insightText = "Not enough data for insights.";
    Color insightColor = Colors.grey;
    IconData insightIcon = Icons.insights;
    double? changePercent;
    bool isPositiveChange = false; // "Positive" as in good for health
    
    if (dataPoints.length >= 2) {
      final first = dataPoints.first.value;
      final last = dataPoints.last.value;
      final diff = last - first;
      final percentStr = first != 0 
          ? (diff / first * 100).abs().toStringAsFixed(1) 
          : "0.0";
      changePercent = double.tryParse(percentStr);
      
      if (diff < 0) {
        insightText = "$_selectedMetric has decreased by $percentStr%";
        isPositiveChange = true; // Generally decrease is good? Not always.
        insightIcon = Icons.trending_down;
      } else if (diff > 0) {
        insightText = "$_selectedMetric has increased by $percentStr%";
        isPositiveChange = false;
        insightIcon = Icons.trending_up;
        
        // Context specific logic
        if (_selectedMetric == 'HDL') {
           isPositiveChange = true;
           insightText += " (Improving)";
        }
      } else {
        insightText = "$_selectedMetric is stable";
        insightIcon = Icons.trending_flat;
        isPositiveChange = true;
      }
      
      insightColor = isPositiveChange ? AppTheme.successBlue : AppTheme.alertRed;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.analytics_outlined, color: AppTheme.primaryBlue),
              ),
              const SizedBox(width: 14),
              const Text("Health Trends", 
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.darkBlue)),
            ],
          ),
          const SizedBox(height: 24),
          
          // Metric Selector
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                 BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                 ),
              ],
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedMetric,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.primaryBlue),
                items: _availableMetrics.map((m) {
                  return DropdownMenuItem(value: m, child: Text(m, 
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)));
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedMetric = val;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 30),
          
          // Insight Card (Restyled)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isPositiveChange 
                  ? [AppTheme.successBlue, const Color(0xFF00C853)] 
                  : [AppTheme.alertRed, const Color(0xFFFF5252)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: (isPositiveChange ? AppTheme.successBlue : AppTheme.alertRed).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(insightIcon, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      isPositiveChange ? "Positive Trend" : "Needs Attention",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  insightText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                if (dataPoints.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    "Latest: ${dataPoints.last.value}",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Chart Container
          Container(
            height: 320,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                 BoxShadow(
                    color: Colors.grey.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                 ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("History Chart", 
                   style: TextStyle(color: Colors.grey[400], fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 20),
                Expanded(
                  child: CustomPaint(
                    painter: _ChartPainter(
                      dataPoints: dataPoints,
                      lineColor: AppTheme.primaryBlue,
                      dotColor: AppTheme.darkBlue,
                    ),
                    child: Container(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          const Text("Detailed Logs", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.darkBlue)),
          const SizedBox(height: 12),
          
          ...dataPoints.reversed.map((p) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(DateFormat.yMMMd().format(p.date),
                   style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500)),
                Text(
                  p.value.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.darkBlue),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

class _DataPoint {
  final DateTime date;
  final double value;
  _DataPoint(this.date, this.value);
}

class _ChartPainter extends CustomPainter {
  final List<_DataPoint> dataPoints;
  final Color lineColor;
  final Color dotColor;

  _ChartPainter({
    required this.dataPoints,
    required this.lineColor,
    required this.dotColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (dataPoints.isEmpty) return;

    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
      
    final dotPaint = Paint()
      ..color = dotColor
      ..style = PaintingStyle.fill;
    
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    // Calc ranges
    double minVal = double.infinity;
    double maxVal = double.negativeInfinity;
    
    for (var p in dataPoints) {
      minVal = min(minVal, p.value);
      maxVal = max(maxVal, p.value);
    }
    
    // Add padding to range
    final range = maxVal - minVal;
    final paddedMin = minVal - (range * 0.1);
    final paddedMax = maxVal + (range * 0.1);
    final effectiveRange = paddedMax - paddedMin == 0 ? 1.0 : paddedMax - paddedMin;

    final width = size.width;
    final height = size.height;
    final paddingBottom = 20.0;
    final paddingLeft = 30.0;
    
    final chartWidth = width - paddingLeft;
    final chartHeight = height - paddingBottom;
    
    final path = Path();
    final points = <Offset>[];
    
    // Grid lines
    final gridPaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1;
      
    // Draw 4 horizontal grid lines
    for (int i=0; i<=3; i++) {
        final y = chartHeight - (i * chartHeight / 3);
        canvas.drawLine(Offset(paddingLeft, y), Offset(width, y), gridPaint);
        
        // Label
        final val = paddedMin + (effectiveRange * i / 3);
        textPainter.text = TextSpan(
            text: val.toStringAsFixed(0),
            style: const TextStyle(color: Colors.grey, fontSize: 10),
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(0, y - textPainter.height/2));
    }

    if (dataPoints.length < 2) {
       // Just draw a dot in middle
       final p = dataPoints.first;
       final x = paddingLeft + chartWidth / 2;
       final y = chartHeight - ((p.value - paddedMin) / effectiveRange * chartHeight);
       canvas.drawCircle(Offset(x,y), 5, dotPaint);
       return;
    }

    final stepX = chartWidth / (dataPoints.length - 1);

    for (int i = 0; i < dataPoints.length; i++) {
      final p = dataPoints[i];
      final x = paddingLeft + (i * stepX);
      final y = chartHeight - ((p.value - paddedMin) / effectiveRange * chartHeight);
      
      points.add(Offset(x, y));
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      
      // Draw Date label
      textPainter.text = TextSpan(
          text: DateFormat.MMMd().format(p.date),
          style: const TextStyle(color: Colors.grey, fontSize: 10),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x - textPainter.width/2, chartHeight + 5));
    }

    canvas.drawPath(path, paint);
    
    for (var point in points) {
      canvas.drawCircle(point, 5, dotPaint);
      canvas.drawCircle(point, 3, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
