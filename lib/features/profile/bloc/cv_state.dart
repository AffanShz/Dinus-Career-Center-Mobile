import 'dart:typed_data';
import 'package:equatable/equatable.dart';

enum CVStatus { initial, loading, success, failure }

class CVState extends Equatable {
  final CVStatus status;
  final Uint8List? pdfData;
  final String? errorMessage;

  const CVState({
    this.status = CVStatus.initial,
    this.pdfData,
    this.errorMessage,
  });

  CVState copyWith({
    CVStatus? status,
    Uint8List? pdfData,
    String? errorMessage,
  }) {
    return CVState(
      status: status ?? this.status,
      pdfData: pdfData ?? this.pdfData,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, pdfData, errorMessage];
}
