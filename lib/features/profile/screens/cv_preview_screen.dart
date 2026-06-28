import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:printing/printing.dart';
import 'package:dcc_mobile/core/theme/colors.dart';
import '../models/profile_model.dart';
import '../services/cv_service.dart';
import '../bloc/cv_bloc.dart';
import '../bloc/cv_event.dart';
import '../bloc/cv_state.dart';

class CVPreviewScreen extends StatelessWidget {
  final UserProfile profile;
  final CVTemplateType template;

  const CVPreviewScreen({
    super.key,
    required this.profile,
    required this.template,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CVBloc()..add(GenerateCV(profile: profile, template: template)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pratinjau CV'),
          backgroundColor: AppColors.background,
        ),
        body: BlocBuilder<CVBloc, CVState>(
          builder: (context, state) {
            if (state.status == CVStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == CVStatus.failure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: AppColors.error, size: 48),
                    const SizedBox(height: 16),
                    Text('Gagal membuat CV: ${state.errorMessage}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<CVBloc>().add(GenerateCV(profile: profile, template: template));
                      },
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              );
            }

            if (state.status == CVStatus.success && state.pdfData != null) {
              return PdfPreview(
                build: (format) => state.pdfData!,
                allowPrinting: true,
                allowSharing: true,
                canChangePageFormat: false,
                canChangeOrientation: false,
                pdfFileName: 'CV_${profile.name.replaceAll(' ', '_')}.pdf',
                previewPageMargin: const EdgeInsets.all(16),
                loadingWidget: const CircularProgressIndicator(),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
