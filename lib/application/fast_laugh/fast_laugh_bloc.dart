// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:netflix_clone_app/domain/downloads/i_downloads_repo.dart';
import 'package:netflix_clone_app/domain/downloads/models/downloads.dart';

part 'fast_laugh_event.dart';
part 'fast_laugh_state.dart';
part 'fast_laugh_bloc.freezed.dart';

final dummyVideoUrls = [
  "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
  "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
  "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
  "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
  "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4",
];

ValueNotifier<Set<int>> likedVideosIdsNotifier = ValueNotifier({});

@injectable
class FastLaughBloc extends Bloc<FastLaughEvent, FastLaughState> {
  FastLaughBloc(
    // ignore: no_leading_underscores_for_local_identifiers
    IDownloadsRepo _downloadService,
  ) : super(FastLaughState.initial()) {
    on<Initialize>((event, emit) async {
      // Sending loading to UI
      emit(const FastLaughState(
        videosList: [],
        isLoading: true,
        isError: false,
      ));
      // get trending movies
      // ignore: no_leading_underscores_for_local_identifiers
      final _result = await _downloadService.getDownloadsImages();
      // ignore: no_leading_underscores_for_local_identifiers
      final _state = _result.fold(
        (l) {
          return const FastLaughState(
            videosList: [],
            isLoading: false,
            isError: true,
          );
        },
        (r) => FastLaughState(
          videosList: r,
          isLoading: false,
          isError: false,
        ),
      );
      //send to ui

      emit(_state);
    });

    on<LikeVedio>((event, emit) async {
      likedVideosIdsNotifier.value.add(event.id);
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      likedVideosIdsNotifier.notifyListeners();
    });

    on<UnlikeVedio>((event, emit) async {
      likedVideosIdsNotifier.value.remove(event.id);
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      likedVideosIdsNotifier.notifyListeners();
    });
  }
}
