import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_audio_waveforms/audio_waveform_stateful_ab.dart';
import 'package:flutter_audio_waveforms/waveforms/squiggly_waveform/active_inactive_waveform_painter.dart';

class SquigglyWaveform extends AudioWaveform {
  const SquigglyWaveform({
    Key? key,
    required List<double> samples,
    required double height,
    required double width,
    required Duration maxDuration,
    required Duration elapsedDuration,
    this.activeColor,
    this.inactiveColor,
    bool showActiveWaveform = true,
  }) : super(
          key: key,
          samples: samples,
          height: height,
          width: width,
          maxDuration: maxDuration,
          elapsedDuration: elapsedDuration,
          absolute: true,
          showActiveWaveform: showActiveWaveform,
        );
  final Color? activeColor;
  final Color? inactiveColor;

  @override
  AudioWaveformState<SquigglyWaveform> createState() =>
      _SquigglyWaveformState();
}

class _SquigglyWaveformState extends AudioWaveformState<SquigglyWaveform> {
  @override
  void processSamples(List<double> samples) {
    List<double> processedSamples = samples
        .map((e) => absolute ? e.abs() * widget.height : e * widget.height)
        .toList();

    final maxNum =
        processedSamples.reduce((a, b) => math.max(a.abs(), b.abs()));
    final double multiplier = math.pow(maxNum, -1).toDouble();
    final finaHeight = widget.height / 2;
    processedSamples = processedSamples
        .map(
          (e) => e * multiplier * finaHeight,
        )
        .toList();
    setState(() {});
    updateProcessedSamples(processedSamples);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.samples.isEmpty) {
      return const SizedBox.shrink();
    }
    final List<double> processedSamples = this.processedSamples;
    final double activeRatio = showActiveWaveform
        ? elapsedDuration.inMilliseconds / maxDuration.inMilliseconds
        : 0;

    return CustomPaint(
      size: Size(widget.width, widget.height),
      isComplex: true,
      willChange: true,
      painter: SquigglyWaveformPainter(
        samples: processedSamples,
        activeColor: widget.activeColor ?? Colors.red,
        inactiveColor: widget.inactiveColor ?? Colors.blue,
        activeRatio: activeRatio,
      ),
    );
  }
}
