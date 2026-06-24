import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dcc_mobile/features/job/bloc/job_bloc.dart';
import 'package:dcc_mobile/features/job/bloc/job_event.dart';
import 'package:dcc_mobile/features/job/bloc/job_state.dart';
import 'package:dcc_mobile/features/job/services/job_service.dart';
import 'package:dcc_mobile/features/job/models/job_model.dart';
import 'package:mocktail/mocktail.dart';

class MockJobService extends Mock implements JobService {}

void main() {
  group('JobBloc', () {
    late JobBloc jobBloc;
    late MockJobService mockJobService;

    setUp(() {
      mockJobService = MockJobService();
      jobBloc = JobBloc(jobService: mockJobService);
    });

    tearDown(() {
      jobBloc.close();
    });

    test('initial state is JobState()', () {
      expect(jobBloc.state, const JobState());
    });

    blocTest<JobBloc, JobState>(
      'emits [loading, success] when LoadJobs is added and succeeds',
      build: () {
        when(() => mockJobService.fetchJobs(
          category: any(named: 'category'),
          query: any(named: 'query'),
          sektor: any(named: 'sektor'),
          jurusan: any(named: 'jurusan'),
          lokasi: any(named: 'lokasi'),
        )).thenAnswer((_) async => []);
        return jobBloc;
      },
      act: (bloc) => bloc.add(LoadJobs()),
      expect: () => [
        const JobState(status: JobStatus.loading),
        const JobState(status: JobStatus.success, jobs: []),
      ],
    );

    blocTest<JobBloc, JobState>(
      'emits [loading, failure] when LoadJobs fails',
      build: () {
        when(() => mockJobService.fetchJobs(
          category: any(named: 'category'),
          query: any(named: 'query'),
          sektor: any(named: 'sektor'),
          jurusan: any(named: 'jurusan'),
          lokasi: any(named: 'lokasi'),
        )).thenThrow(Exception('error'));
        return jobBloc;
      },
      act: (bloc) => bloc.add(LoadJobs()),
      expect: () => [
        const JobState(status: JobStatus.loading),
        const JobState(status: JobStatus.failure),
      ],
    );
  });
}
